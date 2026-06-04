local naming = require("wowdoc.namingway.naming")
local type_doc = require("wowdoc.loader.doc.TypeDocumentation")
local type_api = require("wowdoc.stats.types.api")
local m = {}

local function GetTranscludeExceptions()
	if not m.exceptions then
		local t = {}
		for _, v in pairs(type_doc) do
			if v.NoTransclude then
				local name = v.Name:gsub("Enum%.", "") or name
				t[name] = true
			end
		end
		m.exceptions = t
	end
	return m.exceptions
end

function m:GetTranscludeTemplate(apiTable, nocaption)
	local t = {}
	local actualType = naming:GetActualType(apiTable)
	local cat = type_api:FindTypeCat(actualType)
	local exceptions = GetTranscludeExceptions()
	if cat and not exceptions[actualType] then
		if cat == "Enumeration" then
			table.insert(t, string.format("Enum.%s", actualType))
		elseif cat == "Structure" then
			table.insert(t, string.format("Structure %s", actualType))
		end
		if nocaption then
			table.insert(t, "nocaption=1")
		end
		return string.format("{{:%s}}", table.concat(t, "|"))
	end
end

function m:GetTranscludeList(list)
	local t = {}
	local unique = {}
	for _, field in pairs(list) do
		local transcl = self:GetTranscludeTemplate(field)
		if transcl and not unique[transcl] then
			unique[transcl] = true
			table.insert(t, transcl)
		end
	end
	return t
end

return m
