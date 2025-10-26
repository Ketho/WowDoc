local util = require("wowdoc")

local function main()
	local data = util:DownloadAndRun(
		string.format("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/CVars.lua", BLIZZRES_BRANCH),
		pathlib.join(PATHS.BLIZZRES, string.format("CVars_%s.lua", BLIZZRES_BRANCH))
	)
	return data
end

return main
