local log = require("wowdoc.util.log")

local paramFs = ":;%s:%s"

local function HasMiddleOptionals(paramTbl)
	local optional
	for _, param in ipairs(paramTbl) do
		if param:IsOptional() then
			optional = true
		else
			if optional then
				return true
			end
		end
	end
end

local function GetBlizzardType(name)
	if WarcraftWiki.blizzardTypes[name] then
		if WarcraftWiki.blizzardTypes[name].Replace then
			return WarcraftWiki.blizzardTypes[name].Type
		else
			return name
		end
	end
end

function WarcraftWiki:GetSignature(paramTbl)
	local tbl = {}
	if HasMiddleOptionals(paramTbl) then
		for _, param in ipairs(paramTbl) do
			local name = param.Name
			if param:IsOptional() then
				name = format("%s?", name)
			end
			table.insert(tbl, name)
		end
		return table.concat(tbl, ", ")
	else
		local numOptionals = 0
		for _, param in ipairs(paramTbl) do
			local name = param.Name
			if param:IsOptional() then
				numOptionals = numOptionals + 1
				name = format("[%s", name)
			else
				name = format("%s", name)
			end
			table.insert(tbl, name)
		end
		local str = table.concat(tbl, ", ")
		local result
		if numOptionals > 0 then
			result = str..string.rep("]", numOptionals)
			result = result:gsub(", %[", " [, ")
		else
			result = str
		end
		return result
	end
end

function WarcraftWiki:GetParameters(params, isArgument)
	local tbl = {}
	for _, param in ipairs(params) do
		if param:GetStrideIndex() == 1 then
			table.insert(tbl, format("(Variable %s)", isArgument and "arguments" or "returns"))
		end
		local r = {}
		table.insert(r, paramFs:format(param.Name, self:GetPrettyType(param, isArgument)))
		if param.Documentation and #param.Documentation > 0 then
			table.insert(r, self:GetDocumentationField(param))
		end
		table.insert(tbl, table.concat(r, " - "))
		local complexTable, isTransclude = self:GetComplexTypeInfo(param)
		if complexTable then
			if isTransclude then
				local transclude = format("{{:%s|nocaption=1}}", self:GetTranscludeBase(complexTable))
				table.insert(tbl, transclude)
			else
				table.insert(tbl, self:GetTableText(complexTable))
			end
		end
	end
	return table.concat(tbl, "\n")
end

function WarcraftWiki:GetPrettyType(apiTable, isArgument)
	local complexType = self.complexTypes[apiTable.Type]
	local apiText
	if apiTable.Type == "table" then
		if apiTable.Mixin then
			apiText = apiTable.Mixin
		elseif apiTable.InnerType then
			local complexInnertype = self.complexTypes[apiTable.InnerType]
			if self.basicTypes[apiTable.InnerType] then
				apiText = self.basicTypes[apiTable.InnerType].."[]"
			elseif self.blizzardTypes[apiTable.InnerType] then
				apiText = GetBlizzardType(apiTable.InnerType).."[]"
			elseif complexInnertype then
				apiText = complexInnertype:GetFullName(false, false).."[]"
			else
				log.failure("Unknown InnerType: "..apiTable.InnerType)
				apiText = "Unknown"
			end
		else
			apiText = "Unknown"
		end
	elseif self.basicTypes[apiTable.Type] then
		apiText = self.basicTypes[apiTable.Type]
	elseif self.blizzardTypes[apiTable.Type] then
		apiText = GetBlizzardType(apiTable.Type)
	elseif complexType then
		apiText = complexType:GetFullName(false, false)
	else
		log.failure("Unknown Type: "..apiTable.Type)
		apiText = "Unknown"
	end
	-- `Default` implies `Nilable`, even if nilable is false
	if apiTable.Nilable or apiTable.Default ~= nil then
		apiText = apiText.."?"
	end
	if apiTable.Default ~= nil then
		apiText = apiText..format("|default=%s", tostring(apiTable.Default))
	end
	if apiTable.NeverSecret then
		apiText = apiText.."|secret=NeverSecret"
	elseif apiTable.ConditionalSecret then
		apiText = apiText.."|secret=ConditionalSecret"
	end
	local str = string.format("{{apitype|%s}}", apiText)
	return str
end

function WarcraftWiki:GetDocumentationField(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	else
		return ""
	end
end
