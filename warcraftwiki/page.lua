WarcraftWiki = {}
require("warcraftwiki.types.types")
require("warcraftwiki.core.functions")
require("warcraftwiki.core.events")
require("warcraftwiki.core.fields")
require("warcraftwiki.core.tables")

local TableTypes = {
	Enumeration = true,
	Structure = true,
	Constants = true,
}

function WarcraftWiki:GetPageText(apiTable)
	local t = {}
	table.insert(t, self:GetPageTemplate(apiTable))
	table.insert(t, self:GetPageContents(apiTable))
	return table.concat(t, "\n")
end

function WarcraftWiki:GetPageTemplate(apiTable)
	local t = {}
	if apiTable.Type == "Function" then
		if apiTable.System.Type == "ScriptObject" then
			table.insert(t, "widgetmethod")
		else
			table.insert(t, "wowapi")
			table.insert(t, "t=a")
		end
	elseif apiTable.Type == "Event" then
		table.insert(t, "wowapievent")
		table.insert(t, "t=e")
	elseif TableTypes[apiTable.Type] then
		table.insert(t, "wowapitype")
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end

function WarcraftWiki:GetPageContents(apiTable)
	if apiTable.Type == "Function" then
		return self:GetFunctionPage(apiTable)
	elseif apiTable.Type == "Event" then
		return self:GetEventPage(apiTable)
	elseif TableTypes[apiTable.Type] then
		return self:GetTablePage(apiTable)
	end
end

return WarcraftWiki
