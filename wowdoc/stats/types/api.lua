local get_types = require("wowdoc.stats.types.get_types")
local TypeDoc = require("wowdoc.loader.doc.TypeDocumentation")
local enum = require("wowdoc.web.blizres.enum")

local m = {}
m.types = {}

function m:GetAllTypes()
	self.types.all = self.types.all or get_types:GetAllTypes()
	return self.types.all
end

function m:GetDocTypes()
	self.types.doc = self.types.doc or get_types:GetSets().table_docs
	return self.types.doc
end

function m:GetUndocTypes()
	if not self.types.undoc then
		self.types.undoc = {}
		local all_types = self:GetAllTypes()
		local doc_types = self:GetDocTypes()
		for k in pairs(all_types) do
			if not doc_types[k] then
				self.types.undoc[k] = true
				-- print(k)
			end
		end
	end
	return self.types.undoc
end

-- referenced in docs but not defined
function m:GetMissingEnums()
	if not self.types.missing_enums then
		local undoc = self:GetUndocTypes()
		self.types.missing_enums = {}
		for k in pairs(undoc) do
			if Enum[k] then
				self.types.missing_enums[k] = true
				-- print(k)
			end
		end
	end
	return self.types.missing_enums
end
-- AccountStoreCategoryType
-- AccountStoreItemFlag
-- AccountStoreItemMode
-- AccountStoreItemStatus
-- AccountStoreState
-- AccountStoreTransactionResult
-- CachedRewardType
-- GameMode
-- GameRule
-- HouseSettingFlags
-- InvalidPlotScreenshotReason
-- ItemCreationContext
-- ItemSoundType
-- NeighborhoodOwnerType
-- NeighborhoodType
-- PartyPlaylistEntry
-- PurchaseHouseDisabledReason
-- ResidentType
-- Vocalerrorsounds
-- WeeklyRewardChestThresholdType

-- never referenced in docs
function m:GetUnusedEnums()
	if not self.types.unused_enums then
		local doc = self:GetDocTypes()
		self.types.unused_enums = {}
		for k in pairs(Enum) do
			local missing = self:GetMissingEnums()
			if not doc[k] and not missing[k] then
				self.types.unused_enums[k] = true
				-- print(k)
			end
		end
	end
	return self.types.unused_enums
end
-- AccountStateFlags
-- AccountStateLoadedFlags
-- AccountStoreFrontFlag
-- AccountStoreItemRewardType
-- AccountStoreSettlementAction
-- AccountStoreTransactionType
-- AssertDomain
-- BattlepayLicenseSynthesisFlags
-- BattlepayProductChoiceType
-- BattlepayShopEntryBannerType
-- BattlepayShopEntryFlags
-- CDMLayoutMode
-- ChrRacesAllianceType
-- ClientDebugAISpellReadyStatus
-- CooldownLayoutAction
-- CooldownLayoutStatus
-- CooldownLayoutType
-- CreateAllAccountData
-- EditModeChatFrameDisplayOnlySetting
-- ErrorDomain
-- HousingDecorActionFlags
-- HousingDecorModelType
-- HousingDecorType
-- HousingFavorUpdateSource
-- HousingFavorUpdateType
-- HousingTeleportReason
-- ItemModification
-- LFGRoleMeta -- compat
-- LgVendorPurchaseSettlementState
-- LgVendorPurchaseSqlResults
-- LgVendorPurchaseState
-- ManipulatorEventType
-- ModelSoundOverrideType
-- ModelSoundTagType
-- ReservationFlags
-- ShutdownSessionReason
-- Si3UISoundSubType
-- Siflag
-- SoundBusFlag
-- VasPurchaseProgress
-- WeeklyRewardChestActivityType
-- WeeklyRewardChestClaimRewardResult
-- WeeklyRewardProgressResult
-- WoWLabsAreaType

function m:GetRemainingUndocTypes()
	if not self.types.remain then
		self.types.remain = {}
		local all_types = self:GetAllTypes()
		local doc_types = self:GetDocTypes()
		local missing_enums = self:GetMissingEnums()
		local typedoc = self:GetTypeDocTable()
		for k in pairs(all_types) do
			if not doc_types[k] and not missing_enums[k] and not typedoc[k] then
				self.types.remain[k] = true
				print(k)
			end
		end
	end
	return self.types.remain
end

function m:GetTypeDocTable()
	local t = {}
	for _, v in pairs(TypeDoc) do
		t[v.Name] = v
	end
	return t
end

return m
