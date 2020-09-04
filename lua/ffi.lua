--[[
FFI库，是luajit中最重要的一个库。它允许从纯lua代码调用外部C函数，使用c数据结构。
有了它，就不用再像标准math库一样，编写lua拓展库，把开发者从开发lua扩展C库（语言/功能绑定库）的繁重工作中释放出来。
FFi库最大限度的省去了使用C手工编写繁重的lua/c绑定的需要。不需要学习一门独立/额外的绑定语言--它解析普通C说明。这样就可以从c头文件或者参考手册中，直接剪切，粘贴。
它的任务就是绑定很大的库，但不需要捣鼓脆弱的绑定生成器。
ffi紧紧的整合进了LUAJIT（几乎不可能作为一个独立的模块）。jit编译器在c数据结构上所产生的代码，等同于一个c编译器应该生产的代码。
在jit编译过的代码中，调用c函数，可以被内连处理，不同于基于lua/c API函数调用。
	
gcc -g -o *.so -fpic -shared *.c
LD_LIBRARY_PATH 编译器在查找动态库所在的路径的时候就是在这个变量中的所有路径查找.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD

]]--
--完整的例子
local ffi = require "ffi"
local myffi = ffi.load('myffi')

ffi.cdef[[
int add(int x,int y);
]]

local res = myffi.add(1,2)
print(res)
