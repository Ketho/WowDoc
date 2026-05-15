local pathlib = require("path")
local config = {}

---@type TactProduct
config.TACT_PRODUCT = "wow"

local root = ".wow"
config.path = {
	WAGO       = pathlib.join(root, "wago"),
	CACHE      = pathlib.join(root, "cache"),
	DIFF       = pathlib.join(root, "diff"),
	BLIZZRES   = pathlib.join(root, "blizzres"),
	SCRIBUNTO  = pathlib.join(root, "scribunto"),
	STRINGS    = pathlib.join(root, "strings"),
	WARCRAFTWIKI = pathlib.join(root, "warcraftwiki"),
	WIKI_PAGE  = pathlib.join(root, "wiki_page"),
	WIKI_CLASSIC_COMPARE = pathlib.join(root, "wiki_page", "classic_compare"),
	WIKI_DIFF  = pathlib.join(root, "wiki_page", "diff"),
	WIKI_CATEGORIES = pathlib.join(root, "wiki_categories"),
}

local function CreatePath(path)
	if not pathlib.exists(path) then
		pathlib.mkdir(path)
	end
end

for _, v in pairs(config.path) do
	CreatePath(v)
end

return config
