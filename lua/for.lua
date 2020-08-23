
--数字型for语句：
--for var = begin,finish,step do
--body
--end
--var 从begin变化到finish,每次变化都以step作为步长递增

for i = 1,5 do 
	print(i)
end
print("***************")
for i = 1,10,2 do 
	print(i)
end
print("***************")
for i = 10,1,-1 do 
	print(i)
end
print("***************")
--不给循坏设置上限，使用常量math.huge
for i = 1,math.huge do
	if(0.3*i^3 - 20*i^2 -500 >= 0) then
	print(i)
	break
	end
	print(i)
end
print("***************")
--泛型for循环通过一个迭代器遍历所有值
local a = {"a","b","c","d"}
--ipairs的使用
for i,v in ipairs(a) do
	print("index:",i,"value",v," ",a[i])
end
print("***************")
-- 1234
for t in pairs(a) do
	print(t)
end
print("***************")

