local log = require("wowdoc.util.log")
local m = {}

m.data = {
	AbbreviateConfigAPI = "AbbreviateConfig",
	AbbreviatedNumberFormatterAPI = "AbbreviatedNumberFormatter",
	DurationTextBindingObjectAPI = "DurationTextBinding",
	FrameAPIArchaeologyDigSiteFrame = "ArchaeologyDigSiteFrame", -- empty
	FrameAPIBlob = "Blob",
	FrameAPICharacterModelBase = "PlayerModel", -- instead of CharacterModelBase
	FrameAPICinematicModel = "CinematicModel",
	FrameAPICooldown = "Cooldown",
	FrameAPIDressUpModel = "DressUpModel",
	FrameAPIFogOfWarFrame = "FogOfWarFrame",
	FrameAPIModelSceneFrame = "ModelScene",
	FrameAPIModelSceneFrameActor = "ModelSceneActor",
	FrameAPIModelSceneFrameActorBase = "ModelSceneActorBase",
	FrameAPINamePlate = "NamePlate",
	FrameAPIQuestPOI = "QuestPOIFrame",
	FrameAPIScenarioPOI = "ScenarioPOIFrame",
	FrameAPISimpleCheckout = "Checkout", -- obscure
	FrameAPITabardModel = "TabardModel",
	FrameAPITabardModelBase = "TabardModelBase",
	FrameAPITooltip = "GameTooltip",
	FrameAPIUnitPositionFrame = "UnitPositionFrame",
	HousingCatalogSearcherAPI = "HousingCatalogSearcher",
	HousingFixturePointFrameAPI = "HousingFixturePointFrame",
	HousingLayoutPinFrameAPI = "HousingLayoutPinFrame",
	LuaColorCurveObjectAPI = "ColorCurveObject",
	LuaCurveObjectAPI = "CurveObject",
	LuaCurveObjectBaseAPI = "CurveObjectBase",
	LuaDurationClockObjectAPI = "DurationClock",
	LuaDurationManualClockAPI = "DurationManualClock",
	LuaDurationObjectAPI = "DurationObject",
	MinimapFrameAPI = "Minimap",
	NumericFormatterAPI = "NumericFormatter",
	NumericRuleFormatterAPI = "NumericRuleFormatter",
	PingPinFrameAPI = "PingPin",
	SecondsFormatterAPI = "SecondsFormatter",
	SimpleAnimAlphaAPI = "Alpha",
	SimpleAnimAPI = "Animation",
	SimpleAnimatableObjectAPI = "AnimatableObject",
	SimpleAnimFlipBookAPI = "FlipBook",
	SimpleAnimGroupAPI = "AnimationGroup",
	SimpleAnimPathAPI = "Path",
	SimpleAnimRadialProgressAPI = "RadialProgress",
	SimpleAnimRotationAPI = "Rotation",
	SimpleAnimScaleAPI = "Scale",
	SimpleAnimScaleLineAPI = "ScaleLine", -- empty
	SimpleAnimTextureCoordTranslationAPI = "TextureCoordTranslation",
	SimpleAnimTranslationAPI = "Translation",
	SimpleAnimTranslationLineAPI = "TranslationLine", -- empty
	SimpleAnimVertexColorAPI = "VertexColor",
	SimpleBrowserAPI = "Browser", -- obscure
	SimpleButtonAPI = "Button",
	SimpleCheckboxAPI = "CheckButton",
	SimpleColorSelectAPI = "ColorSelect",
	SimpleControlPointAPI = "ControlPoint",
	SimpleEditBoxAPI = "EditBox",
	SimpleFontAPI = "Font",
	SimpleFontStringAPI = "FontString",
	SimpleFrameAPI = "Frame",
	SimpleFrameScriptObjectAPI = "FrameScriptObject",
	SimpleHTMLAPI = "SimpleHTML",
	SimpleLineAPI = "Line",
	SimpleMapSceneAPI = "MapScene", -- glues
	SimpleMaskTextureAPI = "MaskTexture", -- empty
	SimpleMessageFrameAPI = "MessageFrame",
	SimpleModelAPI = "Model",
	SimpleModelFFXAPI = "ModelFFX", -- glues
	SimpleMovieAPI = "MovieFrame",
	SimpleObjectAPI = "Object",
	SimpleOffScreenFrameAPI = "OffScreenFrame", -- obscure
	SimpleRegionAPI = "Region",
	SimpleScriptRegionAPI = "ScriptRegion",
	SimpleScriptRegionResizingAPI = "ScriptRegionResizing",
	SimpleScrollFrameAPI = "ScrollFrame",
	SimpleSliderAPI = "Slider",
	SimpleStatusBarAPI = "StatusBar",
	SimpleTextureAPI = "Texture",
	SimpleTextureBaseAPI = "TextureBase",
	SimpleVectorGraphicsAPI = "VectorGraphics",
	UnitHealPredictionCalculatorAPI = "UnitHealPredictionCalculator",
}

function m:shorten(s)
	if m.data[s] then
		return m.data[s]
	else
		log.failure(string.format("Missing short name for ScriptObject %s", s))
		return s
	end
end

return m
