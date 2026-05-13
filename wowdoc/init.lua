---@diagnostic disable: need-check-nil
local lfs = require("lfs")
local pathlib = require("path")
local table_sort = require("wowdoc.util.table_sort")

require("wowdoc.config")
local wago = require("wowdoc.web.wago")
local log = require("wowdoc.util.log")
local doc_widgets = require("wowdoc.loader.doc_widgets")

local m = {}

m.PtrVersion = "11.2.7"

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

--- Looks through the FrameXML folder and returns
--- the copy of the FrameXML with the highest build number
--- it does not look at the semantic version (major,minor,patch) but only at the build number
---@param flavor "live"|"classic"|"classic_era"
---@return string path
function m:GetLatestLocalBuild(flavor)
	local folder = pathlib.join("FrameXML", flavor)
	if not lfs.attributes(folder) then
		error("path does not exist: "..folder)
	end
	local t = {}
	for name in lfs.dir(folder) do
		local build = name:match("%((%d+)%)")
		if build then
			table.insert(t, {name = name, build = build})
		end
	end
	table.sort(t, function(a, b)
		return tonumber(a.build) > tonumber(b.build)
	end)
	local path = pathlib.join(folder, t[1].name)
	log:success("util:GetLatestBuild: "..path)
	return path
end

function m:LoadDocumentation(product)
	require("wowdoc.loader"):main(product)
end

function m:GetFullName(apiTable, isWikiLink)
	if isWikiLink then
		local baseName = self:GetBaseName(apiTable, true)
		return baseName
	else
		local baseName = self:GetBaseName(apiTable)
		local arguments = self:GetArguments(apiTable)
		local signature = string.format("%s(%s)", baseName, arguments)
		return signature
	end
end

function m:GetBaseName(apiTable, isWikiLink)
	local baseName
	local system = apiTable.System
	if system.Type == "System" then
		if system.Namespace then
			baseName = string.format("%s.%s", system.Namespace, apiTable.Name)
		else
			baseName = apiTable.Name
		end
	elseif system.Type == "ScriptObject" then
		local widget_system = doc_widgets[system.Name] or system.Name
		local sep = isWikiLink and "_" or ":"
		baseName = string.format("%s%s%s", widget_system, sep, apiTable.Name)
	else
		baseName = apiTable.Name
	end
	return baseName
end

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

function m:ReadCSV(dbc, parser, options, func)
	log:info("Reading "..dbc)
	local csv = parser:ReadCSV(dbc, options)
	local tbl = {}
	for l in csv:lines() do
		local ID = tonumber(l.ID)
		if ID then
			func(tbl, ID, l) -- maybe bad code
		end
	end
	return tbl
end

function m:template_apilink(apitype, apitable)
	local t = {}
	table.insert(t, "{{apilink")
	table.insert(t, "t="..apitype)
	table.insert(t, self:api_func_GetFullName(apitable))
	if apitype == "a" or apitype == "w" then
		if apitable.Arguments and #apitable.Arguments > 0 then
			local r = {}
			for _, v in pairs(apitable.Arguments) do
				table.insert(r, v.Name)
			end
			table.insert(t, "arg="..table.concat(r, ", "))
		end
		if apitable.Returns and #apitable.Returns > 0 then
			local r = {}
			for _, v in pairs(apitable.Returns) do
				table.insert(r, v.Name)
			end
			table.insert(t, "ret="..table.concat(r, ", "))
		end
	elseif apitype == "e" then
		if apitable.payload then
			table.insert(t, "payload="..apitable.payload)
		end
	end
	return table.concat(t, "|").."}}"
end

function m:api_func_GetFullName(v)
	if v.Type == "Function" then
		if v.System.Type == "System" then
			if v.System.Namespace then
				return string.format("%s.%s", v.System.Namespace, v.Name)
			else
				return v.Name
			end
		elseif v.System.Type == "ScriptObject" then
			return string.format("%s:%s", v.System.Name, v.Name)
		end
	end
end

return m
