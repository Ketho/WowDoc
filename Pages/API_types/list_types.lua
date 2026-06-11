local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")
local naming = require("wowdoc.namingway.naming")
local m = {}

local function GetParamTypes(t, parent, params)
	for _, apiTable in pairs(params or {}) do
		local name = naming:GetActualType(apiTable)
		t[name] = t[name] or {}
		t[name][parent] = parent
	end
end

function m:GetAllTypes(t)
	for _, v in pairs(APIDocumentation.functions) do
		GetParamTypes(t, v, v.Arguments)
		GetParamTypes(t, v, v.Returns)
	end
	for _, v in pairs(APIDocumentation.events) do
		GetParamTypes(t, v, v.Payload)	
	end
	for _, v in pairs(APIDocumentation.tables) do
		if v.Type == "Structure" then
			GetParamTypes(t, v, v.Fields)
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

function m:PrintList()
	local t = {}
	self:GetAllTypes(t)
	table.sort(APIDocumentation.tables, function(a, b)
		return a.Name < b.Name
	end)
	PrintTables(t, "Enumeration")
	print()
	PrintTables(t, "Structure")
end

function m:main()
	loader:LoadDocumentation()
	self:PrintList()
end

m:main()
