--非全局变量
--_ENV是一个普通的变量，因此可以对其复制或访问其他变量一样访问它。
--赋值语句_ENV = nil 会使得后续代码不能直接访问全局变量。
--这可以用来代码使用那些变量
local print,sin = print,math.sin
_ENV = nil
print(13)
print(sin(13))
print(math.sin(13)) --error
