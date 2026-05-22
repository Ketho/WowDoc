--[[
sudo apt update
sudo apt install gh
gh auth login
- set and read the token in `GITHUB_TOKEN`
	- or just assign a variable with the token in `gho_*` format

remember to
- delete `(int)MAX_SUMMONABLE_HUNTER_PETS` from uhh some patch
- delete 9.2.7 apidocs as those dont contain anything
]]

local pathlib = require("path")
local https = require("ssl.https")
local cjson = require("cjson")
local ltn12 = require("ltn12")

local system = require("wowdoc.util.system")
local web = require("wowdoc.web")
local github = require("wowdoc.web.github")
local log = require("wowdoc.util.log")
local products = require("wowdoc.products.branches")
local tags = require("wowdoc.products.tags")

---@type GetheBranch[]
local branches = {
	"live",
	"classic",
	"classic_era",
}

local m = {}

---@param name string tag name
function m:DownloadZip(name)
	local url, version
	if name:find("%d+%.%d+%.%d+") then
		url, version = github:GetGithubTag(name)
	else
		error("No valid tag found")
	end
	local patch, build = self:GetPatchBuild(name, version)
	local fileBaseName = string.format("%s (%s)", patch, build)
	local fileExtName = fileBaseName..".zip"

	local zipFolder = pathlib.join("FrameXML", "zips")
	local zipFile = pathlib.join(zipFolder, fileExtName)
	web:DownloadFile(url, zipFile)
	return fileBaseName, zipFile
end

function m:GetPatchBuild(name, msg)
	-- up to 5.2.0 is in "Build %d" format
	if msg:find("Build") then -- Build 16650
		local build = msg:match("Build (%d+)")
		return name, build
	end
	local patterns = {
		"(%d+%.%d+%.%d+)%.(%d+)",    -- 11.1.7.61967
		"(%d+%.%d+%.%d+) %((%d+)%)", -- 11.1.7 (61967)
	}
	for _, v in pairs(patterns) do
		local patch, build = msg:match(v)
		if patch then
			return patch, build
		end
	end
end

function m:UnpackZip(branch, fileBaseName, zipFile)
	local gameTypeFolder = pathlib.join("FrameXML", branch)
	local unpackFolder = pathlib.join(gameTypeFolder, fileBaseName)
	if not pathlib.exists(unpackFolder) then
		local command = string.format('unzip "%s" -d "%s"', zipFile, unpackFolder)
		system:RunCommand(command)
	end
end

local function DownLoadUnpack(tag, branch)
	local fileBaseName, zipFile = m:DownloadZip(tag)
	m:UnpackZip(branch, fileBaseName, zipFile)
end

local function main(_tag, _branch)
	pathlib.mkdir(pathlib.join("FrameXML", "zips"))
	for _, v in pairs(branches) do
		pathlib.mkdir(pathlib.join("FrameXML", v))
	end
	if _tag then
		DownLoadUnpack(_tag, _branch)
	else
		for _, branch in pairs(branches) do
			pathlib.mkdir(pathlib.join("FrameXML", branch))
			for _, tag in pairs(tags[branch]) do
				DownLoadUnpack(tag, branch)
			end
		end
	end
	log.success("Done")
end

main("12.0.5", "live")
-- main()
