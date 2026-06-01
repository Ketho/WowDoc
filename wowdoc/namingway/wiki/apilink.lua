local naming = require("wowdoc.namingway.naming")
require("warcraftwiki.page")
local m = {}

function m:GetWikiTemplate(doc)
	local t = {}
	table.insert(t, "apilink")
	table.insert(t, "t="..doc.Type)
	table.insert(t, naming:GetProperName(doc))
	if doc.Type == "Function" then -- also includes ScriptObject methods
		if doc.Arguments and #doc.Arguments > 0 then
			table.insert(t, "arg="..WarcraftWiki:GetFunctionArguments(doc))
		end
		if doc.Returns and #doc.Returns > 0 then
			table.insert(t, "ret="..WarcraftWiki:GetFunctionReturns(doc))
		end
	elseif doc.Type == "Event" then
		if doc.Payload then
			table.insert(t, "payload="..doc:GetPayloadString(false, false))
		end
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end

return m
