local pathlib = require("path")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.loader.config")
local m = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/refs/heads/%s/Resources/%s.lua"

function m:GetResource(name, branch, path)
	local url = URL:format(branch, name)
	local fs = string.format("%s_%s.lua", name, branch)
	local dest = pathlib.join(cfg.path.BLIZRES, fs)
	return dl:DownloadAndRun(url, dest)
end

return m
