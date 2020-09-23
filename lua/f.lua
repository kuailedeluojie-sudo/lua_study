local ffi = require "ffi"
local myffi = ffi.load("float")
ffi.cdef[[
float add (float x,float y);
]]

local res = myffi.add(1.2,3.4)
print(string.format("%.2f",res))
