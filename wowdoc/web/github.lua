local https = require("ssl.https")
local ltn12 = require("ltn12")
local cjson = require("cjson")
local system = require("wowdoc.util.system")
local log = require("wowdoc.util.log")

local m = {}

local GITHUB_TOKEN

function m:GitHubHttpsRequest(url)
	-- apparently need to trim newlines or it sometimes returns HTTP 400/403
	GITHUB_TOKEN = GITHUB_TOKEN or system:run_command("gh auth token"):gsub("\n", "")
	local headers = {
		["Authorization"] = string.format("Bearer %s", GITHUB_TOKEN),
		["User-Agent"] = "WowDoc"
	}
	local body = {}
	local _, code = https.request{
		url = url,
		headers = headers,
		sink = ltn12.sink.table(body)
	}
	if code ~= 200 then
		error("HTTP "..code)
	end
	local res = table.concat(body)
	local data = cjson.decode(res)
	return data
end

function m:GetGithubBranch(v)
	local URL_BRANCH = "https://github.com/Gethe/wow-ui-source/archive/refs/heads/%s.zip"
	-- version.txt is included since 11.0.7
	local URL_BRANCH_VERSION = "https://raw.githubusercontent.com/Gethe/wow-ui-source/refs/heads/%s/version.txt"
	local version = https.request(URL_BRANCH_VERSION:format(v))
	return URL_BRANCH:format(v), version
end

function m:GetGithubTag(v)
	local URL_TAG = "https://github.com/Gethe/wow-ui-source/archive/refs/tags/%s.zip"
	local version = self:GetCommitVersion(v)
	if version then
		return URL_TAG:format(v), version
	else
		log.failure(string.format("Error %s for %s", version, v))
	end
end

function m:GetCommitVersion(tag)
	local tag_url = string.format("https://api.github.com/repos/Gethe/wow-ui-source/git/refs/tags/%s", tag)
	local data1 = self:GitHubHttpsRequest(tag_url)

	local commits_url = string.format("https://api.github.com/repos/Gethe/wow-ui-source/git/commits/%s", data1.object.sha)
	local data2 = self:GitHubHttpsRequest(commits_url)

	local version = data2.message
	return version
end

return m
