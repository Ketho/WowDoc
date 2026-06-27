local pathlib = require("path")
local loader = require("wowdoc.loader")
local system = require("wowdoc.util.system")
local table_sort = require("wowdoc.util.table_sort")
local naming_version = require("wowdoc.namingway.version")
local m = {}

local PATH_FRAMEXML = "FrameXML"
system:mkdir(PATH_FRAMEXML)
for _, v in pairs({"live", "classic", "classic_era"}) do
	system:mkdir(PATH_FRAMEXML, v)
end

---@alias FrameXmlArchiveBranch
---|"live"
---|"classic"
---|"classic_era"

---@param branch FrameXmlArchiveBranch
function m:GetDocArchive(branch)
	local t = {}
	local branch_path = self:GetBranchFolder(branch)
	for _, v in pairs(self:GetPatchFolders(branch_path)) do
		local addons_path = self:FindAddOnsFolder(branch_path, v.version, true)
		if addons_path then
			local docs = loader:LoadDocumentation({path = addons_path, force = true, silent = true})
			table.insert(t, {
				version = v.version,
				docs = docs,
			})
		end
	end
	return t
end

function m:GetBranchFolder(branch)
	return pathlib.join(PATH_FRAMEXML, branch)
end

function m:GetPatchFolders(path)
	local t = {}
	for folder in lfs.dir(path) do
		if not system.RelativePath[folder] and folder ~= "9.2.7 (45161)" then -- empty docs
			local major, minor, patch, build = naming_version:ParseVersion(folder)
			table.insert(t, {
				version = folder,
				major = major,
				minor = minor,
				patch = patch,
				build = build,
			})
		end
	end
	table.sort(t, table_sort.VersionTable)
	return t
end

local function GetSubfolder(parent, name)
	local path = pathlib.join(parent, name)
	if pathlib.exists(path) then
		return path
	end
end

-- for gethe zips
function m:FindAddOnsFolder(branch_path, version, isDoc)
	local semantic = version:match("%d+%.%d+%.%w+")
	local name_tag = string.format("wow-ui-source-%s", semantic)
	local p = pathlib.join(branch_path, version, name_tag)
	p = GetSubfolder(p, "Interface") or p -- from 9.1.0 onwards
	p = GetSubfolder(p, "AddOns") or p
	if not isDoc or GetSubfolder(p, "Blizzard_APIDocumentation") then
		return p
	end
end

return m
