--加载FFI库
local ffi = require("ffi")

-- Handle arch-dependent typedefs...
if ffi.arch == "x64" then
    require("ffi/posix_types_x64_h")
elseif ffi.arch == "x86" then
    require("ffi/posix_types_x86_h")
elseif ffi.abi("64bit") then
    require("ffi/posix_types_64b_h")
else
    require("ffi/posix_types_def_h")
end
--为函数添加一个c声明，双括号内的部分只是标准C语法
ffi.cdef[[
int pipe(int *) __attribute__((nothrow, leaf));
int fork(void) __attribute__((nothrow));
int dup(int) __attribute__((nothrow, leaf));
int dup2(int, int) __attribute__((nothrow, leaf));
static const int O_RDWR = 2;
static const int O_RDONLY = 0;
static const int O_NONBLOCK = 2048;
static const int O_CLOEXEC = 524288;
int open(const char *, int, ...);
int close(int);
int fcntl(int, int, ...);
int execl(const char *, const char *, ...) __attribute__((nothrow, leaf));
int execlp(const char *, const char *, ...) __attribute__((nothrow, leaf));
int execv(const char *, char *const *) __attribute__((nothrow, leaf));
int execvp(const char *, char *const *) __attribute__((nothrow, leaf));
ssize_t write(int, const void *, size_t);
ssize_t read(int, void *, size_t);
int kill(int, int) __attribute__((nothrow, leaf));
int waitpid(int, int *, int);
int getpid(void) __attribute__((nothrow, leaf));
int setpgid(int, int) __attribute__((nothrow, leaf));
struct pollfd {
  int fd;
  short int events;
  short int revents;
};
static const int POLLIN = 1;
static const int POLLOUT = 4;
static const int POLLERR = 8;
static const int POLLHUP = 16;
int poll(struct pollfd *, long unsigned int, int);
static const int PROT_READ = 1;
static const int PROT_WRITE = 2;
static const int MAP_SHARED = 1;
static const int MAP_FAILED = -1;
static const int PATH_MAX = 4096;
int memcmp(const void *, const void *, size_t) __attribute__((pure, leaf, nothrow));
void *mmap(void *, size_t, int, int, int, off_t) __attribute__((nothrow, leaf));
int munmap(void *, size_t) __attribute__((nothrow, leaf));
int ioctl(int, long unsigned int, ...) __attribute__((nothrow, leaf));
void Sleep(int ms);
unsigned int sleep(unsigned int);
int usleep(unsigned int);
int statvfs(const char *restrict, struct statvfs *restrict) __attribute__((nothrow, leaf));
int gettimeofday(struct timeval *restrict, struct timezone *restrict) __attribute__((nothrow, leaf));
char *realpath(const char *restrict, char *restrict) __attribute__((nothrow, leaf));
char *basename(char *) __attribute__((nothrow, leaf));
char *dirname(char *) __attribute__((nothrow, leaf));
void *malloc(size_t) __attribute__((malloc, leaf, nothrow));
void free(void *) __attribute__((leaf, nothrow));
void *memset(void *, int, size_t) __attribute__((leaf, nothrow));
char *strdup(const char *) __attribute__((malloc, leaf, nothrow));
char *strndup(const char *, size_t) __attribute__((malloc, leaf, nothrow));
struct _IO_FILE *fopen(const char *restrict, const char *restrict);
int fclose(struct _IO_FILE *);
int printf(const char *, ...);
int sprintf(char *, const char *, ...) __attribute__((nothrow));
int fprintf(struct _IO_FILE *restrict, const char *restrict, ...);
int fputc(int, struct _IO_FILE *);
static const int FIONREAD = 21531;
int fileno(struct _IO_FILE *) __attribute__((nothrow, leaf));
char *strerror(int) __attribute__((nothrow, leaf));
int fsync(int);
int fdatasync(int);
int setenv(const char *, const char *, int) __attribute__((nothrow, leaf));
int unsetenv(const char *) __attribute__((nothrow, leaf));
int _putenv(const char *);
]]
--可以用ffi.c.printf("hello %s!","world")调用命名的C函数
-- lua建立在高级数据类型上，它们是灵活的，可扩展的和动态的。
--创建一个额外的c文件，添加一个c函数以检索和检查从lua传递的参数类型并调用实际的c函数
--添加一个模块列表及其名称，添加luaopen_*函数并注册所有模块函数，编译并将其链接到共享库
--移到正确的路径，添加用于加载模块的lua代码，绑定调用该功能