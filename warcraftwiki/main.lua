WarcraftWiki = {}
require("warcraftwiki.functions")
require("warcraftwiki.events")
require("warcraftwiki.tables")
require("warcraftwiki.fields")
require("warcraftwiki.types.types")
require("warcraftwiki.types.missing")

function WarcraftWiki:GetPageText(apiTable, systemType)
	local tbl = {}
	local params
	if apiTable.Type == "Function" then
		params = self:GetFunctionText(apiTable, systemType)
	elseif apiTable.Type == "Event" then
		params = self:GetEventText(apiTable)
	end
	local apiTemplate = self:GetTemplateInfo(apiTable, systemType)
	local sections = {
		apiTemplate,
		self:GetDescription(apiTable),
		params,
	}
	for _, v in ipairs(sections) do
		table.insert(tbl, v)
	end
	return table.concat(tbl, "\n")
end

function WarcraftWiki:GetDescription(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	end
	return "&nbsp;"
end

function WarcraftWiki:GetTemplateInfo(apiTable, systemType)
	local tbl = {}
	if systemType == "ScriptObject" then
		table.insert(tbl, "widgetmethod")
	elseif apiTable.Type == "Function" then
		table.insert(tbl, "wowapi")
		table.insert(tbl, "t=a")
	elseif apiTable.Type == "Event" then
		table.insert(tbl, "wowapievent")
		table.insert(tbl, "t=e")
	elseif apiTable.Type == "Enumeration" or apiTable.Type == "Structure" then
		table.insert(tbl, "wowapitype")
	end
	return format("{{%s}}", table.concat(tbl, "|"))
end

function WarcraftWiki:main()
	self:InitTypeDocumentation()
	local missingTypes = WarcraftWiki:FindMissingTypes()
	if next(missingTypes) then
		self:PullMissingTypes(missingTypes)
	end
end
