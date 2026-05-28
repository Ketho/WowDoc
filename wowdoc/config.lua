local pathlib = require("path")
local config = {}

---@type TactProduct
config.TACT_PRODUCT = "wowxptr"

local root = ".wow"
config.path = {
	warcraftwiki      = pathlib.join(".wiki"),
	blizres           = pathlib.join(root, "blizres"),
	wago              = pathlib.join(root, "wago"),
	wiki              = pathlib.join(root, "wiki"),
	wiki_wowapi       = pathlib.join(root, "wiki", "wowapi"),
	changes_apidoc    = pathlib.join(root, "changes", "apidoc"),
	changes_diff      = pathlib.join(root, "changes", "diff"),
	changes_blizres   = pathlib.join(root, "changes", "blizres"),
	scribunto_flavor     = pathlib.join(root, "scribunto", "flavor"),
	scribunto_elink      = pathlib.join(root, "scribunto", "elink"),
	scribunto_patch      = pathlib.join(root, "scribunto", "patch"),
	scribunto_systems    = pathlib.join(root, "scribunto", "systems"),
	scribunto_namespaces = pathlib.join(root, "scribunto", "namespaces"),
	scribunto_predicates = pathlib.join(root, "scribunto", "predicates"),
	strings = pathlib.join(root, "strings"),
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
