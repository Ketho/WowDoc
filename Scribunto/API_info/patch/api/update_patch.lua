local pathlib = require("path")
local dl = require("wowdoc.web.download")
local log = require("wowdoc.util.log")
local github = require("wowdoc.web.github")
local wago = require("wowdoc.web.wago")
local cfg = require("wowdoc.config")

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/refs/tags/%s/Resources/GlobalAPI.lua"
local BASE_PATH = "Scribunto/API_info/patch/api"
local FLAVOR = "mainline" ---@type "classic"|"classic_era"|"mainline"

local function GetCommit(tag)
	local version = github:GetCommitVersion(tag)
	if version then
		return version
	else
		log.failure(string.format("Error %s for %s", version, tag))
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
	if not pathlib.exists(path) then
		log.info(string.format("path %s does not exist", path))
		return true
	end
	if not file_version or file_version ~= github_version then
		log.info(string.format("versions %s and %s don't match; updating...", file_version, github_version))
		return true
	else
		log.info(string.format("file version %s matches github version %s", file_version, github_version))
		return false
	end
end

local function main()
	local _, tag = wago:GetLatestBuild(cfg.TACT_PRODUCT)
	local FULL_PATH = pathlib.join(BASE_PATH, FLAVOR, tag..".lua")
	local github_version = GetCommit(tag)
	local file_version = GetFileVersion(FULL_PATH)
	if ShouldUpdateFile(FULL_PATH, github_version, file_version) then
		dl:DownloadFile(URL:format(tag), FULL_PATH, 1) -- always redownload
		AppendVersion(FULL_PATH, github_version)
	end
end

main()
