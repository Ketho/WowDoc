-- find first non-optional after optional param
-- might have to do it in reverse but this works for now
local function HasWeirdOptionals(paramTbl)
	local foundOptional
	for idx, param in ipairs(paramTbl) do
		if param:IsOptional() then
			foundOptional = true
		else
			if foundOptional then
				return idx
			end
		end
	end
end

function WarcraftWiki:GetSignature(paramTbl)
	local t = {}
	local numOptionals = 0
	local nonWeirdIdx = HasWeirdOptionals(paramTbl) or 0
	for idx, param in pairs(paramTbl) do
		local r = {}
		if param:IsOptional() then
			if idx < nonWeirdIdx then
				table.insert(r, string.format("<%s>", param.Name)) -- placeholder symbol
			else
				numOptionals = numOptionals + 1
				table.insert(r, string.format("[%s", param.Name))
			end
		else
			table.insert(r, param.Name)
		end
		if idx == #paramTbl and numOptionals > 0 then
			table.insert(r, string.rep("]", numOptionals))
		end
		table.insert(t, table.concat(r, ""))
	end
	local res = table.concat(t, ", ")
	res = res:gsub(", %[", " [, ") -- fix comma placement
	res = res:gsub("<(%w-)>", "[%1]") -- fix weird optionals
	return res
end

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
			table.insert(r, self:GetDocumentationField(param))
		end
		table.insert(t, table.concat(r, " - "))
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetDocumentationField(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	else
		return ""
	end
end
