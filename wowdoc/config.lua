local pathlib = require("path")
local config = {}

---@type TactProduct
config.TACT_PRODUCT = "wow"

local root = ".wow"
config.path = {
	warcraftwiki = pathlib.join(".wiki"),
	blizres    = pathlib.join(root, "blizres"),
	change_summary = pathlib.join(root, "changes", "summary"),
	change_commit  = pathlib.join(root, "changes", "commit"),
	change_compare = pathlib.join(root, "changes", "compare"),
	change_wiki    = pathlib.join(root, "changes", "wiki"),
	wago       = pathlib.join(root, "wago"),
	scribunto_flavor     = pathlib.join(root, "scribunto", "flavor"),
	scribunto_elink      = pathlib.join(root, "scribunto", "elink"),
	scribunto_patch      = pathlib.join(root, "scribunto", "patch"),
	scribunto_systems    = pathlib.join(root, "scribunto", "systems"),
	scribunto_predicates = pathlib.join(root, "scribunto", "predicates"),
	CACHE      = pathlib.join(root, "cache"),
	STRINGS    = pathlib.join(root, "strings"),
	WIKI_PAGE  = pathlib.join(root, "wiki_page"),
	WIKI_CLASSIC_COMPARE = pathlib.join(root, "wiki_page", "classic_compare"),
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
