local lfs = require("lfs")
local PATH = require("path")
local util = require("wowdoc")
local apidoc_nontoc = require("wowdoc.loader.nontoc.old")

local function GetEventMap(data)
	local t = {}
	for _, info in pairs(data) do
		if info.Events then
			for _, event in pairs(info.Events) do
				t[event.LiteralName] = true
			end
		end
	end
	return t
end

local function GetSubfolder(parent, name)
	local path = PATH.join(parent, name)
	if PATH.exists(path) then
		return path
	end
end

-- folder structure can vary
-- changed to read unzipped gethe tags
local function FindApiDocFolder(path)
	local major = path:match("(%d+%.%d+%.%w+)")
	local name_tag = string.format("wow-ui-source-%s", major)
	local new_path = pathlib.join(path, name_tag)
	new_path = GetSubfolder(new_path, "Interface") or new_path
	new_path = GetSubfolder(new_path, "AddOns") or new_path
	new_path = GetSubfolder(new_path, "Blizzard_APIDocumentationGenerated") or new_path
	if new_path:find("Blizzard_APIDocumentationGenerated") then
		return new_path
	end
	new_path = GetSubfolder(new_path, "Blizzard_APIDocumentation") or new_path
	if new_path:find("Blizzard_APIDocumentation") then
		return new_path
	end
end

local m = {}

function m:GetDocEvents(info)
	local t = {}
	for folder in lfs.dir(info.input) do
		if not util.RelativePath[folder] then
			local path = FindApiDocFolder(PATH.join(info.input, folder))
			if path then
				local version = folder:match("%d+%.%d+.%d+")
				local build = folder:match("%((%d+)%)$") or folder:match("%d+$")
				-- Blizzard_APIDocumentation did not have events until patch 8.0
				if not version:find("^7%.") then
					local apiDocs = apidoc_nontoc:LoadBlizzardDocs(path)
					-- sort this by version/build later
					t[build] = {
						folder = folder,
						version = version,
						build = build,
						events = GetEventMap(apiDocs),
					}
				end
			end
		end
	end
	return t
end

local function SortMajor(a, b)
	local _a = a.value.folder
	local _b = b.value.folder
	local major_a, minor_a, patch_a, build_a = _a:match("(%d+)%.(%d+)%.(%d+)%s%((%d+)%)")
	local major_b, minor_b, patch_b, build_b = _b:match("(%d+)%.(%d+)%.(%d+)%s%((%d+)%)")
	major_a = tonumber(major_a); major_b = tonumber(major_b)
	minor_a = tonumber(minor_a); minor_b = tonumber(minor_b)
	patch_a = tonumber(patch_a); patch_b = tonumber(patch_b)
	build_a = tonumber(build_a); build_b = tonumber(build_b)
	if major_a ~= major_b then
		return major_a < major_b
	elseif minor_a ~= minor_b then
		return minor_a < minor_b
	elseif patch_a ~= patch_b then
		return patch_a < patch_b
	elseif build_a ~= build_b then
		return build_a < build_b
	end
end

-- apparently this goes through all patches of both classic and retail
function m:GetPatchData(tbl)
	local added, removed = {}, {}
	for _, v in pairs(util:SortTableCustom(tbl, SortMajor)) do -- todo: sorting here goes wrong
		local version, data = v.value.version, v.value.events
		for name in pairs(data) do
			if not added[name] then
				added[name] = version
			end
		end
		for name in pairs(added) do
			if not data[name] and not removed[name] then
				removed[name] = version
			end
		end
	end

	local t = {}
	for name, version in pairs(added) do
		t[name] = t[name] or {}
		if version == "8.0.1" then -- event docs were added in 8.0.1
			t[name][1] = false
		else
			t[name][1] = version
		end
	end
	for name, version in pairs(removed) do
		t[name] = t[name] or {}
		t[name][2] = version
	end
	return t
end

function m:GetData(info)
	local docEvents = self:GetDocEvents(info)
	local patchData = self:GetPatchData(docEvents)
	return patchData
end

function m:main(flavor)
	return self:GetData(flavor)
end

return m
