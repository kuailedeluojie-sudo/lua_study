--协程
--协程相关得所有函数都被放在表coroutine中
--函数create用于创建新协程，该函数只有一个参数，即协程要执行得代码得函数(协程体(body))
--一个协程有四种状态、挂起suspended、正常normal、运行running、死亡dead
--可以通过函数coroutine.status检查协程的状态
--函数coroutine.resume用于启动或再次启动一个协程的执行
--协程真正的强大之处在于函数yield，该函数可以让一个运行中的协程挂起自己，然后在后续恢复运行
--通过resume-yield来交换数据，第一个resume函数(没有对应等待它饿顶yield)会把所有额外的参数传递给协程的主函数
--当一个协程结束时，主函数所返回的值都将成为对应函数resume的返回值
function  receive(prod)
local status,value = coroutine.resume(prod)
return value
end

function send(x)
	coroutine.yield(x)
end

function producer()
	return coroutine.create(function()
		while true do
			local x = io.read() --产生新值
			send(x)
		end
	end
	)
end

function filter(prod)
	return coroutine.create(function()
		for line = 1,math.huge do
			local x = receive(prod) --接收新值 
			x = string.format("%5d %s",line,x)
			send(x) --发送给消费者
		end
	end)
end

function consumer(prod)
	while true do
		local x = receive(prod) --获取新值
		io.write(x,"\n") --消费新值
	end
end

consumer(filter(producer()))
