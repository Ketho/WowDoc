local pathlib = require("path")
local cfg = require("wowdoc.config")
local loader = require("wowdoc.loader")
local log = require("wowdoc.util.log")
local naming = require("wowdoc.namingway.naming")
local OUT = pathlib.join(cfg.path.wiki_scriptobject, "scriptobject.txt")

local function GetTemplate(name, func)
	local t = {}
	table.insert(t, "apilink")
	table.insert(t, "t=w")
	table.insert(t, name)
	if func.Arguments and #func.Arguments > 0 then
		table.insert(t, "arg="..WarcraftWiki:GetFunctionArguments(func.Arguments))
	end
	if func.Returns and #func.Returns > 0 then
		table.insert(t, "ret="..WarcraftWiki:GetFunctionReturns(func))
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end

local function main()
	loader:LoadDocumentation()
	require("warcraftwiki.page")

	local file = io.open(OUT, "w")
	print("writing to "..OUT)
	for _, system in pairs(APIDocumentation.systems) do
		if system.Type == "ScriptObject" then
			for _, func in pairs(system.Functions) do
				local name = naming:GetProperName(func)
				local apilink = GetTemplate(name, func)
				file:write(string.format(": %s\n", apilink))
			end
		end
	end
	file:close()
end

main()
print("done")
