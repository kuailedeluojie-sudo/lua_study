--垃圾回收
--弱引用表
--元表的__mode字段为"k",这个表的键是弱引用的
--"v",这个表的值是弱引用的
--"kv",这个表的值和键都是弱引用的
a = {}
mt = {__mode = "k"}
setmetatable(a,mt) -- 现在'a'的键是弱引用的了
key = {} -- 创建第一个键
a[key] = 1
key = {} --创建第二个键
a[key] = 2
collectgarbage() -- 强制进行垃圾回收
for k,v in pairs(a) do print(v) end
--由于已经没有指向第一个键的其他引用，因此Lua语言会回收这个键并从表中删除对应的元素
