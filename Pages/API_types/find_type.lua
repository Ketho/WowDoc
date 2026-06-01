local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")
local naming = require("wowdoc.namingway.naming")

local function GetActualType(v)
	return v.InnerType or v.Type
end

local function FindFunctionTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		local found
		if v.Arguments then
			for _, v2 in pairs(v.Arguments) do
				if GetActualType(v2) == name then
					found = true
				end
			end
		end
		if v.Returns then
			for _, v2 in pairs(v.Returns) do
				if GetActualType(v2) == name then
					found = true
				end
			end
		end
		if found then
			table.insert(t, v)
		end

	end
	return t
end

local function FindEventTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.events) do
		local found
		if v.Payload then
			for _, v2 in pairs(v.Payload) do
				if GetActualType(v2) == name then
					found = true
				end
			end
		end
		if found then
			table.insert(t, v)
		end
	end
	return t
end

local function FindTableTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.tables) do
		local found
		if v.Fields then
			for _, v2 in pairs(v.Fields) do
				if GetActualType(v2) == name then
					found = true
				end
			end
		end
		if found then
			table.insert(t, v)
		end
	end
	return t
end

local function GetTypeOrigin(name, map)
	local locations = tablelib.CombineList(
		FindFunctionTypes(name),
		FindEventTypes(name),
		FindTableTypes(name)
	)
	for _, v in pairs(locations) do
		if v.Type ~= "Structure" then
			local proper_name = naming:GetProperName(v)
			map[proper_name] = v
		else
			GetTypeOrigin(v.Name, map)
		end
	end
end

local function GetStructureLine(name, t)
	local map = {}
	GetTypeOrigin(name, map)
	if next(map) then
		table.insert(t, " -> ")
		local sorted = table_sort.ByValue(map, apilink.SortApiLink)
		local r = {}
		for _, v in pairs(sorted) do
			table.insert(r, apilink:GetWikiTemplate(v, true))
		end
		table.insert(t, table.concat(r, ", "))
	end
end

local function GetStructureField(name, v, t)
	for _, field in pairs(v.Fields) do
		if field.Type == name then
			table.insert(t, string.format('<code><span style="color:#4ec9b0">.%s</span></code>', field.Name))
		end
	end
end

local function PrintMainListing(name)
	local locations = tablelib.CombineList(
		FindFunctionTypes(name),
		FindEventTypes(name),
		FindTableTypes(name)
	)
	table.sort(locations, apilink.SortApiLink)
	for _, v in pairs(locations) do
		local t = {}
		if v.Type == "Structure" then
			table.insert(t, "* ") -- more visible due to cluttered output
		else
			table.insert(t, ": ")
		end
		table.insert(t, apilink:GetWikiTemplate(v))
		if v.Type == "Structure" then
			table.insert(t, "<small>")
			GetStructureField(name, v, t)
			GetStructureLine(v.Name, t)
			table.insert(t, "</small>")
		end
		print(table.concat(t))
	end
end

local function main(name)
	loader:LoadDocumentation()
	PrintMainListing(name)
end

main("WOWGUID")
