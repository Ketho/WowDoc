local pathlib = require("path")
local loader = require("wowdoc.loader")
local dl = require("wowdoc.web.download")
local products = require("wowdoc.products.branches")
local naming = require("wowdoc.namingway.naming")
local cfg = require("wowdoc.config")
local m = {}

function m:main(product)
	loader:LoadDocumentation()
	local branch = products:GetBranch(product)
	local globalApi = dl:DownloadAndRun(
		string.format("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/GlobalAPI.lua", branch),
		pathlib.join(cfg.path.blizres, string.format("GlobalAPI_%s.lua", branch))
	)

	local blizzDoc = {}
	for _, func in pairs(APIDocumentation.functions) do
		local name = naming:GetProperName(func)
		blizzDoc[name] = func.System:GetName()
	end

	local nonBlizzDocumented = {}
	for _, name in pairs(globalApi[1]) do
		if not blizzDoc[name] then
			nonBlizzDocumented[name] = true
		end
	end

	return {blizzDoc, nonBlizzDocumented}
end

return m
