local pathlib = require("path")
local cfg = require("wowdoc.config")
local patch_retail = loadfile("out/lua/API_info.patch.api_retail.lua")()
local flavor = loadfile(pathlib.join(cfg.path.scribunto_flavor, "API_info.flavor.api.lua"))()
local table_sort = require("wowdoc.util.table_sort")

local function GetNotExist()
	for _, k in pairs(table_sort.ByKey(patch_retail)) do
		if not flavor[k] then
			print(k)
		end
	end
end
GetNotExist()
