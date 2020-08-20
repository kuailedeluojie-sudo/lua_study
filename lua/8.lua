--环境
--全局环境自身保存在全局变量_G中
--输出全局环境中所有全局变量的名称
for n in pairs(_G) do print(n) end
--写一个getfield让getfield("io.read")返回想要的结果
--这个函数主要是一个主循环，从_G开始逐个字段进行求值
function getfield(f)
	local v = _G --从全局表开始
	for w in string.gmatch(f,"[%a_][%w_]*") do
		v = v[w]
	end
	return v
end
--使用函数gmatch来遍历f中的所有标识符

--local temp = a.b.c
--temp.d = v

function setfield(f,v)
	local t = _G --从全局表开始
	for w ,d in string.gmatch(f,"([%a_][%w_]*)(%.?)") do
		if d == "." then --不是最后一个名字
			t[w] = t[w] or {} --如果不存在则创建表
			t = t[w] --获取表
		else --最后一个名字
			t[w] = v --进行赋值
		end
	end
end
--创建全局表t和t.x，并将10赋值给t.x.y
setfield("t.x.y",10)

print(t.x.y)
print(getfield("t.x.y"))
