local pathlib = require("path")
local util = require("wowdoc")
local log = require("wowdoc.log")
local github = require("wowdoc.web.github")

local URL = "https://raw.githubusercontent.com/Ketho/BlizzardInterfaceResources/refs/tags/%s/Resources/GlobalAPI.lua"
local BASE_PATH = "Scribunto/API_info/patch/api"

local TAG = "12.0.1"

local FLAVOR = "mainline" ---@type "classic"|"classic_era"|"mainline"
local FULL_PATH = pathlib.join(BASE_PATH, FLAVOR, TAG..".lua")

local function GetCommit(tag)
	local version = github:GetCommitVersion(tag)
	if version then
		return version
	else
		log:failure(string.format("Error %s for %s", version, tag))
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

local function main()
	local github_version = GetCommit(TAG)
	if github_version and pathlib.exists(FULL_PATH) then
		local file_version = GetFileVersion(FULL_PATH)
		if not file_version or file_version ~= github_version then
			log:info(string.format("versions %s and %s don't match; updating...", file_version, github_version))
			util:DownloadFile(URL:format(TAG), FULL_PATH, 1) -- always redownload
			AppendVersion(FULL_PATH, github_version)
		else
			log:info(string.format("version %s of tag %s is up-to-date", file_version, TAG))
		end
	end
end

main()
