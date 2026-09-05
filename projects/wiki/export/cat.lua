local export = require("wowdoc.web.wiki.export")

-- form some reason not everything is exported
local wikicats = {
	"API functions",
}

local function main()
	for _, cat in pairs(wikicats) do
		print("exporting", cat)
		export:GetCategory(cat)
	end
	print("done")
end

main()
