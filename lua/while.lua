--[[
 while 表达式 do
 body 
 end
 没有提供continue 这样的控制语句用来立即进入下一个循环迭代
提供了一个break,可以跳出当前循环
]]
x = 1
sum = 0
while x <=5 do
	sum = sum+x
	x = x + 1
end
print(sum)
local t = {1,3,4,5,6,7,8,93,2,11}
local i 
--ipairs是一个用于遍历数组的迭代器函数
--循环中，i被赋予一个索引值
--同时v被赋予一个对应于该索引的数组元素值
for i , v in ipairs(t) do --i 是初始为1，最大值是这个数组大小10，v是数组具体的值
	print(i.."******"..v)
	if 11 == v then
		print("index["..i.."]have right value[11]")
	end
end
