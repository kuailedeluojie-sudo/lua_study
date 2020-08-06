--[[--
Module for various utility functions.

@module ffi.util
]]
-- 加载模块
local bit = require "bit"
local ffi = require "ffi"
local C = ffi.C

local lshift = bit.lshift
local band = bit.band
local bor = bit.bor

-- 定义C语言种的类型
-- win32 utility
ffi.cdef[[
typedef unsigned int UINT;
typedef unsigned long DWORD;
typedef char *LPSTR;
typedef wchar_t *LPWSTR;
typedef const char *LPCSTR;
typedef const wchar_t *LPCWSTR;
typedef bool *LPBOOL;
typedef LPSTR LPTSTR;
typedef int BOOL;

typedef struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
} FILETIME, *PFILETIME;

void GetSystemTimeAsFileTime(FILETIME*);
DWORD GetFullPathNameA(
    LPCSTR lpFileName,
    DWORD nBufferLength,
    LPSTR lpBuffer,
    LPSTR *lpFilePart
);
LPTSTR PathFindFileNameA(LPCSTR lpszPath);
BOOL PathRemoveFileSpec(LPTSTR pszPath);
UINT GetACP(void);
int MultiByteToWideChar(
    UINT CodePage,
    DWORD dwFlags,
    LPCSTR lpMultiByteStr,
    int cbMultiByte,
    LPWSTR lpWideCharStr,
    int cchWideChar
);
int WideCharToMultiByte(
    UINT CodePage,
    DWORD dwFlags,
    LPCWSTR lpWideCharStr,
    int cchWideChar,
    LPSTR lpMultiByteStr,
    int cbMultiByte,
    LPCSTR lpDefaultChar,
    LPBOOL lpUsedDefaultChar
);
]]

require("ffi/posix_h")

local util = {}

-- 如果操作系统是windows
if ffi.os == "Windows" then
    util.gettime = function()
        local ft = ffi.new('FILETIME[1]')[0]
        local tmpres = ffi.new('unsigned long', 0)
        C.GetSystemTimeAsFileTime(ft)
        tmpres = bor(tmpres, ft.dwHighDateTime)
        tmpres = lshift(tmpres, 32)
        tmpres = bor(tmpres, ft.dwLowDateTime)
        -- converting file time to unix epoch
        tmpres = tmpres - 11644473600000000ULL
        tmpres = tmpres / 10
        return tonumber(tmpres / 1000000ULL), tonumber(tmpres % 1000000ULL)
    end
else
    -- 不是windows系统则返回当前的秒和微秒
    local timeval = ffi.new("struct timeval")
    util.gettime = function()
        C.gettimeofday(timeval, nil)
        return tonumber(timeval.tv_sec), tonumber(timeval.tv_usec)
    end
end
-- 如果是windows系统的秒和微秒计时
if ffi.os == "Windows" then
    util.sleep = function(sec)
        C.Sleep(sec*1000)
    end
    util.usleep = function(usec)
        C.Sleep(usec/1000)
    end
else
    --如果不是则直接用C语言种的延时
    util.sleep = C.sleep
    util.usleep = C.usleep
end
--statvfs读取文件系统信息
--传入路径，返回磁盘信息
--tonumber函数的作用是把必须为数字或者是可以转成数字的字符串转成十进制的数字
local statvfs = ffi.new("struct statvfs")
function util.df(path)
    C.statvfs(path, statvfs)
    --f_blocks: 文件系统数据块总数 * f_bsize: 文件系统块大小
    --f_bfree: 可用块数 * f_bsize: 文件系统块大小
    return tonumber(statvfs.f_blocks * statvfs.f_bsize),
        tonumber(statvfs.f_bfree * statvfs.f_bsize)
end

--- Wrapper for C.realpath.
function util.realpath(path)
    local buffer = ffi.new("char[?]", C.PATH_MAX)
    if ffi.os == "Windows" then
        if C.GetFullPathNameA(path, C.PATH_MAX, buffer, nil) ~= 0 then
            return ffi.string(buffer)
        end
    else
        --realpath（）用来将参数path所指的相对路径转换成绝对路径后存于参数buffer中
        --成功返回buffer，失败返回NULL
        if C.realpath(path, buffer) ~= nil then
        --返回绝对路径的字符串
            return ffi.string(buffer)
        end
    end
end

