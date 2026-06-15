-- https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local blizres = require("wowdoc.web.blizres.get")
local bitfield = require("wowdoc.web.blizres.bitfield")
local cfg = require("wowdoc.config")
local m = {}

local lua_filter = {
	["fastrandom"] = true,
	["tostringall"] = true,
	["string.concat"] = true,
	["string.join"] = true,
	["string.split"] = true,
	["string.trim"] = true,
	["strcmputf8i"] = true,
	["strlenutf8"] = true,
	["strsplittable"] = true,
	["table.count"] = true,
	["table.create"] = true,
	["table.freeze"] = true,
	["table.isfrozen"] = true,
	["table.removemulti"] = true,
	["table.wipe"] = true,
}

function m:main()
	local flags = bitfield:main("GlobalAPI", {combine = true})
	local lua_api = blizres:GetResource("GlobalAPI", "live")[2]
	local lua_map = tablelib:ToMap(lua_api)
	local fs = "|-\n| {{apicompat|%s}} || %s\n"
	local out = pathlib.join(cfg.path.wiki, "globalapi_compat.txt")
	local file = io.open(out, "w")
	print("Writing to "..out)
	for _, k in pairs(table_sort.ByKey(flags)) do
		if not lua_map[k] or filter[k] then
			local apilink = string.format("{{apilink.api|%s}}", k)
			file:write(fs:format(flags[k], apilink))
		end
	end
	file:close()
end

m:main()
