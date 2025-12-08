local pathlib = require("path")

local function CreatePath(path)
	if not pathlib.exists(path) then
		pathlib.mkdir(path)
	end
end

PATHS = {}
local root = ".wow"

PATHS.OUT = pathlib.join(root, "out")
PATHS.DOCUMENTER = pathlib.join(root, "documenter")
PATHS.WAGO = pathlib.join(root, "wago")
PATHS.CACHE = pathlib.join(root, "cache")
PATHS.DIFF = pathlib.join(root, "diff")
PATHS.BLIZZRES = pathlib.join(root, "blizzres")
PATHS.SCRIBUNTO = pathlib.join(root, "scribunto")
PATHS.STRINGS = pathlib.join(root, "strings")
PATHS.WIKI_PAGE = pathlib.join(root, "wiki_page")
PATHS.WIKI_CLASSIC_COMPARE = pathlib.join(root, "wiki_page", "classic_compare")

for _, v in pairs(PATHS) do
	CreatePath(v)
end

CONFIG = {}

-- fallback to this tact product for all scripts
-- instead of having to change it all the time everywhere
CONFIG.TACT_PRODUCT = "wow" ---@type TactProduct
