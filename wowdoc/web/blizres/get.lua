local pathlib = require("path")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.config")
local products = require("wowdoc.products.branches")
local m = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/%s.lua"

function m:GetResource(name, branch)
	branch = branch or products:GetBranch(cfg.TACT_PRODUCT)
	local url = URL:format(branch, name)
	local fs = string.format("%s_%s.lua", name, branch)
	local dest = pathlib.join(cfg.path.blizres, fs)
	return dl:DownloadAndRun(url, dest)
end

return m
