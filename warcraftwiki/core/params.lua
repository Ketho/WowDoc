local types_api = require("wowdoc.stats.types.api")

function WarcraftWiki:GetParameters(params, isArgument)
	local t = {}
	for _, param in pairs(params) do
		local line = self:GetParamLine(param)
		table.insert(t, line)
		local transclude = self:GetTransclude(param)
		if transclude then
			table.insert(t, transclude)
		end
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetParamLine(param)
	local t = {}
	local apitype = self:GetTypeTemplate(param)
	local line = string.format(":;%s:%s", param.Name, apitype)
	table.insert(t, line)
	if param.Documentation then
		local doc = self:GetDocumentation(param)
		table.insert(t, string.format(" - %s", doc))
	end
	return table.concat(t)
end

function WarcraftWiki:GetDocumentation(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	else
		if apiTable.Type == "Function" or apiTable.Type == "Event" then
			return "&nbsp;"
		else
			return "" -- needs to return a fallback string
		end
	end
end

function WarcraftWiki:GetTransclude(param)
	local param_type = self:GetActualType(param)
	local cat = types_api:FindTypeCat(param_type)
	if cat then
		local t = {}
		if cat == "Enumeration" then
			table.insert(t, string.format("Enum.%s", param_type))
		elseif cat == "Structure" or cat == "Constants" then
			table.insert(t, string.format("%s %s", cat, param_type))
		end
		table.insert(t, "nocaption=1")
		return string.format("{{:%s}}", table.concat(t, "|"))
	end
end
