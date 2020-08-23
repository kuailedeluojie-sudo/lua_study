--lua中的repeat控制结构类似于其他语言中的do -while,但是控制方式是刚好相反的。
--简单点说，执行repeat循环后，直到until的条件为真时结束，其他语言的do-while是为假时结束

x = 0
repeat
	print(x)
until false
--该代码导致死循环，因为until的条件一直为假，循环不会结束
--也可以使用break退出
