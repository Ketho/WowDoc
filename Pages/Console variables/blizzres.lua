local wowdoc = require("wowdoc")

local function main()
	local data = wowdoc:DownloadAndRun(
		string.format("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/CVars.lua", GETHE_BRANCH),
		pathlib.join(PATHS.BLIZZRES, string.format("CVars_%s.lua", GETHE_BRANCH))
	)
	return data
end

return main
