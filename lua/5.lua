--私有性或信息隐藏是一门面向对象语言不可或缺的一部分
--每个对象的状态都应该由它自己控制
--lua语言中标准的对象实现方式没有提供私有性机制
--一个表用来保存对象的状态，另一个表用于保存对象的操作
--通过组成其接口的操作来访问。
--为了避免未授权的访问，表示对象状态的表不保存在其他表的字段中
--而只保存在方法的闭包中
function newaccount(init)
--创建一个用于保存对象内部状态的表
--将其存储在局部变量self中
	local self ={balance = init} 
	local withdraw = function (v)
		self.balance = self.balance -v
	end
	local deposit = function(v)
		self.balance = self.balance +v
	end
	local getbalance = function() return self.balance end
	return --创建并返回一个外部对象，该对象将方法名与真正的方法实现映射起来
	{
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getbalance
	}
end --这些方法不需要访问额外的self参数，而是直接访问self变量

--可以像普通函数那样来调用这些方法:
acc1 = newaccount(100)
acc1.withdraw(40)
print(acc1.getBalance())
--这种设计给与了存储在表self中所有内容完全的私有性

