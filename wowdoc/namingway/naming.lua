local log = require("wowdoc.util.log")
local scriptobjects = require("wowdoc.namingway.scriptobjects")
local m = {}

function m:GetSystemName(apiTable)
	if apiTable.Type == "System" then
		return apiTable.Name
	elseif apiTable.Type == "ScriptObject" then
		return scriptobjects:shorten(apiTable.Name)
	end
end

function m:GetProperName(apiTable, isWiki)
	local t = {}
	if apiTable.Type == "Function" then
		if apiTable.System.Type == "System" then
			if apiTable.System.Namespace and apiTable.Namespace ~= "" then -- see InCombatLockdown
				table.insert(t, apiTable.System.Namespace..".")
			end
			table.insert(t, apiTable.Name)
		elseif apiTable.System.Type == "ScriptObject" then
			local proper = scriptobjects:shorten(apiTable.System.Name)
			local fs = isWiki and "%s %s" or "%s:%s"
			local fullName = string.format(fs, proper, apiTable.Name)
			table.insert(t, fullName)
		end
	elseif apiTable.Type == "Event" then
		table.insert(t, apiTable.LiteralName)
	else
		table.insert(t, apiTable.Name)
	end
	return table.concat(t)
end

return m
