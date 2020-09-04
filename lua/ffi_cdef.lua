--[[
还可以使用ffi.c(调用ffi.cdef中声明的系统函数)来直接调用add函数
记得要在ffi.load的时候加上参数true,例如ffi.load("myffi",true)
]]--

local ffi = require "ffi"
ffi.load('myffi',true)

ffi.cdef[[
	int add (int x,int y);
]]

local res = ffi.C.add(1,2)
print(res)
