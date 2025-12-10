---@diagnostic disable: need-check-nil
local lfs = require("lfs")
local pathlib = require("path")

local products = require("wowdoc.products")
local git = require("wowdoc.git")
local enum = require("wowdoc.enum")

local PRODUCT = CONFIG.TACT_PRODUCT ---@type TactProduct

local m = {}
local DocGenerated = pathlib.join("wow-ui-source", "Interface", "AddOns", "Blizzard_APIDocumentationGenerated")
local docTables = {}
local currentFile

local filter = {
	["BarberShopInternalDocumentation.lua"] = true,
}

function m:main(product)
	local framexml_branch, blizzres_branch = products:GetBranch(product)
	git:checkout("https://github.com/Gethe/wow-ui-source", framexml_branch)
	self:HookDocTable()
	enum:LoadLuaEnums(blizzres_branch)
	self:LoadBlizzardDocs()
	local systems = self:GetSystems()
	self:WriteCsv(systems)
	self:WriteModuleData(systems)
	print("Done")
end

function m:HookDocTable()
	APIDocumentation = {}

	---@diagnostic disable-next-line: duplicate-set-field
	function APIDocumentation:AddDocumentationTable(info)
		table.insert(docTables, {
			file = currentFile,
			system = info,
		})
	end
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
			local numFunctions = v.system.Functions and #v.system.Functions
			local numEvents = v.system.Events and #v.system.Events
			if v.system.Type == "System" then
				if not filter[v.file] then
					local line = BuildCsvLine(v.file, v.system.Name, v.system.Namespace, numFunctions, numEvents)
					local data = {
						file = v.file,
						system = v.system.Name,
						namespace = v.system.Namespace,
						numFunctions = numFunctions,
						numEvents = numEvents,
					}
					table.insert(t, {
						line = line,
						data = data,
					})
				end
			end
		end
	end
	table.sort(t, function(a, b)
		return a.line < b.line
	end)
	return t
end

function m:WriteCsv(tbl)
	local filePath = pathlib.join(PATHS.WIKI_CATEGORIES, "systems.csv")
	local file = io.open(filePath, "w")
	file:write("File,Name,Namespace,NumFunctions,NumEvents\n")
	for _, v in pairs(tbl) do
		file:write(v.line.."\n")
	end
	file:close()
end

function m:WriteModuleData(tbl)
	local filePath = pathlib.join(PATHS.WIKI_CATEGORIES, "systems_data.lua")
	local file = io.open(filePath, "w")
	file:write("local data = {\n")
	local fs = '\t%s = {"%s", %s, %d, %d},\n'
	for _, v in pairs(tbl) do
		local data = v.data
		local namespace = data.namespace and string.format('"%s"', data.namespace)
		file:write(fs:format(data.system, data.file, namespace, data.numFunctions, data.numEvents))
	end
	file:write("}\n\nreturn data")
	file:close()
end

m:main(PRODUCT)
