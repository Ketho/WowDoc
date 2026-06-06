local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")
local naming = require("wowdoc.namingway.naming")
local recursive_type = require("Pages.API_types.find_type_recursive")
local m = {}

local function GetStructureField(type_name, v, t)
	for _, field in pairs(v.Fields) do
		if naming:GetActualType(field) == type_name then
			table.insert(t, string.format('<code><span style="color:#4ec9b0">.%s</span></code>', field.Name))
		end
	end
end

local function GetStructureLine(type_name, t)
	local map = {}
	recursive_type:GetTypeOrigin(type_name, map)
	if next(map) then
		table.insert(t, " -> ")
		local sorted = table_sort.ByValue(map, apilink.SortApiLink)
		local r = {}
		for _, v in pairs(sorted) do
			table.insert(r, apilink:GetWikiTemplate(v, {plain = true}))
		end
		table.insert(t, table.concat(r, ", "))
	end
end

local function PrintMainListing(type_name)
	local locations = tablelib.CombineList(
		recursive_type:FindFunctionTypes(type_name),
		recursive_type:FindEventTypes(type_name),
		recursive_type:FindTableTypes(type_name)
	)
	table.sort(locations, apilink.SortApiLink)
	for _, v in pairs(locations) do
		local t = {}
		table.insert(t, ": ")
		table.insert(t, apilink:GetWikiTemplate(v, {color_param = type_name}))
		if v.Type == "Structure" then
			table.insert(t, "<small>")
			GetStructureField(type_name, v, t)
			GetStructureLine(v.Name, t)
			table.insert(t, "</small>")
		end
		print(table.concat(t))
	end
end

function m:main(type_name)
	loader:LoadDocumentation()
	PrintMainListing(type_name)
end

m:main("textureAtlas")
