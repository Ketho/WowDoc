-- https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local bitfield = require("wowdoc.web.blizres.bitfield")
local cfg = require("wowdoc.config")
local m = {}

function m:main()
	local flags = bitfield:main("GlobalAPI")
	local fs = "|-\n| {{apicompat|%s}} || %s\n"
	local out = pathlib.join(cfg.path.wiki, "globalapi_compat.lua")
	local file = io.open(out, "w")
	print("Writing to "..out)
	for _, k in pairs(table_sort.ByKey(flags)) do
		local apilink = string.format("{{apilink.api|%s}}", k)
		file:write(fs:format(flags[k], apilink))
	end
	file:close()
end

m:main()
