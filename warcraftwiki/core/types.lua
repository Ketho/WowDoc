local type_api = require("wowdoc.stats.types.api")

local lua_types = {
	bool = "boolean",
	cstring = "string",
}

local secrets = {
	NeverSecret = true,
	NeverSecretContents = true,
	AlwaysSecret = true,
	ConditionalSecret = true,
	ConditionalSecretContents = true,
}

function WarcraftWiki:GetTypeTemplate(apiTable)
	local t = {}
	table.insert(t, "apitype")
	table.insert(t, self:GetTypeText(apiTable))
	if apiTable.Default ~= nil then
		local default = string.format("default=%s", tostring(apiTable.Default))
		table.insert(t, default)
	end
	for secret in pairs(secrets) do
		if apiTable[secret] then
			table.insert(t, string.format("secret=%s", secret))
			break
		end
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end

function WarcraftWiki:GetTypeText(apiTable)
	local t = {}
	table.insert(t, self:GetTypeName(apiTable))
	if apiTable.InnerType then
		table.insert(t, "[]")
	end
	-- Default implies Nilable, even if nilable is false
	if apiTable.Nilable or apiTable.Default ~= nil then
		table.insert(t, "?")
	end
	return table.concat(t)
end

function WarcraftWiki:GetTypeName(apiTable)
	local name = self:GetActualType(apiTable)
	if lua_types[name] then
		name = lua_types[name]
	end
	local cat = type_api:FindTypeCat(name)
	if cat == "Enumeration" then
		name = string.format("Enum.%s", name)
	end
	return name
end

function WarcraftWiki:GetActualType(apiTable)
	if apiTable.Type == "table" and apiTable.InnerType then
		return apiTable.InnerType
	else
		return apiTable.Type
	end
end

function WarcraftWiki:GetTranscludeTypes(apiTable)
	local t = {}
	for _, field in pairs(apiTable.Fields) do
		local actualType = self:GetActualType(field)
		local cat = type_api:FindTypeCat(actualType)
		if cat == "Enumeration" then
			table.insert(t, string.format("{{:Enum.%s}}", actualType))
		elseif cat == "Structure" then
			table.insert(t, string.format("{{:Structure %s}}", actualType))
		end
	end
	return t
end

