-- verify enum docs with actual Enum table
local enum = require("wowdoc.web.blizres.enum")
local tablelib = require("wowdoc.util.table")
local m = {}

function m:test()
	enum:LoadEnumTable("live")
	local loader = require("wowdoc.loader")
	loader:LoadDocumentation(nil, {excludeMissing = true})

	self:CompareFromDocs()
	-- self:CompareFromEnumTable()
end

local function ConvertFromDoc(v)
	local t = {}
	for k, v in pairs(v.Fields) do
		t[v.Name] = v.EnumValue
	end
	return t
end

function m:CompareFromDocs()
	for k, v in pairs(APIDocumentation.tables) do
		if v.Type == "Enumeration" then
			if not Enum[v.Name] then
				print("missing", v.Name)
			else
				local convert = ConvertFromDoc(v)
				local equals = tablelib.equals(Enum[v.Name], convert)
				if not equals then
					print("not equals", v.Name)
				end
			end
		end
	end
end
-- not equals, CooldownViewerCategory, CooldownViewerConstantsDocumentation.lua
-- missing, CharCreateAnimTurnType, CharacterCreationConstantsDocumentation.lua
-- missing, CharSectionCondition, CharacterCreationConstantsDocumentation.lua
-- missing, ConfigurationWarning, ConfigurationWarningConstantsDocumentation.lua
-- missing, VasTransactionPurchaseResult, BattlepayConstantsDocumentation.lua
-- missing, WarbandEventState, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandGroupFlags, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandPlacementDisplayInfoType, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandSceneAnimationEvent, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandSceneAnimationSheatheState, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandSceneAnimationStandState, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandSceneAnimationStandStateFlags, CharacterSelectionConstantsDocumentation.lua
-- missing, WarbandScenePlacementType, CharacterSelectionConstantsDocumentation.lua

function m:CompareFromEnumTable()
	for k, v in pairs(Enum) do
		local doc = APIDocumentation:FindAPIByName("table", k)
		if not doc then
			print("missing", k)
		else
			local convert = ConvertFromDoc(doc)
			local equals = tablelib.equals(v, convert)
			if not equals then
				print("not equals", k)
			end
		end
	end
end
-- not equals, CooldownViewerCategory
-- missing, AccountStateFlags
-- missing, AccountStateLoadedFlags
-- missing, AccountStoreCategoryType
-- missing, AccountStoreFrontFlag
-- missing, AccountStoreItemFlag
-- missing, AccountStoreItemMode
-- missing, AccountStoreItemRewardType
-- missing, AccountStoreItemStatus
-- missing, AccountStoreSettlementAction
-- missing, AccountStoreState
-- missing, AccountStoreTransactionResult
-- missing, AccountStoreTransactionType
-- missing, AssertDomain
-- missing, BattlepayLicenseSynthesisFlags
-- missing, BattlepayProductChoiceType
-- missing, BattlepayShopEntryBannerType
-- missing, BattlepayShopEntryFlags
-- missing, CachedRewardType
-- missing, CDMLayoutMode
-- missing, ChrRacesAllianceType
-- missing, ClientDebugAISpellReadyStatus
-- missing, CooldownLayoutAction
-- missing, CooldownLayoutStatus
-- missing, CooldownLayoutType
-- missing, CreateAllAccountData
-- missing, EditModeChatFrameDisplayOnlySetting
-- missing, ErrorDomain
-- missing, GameMode
-- missing, GameRule
-- missing, HouseSettingFlags
-- missing, HousingDecorActionFlags
-- missing, HousingDecorModelType
-- missing, HousingDecorType
-- missing, HousingFavorUpdateSource
-- missing, HousingFavorUpdateType
-- missing, HousingTeleportReason
-- missing, InvalidPlotScreenshotReason
-- missing, ItemCreationContext
-- missing, ItemModification
-- missing, ItemSoundType
-- missing, LFGRoleMeta
-- missing, LgVendorPurchaseSettlementState
-- missing, LgVendorPurchaseSqlResults
-- missing, LgVendorPurchaseState
-- missing, ManipulatorEventType
-- missing, ModelSoundOverrideType
-- missing, ModelSoundTagType
-- missing, NeighborhoodOwnerType
-- missing, NeighborhoodType
-- missing, PartyPlaylistEntry
-- missing, PurchaseHouseDisabledReason
-- missing, ReservationFlags
-- missing, ResidentType
-- missing, ShutdownSessionReason
-- missing, Si3UISoundSubType
-- missing, Siflag
-- missing, SoundBusFlag
-- missing, VasPurchaseProgress
-- missing, Vocalerrorsounds
-- missing, WeeklyRewardChestActivityType
-- missing, WeeklyRewardChestClaimRewardResult
-- missing, WeeklyRewardChestThresholdType
-- missing, WeeklyRewardProgressResult
-- missing, WoWLabsAreaType

m:test()
return m
