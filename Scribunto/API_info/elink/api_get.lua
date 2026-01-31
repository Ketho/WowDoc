local pathlib = require("path")
local util = require("wowdoc")
local products = require("wowdoc.products")

local m = {}

function m:main(product)
	util:LoadDocumentation(product)
	local branch = products:GetBranch(product)
	local globalApi = util:DownloadAndRun(
		string.format("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/GlobalAPI.lua", branch),
		pathlib.join(PATHS.BLIZZRES, string.format("GlobalAPI_%s.lua", branch))
	)

	local blizzDoc = {}
	for _, func in ipairs(APIDocumentation.functions) do
		local name = util:api_func_GetFullName(func)
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
