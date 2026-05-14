-- documented namespaces that dont actually exist

local tablelib = require("wowdoc.util.table")
local blizres = require("wowdoc.web.blizres.get")

if not APIDocumentation then
	require("wowdoc.loader"):LoadDocumentation()
end

local m = {}

function m:GetDocNamespaces()
	local t = {}
	for _, v in pairs(APIDocumentation.systems) do
		if v.Namespace then
			t[v.Namespace] = true
		end
	end
	return t
end

function m:GetDefinedNamespaces()
	local globalapi = blizres:GetResource("GlobalAPI", "live")
	local t = {}
	for _, v in pairs(globalapi[1]) do
		if v:find("%.") then
			local namespace = v:match("^(.*)%.")
			t[namespace] = true
		end
	end
	return t
end

function m:GetGhostNamespaces()
	local doc = self:GetDocNamespaces()
	local defined = self:GetDefinedNamespaces()
	local t = {}
	for k in pairs(doc) do
		if not defined[k] then
			t[k] = true
		end
	end
	return t
end

function m:test()
	local doc = m:GetDocNamespaces()
	local defined = m:GetDefinedNamespaces()
	tablelib.CompareTable(doc, defined)
end
-- m:test()

-- these do not exist or do not have functions yet, but are documented with having at least a namespace
-- C_AccessibilityOptions
-- C_BarberShopInternal
-- C_BattlePet
-- C_BlackMarketInfo
-- C_Browser
-- C_CinematicList
-- C_ClientScene
-- C_CombatLogInternal
-- C_CombatLogSecure
-- C_CompactUnitFrames
-- C_ConfigurationWarnings
-- C_CursorUtil
-- C_DeathAlert
-- C_DuelInfo
-- C_EncounterInfo
-- C_GlyphInfo
-- C_GMTicketInfo
-- C_IslandsInfo
-- C_ItemText
-- C_LiveEvent
-- C_LoadingScreen
-- C_MacOptions
-- C_PingSecure
-- C_Platform
-- C_Pony
-- C_ScriptWarnings
-- C_SecureTransfer
-- C_SkillInfo
-- C_Trainer
-- C_TraitConfig
-- C_UIActionHandler
-- C_Vehicle
-- C_WorldSafeLocsUIInternal
-- C_WorldStateInfo
-- C_WowEntitlementInfo

-- # these exist but are not documented
-- C_AccountServices
-- C_ArrowCalloutManager
-- C_BlackMarket
-- C_CharacterServices
-- C_CharacterServicesPublic
-- C_Debug
-- C_FunctionContainers
-- C_Heirloom
-- C_PrototypeDialog
-- C_Reincarnation
-- C_Scenario
-- C_SharedCharacterServices
-- C_SpectatingUI
-- C_ToyBox
-- C_Trophy
-- C_Widget
-- C_WowLabsDataManager
-- C_WoWLabsMatchmaking
-- C_WowTokenPublic

return m
