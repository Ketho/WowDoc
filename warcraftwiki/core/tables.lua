local table_util = require("wowdoc.util.table")

local shortComplex = {
	Enumeration = "Enum",
	Structure = "Struct",
	Constants = "Const",
	CallbackType = "Callback",
}

local alignFirstCol = {
	Enumeration = true,
	Constants = true,
}

function WarcraftWiki:GetTableText(apiTable, isTemplate, isSubTable)
	local tbl = {}
	local transclude = self:GetTranscludeBase(apiTable)
	local fullName = apiTable:GetFullName()
	local tableClass = '{| class="sortable darktable zebra'
	if alignFirstCol[apiTable.Type] then
		tableClass = tableClass.." col1-center"
	end
	tableClass = tableClass..'" style="margin-left: 3.9em"'
	table.insert(tbl, tableClass)
	if isTemplate then
		table.insert(tbl, format("|+ {{#if:{{{nocaption|}}}||%s}}", fullName))
	elseif isSubTable then
		table.insert(tbl, format("|+ %s", fullName))
	end
	if apiTable.Type == "Enumeration" then
		local isBitEnum = table_util.IsBitEnum(apiTable)
		table.insert(tbl, "! Value !! Field !! Description")
		for _, field in ipairs(apiTable.Fields) do
			local enumValue = isBitEnum and string.format("0x%X", field.EnumValue) or field.EnumValue
			local doc = self:GetDocumentationField(field)
			table.insert(tbl, format('|-\n| %s || {{apiname|%s}} || %s', enumValue, field.Name, doc))
		end
	elseif apiTable.Type == "Structure" then
		table.insert(tbl, "! Field !! Type !! Description")
		for _, field in ipairs(apiTable.Fields) do
			local prettyType = self:GetPrettyType(field)
			local doc = self:GetDocumentationField(field)
			table.insert(tbl, format('|-\n| {{apiname|%s}} || %s || %s', field.Name, prettyType, doc))
		end
	elseif apiTable.Type == "Constants" then
		table.insert(tbl, "! Constant !! Type !! Value !! Description")
		for _, field in ipairs(apiTable.Values) do
			local prettyType = self:GetPrettyType(field)
			local doc = self:GetDocumentationField(field)
			table.insert(tbl, format('|-\n| {{apiname|%s}} || %s || %s || %s', field.Name, prettyType, field.Value, doc))
		end
	end
	table.insert(tbl, "|}")
	local text = table.concat(tbl, "\n")
	local includedTables = self:GetIncludedTables(apiTable)
	if #includedTables > 0 then
		text = text.."\n\n"..table.concat(includedTables, "\n\n")
	end
	local apiTemplate = self:GetTemplateInfo(apiTable)
	return isTemplate and format("%s\n<onlyinclude>%s</onlyinclude>", apiTemplate, text) or text
end
