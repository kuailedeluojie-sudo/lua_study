function newobject(value)
	return function(action,v)
		if action == "get" then return value
		elseif action == "set" then value = v
		else error "invalid action"
		end
	end
end

d = newobject(0)
print(d("get"))
d("set",10)
print(d("get"))
--这种非传统的对象对象实现方式很高效
--每个对象实现一个闭包，要比使用一个表的开销更低
--虽然使用这种方法不能实现继承，但我们却可以拥有完全的私有性
--访问单方法对象中某个成员只能通过该对象所具有的唯一方法进行

