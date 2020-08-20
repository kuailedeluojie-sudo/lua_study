--检查全局变量的声明
local declaredNames = {}
setmetatable(_G,{
	__newindex = function(t,n,v)
		if not declareNames[n] then
			local w = debug.getinfo(2,"S").what
			if w ~= "main" and w ~= "C" then
				error("attempt to write to undeclared variable " .. n,2)
			end
			declaredNames[n] = true
		end
		rawset(t,n,v) -- 进行真正的赋值
	end

	__index = function(_,n)
		if not declaredNames[n] then
				error("attempt to write to undeclared variable " .. n,2)
			else
				return nil
			end
		end,
	})

--元方法只有当程序访问一个值为nil的变量时才会被调用
--lua语言发行版中包含了一个strict.lua模块，实现了对全局变量的检查

