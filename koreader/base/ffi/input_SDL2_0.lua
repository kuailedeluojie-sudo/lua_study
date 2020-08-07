-- load common SDL input/video library
--这里直接加载了SDL的输入，晚上备注SDL
local SDL = require("ffi/SDL2_0")

return {
    open = SDL.open,
    waitForEvent = SDL.waitForEvent,
    -- NOP:
    fakeTapInput = function() end,
    -- NOP:
    closeAll = function() end,
    hasClipboardText = SDL.hasClipboardText,
    getClipboardText = SDL.getClipboardText,
    setClipboardText = SDL.setClipboardText,
    gameControllerRumble = SDL.gameControllerRumble,
}
