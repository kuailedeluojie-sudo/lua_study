--对偶表示
--使用键来把属性关联到表
--table[key] = value
--也可以对偶表示：把表当作键，同时把这个对象本身当作这个表的键：
--key = {}
--key[table] = value
--关键在于：不仅可以通过数值和字符串来索引一个表，还可以通过任何值来索引一个表
--尤其是可以通过其他的表来索引一个表
local balance = {}
Account = {}
function Account:withdraw(v)
	balance[self] = balance[self] - v
end

function Account:deposit(v)
	balance[self] = balance[self] + v
end

function Account:balance()
	return balance[self]
end

function Account:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	balance[o] = 0 --初始余额
	return o
end

a = Account:new()
a:deposit(100)
print(a:balance())
--这种实现对垃圾收集器来说需要一些额外的工作
