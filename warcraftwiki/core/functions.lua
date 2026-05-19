local scriptobjects = require("wowdoc.namingway.scriptobjects")

function WarcraftWiki:GetFunctionPage(func)
	local t = {}
	table.insert(t, self:GetDocumentation(func))
	local signature = self:GetFunctionSignature(func)
	table.insert(t, string.format("{{apisig|%s}}\n", signature))
	if func.Arguments and #func.Arguments>0 then
		table.insert(t, "==Arguments==")
		table.insert(t, self:GetParameters(func.Arguments, true))
		table.insert(t, "")
	end
	if func.Returns and #func.Returns>0 then
		table.insert(t, "==Returns==")
		table.insert(t, self:GetParameters(func.Returns))
	end
	return table.concat(t, "\n")
end

function WarcraftWiki:GetFunctionSignature(func)
	local t = {}
	if func.Returns and #func.Returns > 0 then
		local returns = func:GetReturnString(false, false)
		table.insert(t, string.format("%s {{=}} ", returns))
	end
	if func.System.Type == "ScriptObject" then
		local name = scriptobjects:shorten(func.System.Name)
		table.insert(t, string.format("%s:", name))
	elseif func.System.Type == "System" and func.System.Namespace then
		local namespace = string.format("%s.", func.System.Namespace)
		table.insert(t, namespace)
	end
	table.insert(t, func.Name)
	if func.Arguments and #func.Arguments > 0 then
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
