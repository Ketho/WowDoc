local scriptobjects = require("wowdoc.namingway.scriptobjects")

local function IsValidTable(tbl)
	return tbl and #tbl > 0
end

function WarcraftWiki:GetFunctionPage(func)
	local t = {}
	local doc = self:GetDocumentation(func)
	local signature = string.format("{{apisig|%s}}", self:GetFunctionSignature(func))
	table.insert(t, string.format("%s\n%s", doc, signature))
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
		local returns = self:GetFunctionReturns(func)
		table.insert(t, string.format("%s {{=}} ", returns))
	end
	if func.System.Type == "ScriptObject" then
		local name = scriptobjects:shorten(func.System.Name)
		table.insert(t, string.format("%s:%s", name, func.Name))
	elseif func.System.Type == "System" then
		if func.Namespace then
			if #func.Namespace > 0 then
				table.insert(t, string.format("%s.%s", func.Namespace, func.Name))
			else
				table.insert(t, func.Name)
			end
		elseif func.System.Namespace then
			table.insert(t, string.format("%s.%s", func.System.Namespace, func.Name))
		else
			table.insert(t, func.Name)
		end
	end
	if IsValidTable(func.Arguments) then
		local arguments = self:GetFunctionArguments(func)
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

function WarcraftWiki:AddColorParam(doc, options)
	for idx, param in pairs(doc) do
		if self:GetActualType(param) == options.color_param then
			doc[idx].Name = string.format("#%s", param.Name)
		end
	end
end

function WarcraftWiki:GetFunctionArguments(func, options)
	options = options or {}
	local t = {}
	local numOptionals = 0
	local nonWeirdIdx = HasWeirdOptionals(func.Arguments) or 0
	if options.color_param then
		self:AddColorParam(func.Arguments, options)
	end
	for idx, param in pairs(func.Arguments) do
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
		if idx == #func.Arguments and numOptionals > 0 then
			table.insert(r, string.rep("]", numOptionals))
		end
		table.insert(t, table.concat(r, ""))
	end
	if self:HasStrideIndex(func.Arguments) then
		table.insert(t, "...")
	end
	local res = table.concat(t, ", ")
	res = res:gsub(", %[", " [, ") -- fix comma placement
	res = res:gsub("<(%w-)>", "[%1]") -- fix weird optionals
	return res
end

function WarcraftWiki:GetFunctionReturns(func, options)
	options = options or {}
	local t = {}
	if options.color_param then
		self:AddColorParam(func.Returns, options)
	end
	for _, param in pairs(func.Returns) do
		table.insert(t, param.Name)
	end
	if self:HasStrideIndex(func.Returns) then
		table.insert(t, "...")
	end
	return table.concat(t, ", ")
end

function WarcraftWiki:HasStrideIndex(paramTbl)
	for _, param in pairs(paramTbl) do
		if param.StrideIndex then
			return true
		end
	end
end
