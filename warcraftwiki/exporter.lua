local util_system = require("wowdoc.util.system")
local log = require("wowdoc.util.log")
local cfg = require("wowdoc.loader.config")
-- local Widgets = require("wowdoc.namingway.scriptobjects")
local emptySystems = require("wowdoc.analyse.systems.system_empty"):get()
local ghostSystems = require("wowdoc.analyse.systems.system_ghost"):get()
local m = {}

local subfolders = {
	"enum",
	"struct",
	"system",
	"scriptobject",
}

local function IsValidSystem(system)
	if emptySystems.isEmpty[system.Name] then
		return false
	elseif ghostSystems[system.Namespace] then
		return false
	end
	return true
end

function m:ExportSystems()
	local folder = cfg.path.WARCRAFTWIKI
	for _, v in pairs(subfolders) do
		util_system:mkdir(folder, v)
	end
	for _, system in ipairs(APIDocumentation.systems) do
		if system.Type == "System" then
			if IsValidSystem(system) then
				util_system:mkdir(folder, "system", system.Name)
			end
		end
	end
	log.success("Finished exporting")
end

--[[
function m:ExportSystems(folder)
	util_system:mkdir(format("%s/system", folder))
	util_system:mkdir(format("%s/widget", folder))
	for _, system in ipairs(APIDocumentation.systems) do
		local systemFolder
		if system.Type == "System" then
			systemFolder = "system"
		elseif system.Type == "ScriptObject" then
			systemFolder = "widget"
		end
		if not emptySystems[system.Name] then
			log.info("Exporting system: "..system:GetFullName())
			util_system:mkdir(format("%s/%s/%s", folder, systemFolder, system.Name))
			local prefix
			if system.Type == "ScriptObject" then
				if not Widgets[system.Name] then
					error(string.format("Not yet mapped widget in namingway/scriptobjects.lua for %s", system.Name))
				end
				prefix = Widgets[system.Name].." "
			else
				prefix = system.Namespace and system.Namespace.."." or ""
			end
			for _, func in ipairs(system.Functions) do
				local path = format("%s/%s/%s/API %s.txt", folder, systemFolder, system.Name, prefix..func.Name)
				local pageText = Wowpedia:GetPageText(func, system.Type)
				WriteFile(path, pageText)
			end
			for _, event in ipairs(system.Events) do
				local path = format("%s/%s/%s/%s.txt", folder, systemFolder, system.Name, event.LiteralName)
				local pageText = Wowpedia:GetPageText(event)
				WriteFile(path, pageText)
			end
		else
			log.warn(string.format("Skipping empty system: %s", system:GetFullName()))
		end
	end
	util_system:mkdir(format("%s/enum", folder))
	util_system:mkdir(format("%s/struct", folder))
	log.info("Exporting (systemless) tables")
	for _, apiTable in ipairs(APIDocumentation.tables) do
		if type(apiTable.Type) == "table" then -- hack for TypeDocumentation
			apiTable.Type = apiTable.Type[1]
		end
		local isTransclude = Wowpedia.complexRefs[apiTable.Name]
		if isTransclude and isTransclude > 1 then
			local transcludeBase, shortType = Wowpedia:GetTranscludeBase(apiTable)
			local path = format("%s/%s/%s.txt", folder, shortType:lower(), transcludeBase)
			local pageText = Wowpedia:GetTableText(apiTable, true)
			WriteFile(path, pageText)
		end
	end
	log.success("Finished exporting")
end
]]

return m
