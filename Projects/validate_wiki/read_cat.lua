local m = {
	tablelib = require("wowdoc.util.table"),
	wowdoc = require("wowdoc.loader"),
	export = require("wowdoc.web.wiki.export"),
}
local p = {}

function p:main()
	local doc = m.wowdoc:LoadDocumentation()
	local docTables = self:GetDocTables(doc)
	local wikiTables = self:GetWikiCats()

	print("Mismatching enums:")
	for name, doc_enum in pairs(docTables.Enumeration) do
		local wiki_enum = wikiTables.Enums[name]
		local eq = m.tablelib.equals(doc_enum, wiki_enum)
		if not eq then
			print("- "..name)
		end
	end

	print("Mismatching structures:")
	for name, doc_struct in pairs(docTables.Structure) do
		local wiki_struct = wikiTables.Structures[name]
		local eq = m.tablelib.equals(doc_struct, wiki_struct)
		if not eq then
			print("- "..name)
			-- self:PrintMismatch(doc_struct, wiki_struct)
		end
	end
	print("done")
end

local function ReplaceCommonTypes(s)
	if s == "bool" then
		return "boolean"
	elseif s == "cstring" then
		return "string"
	else
		return s
	end
end

local function GetActualType(field)
	local s = field.InnerType or field.Type
	s = ReplaceCommonTypes(s)
	return s
end

function p:GetDocTables(doc)
	local t = {
		Enumeration = {},
		Structure = {},
	}
	for _, docTable in pairs(doc.tables) do
		if docTable.Type == "Enumeration" then
			t[docTable.Type][docTable.Name] = {}
			for _, field in pairs(docTable.Fields) do
				local fieldTable = {field.EnumValue, field.Name}
				table.insert(t[docTable.Type][docTable.Name], fieldTable)
			end
		elseif docTable.Type == "Structure" then
			t[docTable.Type][docTable.Name] = {}
			for _, field in pairs(docTable.Fields) do
				local apitype = GetActualType(field)
				local fieldTable = {field.Name, apitype}
				table.insert(t[docTable.Type][docTable.Name], fieldTable)
			end
		end
	end
	return t
end

local wiki_categories = {
	"Enums",
	"Structures",
}

function p:GetWikiCats()
	local t = {}
	for _, cat in pairs(wiki_categories) do
		t[cat] = {}
		local pages = m.export:GetCategory(cat)
		if cat == "Enums" then
			for pageName, pageText in pairs(pages) do
				local name = pageName:match("Enum%.(%w+)")
				local tbl = self:ParseEnumPage(pageName, pageText)
				t[cat][name] = tbl
			end
		elseif cat == "Structures" then
			for pageName, pageText in pairs(pages) do
				local name = pageName:match("Structure (%w+)")
				local tbl = self:ParseStructurePage(pageName, pageText)
				t[cat][name] = tbl
			end
		end
	end
	return t
end

function p:ParseEnumPage(pageName, text)
	local t = {}
	for line in text:gmatch("[^\n]+") do
		-- account for negative numbers
		local enumvalue, apiname = line:match("| ([%w%-]+) || {{apiname|([%w_]+)}}")
		if enumvalue then
			enumvalue = tonumber(enumvalue) -- also converts any hex numbers
			table.insert(t, {enumvalue, apiname})
		end
	end
	return t
end

function p:ParseStructurePage(pageName, text)
	local t = {}
	for line in text:gmatch("[^\n]+") do
		local apiname, apitype = line:match("| {{apiname|([%w_]+)}} || {{apitype|([%w_%.]+).-}}")
		if apiname then
			if apitype:find("Enum%.") then
				apitype = apitype:match("Enum%.(%w+)")
			end
			table.insert(t, {apiname, apitype})
		end
	end
	return t
end

function p:PrintMismatch(a, b)
	for _, v in pairs(a) do
		print(v[1], v[2])
	end
	print("---")
	for _, v in pairs(b) do
		print(v[1], v[2])
	end
end

p:main()
