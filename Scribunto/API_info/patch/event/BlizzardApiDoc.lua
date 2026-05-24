local lfs = require("lfs")
local pathlib = require("path")
local system = require("wowdoc.util.system")
local table_sort = require("wowdoc.util.table_sort")
local log = require("wowdoc.util.log")
local loader = require("wowdoc.loader")

local function GetEventMap(data)
	local t = {}
	for _, event in pairs(data.events) do
		t[event.LiteralName] = true
	end
	return t
end

local function GetSubfolder(parent, name)
	local path = pathlib.join(parent, name)
	if pathlib.exists(path) then
		return path
	end
end

-- folder structure can vary
-- changed to read unzipped gethe tags
local function FindApiDocFolder(path)
	-- log.debug(string.format("FindApiDocFolder: %s", path))
	local major = path:match("(%d+%.%d+%.%w+)")
	local name_tag = string.format("wow-ui-source-%s", major)
	local p = pathlib.join(path, name_tag)
	p = GetSubfolder(p, "Interface") or p
	p = GetSubfolder(p, "AddOns") or p
	local apidoc = GetSubfolder(p, "Blizzard_APIDocumentation")
	if apidoc then
		return p
	end
end

local m = {}

function m:GetDocEvents(info)
	local t = {}
	for folder in lfs.dir(info.input) do
		if not system.RelativePath[folder] then
			local path = FindApiDocFolder(pathlib.join(info.input, folder))
			if path then
				local version = folder:match("%d+%.%d+.%d+")
				local build = folder:match("%((%d+)%)$") or folder:match("%d+$")
				-- Blizzard_APIDocumentation did not have events until patch 8.0
				-- 9.2.7 has no Blizzard_APIDocumentationGenerated
				if not version:find("^7%.") and version ~= "9.2.7" then
					APIDocumentation = nil
					loader:LoadDocumentation({path = path, silent = true})
					local apiDocs = APIDocumentation
					APIDocumentation = nil
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
	for _, v in pairs(table_sort.SortTableKV(tbl, SortMajor)) do -- todo: sorting here goes wrong
		local version, data = v.v.version, v.v.events
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
