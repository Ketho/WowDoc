local pathlib = require("path")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.config")
local products = require("wowdoc.products.branches")
local m = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/%s.lua"

function m:GetResource(name, options)
	if not options.product then
		options.product = cfg.TACT_PRODUCT
	end
	if not options.branch then
		options.branch = products:GetBranch(options.product)
	end
	local url = URL:format(options.branch, name)
	local fs = string.format("%s_%s.lua", name, options.branch)
	local dest = pathlib.join(cfg.path.blizres, fs)
	return dl:DownloadAndRun(url, dest)
end

return m
