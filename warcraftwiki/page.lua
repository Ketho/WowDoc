WarcraftWiki = {}
-- require("warcraftwiki.core.functions")
-- require("warcraftwiki.core.events")
-- require("warcraftwiki.core.tables")
-- require("warcraftwiki.core.fields")
-- require("warcraftwiki.types.types")
-- require("warcraftwiki.types.missing")
local naming = require("wowdoc.namingway.naming")

function WarcraftWiki:GetPageText(apiTable)
	local t = {}
	local proper = naming:GetProperName(apiTable)
	return proper
	-- local tbl = {}
	-- local params
	-- if apiTable.Type == "Function" then
	-- 	params = self:GetFunctionText(apiTable, systemType)
	-- elseif apiTable.Type == "Event" then
	-- 	params = self:GetEventText(apiTable)
	-- end
	-- local apiTemplate = self:GetTemplateInfo(apiTable, systemType)
	-- local sections = {
	-- 	apiTemplate,
	-- 	self:GetDescription(apiTable),
	-- 	params,
	-- }
	-- for _, v in ipairs(sections) do
	-- 	table.insert(tbl, v)
	-- end
	-- return table.concat(tbl, "\n")
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

return WarcraftWiki
