local m = {
	pathlib = require("path"),
	dl = require("wowdoc.web.download"),
	log = require("wowdoc.util.log"),
	github = require("wowdoc.web.github"),
	wago = require("wowdoc.web.wago"),
	cfg = require("wowdoc.config"),
	products = require("wowdoc.products.branches"),
}
local p = {}

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/refs/tags/%s/Resources/GlobalAPI.lua"
local BASE_PATH = "Scribunto/API_info/patch/api"

local function GetCommit(tag)
	local version = m.github:GetCommitVersion(tag)
	if version then
		return version
	else
		m.log.failure(string.format("Error %s for %s", version, tag))
	end
end

local function GetFileVersion(path)
	local f = io.open(path, "r")
	if f then
		local contents = f:read("a")
		f:close()
		local version = contents:match("-- version: (%d+%.%d+%.%d+ %(%d+%))")
		return version
	end
end

local function AppendVersion(path, version)
	local f = io.open(path, "a")
	if f then
		f:write(string.format("-- version: %s", version))
		f:close()
	end
end

local function ShouldUpdateFile(path, github_version, file_version)
	if not m.pathlib.exists(path) then
		m.log.info(string.format("path %s does not exist", path))
		return true
	end
	if not file_version or file_version ~= github_version then
		m.log.info(string.format("versions %s and %s don't match; updating...", file_version, github_version))
		return true
	else
		m.log.info(string.format("file version %s matches github version %s", file_version, github_version))
		return false
	end
end

function p:main()
	local _, tag = m.wago:GetLatestBuild(m.cfg.TACT_PRODUCT)
	local gametype = m.products.tact_gametype[m.cfg.TACT_PRODUCT]
	local FULL_PATH = m.pathlib.join(BASE_PATH, gametype, tag..".lua")
	local github_version = GetCommit(tag)
	local file_version = GetFileVersion(FULL_PATH)
	if ShouldUpdateFile(FULL_PATH, github_version, file_version) then
		m.dl:DownloadFile(URL:format(tag), FULL_PATH, 1) -- always redownload
		AppendVersion(FULL_PATH, github_version)
	end
end

return p
