-- Blizzard_APIDocumentationGenerated requires the Enum table
local pathlib = require("path")
local log = require("wowdoc.util.log")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.config")
local m = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/LuaEnum.lua"

function m:LoadEnumTable(options)
	options.branch = options.branch or "live"
	if Enum then
		if not options.silent then
			log.warn(string.format("wowdoc: [branch %s] Enum table already loaded", options.branch))
		end
		return
	else
		log.info(string.format("wowdoc: [branch %s] Loading Enum table", options.branch))
	end
	local url = URL:format(options.branch)
	local path = pathlib.join(cfg.path.blizres, string.format("LuaEnum_%s.lua", options.branch))
	dl:DownloadAndRun(url, path)
	self:FixEnumTable()
	if options.enum_postcall then
		options.enum_postcall()
	end
end

function m:FixEnumTable()
	if not Enum.LFGRoleMeta then -- Meta fields are not written to LuaEnum.lua
		Enum.LFGRoleMeta = {NumValue = 0} -- 10.2.5 LFGConstantsDocumentation.lua
	end
end

return m
