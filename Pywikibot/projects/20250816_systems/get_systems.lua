---@diagnostic disable: need-check-nil
local lfs = require("lfs")
local pathlib = require("path")

local products = require("wowdoc.products")
local git = require("wowdoc.git")

local m = {}
local DocGenerated = pathlib.join("wow-ui-source", "Interface", "AddOns", "Blizzard_APIDocumentationGenerated")
local WORK_DIR = pathlib.join("Pywikibot", "projects", "20250816_systems")

local docTables = {}
local currentFile

function m:main(product)
	local framexml_branch, blizzres_branch = products:GetBranch(product)
	git:checkout("https://github.com/Gethe/wow-ui-source", framexml_branch)
	self:SimpleCompat()
	self:LoadBlizzardDocs()
	local systems = self:GetSystems()
	self:WriteCsv(systems)
	print("Done")
end

function m:SimpleCompat()
	APIDocumentation = {}

	---@diagnostic disable-next-line: duplicate-set-field
	function APIDocumentation:AddDocumentationTable(info)
		table.insert(docTables, {
			file = currentFile,
			system = info,
		})
	end

	Enum = {
		CalendarGetEventType = {},
		PlayerCurrencyFlagsDbFlags = {
			InBackpack = 0,
			UnusedInUI = 0,
		},
		LFGRoleMeta = {},
	}

	Constants = {
		PetConsts = {},
		PetConsts_PreWrath = {
			MAX_STABLE_SLOTS = 0,
			NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
		},
		PetConsts_Wrath = {
			MAX_STABLE_SLOTS = 0,
			NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
		},
		PetConsts_PostCata = {
			MAX_STABLE_SLOTS = 0,
			NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
		},
		CharCustomizationConstants = {
			CHAR_CUSTOMIZE_CUSTOM_DISPLAY_OPTION_LAST = 0,
			CHAR_CUSTOMIZE_CUSTOM_DISPLAY_OPTION_FIRST = 0,
		},
	}
end

function m:LoadBlizzardDocs()
	for fileName in lfs.dir(DocGenerated) do
		if fileName:match("%.lua$") then
			currentFile = fileName
			loadfile(pathlib.join(DocGenerated, fileName))()
		end
	end
end

local function BuildCsvLine(...)
	local t = {}
	for i = 1, select("#", ...) do
		table.insert(t, select(i, ...) or "")
	end
	return table.concat(t, ",")
end

function m:GetSystems()
	local t = {}
	for _, v in pairs(docTables) do
		if v.system.Name then
			if v.system.Type == "System" then
				local line = BuildCsvLine(v.file, v.system.Name, v.system.Namespace)
				table.insert(t, line)
			end
		end
	end
	table.sort(t)
	return t
end

function m:WriteCsv(tbl)
	local filePath = pathlib.join(WORK_DIR, "systems.csv")
	local file = io.open(filePath, "w")
	file:write("File,Name,Namespace\n")
	for _, line in pairs(tbl) do
		file:write(line.."\n")
	end
	file:close()
end

m:main("wow") ---@type TactProduct
