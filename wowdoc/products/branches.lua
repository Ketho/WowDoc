-- https://wago.tools/
local log = require("wowdoc.util.log")
local m = {}

-- https://wago.tools/
---@alias TactProduct
---|"wow"
---|"wow_anniversary"
---|"wow_beta"
---|"wow_classic"
---|"wow_classic_beta"
---|"wow_classic_era"
---|"wow_classic_era_ptr"
---|"wow_classic_ptr"
---|"wow_classic_titan"
---|"wowdev"
---|"wowdev2"
---|"wowdev3"
---|"wowe1"
---|"wowe3"
---|"wowlivetest"
---|"wowlivetest2"
---|"wowt"
---|"wowv"
---|"wowv2"
---|"wowv3"
---|"wowv4"
---|"wowxptr"
---|"wowz"

-- https://github.com/Gethe/wow-ui-source
---@alias GetheBranch
---|"beta"
---|"classic"
---|"classic_anniversary"
---|"classic_beta"
---|"classic_era"
---|"classic_era_ptr"
---|"classic_ptr"
---|"classic_titan"
---|"forever"
---|"live"
---|"ptr"
---|"ptr2"

-- https://warcraft.wiki.gg/wiki/TOC_format
---@alias GameType
---|"camelot" -- forever
---|"cata"
---|"classic" -- family: any classic gametype
---|"mainline" -- family: midnight, forever
---|"mists"
---|"plunderstorm"
---|"standard" -- midnight
---|"tbc"
---|"vanilla"
---|"wowhack"
---|"wowlabs"
---|"wrath"

---@type table<TactProduct, GetheBranch>
m.product_gethe = {
	wow = "live",
	wow_anniversary = "classic_anniversary",
	wow_beta = "beta",
	wow_classic = "classic",
	wow_classic_beta = "forever",
	wow_classic_era = "classic_era",
	wow_classic_era_ptr = "classic_era_ptr",
	wow_classic_ptr = "classic_ptr",
	wow_classic_titan = "classic_titan",
	wowt = "ptr",
	wowxptr = "ptr2",
}

---@type table<GameType, GetheBranch|string>
m.gametype_branch = {
	camelot = "forever",
	cata = "4.4.2",
	mainline = "live",
	mists = "classic",
	tbc = "classic_anniversary",
	vanilla = "classic_era",
	wrath = "3.4.3",
}

---@type table<TactProduct, GetheBranch>
m.product_branch = {
	wow = "live",
	wow_beta = "live",
	wow_classic = "classic",
	wow_classic_beta = "forever",
	wow_classic_era = "classic_era",
	wow_classic_era_ptr = "classic_era",
	wow_classic_ptr = "classic",
	wowt = "live",
	wowxptr = "live",
}

function m:GetBranch(product)
	local branch = self.product_gethe[product]
	if not branch then
		error(string.format("No branch found for product %s", product))
	end
	return branch
end

return m
