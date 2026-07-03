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

local function GetGameTypes(v)
	local t = {
		mainline = v & 0x1 > 0,
		classic = v & 0x2 > 0,
		bcc_anniversary = v & 0x4 > 0,
		classic_era = v & 0x8 > 0,
	}
	return t
end

local classic_types = {
	"classic",
	"bcc_anniversary",
	"classic_era",
}

local classic_type_order = {
	classic_era = 1,
	bcc_anniversary = 2,
	classic = 3
}

-- vibed
local function GetClassicRank(t)
	local count = 0
	for _, name in pairs(classic_types) do
		if t[name] then
			count = count + 1
		end
	end
	if count == 1 then
		for name, rank in pairs(classic_type_order) do
			if t[name] then
				return rank
			end
		end
	elseif count == 2 then
		return 4
	end
	return 5
end

local function SortGameTypes(a, b)
	local a1 = GetGameTypes(a.v)
	local b1 = GetGameTypes(b.v)
	if a1.mainline ~= b1.mainline then
		return not a1.mainline
	end

	local a_rank = GetClassicRank(a1)
	local b_rank = GetClassicRank(b1)
	if a_rank ~= b_rank then
		return a_rank < b_rank
	end

	local a_mainline_only = a.v == 0x1
	local b_mainline_only = b.v == 0x1
	if a_mainline_only ~= b_mainline_only then
		return not a_mainline_only
	end

	return a.k < b.k
end

function m:main()
	local flags = bitfield:main("GlobalAPI", {combine = true})
	local lua_api = blizres:GetResource("GlobalAPI", "live")[2]
	local lua_map = tablelib:ToMap(lua_api)
	local fs = "|-\n| {{apicompat|0x%x}} || %s\n"
	local out = pathlib.join(cfg.path.wiki, "globalapi_compat.txt")
	local file = io.open(out, "w")
	print("Writing to "..out)
	for _, tbl in pairs(table_sort.ByKeyValue(flags, SortGameTypes)) do
		if not lua_map[tbl.k] or lua_filter[tbl.k] then
			local apilink = string.format("{{apilink.api|%s}}", tbl.k)
			file:write(fs:format(flags[tbl.k], apilink))
		end
	end
	file:close()
end

m:main()
