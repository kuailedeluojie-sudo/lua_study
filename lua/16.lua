--记忆函数
--空间换时间是一种常见的编程技巧。
--我们可以通过记忆函数的执行结果，在后续使用相同参数再次调用该函数时直接返回
--之前记忆的结果，来加快函数的运行速度。

local results = {}
--setmetatable(results,{__mode = "v"}) --让表成为弱引用的
--每个垃圾收集周期都会删除所有那个时刻未使用的编译结果(基本上就是全部)
setmetatable(results,{__mode = "kv"}) --让表完全成为弱引用的
function mem_loadstring(s)
	local res = results[s]
	if res == nil then --已有结果么?
		res = assert(load(s)) --计算新结果
		results[s] = res --保存结果以便后续重用
	end
	return res
end

--节省很多可观的开销，也可能导致不易觉察的资源浪费。
--虽然有些命令会重复出现，但也有很多命令可能就出现一次。
--表results会堆积上服务器收到的所有命令及编译结果；在运行一段足够长的时间后
--这种行为会耗尽服务器的内存
