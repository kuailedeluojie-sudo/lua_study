--可以显式的使用_ENV来绕过局部声明
a = 13 --全局的
local a = 12 --局部
print (a) -- 局部
print(_ENV.a) -- 全局
--用_G也可以
print(_G.a)
--_ENV永远指向的是当前的环境
--假设在可见且无人改变过其值的前提下，_G通常指向的是全局变量

