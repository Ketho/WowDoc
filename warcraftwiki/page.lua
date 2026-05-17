WarcraftWiki = {}
require("warcraftwiki.types.types")
require("warcraftwiki.core.functions")
require("warcraftwiki.core.fields")
require("warcraftwiki.core.events")
-- require("warcraftwiki.core.tables")

local naming = require("wowdoc.namingway.naming")

function WarcraftWiki:GetPageText(apiTable)
	local t = {}
	table.insert(t, self:GetTemplateInfo(apiTable))
	table.insert(t, self:GetDescription(apiTable))
	local body
	if apiTable.Type == "Function" then
		body = self:GetFunctionText(apiTable)
	elseif apiTable.Type == "Event" then
		body = self:GetEventText(apiTable)
	end
	table.insert(t, body)
	return table.concat(t, "\n")
end

function WarcraftWiki:GetDescription(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	end
	return "&nbsp;"
end

function WarcraftWiki:GetTemplateInfo(apiTable)
	local tbl = {}
	if apiTable.Type == "Function" then
		if apiTable.System.Type == "ScriptObject" then
			table.insert(tbl, "widgetmethod")
		else
			table.insert(tbl, "wowapi")
			table.insert(tbl, "t=a")
		end
	elseif apiTable.Type == "Event" then
		table.insert(tbl, "wowapievent")
		table.insert(tbl, "t=e")
	elseif apiTable.Type == "Enumeration" or apiTable.Type == "Structure" then
		table.insert(tbl, "wowapitype")
	end
	return format("{{%s}}", table.concat(tbl, "|"))
end

return WarcraftWiki
