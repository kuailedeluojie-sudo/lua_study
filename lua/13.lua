--[[
a = 15   --创建一个全局变量
_ENV = {g = _G} --改变当前环境
a = 1 --在_ENV中创建一个字段
g.print(_ENV.a,g.a) --1 15
a = 15
_ENV = {_G = _G}
a = 1
_G.print(_ENV.a,_G.a)
--print(_ENV.a,_G.a) --error
a = 1
local newgt = {} --设置新环境
setmetatable(newgt,{__index = _G})
_ENV = newgt -- 设置新环境
print(a)
a = 10
print(a,_G.a)
_G.a = 20
print(a)

--作为一个普通的变量，_ENV遵循通常的定界规则。
--特别的，在一段代码中定义的函数可以按照访问其他变量一样的规则访问_ENV:
_ENV = {_G = _G}
local function foo()
	_G.print(a) -- 编译为'_ENV._G.print(_ENV.a)'
end
a = 10
foo() -- 10
_ENV = {_G = _G,a = 20}
foo() -- 20

--如果定义一个名为_ENV的局部变量,那么对自由名称的引用将会绑定到这个新变量上：

a = 2
do
	local _ENV = {print = print,a = 14}
	print(a) -- 14
end
print(a) --2
]]
--可以很容易的使用私有环境定义一个函数:
function factory(_ENV)
	return function() return a end

end
f1  = factory{a = 6}
f2  = factory{a = 7}
print(f1())
print(f2())
