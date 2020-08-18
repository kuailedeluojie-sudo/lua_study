--使用参数self是所有面向对象语言的核心点，
--大多数面向对象语言都向程序员隐藏了这个机制
--可以在方法内使用self或者this
--可以通过冒号隐藏该参数，是在调用中增加一个实参。

Account = {
	balance = 0,
	withdraw = function(self,v)
		self.balance = self.balance - v
	end

}

function Account:deposit(v)
	self.balance = self.balance + v
end

--用点分方法定义一个函数，然后用冒号来调用，只要能正确处理好额外的参数就可以了
Account.deposit(Account,200)
print(Account.balance)
Account:withdraw(100)
print(Account.balance)

--继承的思想实现原型
--setmetatable(A,{__index = B})
local mt = {__index = Account}

function Account.new(o)
	o = o or {} -- 如果用户灭有提供则创建一个表
	setmetatable(o,mt)--继承mt 到o
	return o;
end


a = Account.new{balance=0}
a:deposit(100)
print(a.balance)

--改进一下
function Account:new1(o) --冒号法引进slef 本身
	o = o or {}
	self.__index = self --不创建扮演元表角色的新表而是直接把Account变成元表
	setmetatable(o,self)
	return o
end
a = Account:new1{balance=0}
a:deposit(100)
print(a.balance)
