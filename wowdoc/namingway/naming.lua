local scriptobjects = require("wowdoc.namingway.scriptobjects")
local m = {}

function m:GetActualType(apiTable)
	-- Type will always be "table" if there is an InnerType, but just to be safe
	if apiTable.Type == "table" and apiTable.InnerType then
		return apiTable.InnerType
	else
		return apiTable.Type
	end
end

-- expects system apitables
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
			if apiTable.Namespace then
				if #apiTable.Namespace > 0 then -- see C_StringUtil.GetDefaultAbbreviationBreakpoints
					return string.format("%s.%s", apiTable.Namespace, apiTable.Name)
				else -- see InCombatLockdown
					return apiTable.Name
				end
			elseif apiTable.System.Namespace then
				return string.format("%s.%s", apiTable.System.Namespace, apiTable.Name)
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
