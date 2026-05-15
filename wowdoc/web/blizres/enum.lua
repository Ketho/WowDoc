-- Blizzard_APIDocumentationGenerated requires the Enum table
local pathlib = require("path")
local log = require("wowdoc.util.log")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.loader.config")
local m = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/%s/Resources/LuaEnum.lua"

function m:LoadEnumTable(branch)
	local pretty_branch = log.colorize(branch, 32)
	if Enum then
		log.warn(string.format("wowdoc: [branch %s] Enum table already loaded", branch))
		return
	else
		log.info(string.format("wowdoc: [branch %s] Loading Enum table", pretty_branch))
	end
	local url = URL:format(branch)
	local path = pathlib.join(cfg.path.BLIZZRES, string.format("LuaEnum_%s.lua", branch))
	dl:DownloadAndRun(url, path)
	self:FixEnumTable()
end

function m:FixEnumTable()
	if not Enum.LFGRoleMeta then -- Meta fields are not written to LuaEnum.lua
		Enum.LFGRoleMeta = {NumValue = 0} -- 10.2.5 LFGConstantsDocumentation.lua
	end
	-- if not Constants.PetConsts_PreWrath then
	-- 	Constants.PetConsts_PreWrath = { -- 12.0.0 PetConstantsDocumentation.lua
	-- 		MAX_STABLE_SLOTS = 0,
	-- 		NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
	-- 	}
	-- end
	-- if not Constants.PetConsts_Wrath then
	-- 	Constants.PetConsts_Wrath = {
	-- 		MAX_STABLE_SLOTS = 0,
	-- 		NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
	-- 	}
	-- end
end

return m
