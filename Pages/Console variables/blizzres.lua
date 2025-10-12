local util = require("wowdoc")
local flavor = "mainline_ptr"

local function main()
	local data = util:DownloadAndRun(
		string.format("https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/CVars.lua", flavor),
		pathlib.join(PATHS.BLIZZRES, string.format()"CVars_%s.lua", flavor)
	)
	return data
end

return main
