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

	-- loading docs from a future build than the current enum table
	Constants.HousingCatalogConsts = { -- 12.0.0 HousingCatalogConstantsDocumentation.lua
		HOUSING_CATALOG_OPTIONS_EXPECTED = 0,
		HOUSING_CATALOG_CATEGORIES_EXPECTED = 0,
		HOUSING_CATALOG_SUBCATEGORIES_EXPECTED = 0,
	}
	Enum.SecretAspect = {}
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
