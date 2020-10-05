--[[--
Logger module.
See @{Logger.levels} for list of supported levels.

Example:

    local logger = require("logger")
    logger.info("Something happened.")
    logger.err("House is on fire!")
]]

local dump = require("dump")
local isAndroid, android = pcall(require, "android")

local DEFAULT_DUMP_LVL = 10

--- Supported logging levels
-- @table Logger.levels
-- @field dbg debug
-- @field info informational (default level)
-- @field warn warning
-- @field err error
local LOG_LVL = {
    dbg = 1,
    info = 2,
    warn = 3,
    err = 4,
}

local LOG_PREFIX = {
    dbg = 'DEBUG',
    info = 'INFO ',
    warn = 'WARN ',
    err = 'ERROR',
}

local noop = function() end

local Logger = {
    levels = LOG_LVL,
}
--定义打印信息
local function log(log_lvl, dump_lvl, ...)
    local line = ""
    for i,v in ipairs({...}) do
        if type(v) == "table" then
            line = line .. " " .. dump(v, dump_lvl)
        else
            line = line .. " " .. tostring(v)
        end
    end
    if isAndroid then
        if log_lvl == "dbg" then
            android.LOGV(line)
        elseif log_lvl == "info" then
            android.LOGI(line)
        elseif log_lvl == "warn" then
            android.LOGW(line)
        elseif log_lvl == "err" then
            android.LOGE(line)
        end
    else
        io.stdout:write(os.date("%x-%X"), " ", LOG_PREFIX[log_lvl], line, "\n")
        io.stdout:flush()
    end
end

--确定传进来的参数匹配这个表格中的那个参数
local LVL_FUNCTIONS = {
    dbg = function(...) log('dbg', DEFAULT_DUMP_LVL, ...) end,
    info = function(...) log('info', DEFAULT_DUMP_LVL, ...) end,
    warn = function(...) log('warn', DEFAULT_DUMP_LVL, ...) end,
    err = function(...) log('err', DEFAULT_DUMP_LVL, ...) end,
}

--设置打印等级
--[[--
Set logging level. By default, level is set to info.

@int new_lvl new logging level, must be one of the levels from @{Logger.levels}

@usage
Logger:setLevel(Logger.levels.warn)
]]
function Logger:setLevel(new_lvl)
    for lvl_name, lvl_value in pairs(LOG_LVL) do
        if new_lvl <= lvl_value then
            self[lvl_name] = LVL_FUNCTIONS[lvl_name] --匹配到参数
        else
            self[lvl_name] = noop
        end
    end
end

Logger:setLevel(LOG_LVL.info) --设置打印等级

return Logger
