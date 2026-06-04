local types_api = require("wowdoc.stats.types.api")
local naming = require("wowdoc.namingway.naming")
local transclude = require("wowdoc.namingway.wiki.transclude")

function WarcraftWiki:GetParameters(params)
	local t = {}
	for _, param in pairs(params) do
		local line = self:GetParamLine(param)
		table.insert(t, line)
		local transcl = transclude:GetTranscludeTemplate(param, true)
		if transcl then
			table.insert(t, transcl)
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
