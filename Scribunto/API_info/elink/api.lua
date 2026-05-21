-- https://wowpedia.fandom.com/wiki/Module:API_info/elink/api
local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local api_get = require("Scribunto/API_info/elink/api_get")
local cfg = require("wowdoc.config")

local ApiDoc = api_get:main(cfg.TACT_PRODUCT)
local OUT = pathlib.join(cfg.path.scribunto, "API_info.elink.api.lua")

local function main()
	local doc, non_doc = table.unpack(ApiDoc)
	local full = tablelib.CombineTable(doc, non_doc)
	print("writing", OUT)
	local file = io.open(OUT, "w")
	file:write("-- https://github.com/Ketho/WowpediaDoc/blob/master/Scribunto/API_info/elink/api.lua\n")
	file:write('local data = {\n')
	for _, name in pairs(table_sort.SortTable(full)) do
		if doc[name] then
			file:write(string.format('\t["%s"] = "%s",\n', name, doc[name]))
		end
	end
	file:write("}\n\nreturn data\n")
	file:close()
end

main()
