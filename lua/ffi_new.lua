--[[
 cdata = ffi.new(ct[,nelem][,init...])
功能：开辟空间，第一个参数为ctype对象，ctype对象最好通关过ctype=ffi.typeof(ct)构建
如果使用ffi.new分配的cdata对象指向的内存块是由垃圾回收器luajit gc自动管理的，所以不需要用户去释放内存
如果使用ffi.C.malloc分配的空间便不再使用luajit自己的分配器了。
可以调用ffi.C.free来释放

ffi.fill(dst,len[,c])
功能：填充数据，此函数和memset(dst,c,len)类似，注意参数的顺序.

ffi.cast
cdata = ffi.cast(ct,init)
创建一个scalar cdata对象。

cdata 对象的垃圾回收
所有由显示的ffi.new(),ffi.cast()etc.或者隐式的accessors所创建的cdata对象都是能被垃圾回收的，当他们使用的时候要确保有在lua stack,upvalue,或者lua table上保留对cdata对象的有效引用，一旦最后一个cdata对象的有效引用失效了，那么垃圾回收器将自动释放内存(在下一个GC周期结束的时候)，另外如果你要分配一个cdata数组给一个指针的话，你必须保持这个持有这个数据的cdata对象活跃
]]--

--调用C函数

local ffi = require('ffi')
ffi.cdef[[
int printf(const char *fmt,...);
]]

ffi.C.printf("hello %s!\n","world")

