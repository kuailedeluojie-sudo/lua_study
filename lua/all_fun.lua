--全动态函数调用
--调用一个数组参数作为回调函数的参数
local function run(x,y)
	print("run",x,y)
end

local function attack(x)
	print("targetid",x)
end
--1、要调用的函数实参时未知的；
--2、函数的实际参数类型和数目也是未知的
local function do_action(method,...)--传入函数名
	local args = {...} or {}
	method(unpack(args,1,table.maxn(args)))
end

do_action(run,1,2)
do_action(attack,11111)
