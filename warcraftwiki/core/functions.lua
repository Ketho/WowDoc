local scriptobjects = require("wowdoc.namingway.scriptobjects")

local function IsValidTable(tbl)
	return tbl and #tbl > 0
end

function WarcraftWiki:GetFunctionPage(func)
	local t, r = {}, {}
	table.insert(r, self:GetDocumentation(func))
	local signature = self:GetFunctionSignature(func)
	table.insert(r, string.format("{{apisig|%s}}", signature))
	table.insert(t, table.concat(r, "\n"))
	if IsValidTable(func.Arguments) then
		table.insert(t, "==Arguments==\n"..self:GetParameters(func.Arguments, true))
	end
	if IsValidTable(func.Returns) then
		table.insert(t, "==Returns==\n"..self:GetParameters(func.Returns))
	end
	return table.concat(t, "\n\n")
end

function WarcraftWiki:GetFunctionSignature(func)
	local t = {}
	if IsValidTable(func.Returns) then
		local returns = func:GetReturnString(false, false)
		table.insert(t, string.format("%s {{=}} ", returns))
	end
	if func.System.Type == "ScriptObject" then
		local name = scriptobjects:shorten(func.System.Name)
		table.insert(t, string.format("%s:%s", name, func.Name))
	elseif func.System.Type == "System" then
		if func.System.Namespace then
			local name = string.format("%s.%s", func.System.Namespace, func.Name)
			table.insert(t, name)
		elseif func.Namespace then
			local name = string.format("%s.%s", func.Namespace, func.Name)
			table.insert(t, name)
		else
			table.insert(t, func.Name)
		end
	end
	if IsValidTable(func.Arguments) then
		local arguments = self:GetFunctionArguments(func.Arguments)
		table.insert(t, string.format("(%s)", arguments))
	else
		table.insert(t, "()")
	end
	return table.concat(t)
end

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

function WarcraftWiki:GetFunctionArguments(paramTbl)
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
