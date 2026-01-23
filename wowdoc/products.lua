-- https://wago.tools/
local log = require("wowdoc.log")

local m = {}

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
---|"wowt"
---|"wowxptr"

---@alias GetheBranch string
---|"live"
---|"beta"
---|"classic_anniversary"
---|"classic_beta"
---|"classic_era_ptr"
---|"classic_era"
---|"classic_ptr"
---|"classic_titan"
---|"classic"
---|"ptr"
---|"ptr2"

---@alias BlizzResBranch string
---|"classic_anniversary"
---|"mainline"
---|"mainline_ptr"
---|"mainline_beta"
---|"mists"
---|"mists_ptr"
---|"mists_beta"
---|"cata"
---|"cata_ptr"
---|"vanilla"
---|"vanilla_ptr"
---
---@alias GameType
---|"mainline"
---|"classic"
---|"mists"
---|"cata"
---|"wrath"
---|"tbc"
---|"vanilla"

---@type table<GetheBranch, true>
m.gethe_branch = {
	live = true,
	classic_anniversary = true,
	beta = true,
	classic = true,
	classic_beta = true,
	classic_era = true,
	classic_era_ptr = true,
	classic_ptr = true,
	classic_titan = true,
	ptr = true,
	ptr2 = true,
}

---@type table<TactProduct, GetheBranch>
m.tact_gethe = {
	wow = "live",
	wow_anniversary = "classic_anniversary",
	wow_beta = "beta",
	wow_classic = "classic",
	wow_classic_beta = "classic_beta",
	wow_classic_era = "classic_era",
	wow_classic_era_ptr = "classic_era_ptr",
	wow_classic_ptr = "classic_ptr",
	wow_classic_titan = "classic_titan",
	wowt = "ptr",
	wowxptr = "ptr2",
}

---@type table<TactProduct, BlizzResBranch>
m.blizzres_branch = {
	wow = "mainline",
	wowt = "mainline_ptr",
	wowxptr = "mainline_ptr",
	wow_beta = "mainline_beta",
	wow_classic = "mists",
	wow_classic_ptr = "mists_ptr",
	wow_classic_beta = "mists_beta",
	wow_classic_era = "vanilla",
	wow_classic_era_ptr = "vanilla_ptr",
}

---@type table<GameType, GetheBranch>
m.gametype_branch = {
	mainline = "live",
	mists = "classic",
	cata = "4.4.2",
	wrath = "3.4.3",
	tbc = "classic_anniversary",
	vanilla = "classic_era",
}

local hasShownMsg = {}

local function showLogMessage(product, framexml, blizzres)
	if not hasShownMsg[product] then
		if product then
			log:success(string.format("TACT product: %s", product))
		end
		if framexml then
			log:success(string.format("Gethe branch: %s", framexml))
		end
		if blizzres then
			log:success(string.format("BlizzRes branch: %s", blizzres))
		end
		print("----")
		hasShownMsg[product] = true
	end
end

function m:GetBranch(product)
	local framexml = self.tact_gethe[product]
	local blizzres = self.blizzres_branch[product]
	showLogMessage(product, framexml, blizzres)
	return framexml, blizzres
end

return m
