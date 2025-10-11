local pathlib = require("path")

local function CreatePath(name, path)
	if not pathlib.exists(path) then
		pathlib.mkdir(path)
	end
	_G[name] = path
end

local folder = "wowdoc"
CreatePath("OUT_PATH", pathlib.join(folder, ".out"))
CreatePath("WAGO_CACHE", pathlib.join(folder, ".cache", "wago"))
CreatePath("CACHE_LUA", pathlib.join(folder, ".cache", "lua"))
CreatePath("CACHE_DIFF", pathlib.join(folder, ".cache", "diff"))
