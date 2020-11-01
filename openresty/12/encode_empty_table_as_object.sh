resty -e 'local cjson = require "cjson"
cjson.encode_empty_table_as_object(false)
local t = {}
print(cjson.encode(t))
'
