--这个函数只针对特定的函数工作，如果改变对象名称，那么它就不能工作
Account = {balance = 0}
--[[
function Account.withdraw(v)
	Account.balance = Account.balance - v
end

Account.withdraw(100)
]]
print(Account.balance)

--更加有原则的办法是对操作的接收者(receiver)进行操作。
--因此，我们的方法需要一个额外的参数来表示该接受者，这个参数通常被称为self或this:

function Account.withdraw(self,v)
	self.balance = self.balance -v
end

a1 = Account
Account = nil
a1.withdraw(a1,100)
print(a1.balance)

--通过使用self,可以对多个对象调用相同的方法：
a2 = a1
print(a2.balance)
a2 = {balance = 0,withdraw = a1.withdraw}
a2.withdraw(a2,260)
print(a2.balance)
