--生成排列的函数
function printResule(a)
	for i = 1,#a do io.write(a[i]," ") end
	io.write("\n")
end
function permgen(a,n)
	n = n or #a -- 'n'的默认大小是'a'
	if n <= 1 then
			io.write("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n")
		printResule(a)
			io.write("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n")
	else
		for i = 1,n do
			a[n],a[i] = a[i],a[n]
			io.write("******************************\n")
		printResule(a)
			io.write("******************************\n")
			permgen(a,n-1)
			a[n],a[i] = a[i],a[n]
			io.write("##############################\n")
		printResule(a)
			io.write("##############################\n")
		end
	end
end

permgen({1,2,3,4})
			
