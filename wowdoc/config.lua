local pathlib = require("path")
local config = {}

---@type TactProduct
config.TACT_PRODUCT = "wow"

local root = ".wow"
config.path = {
	CACHE      = pathlib.join(root, "cache"),
	DIFF       = pathlib.join(root, "diff"),
	STRINGS    = pathlib.join(root, "strings"),
	WIKI_PAGE  = pathlib.join(root, "wiki_page"),
	WIKI_CLASSIC_COMPARE = pathlib.join(root, "wiki_page", "classic_compare"),
	WIKI_DIFF  = pathlib.join(root, "wiki_page", "diff"),
	blizres    = pathlib.join(root, "blizres"),
	scribunto  = pathlib.join(root, "scribunto"),
	wago       = pathlib.join(root, "wago"),
	wiki_cats  = pathlib.join(root, "wiki", "cats"),
	wiki_predicates = pathlib.join(root, "wiki", "predicates"),
	warcraftwiki = pathlib.join(".wiki"),
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
