--[[
还可以使用ffi.c(调用ffi.cdef中声明的系统函数)来直接调用add函数
记得要在ffi.load的时候加上参数true,例如ffi.load("myffi",true)
]]--

local ffi = require "ffi"
local sdl = ffi.load('hello')

ffi.cdef[[
	int sdl_1();
]]
local res = sdl.sdl_1()
--local res = ffi.C.add(1,2)
print(res)
