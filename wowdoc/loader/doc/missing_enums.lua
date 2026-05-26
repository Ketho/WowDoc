local log = require("wowdoc.util.log")
local types_api = require("wowdoc.stats.types.api")
local util_sort = require("wowdoc.util.table_sort")
local m = {}

function m:GetMissingEnumTable()
	local docTable = {Tables = {}}
	local missing = types_api:GetMissingEnums()
	for _, k in pairs(util_sort.ByKey(missing)) do
		log.warn("Adding missing Enum."..k)
		local enum = self:CreateEnumDoc(k)
		table.insert(docTable.Tables, enum)
	end
	return docTable
end

function m:CreateEnumDoc(name)
	local doc = {
		Name = name,
		Type = "Enumeration",
		Fields = {},
	}
	for k, v in pairs(Enum[name]) do
		table.insert(doc.Fields, { Name = k, Type = name, EnumValue = v })
	end
	table.sort(doc.Fields, function(a, b)
		return a.EnumValue < b.EnumValue
	end)
	return doc
end

return m

