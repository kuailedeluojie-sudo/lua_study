-- set search path for 'require()'
--从package.path 路径中寻找指定模块名的Lua文件
package.path =
    "common/?.lua;rocks/share/lua/5.1/?.lua;frontend/?.lua;" ..
    package.path
-- 如果找不到则从c标准库中寻找
package.cpath =
    "common/?.so;common/?.dll;/usr/lib/lua/?.so;rocks/lib/lua/5.1/?.so;" ..
    package.cpath

-- set search path for 'ffi.load()'
-- FFI库允许调用外部C函数并 使用纯Lua代码中的C数据结构。
local ffi = require("ffi")
-- 加载ffi目录下的posix_h lua文件
local dummy = require("ffi/posix_h")
local C = ffi.C
if ffi.os == "Windows" then
    C._putenv("PATH=libs;common;")
end
local ffi_load = ffi.load
-- patch ffi.load for thirdparty luajit libraries
-- 把这些库全部加载进来
ffi.load = function(lib)
    io.write("ffi.load: ", lib, "\n")
    local loaded, re = pcall(ffi_load, lib)
    if loaded then return re end

    local lib_path = package.searchpath(lib, "./lib?.so;./libs/lib?.so;./libs/lib?.so.1")

    if not lib_path then
        io.write("ffi.load (warning): ", re, "\n")
        error('Not able to load dynamic library: ' .. lib)
    else
        io.write("ffi.load (assisted searchpath): ", lib_path, "\n")
        return ffi_load(lib_path)
    end
end
