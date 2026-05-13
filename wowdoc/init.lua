---@diagnostic disable: need-check-nil
local lfs = require("lfs")
local pathlib = require("path")
local table_sort = require("wowdoc.util.table_sort")

require("wowdoc.config")
local wago = require("wowdoc.web.wago")
local log = require("wowdoc.util.log")
local doc_widgets = require("wowdoc.loader.doc_widgets")

local m = {}

-- keep note this is also being called indirectly from the wikiparser
-- with "converted" api tables which dont include the mixins
function m:GetArguments(apiTable)
	local t = {}
	for _, v in pairs(apiTable.Arguments or {}) do
		-- luals varargs need to be annotated with "..."
		if v.StrideIndex then
			table.insert(t, "...")
		else
			table.insert(t, v.Name)
		end
	end
	return table.concat(t, ", ")
end

function m:GetPatchVersion(v)
	return v:match("%d+%.%d+%.%d+")
end


m.PtrVersion = "11.2.7"

function m:GetPatchText(patchData, ID, patch_override)
	local version = self:GetPatchVersion(patchData[ID].patch)
	local text = patch_override and patch_override[version] or version
	if text == self.PtrVersion then
		text = text.." [[File:PTR_client.png|16px|link=]]"
	end
	return text
end

local classicVersions = {
	"^1.13.",
	"^1.14.",
	"^1.15.",
	"^2.5.",
	"^3.4.",
}

function m:IsClassicVersion(v)
	for _, pattern in pairs(classicVersions) do
		if v:find(pattern) then
			return true
		end
	end
	return false
end

local flavorInfo = {
	mainline = {flavor = "mainline", branch = "wow", header = true},
	mainline_beta = {flavor = "mainline", branch = "wow_beta", header = true},
	mainline_ptr = {flavor = "mainline", branch = "wowxptr", header = true},
	vanilla = {flavor = "vanilla", header = true, branch = "wow_classic_era"},
	vanilla_ptr = {flavor = "vanilla", branch = "wow_classic_era_ptr", header = true}, -- has 10.1.5 and 10.0.7 builds
	cata = {flavor = "cata", header = true, branch = "wow_classic"},
	cata_ptr = {flavor = "cata", header = true, branch = "wow_classic_beta"},
	mists_beta = {flavor = "mists", header = true, branch = "wow_classic_beta"},
}

-- accepts an options table or a game flavor
function m:GetFlavorOptions(info)
	local infoType = type(info)
	if infoType == "table" then
		return info
	elseif infoType == "string" then
		local t = flavorInfo[info]
		if t.branch then
			-- need to know what the latest build is when downloading
			t.build = wago:GetWagoVersions(t.branch)[1] -- latest build for a branch
		end
		t.sort = table_sort.SortPatch
		return t
	elseif not info then
		return flavorInfo.mainline
	end
end

return m
