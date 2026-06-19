local naming = require("wowdoc.namingway.naming")
require("warcraftwiki.page")
local m = {}

function m:GetSignatures()
	local t = {}
	for _, func in pairs(APIDocumentation.functions) do
		local name = naming:GetProperName(func)
		local args, returns = "", ""
		if func.Arguments then
			args = string.format('<span class="apiarg">%s</span>', WarcraftWiki:GetFunctionArguments(func))
		end
		if func.Returns then
			local returnString = WarcraftWiki:GetFunctionReturns(func)
			returns = string.format(' : <span class="apiret">%s</span>', returnString)
		end
		t[name] = string.format('[[API %s|%s]](%s)%s', name, name, args, returns)
	end
	return t
end

return m
