local m = {}

function m:GetFullName(apiTable, isWikiLink)
	if isWikiLink then
		local baseName = self:GetBaseName(apiTable, true)
		return baseName
	else
		local baseName = self:GetBaseName(apiTable)
		local arguments = self:GetArguments(apiTable)
		local signature = string.format("%s(%s)", baseName, arguments)
		return signature
	end
end

-- keep note this is also being called indirectly from the wikiparser
-- with "converted" api tables which dont include the mixins
function m:GetArguments(apiTable)
	local t = {}
	for _, v in pairs(apiTable.Arguments or {}) do
		-- luals varargs need to be annotated with "..."
		if v.StrideIndex then
			table.insert(t, "...")
		else
			table.insert(t, v.Name)
		end
	end
	return table.concat(t, ", ")
end

function m:GetBaseName(apiTable, isWikiLink)
	local baseName
	local system = apiTable.System
	if system.Type == "System" then
		if system.Namespace then
			baseName = string.format("%s.%s", system.Namespace, apiTable.Name)
		else
			baseName = apiTable.Name
		end
	elseif system.Type == "ScriptObject" then
		local widget_system = doc_widgets[system.Name] or system.Name
		local sep = isWikiLink and "_" or ":"
		baseName = string.format("%s%s%s", widget_system, sep, apiTable.Name)
	else
		baseName = apiTable.Name
	end
	return baseName
end

function m:api_func_GetFullName(v)
	if v.Type == "Function" then
		if v.System.Type == "System" then
			if v.System.Namespace then
				return string.format("%s.%s", v.System.Namespace, v.Name)
			else
				return v.Name
			end
		elseif v.System.Type == "ScriptObject" then
			return string.format("%s:%s", v.System.Name, v.Name)
		end
	end
end

return m
