local log = require("wowdoc.util.log")
local scriptobjects = require("wowdoc.namingway.scriptobjects")
local m = {}

function m:GetSystemName(v)
	if v.Type == "System" then
		return v.Name
	elseif v.Type == "ScriptObject" then
		return scriptobjects:shorten(v.Name)
	end
end

function m:GetProperName(v, isWiki)
	local t = {}
	if v.Type == "Function" then
		if v.System.Type == "System" then
			if v.System.Namespace and v.Namespace ~= "" then -- see InCombatLockdown
				table.insert(t, v.System.Namespace..".")
			end
			table.insert(t, v.Name)
		elseif v.System.Type == "ScriptObject" then
			local proper = scriptobjects:shorten(v.System.Name)
			local fs = isWiki and "%s %s" or "%s:%s"
			local fullName = string.format(fs, proper, v.Name)
			table.insert(t, fullName)
		end
	elseif v.Type == "Event" then
		table.insert(t, v.LiteralName)
	else
		table.insert(t, v.Name)
	end
	return table.concat(t)
end

return m
