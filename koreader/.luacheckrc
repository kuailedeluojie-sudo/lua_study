unused_args = false
std = "luajit"
-- ignore implicit self
self = false

globals = {
    "G_reader_settings",
}

read_globals = {
    "_ENV",
    "KOBO_TOUCH_MIRRORED",
    "KOBO_SYNC_BRIGHTNESS_WITH_NICKEL",
    "DHINTCOUNT",
    "DRENDER_MODE",
    "DGLOBAL_CACHE_SIZE_MINIMUM",
    "DGLOBAL_CACHE_FREE_PROPORTION",
    "DGLOBAL_CACHE_SIZE_MAXIMUM",
    "DBACKGROUND_COLOR",
    "DOUTER_PAGE_COLOR",
    "DCREREADER_VIEW_MODE",
    "DSHOWOVERLAP",
    "DSHOWHIDDENFILES",
    "DLANDSCAPE_CLOCKWISE_ROTATION",
    "DCREREADER_TWO_PAGE_THRESHOLD",
    "DOVERLAPPIXELS",
    "FOLLOW_LINK_TIMEOUT",
    "DTAP_ZONE_MENU",
    "DTAP_ZONE_CONFIG",
    "DTAP_ZONE_MINIBAR",
    "DTAP_ZONE_FORWARD",
    "DTAP_ZONE_BACKWARD",
    "DTAP_ZONE_BOOKMARK",
    "DTAP_ZONE_FLIPPING",
    "DTAP_ZONE_TOP_LEFT",
    "DTAP_ZONE_TOP_RIGHT",
    "DTAP_ZONE_BOTTOM_LEFT",
    "DTAP_ZONE_BOTTOM_RIGHT",
    "DDOUBLE_TAP_ZONE_NEXT_CHAPTER",
    "DDOUBLE_TAP_ZONE_PREV_CHAPTER",
    "DCHANGE_WEST_SWIPE_TO_EAST",
    "DCHANGE_EAST_SWIPE_TO_WEST",
    "DKOPTREADER_CONFIG_FONT_SIZE",
    "DKOPTREADER_CONFIG_TEXT_WRAP",
    "DKOPTREADER_CONFIG_TRIM_PAGE",
    "DKOPTREADER_CONFIG_DETECT_INDENT",
    "DKOPTREADER_CONFIG_DEFECT_SIZE",
    "DKOPTREADER_CONFIG_PAGE_MARGIN",
    "DKOPTREADER_CONFIG_LINE_SPACING",
    "DKOPTREADER_CONFIG_RENDER_QUALITY",
    "DKOPTREADER_CONFIG_AUTO_STRAIGHTEN",
    "DKOPTREADER_CONFIG_JUSTIFICATION",
    "DKOPTREADER_CONFIG_MAX_COLUMNS",
    "DKOPTREADER_CONFIG_CONTRAST",
    "DKOPTREADER_CONFIG_WORD_SPACINGS",
    "DKOPTREADER_CONFIG_DEFAULT_WORD_SPACING",
    "DKOPTREADER_CONFIG_DOC_LANGS_TEXT",
    "DKOPTREADER_CONFIG_DOC_LANGS_CODE",
    "DKOPTREADER_CONFIG_DOC_DEFAULT_LANG_CODE",
    "DCREREADER_CONFIG_FONT_SIZES",
    "DCREREADER_CONFIG_DEFAULT_FONT_SIZE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_SMALL",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_MEDIUM",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_LARGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_X_LARGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_XX_LARGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_XXX_LARGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_HUGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_X_HUGE",
    "DCREREADER_CONFIG_H_MARGIN_SIZES_XX_HUGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_SMALL",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_MEDIUM",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_LARGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_X_LARGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_XX_LARGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_XXX_LARGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_HUGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_X_HUGE",
    "DCREREADER_CONFIG_T_MARGIN_SIZES_XX_HUGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_SMALL",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_MEDIUM",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_LARGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_X_LARGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_XX_LARGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_XXX_LARGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_HUGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_X_HUGE",
    "DCREREADER_CONFIG_B_MARGIN_SIZES_XX_HUGE",
    "DCREREADER_CONFIG_LIGHTER_FONT_GAMMA",
    "DCREREADER_CONFIG_DEFAULT_FONT_GAMMA",
    "DCREREADER_CONFIG_DARKER_FONT_GAMMA",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_X_TINY",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_TINY",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_XX_SMALL",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_X_SMALL",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_SMALL",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_L_SMALL",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_MEDIUM",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_L_MEDIUM",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_XL_MEDIUM",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_XXL_MEDIUM",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_LARGE",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_X_LARGE",
    "DCREREADER_CONFIG_LINE_SPACE_PERCENT_XX_LARGE",
    "DCREREADER_CONFIG_WORD_SPACING_SMALL",
    "DCREREADER_CONFIG_WORD_SPACING_MEDIUM",
    "DCREREADER_CONFIG_WORD_SPACING_LARGE",
    "DCREREADER_CONFIG_WORD_EXPANSION_NONE",
    "DCREREADER_CONFIG_WORD_EXPANSION_SOME",
    "DCREREADER_CONFIG_WORD_EXPANSION_MORE",
    "DMINIBAR_CONTAINER_HEIGHT",
    "DGESDETECT_DISABLE_DOUBLE_TAP",
    "FRONTLIGHT_SENSITIVITY_DECREASE",
    "DALPHA_SORT_CASE_INSENSITIVE",
    "KOBO_LIGHT_ON_START",
    "NETWORK_PROXY",
    "DUSE_TURBO_LIB",
    "STARDICT_DATA_DIR",
    "cre",
    "lfs",
    "lipc",
    "xtext",
}

exclude_files = {
    "frontend/luxl.lua",
    "plugins/newsdownloader.koplugin/lib/handler.lua",
    "plugins/newsdownloader.koplugin/lib/LICENSE_LuaXML",
    "plugins/newsdownloader.koplugin/lib/xml.lua",
    "plugins/newsdownloader.koplugin/lib/LICENCE_lua-feedparser",
    "plugins/newsdownloader.koplugin/lib/dateparser.lua",
}

-- don't balk on busted stuff in spec
files["spec/unit/*"].std = "+busted"
files["spec/unit/*"].globals = {
    "package",
    "requireBackgroundRunner",
    "stopBackgroundRunner",
}

-- TODO: clean up and enforce max line width (631)
-- https://luacheck.readthedocs.io/en/stable/warnings.html
-- 211 - Unused local variable
-- 631 - Line is too long
ignore = {
    "211/__*",
    "231/__",
    "631",
    "dummy",
}