local ffi = require("ffi")
--加载ffi模块
--用C语言重新定义变量
--想买一本luaffi的书籍看一下，听说这个是处理速度最快的脚本语言
ffi.cdef[[
static const int EVIOCGRAB = 1074021776;
static const int EV_SYN = 0;
static const int EV_KEY = 1;
static const int EV_REL = 2;
static const int EV_ABS = 3;
static const int EV_MSC = 4;
static const int EV_SW = 5;
static const int EV_LED = 17;
static const int EV_SND = 18;
static const int EV_REP = 20;
static const int EV_FF = 21;
static const int EV_PWR = 22;
static const int EV_FF_STATUS = 23;
static const int EV_MAX = 31;
static const int SYN_REPORT = 0;
static const int SYN_CONFIG = 1;
static const int SYN_MT_REPORT = 2;
static const int SYN_DROPPED = 3;
static const int ABS_MT_SLOT = 47;
static const int ABS_MT_TOUCH_MAJOR = 48;
static const int ABS_MT_TOUCH_MINOR = 49;
static const int ABS_MT_WIDTH_MAJOR = 50;
static const int ABS_MT_WIDTH_MINOR = 51;
static const int ABS_MT_ORIENTATION = 52;
static const int ABS_MT_POSITION_X = 53;
static const int ABS_MT_POSITION_Y = 54;
static const int ABS_MT_TOOL_TYPE = 55;
static const int ABS_MT_BLOB_ID = 56;
static const int ABS_MT_TRACKING_ID = 57;
static const int ABS_MT_PRESSURE = 58;
static const int ABS_MT_DISTANCE = 59;
static const int ABS_MT_TOOL_X = 60;
static const int ABS_MT_TOOL_Y = 61;
struct input_event {
  struct timeval time;
  short unsigned int type;
  short unsigned int code;
  int value;
};
]]
