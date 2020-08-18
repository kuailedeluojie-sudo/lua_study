--多重继承
--关键在于把一个函数用作__index元方法
--一种多重继承的实现
--在表'plist'的列表中查找'k'
local function search(k,plist)
	for i = 1, #plist do
		print("1")
		local v = plist[i][k] -- 尝试第i个超类
		if v then return v end
	end
end

function createClass(...)
	local c = {} -- 新类
	local parents = {...} -- 父类列表
	
	--在父类列表中查找类缺失的方法
	setmetatable(c,{__index = function (t,k)
		print("1")
		return search(k,parents)
	end })
	
	--将'c'作为其实例的元表
	c.__index = c
	
	--为新类定义一个新的构造函数
	function c:new(o)
		o = o or {}
		setmetatable(o,c)
		return o
	end

	return c --返回新类
end

named = {}
function named:getname()
	return self.name
end

function named:setname(n)
	self.name =n
end

--创建一个同时继承Account和named的新类namedaccount
nd = createClass(Account,named)
--创建一个实例
a = nd:new{name = "bin"}
print(a:getname())
	

