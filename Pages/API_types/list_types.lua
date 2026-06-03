local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")
local naming = require("wowdoc.namingway.naming")
local m = {}

function m:FillFunctionTypes(t)
	for _, v in pairs(APIDocumentation.functions) do
		for _, v2 in pairs(v.Arguments or {}) do
			local name = naming:GetActualType(v2)
			t[name] = t[name] or {}
			t[name][v] = v
		end
		for _, v2 in pairs(v.Returns or {}) do
			local name = naming:GetActualType(v2)
			t[name] = t[name] or {}
			t[name][v] = v
		end
	end
end

function m:FillEventTypes(t)
	for _, v in pairs(APIDocumentation.events) do
		for _, v2 in pairs(v.Payload or {}) do
			local name = naming:GetActualType(v2)
			t[name] = t[name] or {}
			t[name][v] = v
		end
	end
end

function m:FillTableTypes(t)
	for _, v in pairs(APIDocumentation.tables) do
		if v.Type == "Structure" then
			for _, v2 in pairs(v.Fields) do
				local name = naming:GetActualType(v2)
				t[name] = t[name] or {}
				t[name][v] = v
			end
		end
	end
end

local function PrintTables(t, table_type)
	print(string.format("==%s==", table_type))
	for _, v in pairs(APIDocumentation.tables) do
		if v.Type == table_type then
			local type_link = apilink:GetWikiTemplate(v)
			if t[v.Name] then
				local sorted = table_sort.ByValue(t[v.Name], apilink.SortApiLink)
				local r = {}
				for _, v2 in pairs(sorted) do
					local parent_link = apilink:GetWikiTemplate(v2, {plain = true})
					table.insert(r, parent_link)
				end
				print(string.format("* %s - %s", type_link, table.concat(r, ", ")))
			else
				print(string.format("* %s", type_link))
			end
		end
	end
end

function m:PrintList(type_name)
	local t = {}
	self:FillFunctionTypes(t)
	self:FillEventTypes(t)
	self:FillTableTypes(t)
	table.sort(APIDocumentation.tables, function(a, b)
		return a.Name < b.Name
	end)
	PrintTables(t, "Enumeration")
	print()
	PrintTables(t, "Structure")
end

function m:main(type_name)
	loader:LoadDocumentation()
	self:PrintList(type_name)
end

m:main()
