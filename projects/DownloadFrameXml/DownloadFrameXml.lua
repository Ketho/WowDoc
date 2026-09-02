local pathlib = require("path")
local https = require("ssl.https")
local cjson = require("cjson")
local ltn12 = require("ltn12")
local system = require("wowdoc.util.system")
local dl = require("wowdoc.web.download")
local github = require("wowdoc.web.github")
local log = require("wowdoc.util.log")
local tags = require("wowdoc.products.tags")
local cfg = require("wowdoc.config")
local wago = require("wowdoc.web.wago")
local products = require("wowdoc.products.branches")
local m = {}

---@type GetheBranch[]
local branches = {
	"live",
	"classic",
	"classic_era",
}

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
	dl:DownloadFile(url, zipFile)
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

function m:main(_tag)
	pathlib.mkdir(pathlib.join("FrameXML", "zips"))
	for _, v in pairs(branches) do
		pathlib.mkdir(pathlib.join("FrameXML", v))
	end
	if _tag then
		local folder_name = products.product_branch[cfg.TACT_PRODUCT]
		DownLoadUnpack(_tag, folder_name)
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

local _, release = wago:GetLatestBuild(cfg.TACT_PRODUCT)
m:main(release)
-- main()
