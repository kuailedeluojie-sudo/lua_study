--加载模块
local util = require("ffi/util")
--util.lua备注完成
--换一个键盘输入，小键盘比较适合我。
--像我聪明的人，本该灿烂过一生，怎么二十多岁了，还在人海里浮沉，毛不易的这首歌写的真是不错啊
--这里主要通过util来判断当前是否有sdl，如果有的直接加载sdl的输入处理，今天晚上就备注这个SDL的输入处理
if util.isSDL() then
    if util.haveSDL2() then
        return require("ffi/input_SDL2_0")
    end
elseif util.isAndroid() then
    return require("ffi/input_android")
else
    return require("libs/libkoreader-input")
end
