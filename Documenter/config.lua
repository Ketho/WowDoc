local pathlib = require("path")

local function CreatePath(name, path)
	if not pathlib.exists(path) then
		pathlib.mkdir(path)
	end
	_G[name] = path
end

CreatePath("OUT_PATH", "out")
CreatePath("WAGO_CACHE", pathlib.join(OUT_PATH, "wago"))
