function WarcraftWiki:GetParameters(params, isArgument)
	local t = {}
	for _, param in ipairs(params) do
		if param:GetStrideIndex() == 1 then
			table.insert(t, format("(Variable %s)", isArgument and "arguments" or "returns"))
		end
		local r = {}
		local pretty = self.Types:GetPrettyType(param, isArgument)
		local line = string.format(":;%s:%s", param.Name, pretty)
		table.insert(r, line)
		if param.Documentation and #param.Documentation > 0 then
			table.insert(r, self:GetDocumentation(param))
		end
		table.insert(t, table.concat(r, " - "))
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetDocumentation(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	else
		if apiTable.Type == "Function" or apiTable.Type == "Event" then
			return "&nbsp;"
		else
			return ""
		end
	end
end
