local tablelib = require("wowdoc.util.table")

function WarcraftWiki:GetTablePage(apiTable)
	local contents = self:GetTableContents(apiTable)
	local wikiTable = self:GetWikiTable(apiTable, contents)
	local onlyinclude = string.format("<onlyinclude>%s</onlyinclude>", wikiTable)
	return onlyinclude
end

function WarcraftWiki:GetTableContents(apiTable)
	if apiTable.Type == "Enumeration" then
		return self:GetEnumerationTable(apiTable)
	elseif apiTable.Type == "Structure" then
		return self:GetStructureTable(apiTable)
	elseif apiTable.Type == "Constants" then
		return self:GetConstantsTable(apiTable)
	end
end

local function GetClassAttributes(apiTable)
	local t = {}
	table.insert(t, "sortable")
	table.insert(t, "darktable")
	table.insert(t, "zebra")
	if apiTable.Type == "Enumeration" or apiTable.Type == "Constants" then
		table.insert(t, "col1-center")
	end
	return table.concat(t, " ")
end

function WarcraftWiki:GetWikiTable(apiTable, contents)
	local t = {}
	local attributes = GetClassAttributes(apiTable)
	table.insert(t, string.format('{| class="%s" style="margin-left: 3.9em"', attributes))
	table.insert(t, string.format('|+ {{apicaption}} | {{#if:{{{nocaption|}}}||%s}}', apiTable:GetFullName()))
	table.insert(t, contents)
	table.insert(t, "|}")
	return table.concat(t, "\n")
end

function WarcraftWiki:GetEnumerationTable(apiTable)
	local t = {}
	local isBitEnum = tablelib.IsBitEnum(apiTable)
	table.insert(t, "! Value !! Field !! Description")
	for _, field in pairs(apiTable.Fields) do
		local enumValue = isBitEnum and string.format("0x%X", field.EnumValue) or field.EnumValue
		local doc = self:GetDocumentation(field)
		table.insert(t, string.format('|-\n| %s || {{apiname|%s}} || %s', enumValue, field.Name, doc))
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetStructureTable(apiTable)
	local t = {}
	table.insert(t, "! Field !! Type !! Description")
	for _, field in pairs(apiTable.Fields) do
		local apitype = self:GetTypeTemplate(field)
		local doc = self:GetDocumentation(field)
		table.insert(t, string.format('|-\n| {{apiname|%s}} || %s || %s', field.Name, apitype, doc))
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetConstantsTable(apiTable)
	local t = {}
	table.insert(t, "! Constant !! Type !! Value !! Description")
	for _, field in pairs(apiTable.Values) do
		local apitype = self:GetTypeTemplate(field)
		local doc = self:GetDocumentation(field)
		table.insert(t, string.format('|-\n| {{apiname|%s}} || %s || %s || %s', field.Name, apitype, field.Value, doc))
	end
	return table.concat(t, "\n")
end
