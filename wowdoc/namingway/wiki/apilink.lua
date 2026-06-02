local naming = require("wowdoc.namingway.naming")
require("warcraftwiki.page")
local m = {}

local function GetEventPayload(doc, options)
	local t = {}
	for _, param in pairs(doc.Payload) do
		if param.Type == options.color_param then
			table.insert(t, string.format('#%s', param.Name))
		else
			table.insert(t, param.Name)
		end
	end
	return table.concat(t, ", ")
end

function m:GetWikiTemplate(doc, options)
	options = options or {}
	local t = {}
	table.insert(t, "apilink")
	table.insert(t, "t="..doc.Type)
	table.insert(t, naming:GetProperName(doc))
	if doc.Type == "Function" then -- also includes ScriptObject methods
		if not options.plain then
			if doc.Arguments and #doc.Arguments > 0 then
				table.insert(t, "arg="..WarcraftWiki:GetFunctionArguments(doc))
			end
			if doc.Returns and #doc.Returns > 0 then
				table.insert(t, "ret="..WarcraftWiki:GetFunctionReturns(doc))
			end
		else
			table.insert(t, "noparens=1")
		end
	elseif doc.Type == "Event" then
		if not options.plain then
			if doc.Payload then
				table.insert(t, "payload="..GetEventPayload(doc, options))
			end
		end
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end

local type_priority = {
	Function = 1,
	Event = 2,
	Structure = 3
}

local system_priority = {
	System = 1,
	ScriptObject = 2,
}

function m.SortApiLink(a, b)
	if a.Type ~= b.Type then
		return type_priority[a.Type] < type_priority[b.Type]
	end
	if a.Type == "Function" and b.Type == "Function" and a.System.Type ~= b.System.Type then
		return system_priority[a.System.Type] < system_priority[b.System.Type]
	end
	local name_a = naming:GetProperName(a)
	local name_b = naming:GetProperName(b)
	if name_a ~= name_b then
		return name_a < name_b
	end
end

return m
