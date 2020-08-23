--函数返回值
--lua具有一个与众不通的特性，允许函数返回多个值。
local s,e = string.find("hello world","llo")
print(s,e) --查找成功，则返回目标字符串在源字符串中的起始位置和结束位置的下标

--返回多个值时，直接用,号隔开
--
print("***********************")
local function swap(a,b)
	return b,a --按相反的顺序返回变量的值
end

local x = 1
local y = 20
x,y = swap(x,y)
print(x,y)
print("***********************")
--调整规则，若返回值的个数大宇接收变量的个数，多余的返回值会被忽略掉
--若返回值个数小于参数个数，从左往右，没有被返回值初始化的变量会被初始化为nil
function init()
	return 1,"lua" --返回两个值 1 和"lua"
end

x = init()
print(x)

x,y,z = init()
print(x,y,z)

print(init())
print("***********************")
--当一个函数有一个以上的返回值，且函数调用不是一个列表表达式的最后一个元素
--那么函数调用只会产生一个返回值，也就是第一个返回值
local x ,y,z = init(),2 --init 函数的位置不在最后，此时只返回1
print(x,y,z)
local a,b,c = 2,init() --init函数的位置在最后，此时返回1 和"lua"
print(a,b,c)
print("***********************")

--函数调用的实参也是一个例子
print(init(),2)
print(2,init())

--如果确保只取函数返回值的第一个值，可以用括号运算符
print((init()),2)
print(2,(init()))
--如果没有显式的使用括号运算符来筛选和过滤，只能被解释执行

