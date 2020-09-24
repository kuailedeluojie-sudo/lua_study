function allwords()
	local line = io.read() -- 当前行
	local pos = 1 --当前行的位置
	return function() --迭代函数
		while line do --当还有行时循环
			local w,e = string.match(line,"(%w+)()",pos)
			if w then
				pos = e
				return w 
			else
				line = io.read()
				pos = 1
			end
		end
		return nil
	end
end
--function for_word()
for word in allwords() do
	print(word)
end
--end
