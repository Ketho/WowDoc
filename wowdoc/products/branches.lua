local p = {}

-- https://wago.tools/
---@enum TactProduct
p.TactProduct = {
	wow = "wow",
	wow_anniversary = "wow_anniversary",
	wow_beta = "wow_beta",
	wow_classic = "wow_classic",
	wow_classic_beta = "wow_classic_beta",
	wow_classic_era = "wow_classic_era",
	wow_classic_era_ptr = "wow_classic_era_ptr",
	wow_classic_ptr = "wow_classic_ptr",
	wow_classic_titan = "wow_classic_titan",
	wowdev = "wowdev",
	wowdev2 = "wowdev2",
	wowdev3 = "wowdev3",
	wowe1 = "wowe1",
	wowe3 = "wowe3",
	wowlivetest = "wowlivetest",
	wowlivetest2 = "wowlivetest2",
	wowt = "wowt",
	wowv = "wowv",
	wowv2 = "wowv2",
	wowv3 = "wowv3",
	wowv4 = "wowv4",
	wowxptr = "wowxptr",
	wowz = "wowz",
}

-- https://warcraft.wiki.gg/wiki/TOC_format#Client-specific_TOC_files
---@enum GameType
p.GameType = {
	camelot = "camelot", -- forever
	cata = "cata",
	classic = "classic", -- family: any classic gametype
	mainline = "mainline", -- family: midnight, forever
	mists = "mists",
	plunderstorm = "plunderstorm",
	standard = "standard", -- midnight
	tbc = "tbc",
	vanilla = "vanilla",
	wowhack = "wowhack",
	wowlabs = "wowlabs",
	wrath = "wrath",
}

-- https://github.com/Gethe/wow-ui-source
---@enum GetheBranch
p.GetheBranch = {
	beta = "beta",
	classic = "classic",
	classic_anniversary = "classic_anniversary",
	classic_beta = "classic_beta",
	classic_era = "classic_era",
	classic_era_ptr = "classic_era_ptr",
	classic_ptr = "classic_ptr",
	classic_titan = "classic_titan",
	forever = "forever",
	live = "live",
	ptr = "ptr",
	ptr2 = "ptr2",
}

---@type table<TactProduct, GetheBranch>
p.product_gethe = {
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

---@type table<TactProduct, GameType>
p.tact_gametype = {
	wow = p.GameType.standard,
	wow_anniversary = p.GameType.tbc,
	wow_beta = p.GameType.standard,
	wow_classic = p.GameType.mists,
	wow_classic_beta = p.GameType.camelot,
	wow_classic_era = p.GameType.vanilla,
	wow_classic_era_ptr = p.GameType.vanilla,
	wow_classic_ptr = p.GameType.mists,
	wow_classic_titan = p.GameType.wrath,
	wowt = p.GameType.standard,
	wowxptr = p.GameType.standard,
}

---@type table<GameType, GetheBranch|string>
p.gametype_branch = {
	camelot = p.GetheBranch.forever,
	cata = "4.4.2",
	mainline = p.GetheBranch.live,
	mists = p.GetheBranch.classic,
	tbc = p.GetheBranch.classic_anniversary,
	vanilla = p.GetheBranch.classic_era,
	wrath = "3.4.3",
}

---@type GameType[]
p.tracked_gametype = {
	p.GameType.standard,
	p.GameType.camelot,
	p.GameType.mists,
	p.GameType.tbc,
	p.GameType.vanilla,
}

function p:GetBranch(product)
	local branch = self.product_gethe[product]
	if not branch then
		error(string.format("No branch found for product %s", product))
	end
	return branch
end

return p
