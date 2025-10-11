local pathlib = require("path")

local function CreatePath(path)
	if not pathlib.exists(path) then
		pathlib.mkdir(path)
	end
end

local folder = "wowdoc"
OUT_PATH = pathlib.join(folder, ".out"); CreatePath(OUT_PATH)
WAGO_CACHE = pathlib.join(folder, ".cache", "wago"); CreatePath(WAGO_CACHE)
CACHE_LUA = pathlib.join(folder, ".cache", "lua"); CreatePath(CACHE_LUA)
CACHE_DIFF = pathlib.join(folder, ".cache", "diff"); CreatePath(CACHE_DIFF)
