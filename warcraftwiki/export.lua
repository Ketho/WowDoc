local pathlib = require("path")
local util_system  = require("wowdoc.util.system")
local log          = require("wowdoc.util.log")
local cfg          = require("wowdoc.config")
local naming       = require("wowdoc.namingway.naming")
local emptySystems = require("wowdoc.stats.systems.system_empty"):get()
local ghostSystems = require("wowdoc.stats.systems.system_ghost"):get()
local page = require("warcraftwiki.page")
local m = {}

function m:ExportDocumentation()
	self:ExportSystems()
	self:ExportTables()
	log.success("Finished exporting")
end

local function IsValidSystem(system)
	if emptySystems.empty[system.Name] then
		return false, "empty"
	elseif emptySystems.irrelevant[system.Name] then
		return false, "irrelevant"
	elseif ghostSystems[system.Namespace] then
		return false, "ghost"
	end
	return true
end

function m:ExportSystems()
	for _, system in pairs(APIDocumentation.systems) do
		local name = system:GetFullName()
		local isValid, reason = IsValidSystem(system)
		if isValid then
			log.info(string.format("Exporting %s: %s", system.Type, name))
			self:ExportSystem(system)
		else
			log.warn(string.format("Skipping %s system: %s", reason, name))
		end
	end
end

function m:ExportSystem(system)
	local proper_name = naming:GetSystemName(system)
	local folder = pathlib.join(cfg.path.warcraftwiki, system.Type, proper_name)
	util_system:mkdir(folder)
	for _, v1 in pairs({"Functions", "Events"}) do
		for _, v2 in pairs(system[v1]) do
			self:ExportFile(v2, folder)
		end
	end
end

function m:ExportTables()
	for _, folder in pairs({"Enumeration", "Structure"}) do
		util_system:mkdir(cfg.path.warcraftwiki, folder)
	end
	for _, tbl in pairs(APIDocumentation.tables) do
		local folder = pathlib.join(cfg.path.warcraftwiki, tbl.Type)
		self:ExportFile(tbl, folder)
	end
end

function m:ExportFile(tbl, folder)
	local proper_name = naming:GetWikiPageName(tbl)
	local file
	if tbl.Type == "Function" then
		file = string.format("API %s.txt", proper_name)
	elseif tbl.Type == "Event" then
		file = string.format("%s.txt", proper_name)
	elseif tbl.Type == "Enumeration" then
		file = string.format("Enum.%s.txt", proper_name)
	elseif tbl.Type == "Structure" then
		file = string.format("Structure %s.txt", proper_name)
	end
	if file then
		local path = pathlib.join(folder, file)
		local text = page:GetPageText(tbl)
		util_system:WriteFile(path, text, true)
	end
end

-- Tables: Constants, CallbackType
-- Predicates: Precondition, Secret

return m
