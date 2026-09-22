local m = {
	pathlib = require("path"),
	system = require("wowdoc.util.system"),
	dl = require("wowdoc.web.download"),
	github = require("wowdoc.web.github"),
	log = require("wowdoc.util.log"),
	tags = require("wowdoc.products.tags"),
	cfg = require("wowdoc.config"),
	wago = require("wowdoc.web.wago"),
	products = require("wowdoc.products.branches"),
}
local p = {}

---@param name string tag name
function p:DownloadZip(name)
	local url, version
	if name:find("%d+%.%d+%.%d+") then
		url, version = m.github:GetGithubTag(name)
	else
		error("No valid tag found")
	end
	local patch, build = self:GetPatchBuild(name, version)
	local fileBaseName = string.format("%s (%s)", patch, build)
	local fileExtName = fileBaseName..".zip"

	local zipFolder = m.pathlib.join("FrameXML", "zips")
	local zipFile = m.pathlib.join(zipFolder, fileExtName)
	m.dl:DownloadFile(url, zipFile)
	return fileBaseName, zipFile
end

function p:GetPatchBuild(name, msg)
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

function p:UnpackZip(branch, fileBaseName, zipFile)
	local gameTypeFolder = m.pathlib.join("FrameXML", branch)
	local unpackFolder = m.pathlib.join(gameTypeFolder, fileBaseName)
	if not m.pathlib.exists(unpackFolder) then
		local command = string.format('unzip "%s" -d "%s"', zipFile, unpackFolder)
		m.system:RunCommand(command)
	end
end

local function DownLoadUnpack(tag, branch)
	local fileBaseName, zipFile = p:DownloadZip(tag)
	p:UnpackZip(branch, fileBaseName, zipFile)
end

function p:main(_tag)
	m.pathlib.mkdir(m.pathlib.join("FrameXML", "zips"))
	for _, v in pairs(m.products.tracked_gametype) do
		m.pathlib.mkdir(m.pathlib.join("FrameXML", v))
	end
	if _tag then
		DownLoadUnpack(_tag, m.cfg.TACT_PRODUCT)
	else
		for _, branch in pairs(m.products.tracked_gametype) do
			m.pathlib.mkdir(m.pathlib.join("FrameXML", branch))
			for _, tag in pairs(m.tags[branch]) do
				DownLoadUnpack(tag, branch)
			end
		end
	end
	m.log.success("Done")
end

local _, release = m.wago:GetLatestBuild(m.cfg.TACT_PRODUCT)
p:main(release)
-- main()
