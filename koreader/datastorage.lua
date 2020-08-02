-- need low-level mechnism to detect android to avoid recursive dependency
-- pcall在保护模式下执行函数内容，同时捕获所有的异常和错误。
-- 若一切正常，pcall返回true以及“被执行函数”的返回值，否则返回nil和错误信息。
-- 判断当前是否能加载安卓模块
local isAndroid, android = pcall(require, "android")

local lfs = require("libs/libkoreader-lfs")

local DataStorage = {}

local data_dir
local full_data_dir
-- 返回当前目录
function DataStorage:getDataDir()
    if data_dir then return data_dir end

    if isAndroid then
        data_dir = android.getExternalStoragePath() .. "/koreader"
    elseif os.getenv("UBUNTU_APPLICATION_ISOLATION") then
        local app_id = os.getenv("APP_ID")
        local package_name = app_id:match("^(.-)_")
        -- confined ubuntu app has write access to this dir
        data_dir = string.format("%s/%s", os.getenv("XDG_DATA_HOME"), package_name)
    elseif os.getenv("APPIMAGE") or os.getenv("KO_MULTIUSER") then
        data_dir = string.format("%s/%s/%s", os.getenv("HOME"), ".config", "koreader")
    else
        data_dir = "."
    end
    if lfs.attributes(data_dir, "mode") ~= "directory" then
        lfs.mkdir(data_dir)
    end

    return data_dir
end
--历史文件目录
function DataStorage:getHistoryDir()
    return self:getDataDir() .. "/history"
end
--设置目录
function DataStorage:getSettingsDir()
    return self:getDataDir() .. "/settings"
end


function DataStorage:getFullDataDir()
    if full_data_dir then return full_data_dir end

    if string.sub(self:getDataDir(), 1, 1) == "/" then
        full_data_dir = self:getDataDir()
    elseif self:getDataDir() == "." then
        full_data_dir = lfs.currentdir()
    end

    return full_data_dir
end

local function initDataDir()
    local sub_data_dirs = {
        "cache", "clipboard",
        "data", "data/dict", "data/tessdata",
        "history", "ota",
        "screenshots", "settings", "styletweaks",
    }
    --遍历数组成员，并且判断这个文件名的格式是否为文件夹，如果不是，则创建这个目录。
    for _, dir in ipairs(sub_data_dirs) do
        local sub_data_dir = string.format("%s/%s", DataStorage:getDataDir(), dir)
        if lfs.attributes(sub_data_dir, "mode") ~= "directory" then
            lfs.mkdir(sub_data_dir)
        end
    end
end
--初始化当前目录下的文件夹，如果没有，则创建
initDataDir()

return DataStorage