--- Wrapper for C.basename.
function util.basename(path)
    -- 把path转换成uint8_t *的对象
    local ptr = ffi.cast("uint8_t *", path)
    if ffi.os == "Windows" then
        return ffi.string(C.PathFindFileNameA(ptr))
    else
    --返回路径最后一个路径分隔符之后的内容
        return ffi.string(C.basename(ptr))
    end
end

--- Wrapper for C.dirname.
function util.dirname(in_path)
    --[[
    Both PathRemoveFileSpec and dirname will change original input string, so
    we need to make a copy.
    --]]
    --#号是获取字符串的长度，这个语句的意思是申请一个char* 的空间
    local path = ffi.new("char[?]", #in_path + 1)
    --把传入的参数拷贝到申请的空间中去
    ffi.copy(path, in_path)
    --把path转换成uint8_t *类型的
    local ptr = ffi.cast("uint8_t *", path)
    if ffi.os == "Windows" then
        if C.PathRemoveFileSpec(ptr) then
            return ffi.string(ptr)
        else
            return path
        end
    else
        --截取ptr中的路径返回
        return ffi.string(C.dirname(ptr))
    end
end

--- Copies file.
--拷贝文件
function util.copyFile(from, to)
    --以读二进制的形式打开文件
    local ffp, err = io.open(from, "rb")
    if err ~= nil then
        return err
    end
    --以写二进制的形式打开文件
    local tfp = io.open(to, "wb")

    while true do
        --每次读8192大小的内容
        local bytes = ffp:read(8192)
        --如果没有读到，关闭文件描述符
        if not bytes then
            ffp:close()
            break
        end
        --读到了则写进这个文件描述符
        tfp:write(bytes)
    end
    tfp:close()
end

--[[--
Joins paths.

NOTE: If `path2` is an absolute path, then this function ignores `path1` and returns `path2` directly.
--]]
function util.joinPath(path1, path2)
    --如果path2的第一个字符是'/',它就是绝对路径，直接返回
    if string.sub(path2, 1, 1) == "/" then
        return path2
    end
    --如果Path1最后一个不是‘/’,则返回添加'/'的字符串
    if string.sub(path1, -1, -1) ~= "/" then
        path1 = path1 .. "/"
    end
    --返回path1+path2的路径
    return path1 .. path2
end

--- Purges directory.
--清除目录
function util.purgeDir(dir)
    local ok, err
    --返回路径的指定属性
    ok, err = lfs.attributes(dir)
    --如果ok为nil 或者err不为nil
    if not ok or err ~= nil then
        return nil, err
    end
    --遍历目录下的所有入口，每次迭代返回值都作为入口名称的字符串
    for f in lfs.dir(dir) do
        --返回的节点不是当前目录或上个目录
        if f ~= "." and f ~= ".." then
            --调用上面封装好的函数，两个路径的判断拼接
            local fullpath = util.joinPath(dir, f)
            --返回当前文件/目录的数据
            local attributes = lfs.attributes(fullpath)
            --如果是目录的话
            if attributes.mode == "directory" then
                --递归调用当前函数
                ok, err = util.purgeDir(fullpath)
            else
                --删除当前目录
                ok, err = os.remove(fullpath)
            end
            if not ok or err ~= nil then
                return ok, err
            end
        end
    end
    --删除当前目录
    ok, err = os.remove(dir)
    return ok, err
end

--- Executes child process.
--exec 子进程中执行一个任务，执行完成后返回
function util.execute(...)
    --如果是安卓系统
    if util.isAndroid() then
        local A = require("android")
        return A.execute(...)
    --不是安卓系统
    else
        --fork父子进程
        local pid = C.fork()
        --等于0的时候是子进程
        if pid == 0 then
            --保存传进来的参数
            local args = {...}
            --调用c函数中的exec来执行这个任务，并且传入相应的参数
            os.exit(C.execl(args[1], unpack(args, 1, #args+1)))
        end
        --创建一个int的数组
        local status = ffi.new('int[1]')
        --父进程中等待子进程的任务执行完成
        C.waitpid(pid, status, 0)
        --返回任务执行完成后的结果
        return status[0]
    end
end

--- Run lua code (func) in a forked subprocess
--  在子进程中运行lua代码
-- With with_pipe=true, sets up a pipe for communication
--With With With_pipe=true，设置用于通信的管道
-- from children towards parent.
-- func is called with the child pid as 1st argument, and,
-- if with_pipe: a fd for writting
-- This function returns (to parent): the child pid, and,
-- if with_pipe: a fd for reading what the child wrote
-- if double_fork: do a double fork so the child gets reparented to init,
--                 ensuring automatic reaping of zombies.
--                 NOTE: In this case, the pid returned will *already*
--                       have been reaped, making it fairly useless.
--                       This means you do NOT have to call isSubProcessDone on it.
--                       It is safe to do so, though, it'll just immediately return success,
--                       as waitpid will return -1 w/ an ECHILD errno.
--[[-- 
在这种情况下，返回的pid将*已经*被收获，这使得它相当无用。这意味着您不必对它调用isSubProcessDone。这样做是安全的，但是，它将立即返回success，因为waitpid将返回-1w/anechild errno。
]]
function util.runInSubProcess(func, with_pipe, double_fork)
    local parent_read_fd, child_write_fd
    --创建无名管道
    if with_pipe then
        local pipe = ffi.new('int[2]', {-1, -1})
        if C.pipe(pipe) ~= 0 then -- failed creating pipe !
            return false
        end
        parent_read_fd, child_write_fd = pipe[0], pipe[1]
        if parent_read_fd == -1 or child_write_fd == -1 then
            return false
        end
    end
    --fork父子进程
    local pid = C.fork()
    --子进程
    if pid == 0 then -- child process
        if double_fork then
            --在fork父子进程
            pid = C.fork()
            if pid ~= 0 then
                -- Parent side of the outer fork, we don't need it anymore, so just exit.
                -- NOTE: Technically ought to be _exit, not exit.
                os.exit((pid < 0) and 1 or 0)
            end
            -- pid == 0 -> inner child :)
        end
        -- We need to wrap it with pcall: otherwise, if we were in a
        -- subroutine, the error would just abort the coroutine, bypassing
        -- our os.exit(0), and this subprocess would be a working 2nd instance
        -- of KOReader (with libraries or drivers probably getting messed up).
        local ok, err = xpcall(function()
            -- Give the child its own process group, so we can kill(-pid) it
            -- to have all its own children killed too (otherwise, parent
            -- process would kill the child, the child's children would
            -- be adopted by init, but parent would still have
            -- util.isSubProcessDone() returning false until all the child's
            -- children are done.
            C.setpgid(0, 0)
            if parent_read_fd then
                -- close our duplicate of parent fd
                C.close(parent_read_fd)
            end
            -- Just run the provided lua code object in this new process,
            -- and exit immediatly (so we do not release drivers and
            -- resources still used by parent process)
            -- We pass child pid to func, which can serve as a key
            -- to communicate with parent process.
            -- We pass child_write_fd (if with_pipe) so 'func' can write to it
            pid = C.getpid()
            func(pid, child_write_fd)
        end, debug.traceback)
        if not ok then
            print("error in subprocess:", err)
        end
        os.exit(0)
    end
    -- parent/main process
    if pid < 0 then -- on failure, fork() returns -1
        return false
    end
    -- If we double-fork, reap the outer fork now, since its only purpose is fork -> _exit
    if double_fork then
        local status = ffi.new('int[1]')
        local ret = C.waitpid(pid, status, 0)
        -- Returns pid on success, -1 on failure
        if ret < 0 then
            return false
        end
    end
    if child_write_fd then
        -- close our duplicate of child fd
        C.close(child_write_fd)
    end
    return pid, parent_read_fd
end

--- Collect subprocess so it does not become a zombie.
-- 收集子进程，使其不会成为僵尸。
-- This does not block. Returns true if process was collected or was already
-- no more running, false if process is still running
--[[

这不会阻塞。如果进程已收集或已不再运行，则返回true；如果进程仍在运行，则返回false
]]
function util.isSubProcessDone(pid)
    -- 创建一个Int数组
    local status = ffi.new('int[1]')
    --等待进程结束，返回信息存放到数组中
    local ret = C.waitpid(pid, status, 1) -- 1 = WNOHANG : don't wait, just tell
    -- status = tonumber(status[0])
    -- If still running: ret = 0 , status = 0
    -- If exited: ret = pid , status = 0 or 9 if killed
    -- If no more running: ret = -1 , status = 0
    --判断当前进程的状态
    if ret == pid or ret == -1 then
        return true
    end
    return false
end

--- Terminate subprocess pid by sending SIGKILL
-- 通过发送SIGKILL终止子进程pid
function util.terminateSubProcess(pid)
    --判断当前进程状态
    local done = util.isSubProcessDone(pid)
    if not done then
        -- We kill with signal 9/SIGKILL, which may be violent, but ensures
        -- that it is terminated (a process may catch or ignore SIGTERM)
        -- If we used setpgid(0,0) above, we can kill the process group
        -- instead, by just using -pid
        -- C.kill(pid, 9) 
        --[[
我们用信号9/SIGKILL杀死它，这可能很暴力，但是确保它被终止（进程可能会捕获或忽略SIGTERM）。如果我们使用上面的setpgid（0,0），我们可以通过使用-pid C.kill（pid，9）来杀死进程组

        ]]
        C.kill(-pid, 9)
        --[[
            进程仍必须通过调用util.isSubProcessDone（），在我们的kill（）之后的一段时间内，它仍可能返回false（）
        ]]
        -- Process will still have to be collected with calls to
        -- util.isSubProcessDone(), which may still return false for
        -- some small amount of time after our kill()
    end
end

--- Returns the length of data that can be read immediately without blocking
-- 返回可以立即读取而不阻塞的数据的长度
-- Accepts a low-level file descriptor, or a higher level lua file object
--接受低级文件描述符或更高级别的lua文件对象
-- returns 0 if not readable yet, otherwise len of available data
--如果还不可读，则返回0，否则返回可用数据的len
-- returns nil when unsupported: caller may read (with possible blocking)
-- 不支持时返回nil:caller可能读取（可能有阻塞）
-- Caveats with pipes: returns 0 too if other side of pipe has exited
-- 管道注意事项：如果管道的另一端已退出，也将返回0
-- without writing anything
-- 什么都没写
function util.getNonBlockingReadSize(fd_or_luafile)
    local fileno
    if type(fd_or_luafile) == "number" then -- low-level fd 文件描述符
        fileno = fd_or_luafile
    else -- lua file object 文件对象
        fileno = C.fileno(fd_or_luafile) --返回当前文件流的文件描述符
    end
    --申请一个int 数组
    local available = ffi.new('int[1]')
    --缓冲区中有多少字节要读取，把字节存入available中
    local ok = C.ioctl(fileno, C.FIONREAD, available)
    --失败直接返回
    if ok ~= 0 then -- ioctl failed, not supported
        return
    end
    available = tonumber(available[0])
    --成功返回字节数
    return available
end

--- Write data to file descriptor, and optionally close it when done
-- 
-- 将数据写入文件描述符，完成后可以选择关闭它
-- May block if data is large until the other end has read it.
--如果数据很大，可能会阻塞，直到另一端读取了它。 
-- If data fits into kernel pipe buffer, it can return before the
-- other end has started reading it.
--[[
    如果数据适合内核管道缓冲区，它可以在另一端开始读取之前返回。
]]
function util.writeToFD(fd, data, close_fd)
    --当前数据的大小
    local size = #data
    --转换数据格式
    local ptr = ffi.cast("uint8_t *", data)
    -- print("writing to fd")
    --把数据写入文件描述符中
    local bytes_written = C.write(fd, ptr, size)
    -- print("done writing to fd")
    --写入成功与否
    local success = bytes_written == size
    --关闭文件描述符
    if close_fd then
        C.close(fd)
        -- print("write fd closed")
    end
    --返回写入状态
    return success
end

--- Read all data from file descriptor, and close it.
-- 从文件描述符读取所有数据，然后关闭它。
-- This blocks until remote side has closed its side of the fd
-- 直到远程侧关闭其fd侧
function util.readAllFromFD(fd)
    local chunksize = 8192
    --申请8192的块大小
    local buffer = ffi.new('char[?]', chunksize, {0})
    local data = {}
    while true do
        -- print("reading from fd")
        --读取文件到申请的空间中，返回读取的字节数
        local bytes_read = tonumber(C.read(fd, ffi.cast('void*', buffer), chunksize))
        if bytes_read < 0 then
            --小于零则表示读取失败
            local err = ffi.errno()
            print("readFromFD() error: "..ffi.string(C.strerror(err)))
            break
            --等于零表示没有什么数据可读
        elseif bytes_read == 0 then -- EOF, no more data to read
            break
        else
            --把读取到的值插入表格中，第一次的下标为1，依次往后
            table.insert(data, ffi.string(buffer, bytes_read))
        end
    end
    C.close(fd)
    -- print("read fd closed")
    --把表格中的数据连接起来，就是读取到的全部数据
    return table.concat(data)
end

--- Ensure content written to lua file or fd is flushed to the storage device.
-- 确保写入lua文件或fd的内容被刷新到存储设备。
--
-- Accepts a low-level file descriptor, or a higher level lua file object,
-- 接受低级文件描述符或更高级别的lua文件对象，
-- which must still be opened (call :close() only after having called this).
-- 必须仍然打开（调用此函数后才调用：close（））
--如果可选参数sync_metadata为true，则使用fsync（）同时刷新文件元数据（时间戳…）
-- If optional parameter sync_metadata is true, use fsync() to also flush
-- file metadata (timestamps...), otherwise use fdatasync() to only flush
-- file content and file size. 
-- 否则，请使用fdatasync（）仅刷新文件内容和文件大小。
-- Returns true if syscall successful
-- See https://stackoverflow.com/questions/37288453/calling-fsync2-after-close2
function util.fsyncOpenedFile(fd_or_luafile, sync_metadata)
    local fileno
    if type(fd_or_luafile) == "number" then -- low-level fd 文件描述符号
        fileno = fd_or_luafile
    else -- lua file object
        -- 将用户空间缓冲区刷新到系统缓冲区
        fd_or_luafile:flush() -- flush user-space buffers to system buffers
        fileno = C.fileno(fd_or_luafile) --返回文件流中的文件描述符
    end
    local ret
    if sync_metadata then
        -- 同步内存中所有已修改的文件数据到储存设备。
        ret = C.fsync(fileno) -- sync file data and metadata
    else
        --仅仅在必要的情况下才会同步metadata
        ret = C.fdatasync(fileno) -- sync only file data
    end
    if ret ~= 0 then
        local err = ffi.errno()
        return false, ffi.string(C.strerror(err))
    end
    return true
end

--- Ensure directory content updates are flushed to the storage device.
-- 
-- 确保目录内容更新刷新到存储设备。
-- Accepts the directory path as a string, or a file path (from which
-- we can deduce the directory to sync).
--[[
接受目录路径为字符串或文件路径（从中我们可以推断出要同步的目录）。

]]
-- Returns true if syscall successful
-- See http://blog.httrack.com/blog/2013/11/15/everything-you-always-wanted-to-know-about-fsync/
function util.fsyncDirectory(path)
    local attributes, err = lfs.attributes(path)
    if not attributes or err ~= nil then
        return false, err
    end
    if attributes.mode ~= "directory" then
        -- file, symlink...: get its parent directory
        path = util.dirname(path)
        attributes, err = lfs.attributes(path)
        if not attributes or err ~= nil or attributes.mode ~= "directory" then
            return false, err
        end
    end
    local dirfd = C.open(ffi.cast("char *", path), C.O_RDONLY)
    if dirfd == -1 then
        err = ffi.errno()
        return false, ffi.string(C.strerror(err))
    end
    -- Not certain it's safe to use fdatasync(), so let's go with the more costly fsync()
    -- https://austin-group-l.opengroup.narkive.com/vC4Fjvsn/fsync-ing-a-directory-file-descriptor
    local ret = C.fsync(dirfd)
    if ret ~= 0 then
        err = ffi.errno()
        C.close(dirfd)
        return false, ffi.string(C.strerror(err))
    end
    C.close(dirfd)
    return true
end

--- Gets UTF-8 charcode.
--获取UTF-8字符码。
-- See unicodeCodepointToUtf8 in frontend/util for an encoder.
function util.utf8charcode(charstring)
    local ptr = ffi.cast("uint8_t *", charstring)
    local len = #charstring
    if len == 1 then
        return band(ptr[0], 0x7F)
    elseif len == 2 then
        return lshift(band(ptr[0], 0x1F), 6) +
            band(ptr[1], 0x3F)
    elseif len == 3 then
        return lshift(band(ptr[0], 0x0F), 12) +
            lshift(band(ptr[1], 0x3F), 6) +
            band(ptr[2], 0x3F)
    elseif len == 4 then
        return lshift(band(ptr[0], 0x07), 18) +
            lshift(band(ptr[1], 0x3F), 12) +
            lshift(band(ptr[2], 0x3F), 6) +
            band(ptr[3], 0x3F)
    end
end

local CP_UTF8 = 65001
--- Converts multibyte string to utf-8 encoded string on Windows.
-- 在Windows上将多字节字符串转换为utf-8编码字符串。
function util.multiByteToUTF8(str, codepage)
    -- if codepage is not provided we will query the system codepage
    -- 如果没有提供代码页，我们将查询系统代码页
    codepage = codepage or C.GetACP()
    local size = C.MultiByteToWideChar(codepage, 0, str, -1, nil, 0)
    if size > 0 then
        local wstr = ffi.new("wchar_t[?]", size)
        C.MultiByteToWideChar(codepage, 0, str, -1, wstr, size)
        size = C.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, nil, 0, nil, nil)
        if size > 0 then
            local mstr = ffi.new("char[?]", size)
            C.WideCharToMultiByte(CP_UTF8, 0, wstr, -1, mstr, size, nil, nil)
            return ffi.string(mstr)
        end
    end
end

function util.ffiLoadCandidates(candidates)
    local lib_loaded, lib
    --迭代加载传进来的C语言库
    for _, candidate in ipairs(candidates) do
        lib_loaded, lib = pcall(ffi.load, candidate)

        if lib_loaded then
            return lib
        end
    end

    -- we failed, lib is the error message
    return lib_loaded, lib
end

--- Returns true if isWindows…
-- 如果是windows 操作系统
function util.isWindows()
    return ffi.os == "Windows"
end

local isAndroid = nil
--- Returns true if Android.
-- For now, we just check if the "android" module can be loaded.
--现在只能通过加载安卓模块的形式来判断是否为安卓系统
function util.isAndroid()
    if isAndroid == nil then
        isAndroid = pcall(require, "android")
    end
    return isAndroid
end

local haveSDL2 = nil
--判断是否有SDL2
--- Returns true if SDL2
function util.haveSDL2()
    local err

    if haveSDL2 == nil then
        local candidates
        if jit.os == "OSX" then
            candidates = {"libs/libSDL2.dylib", "SDL2"}
        else
            candidates = {"SDL2", "libSDL2-2.0.so", "libSDL2-2.0.so.0"}
        end
        --加载sdl库
        haveSDL2, err = util.ffiLoadCandidates(candidates)
    end
    --如果没有包含SDL2库
    if not haveSDL2 then
        print("SDL2 not loaded:", err)
    end

    return haveSDL2
end

local isSDL = nil
--- Returns true if SDL
--返回当前系统是否包含SDL库
function util.isSDL()
    if isSDL == nil then
        --调用上面的函数
        isSDL = util.haveSDL2()
    end
    return isSDL
end

--- Division with integer result.
--结果为整数的除法。
function util.idiv(a, b)
    local q = a/b
    return (q > 0) and math.floor(q) or math.ceil(q)
end

-- pairs(), but with *keys* sorted alphabetically.
-- pairs（），但使用*键*按字母顺序排序。
-- c.f., http://lua-users.org/wiki/SortedIteration
-- See also http://lua-users.org/wiki/SortedIterationSimple
local function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    --实现排序
    table.sort( orderedIndex )
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic order.
    --相当于下一个函数，但按字母顺序返回键。
    -- We use a temporary ordered key table that is stored in the table being iterated.
    -- 我们使用一个临时有序键表，它存储在被迭代的表中。
    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function util.orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate in order
    --相当于表上的pairs（）函数。允许按顺序迭代
    return orderedNext, t, nil
end

--[[--
The util.template function allows for better translations through
dynamic positioning of place markers. The range of place markers
runs from %1 to %99, but normally no more than two or three should
be required. There are no provisions for escaping place markers.

@usage
    output = util.template(
        _("Hello %1, welcome to %2."),
        name,
        company
    )

This function was inspired by Qt:
<http://qt-project.org/doc/qt-4.8/internationalization.html#use-qstring-arg-for-dynamic-text>
--]]
function util.template(str, ...)
    local params = {...}
    -- shortcut:
    if #params == 0 then return str end
    local result = string.gsub(str, "%%([1-9][0-9]?)",
        function(i)
            return params[tonumber(i)]
        end)
    return result
end

return util
