local table_sort = require("wowdoc.util.table_sort")
local wago = require("wowdoc.web.wago")
local m = {}

local flavorInfo = {
	mainline = {flavor = "mainline", branch = "wow", header = true},
	mainline_beta = {flavor = "mainline", branch = "wow_beta", header = true},
	mainline_ptr = {flavor = "mainline", branch = "wowxptr", header = true},
	vanilla = {flavor = "vanilla", header = true, branch = "wow_classic_era"},
	vanilla_ptr = {flavor = "vanilla", branch = "wow_classic_era_ptr", header = true}, -- has 10.1.5 and 10.0.7 builds
	cata = {flavor = "cata", header = true, branch = "wow_classic"},
	cata_ptr = {flavor = "cata", header = true, branch = "wow_classic_beta"},
	mists_beta = {flavor = "mists", header = true, branch = "wow_classic_beta"},
}

-- accepts an options table or a game flavor
function m:GetFlavorOptions(info)
	local infoType = type(info)
	if infoType == "table" then
		return info
	elseif infoType == "string" then
		local t = flavorInfo[info]
		if t.branch then
			-- need to know what the latest build is when downloading
			t.build = wago:GetWagoVersions(t.branch)[1] -- latest build for a branch
		end
		t.sort = table_sort.SortPatch
		return t
	elseif not info then
		return flavorInfo.mainline
	end
end

return m
