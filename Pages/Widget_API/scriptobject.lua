local pathlib = require("path")
local cfg = require("wowdoc.config")
local loader = require("wowdoc.loader")
local log = require("wowdoc.util.log")
local naming = require("wowdoc.namingway.naming")
local apilink = require("wowdoc.namingway.wiki.apilink")
local OUT = pathlib.join(cfg.path.wiki, "scriptobject.txt")

local function main()
	loader:LoadDocumentation()
	require("warcraftwiki.page")

	local file = io.open(OUT, "w")
	print("writing to "..OUT)
	for _, system in pairs(APIDocumentation.systems) do
		if system.Type == "ScriptObject" then
			for _, func in pairs(system.Functions) do
				local name = naming:GetProperName(func)
				local link = apilink:GetWikiTemplate(func)
				file:write(string.format(": %s\n", link))
			end
		end
	end
	file:close()
end

main()
print("done")
