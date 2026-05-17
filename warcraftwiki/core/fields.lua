local log = require("wowdoc.util.log")

local paramFs = ":;%s:%s"

local function HasMiddleOptionals(paramTbl)
	local optional
	for _, param in ipairs(paramTbl) do
		if param:IsOptional() then
			optional = true
		else
			if optional then
				return true
			end
		end
	end
end

function WarcraftWiki:GetSignature(paramTbl)
	local tbl = {}
	if HasMiddleOptionals(paramTbl) then
		for _, param in ipairs(paramTbl) do
			local name = param.Name
			if param:IsOptional() then
				name = format("%s?", name)
			end
			table.insert(tbl, name)
		end
		return table.concat(tbl, ", ")
	else
		local numOptionals = 0
		for _, param in ipairs(paramTbl) do
			local name = param.Name
			if param:IsOptional() then
				numOptionals = numOptionals + 1
				name = format("[%s", name)
			else
				name = format("%s", name)
			end
			table.insert(tbl, name)
		end
		local str = table.concat(tbl, ", ")
		local result
		if numOptionals > 0 then
			result = str..string.rep("]", numOptionals)
			result = result:gsub(", %[", " [, ")
		else
			result = str
		end
		return result
	end
end

function WarcraftWiki:GetParameters(params, isArgument)
	local tbl = {}
	for _, param in ipairs(params) do
		if param:GetStrideIndex() == 1 then
			table.insert(tbl, format("(Variable %s)", isArgument and "arguments" or "returns"))
		end
		local r = {}
		table.insert(r, paramFs:format(param.Name, self.Types:GetPrettyType(param, isArgument)))
		if param.Documentation and #param.Documentation > 0 then
			table.insert(r, self:GetDocumentationField(param))
		end
		table.insert(tbl, table.concat(r, " - "))
	end
	return table.concat(tbl, "\n")
end

function WarcraftWiki:GetDocumentationField(apiTable)
	if apiTable.Documentation then
		return table.concat(apiTable.Documentation, "; ")
	else
		return ""
	end
end
