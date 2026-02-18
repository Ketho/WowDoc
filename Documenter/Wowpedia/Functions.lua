local widgets = require("wowdoc.loader.doc_widgets")

local function FormatApisig(s)
	return string.format("{{apisig|%s}}", s)
end

function Wowpedia:GetFunctionText(func, systemType)
	local str = format("%s\n", self:GetFunctionSignature(func, systemType))
	-- widget api can provide empty tables
	if func.Arguments and #func.Arguments>0 then
		str = str..format("\n==Arguments==\n%s\n", self:GetParameters(func.Arguments, true))
	end
	if func.Returns and #func.Returns>0 then
		str = str..format("\n==Returns==\n%s\n", self:GetParameters(func.Returns))
	end
	return str
end

function Wowpedia:GetWidgetSignature(func)
	local t = {}
	if func.Returns and #func.Returns > 0 then
		table.insert(t, string.format("%s {{=}} ", self:GetSignature(func.Returns)))
	end
	local widget = widgets[func.System.Name]
	table.insert(t, string.format("%s:%s", widget, func.Name))
	table.insert(t, string.format("(%s)", self:GetSignature(func.Arguments)))
	return table.concat(t)
end

function Wowpedia:GetFunctionSignature(func, systemType)
	local str
	if systemType == "ScriptObject" then
		str = self:GetWidgetSignature(func)
	else
		if func.System.Namespace then
			str = format("%s.%s", func.System.Namespace, func.Name)
		else
			str = func.Name
		end
		if func.Arguments and #func.Arguments > 0 then
			local argumentString = self:GetSignature(func.Arguments)
			str = format("%s(%s)", str, argumentString)
		else
			str = str.."()"
		end
		if func.Returns and #func.Returns > 0 then
			local returnString = func:GetReturnString(false, false)
			str = format("%s {{=}} %s", returnString, str)
		end
	end
	return FormatApisig(str)
end
