-- https://wowpedia.fandom.com/wiki/Module:API_info/patch/event_retail
-- https://wowpedia.fandom.com/wiki/Module:API_info/patch/event_classic
local lfs = require("lfs")
local pathlib = require("path")
local table_write = require("wowdoc.util.table_write")
local enum = require("wowdoc.web.blizres.enum")
local products = require("wowdoc.products.branches")
local cfg = require("wowdoc.config")

local BRANCH = products:GetBranch(cfg.TACT_PRODUCT)
enum:LoadEnumTable({branch = BRANCH})

local flavors = {
	mainline = {
		id = "mainline",
		input = "FrameXML/live",
		out = pathlib.join(cfg.path.scribunto_patch, "API_info.patch.event_retail.lua"),
	},
	classic = {
		id = "classic",
		input = "FrameXML/classic",
		out = pathlib.join(cfg.path.scribunto_patch, "API_info.patch.event_classic.lua"),
	},
}

-- caches the results after scanning
local function GetFrameXmlData(tbl_apidoc)
	local path = "Scribunto/API_info/patch/event/framexml_data.lua"
	local data
	if not lfs.attributes(path) then
		local FrameXML = require("Scribunto/API_info/patch/event/FrameXML")
		data = FrameXML:main(flavors, tbl_apidoc)
		table_write(data, path)
	else
		data = dofile(path)
	end
	return data
end

local function WritePatchData(flavor)
	print("WritePatchData", flavor)
	-- get event patch data from >8.0.1 blizzard api docs
	print("-- reading Blizzard_APIDocumentation", flavor.id)
	local BlizzardApiDoc = require("Scribunto/API_info/patch/event/BlizzardApiDoc")
	local tbl_apidoc = BlizzardApiDoc:main(flavor)
	if flavor.id == "mainline" then
		-- get older event data by looking through framexml
		print("-- reading framexml")
		local tbl_framexml = GetFrameXmlData(tbl_apidoc)
		-- fill in false values
		for k, v in pairs(tbl_framexml) do
			tbl_apidoc[k][1] = v
		end
	end
	table_write(tbl_apidoc, flavor.out)
	local file = io.open(flavor.out, "a+")
	file:write("-- https://github.com/Ketho/WowpediaApiDoc/blob/master/Scribunto/API_info/patch/event/event.lua\n")
	file:close()
end

local function main()
	WritePatchData(flavors.mainline)
	WritePatchData(flavors.classic)
end

main()
