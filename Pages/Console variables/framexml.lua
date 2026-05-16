local util = require("wowdoc")
local system = require("wowdoc.util.system")
local wago = require("wowdoc.web.wago")

local framexml_strings = {}

local function ReadFile(path)
	local file = io.open(path, "r")
	local text = file:read("a")
	file:close()
	return text
end

local function GetStrings(path)
	local text = ReadFile(path)
	for s in text:gmatch('"(.-)"') do
		framexml_strings[s:lower()] = true
	end
end

--- Looks through the FrameXML folder and returns
--- the copy of the FrameXML with the highest build number
--- it does not look at the semantic version (major,minor,patch) but only at the build number
---@param flavor "live"|"classic"|"classic_era"
---@return string path
local function GetLatestLocalBuild(flavor)
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
	log.success("util:GetLatestBuild: "..path)
	return path
end

local function main(blizres)
	-- local latestWagoBuild = wago:GetLatestBuild("wow")
	local frameXML = GetLatestLocalBuild("live")
	system:IterateFiles(frameXML, GetStrings)
	local framexml_cvars = {}
	for k in pairs(blizres[1].var) do
		if framexml_strings[k:lower()] then
			framexml_cvars[k] = true
		end
	end
	return framexml_cvars
end

return main
