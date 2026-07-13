-- https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic
local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local blizres = require("wowdoc.web.blizres.get")
local bitfield = require("wowdoc.web.blizres.bitfield")
local cfg = require("wowdoc.config")
local latest_product = require("wowdoc.products.latest_product")
local m_version = require("wowdoc.namingway.version")
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
	"classic_era",
	"bcc_anniversary",
	"classic",
}

-- more vibing
local function GetClassicRank(t)
	local count = 0
	local value = 0
	for i, name in ipairs(classic_types) do
		if t[name] then
			count = count + 1
			value = value * 4 + i
		end
	end
	return count * 100 + value
end

local function GetSortRank(v)
	local game_types = GetGameTypes(v)
	local tier = 0
	if game_types.mainline then
		if v == 0x1 then
			tier = 3
		elseif v == 0xf then
			tier = 2
		else
			tier = 1
		end
	end
	return tier, GetClassicRank(game_types)
end

local function SortGameTypes(a, b)
	local a_tier, a_rank = GetSortRank(a.v)
	local b_tier, b_rank = GetSortRank(b.v)
	if a_tier ~= b_tier then
		return a_tier < b_tier
	end
	if a_rank ~= b_rank then
		return a_rank < b_rank
	end
	return a.k < b.k
end

function m:main(resource)
	local flags = bitfield:main(resource, {combine = true})
	local lua_api = blizres:GetResource(resource, {branch = "live"})[2]
	local lua_map = tablelib:ToMap(lua_api)
	local fs = "|-\n| {{apicompat|0x%x}} || %s\n"
	local out = pathlib.join(cfg.path.wiki, string.format("compat_%s.txt", resource))
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
-- m:main()

local function GetLatestPatches()
	local latest_products = latest_product:GetLatestProducts()
	local t = {
		classic = m_version:GetReleaseVersion(latest_products.wow_classic.version),
		bcc_anniversary = m_version:GetReleaseVersion(latest_products.wow_anniversary.version),
		classic_era = m_version:GetReleaseVersion(latest_products.wow_classic_era.version),
	}
	return t
end

local function TemplateBuilder(latest_classic_patches, flags, name)
	local game_types = GetGameTypes(flags[name])
	local t = {}
	table.insert(t, "tlygo")
	local build
	if game_types.mainline then
		-- noop
	elseif game_types.classic then
		build = latest_classic_patches.classic
	elseif game_types.bcc_anniversary then
		build = latest_classic_patches.bcc_anniversary
	elseif game_types.classic_era then
		build = latest_classic_patches.classic_era
	end
	if build then
		table.insert(t, string.format("build=%s", build))
	end
	table.insert(t, name)
	return string.format("{{%s}}", table.concat(t, "|"))
end

-- need to refactor everything, this is horrible
function m:WriteTlyResource(resource)
	local latest_classic_patches = GetLatestPatches()
	local flags, unified = bitfield:main(resource, {combine = true})
	local fs
	if resource == "Templates" then
		fs = "|-\n| {{apicompat|0x%x}} || %s || %s\n"
	else
		fs = "|-\n| {{apicompat|0x%x}} || %s\n"
	end
	local out = pathlib.join(cfg.path.wiki, string.format("compat_%s.txt", resource))
	local file = io.open(out, "w")
	print("Writing to "..out)
	for _, tbl in pairs(table_sort.ByKeyValue(flags, SortGameTypes)) do
		local apilink = TemplateBuilder(latest_classic_patches, flags, tbl.k)
		file:write(fs:format(flags[tbl.k], apilink, unified[tbl.k]))
	end
	file:close()
end
m:WriteTlyResource("FrameXML")
