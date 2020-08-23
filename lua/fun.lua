--形参的改变和实参的改变没有多大关系
local function swap(a,b)
	local temp = a
	a = b
	b = temp
	print(a,b)
end
local x = "hello"
local y = 20
print(x,y)
swap(x,y)
print(x,y)
print("***************")

local function fun1(a,b) --两个实参，多余的实参被忽略掉
	print(a,b)
end

local function fun2(a,b,c, d) --两个实参，没有被实参初始化的形参，用nil初始化
	print(a,b,c,d)
end

local x = 1
local y =2
local z = 3
fun1(x,y,z)
fun2(x,y,z)
print("***************")
--变长参数 ...表示该函数可以接收不同长度的参数
local function func(...) --形参为...，表示函数采用边长参数
	local temp = {...} -- 访问时也要使用...
	--组内容使用“”拼接成字符串
	local ans =table.concat(temp," ") --使用table.concat库对数
	print(ans)
end

func(1,2)
func(1,2,3,4)
print("***************")

--具名参数
--lua还支持通过名称来指定实参，这时候要把所有的实参组织到一个table中
--并将这个table作为唯一的实参传递给函数
local function change(arg) --改变长方形的长和宽，使其各增长一倍
	arg.width = arg.width*2
	arg.height = arg.height * 2
	return arg
end

local rectangle = {width = 20,height = 12}
print("###: width = ",rectangle.width,"height = ",rectangle.height)
rectangle = change(rectangle)
print("****: width = ",rectangle.width,"height = ",rectangle.height)
print("***************")

--按引用传参，当函数参数使table类型时，传递进来的是实际参数的引用
--此时在函数内部对table所做的改变，会直接对调用者所传递的实际参数生效
--而无需自己返回结果和让调用者赋值。
print("((((((: width = ",rectangle.width,"height = ",rectangle.height)
 change(rectangle)
print(")))))): width = ",rectangle.width,"height = ",rectangle.height)
print("***************")

--在常用基本类型中，除了table是按地址传递类型外，其他都是按值传递参数。
--良好的编程习惯应该减少全局变量的使用


