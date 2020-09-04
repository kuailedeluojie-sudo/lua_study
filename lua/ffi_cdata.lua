--[[
使用C数据结构
cdata类型用来将任意C数据保存在lua变量中。这个类型相当于一块原生的内存，除了赋值和相同性判断，lua没有为之预定义任何操作。
然而，通过使用metatable(元表),程序员可以为cdata自定义一组操作。
cdata不能在lua中创建出来，也不能在lua中修改。
这样的操作只能通过C API，这一点保证了宿主程序完全掌管其中的数据。

我们将c语言类型metamethod(元方法)关联起来，这个操作只用做一次。
ffi.metatype会返回一个该类型的构造函数。
原始C类型也可以用来创建数组，元方法会自动的应用到每个元素。
尤其需要指出的是，metatable与C类型的关联是永久的，而且不允许被修改，__index元方法也是

]]--

local ffi = require("ffi")
ffi.cdef[[
	typedef struct {double x,y;} point_t;
]]

local point
local mt = {
	__add = function(a,b) return point(a.x+b.x,a.y+b.y) end,
	__len = function(a) return math.sqrt(a.x*a.x + a.y * a.y) end,
	__index = {
		area = function(a) return a.x * a.x + a.y * a.y end,
	},
}

point = ffi.metatype("point_t",mt)

local a = point(3,4)
print(a.x,a.y)
print(#a)
print(a:area())
local b = a + point(0.5,8)
print(#b)
