-- Blizzard_APIDocumentationGenerated requires the `Enum` table
local util = require("wowdoc")
local pathlib = require("path")
local log = require("wowdoc.log")

local m = {}
local REPO = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources"
local PATH = PATHS.BLIZZRES

local function ApplyFixes()
	-- Meta fields are not written to LuaEnum.lua
	Enum.LFGRoleMeta = {NumValue = 0} -- 10.2.5 LFGConstantsDocumentation.lua
	Constants.PetConsts_PreWrath = { -- 12.0.0 PetConstantsDocumentation.lua
		MAX_STABLE_SLOTS = 0,
		NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
	}
	Constants.PetConsts_Wrath = {
		MAX_STABLE_SLOTS = 0,
		NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
	}
end

function m:LoadLuaEnums(branch)
	if Enum then
		log:warn("WowDocLoader: Enum table already loaded")
		return
	end
	local path = pathlib.join(PATH, string.format("LuaEnum_%s.lua", branch))
	local url = string.format("%s/%s/Resources/LuaEnum.lua", REPO, branch)
	util:DownloadAndRun(url, path)
	ApplyFixes()
	log:success("WowDocLoader: Loaded Enum table")
end

return m
