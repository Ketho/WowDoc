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
				return string.format("%s.%s", apiTable.System.Namespace, apiTable.Name)
			elseif apiTable.Namespace then -- see C_StringUtil.GetDefaultAbbreviationBreakpoints
				return string.format("%s.%s", apiTable.Namespace, apiTable.Name)
			else
				return apiTable.Name
			end
		elseif apiTable.System.Type == "ScriptObject" then
			local proper = scriptobjects:shorten(apiTable.System.Name)
			local fs = isWiki and "%s %s" or "%s:%s"
			return string.format(fs, proper, apiTable.Name)
		end
	elseif apiTable.Type == "Event" then
		return apiTable.LiteralName
	else
		return apiTable.Name
	end
end

return m
