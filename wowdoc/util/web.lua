local https = require("ssl.https")
local ltn12 = require("ltn12")
local system = require("wowdoc.util.system")
local log = require("wowdoc.util.log")

local m = {}

local INVALIDATION_TIME = 60*60

--- Downloads a file
---@param url string URL to download from
---@param path string Path to write the file to
---@param isCache? number|boolean If the file should be redownloaded after `INVALIDATION_TIME`
function m:DownloadFile(url, path, isCache)
	if self:ShouldDownload(path, isCache) then
		log:info(string.format('Downloading %s to "%s"', url, path))
		local body = https.request(url)
		system:WriteFile(path, body)
	end
end

--- Downloads and runs a Lua file
---@param url string URL to download from
---@param path string Path to write the file to
---@return ... @ The values returned from the Lua file, if applicable
function m:DownloadAndRun(url, path)
	self:DownloadFile(url, path, true)
	local p = path:gsub("%.lua", "")
	if p:find("%.") then
		return loadfile(path)()
	else
		return require(p)
	end
end

--- Sends a POST request and downloads a file
---@param url string URL to download from
---@param path string Path to write the file to
---@param requestBody string Contents of the request
---@param cacheTime? number|boolean If the file should be redownloaded after `INVALIDATION_TIME`
function m:DownloadFilePost(url, path, requestBody, cacheTime)
	if self:ShouldDownload(path, cacheTime) then
		local body = self:HttpPostRequest(url, requestBody)
		if body then
			system:WriteFile(path, body)
		end
	end
end

function m:ShouldDownload(path, cacheTime)
	local attr = lfs.attributes(path)
	if not attr then
		return true
	elseif cacheTime and os.time() > attr.modification + (type(cacheTime) == "number" and cacheTime or INVALIDATION_TIME) then
		return true
	end
end

-- https://github.com/brunoos/luasec/wiki/LuaSec-1.0.x#httpsrequesturl---body
function m:HttpPostRequest(url, request)
	local response = {}
	local _, code = https.request{
		url = url,
		method = "POST",
		headers = {
			["Content-Length"] = string.len(request),
			["Content-Type"] = "application/x-www-form-urlencoded"
		},
		source = ltn12.source.string(request),
		sink = ltn12.sink.table(response)
	}
	if code == 204 then -- tly no result
		return false
	elseif code ~= 200 then
		error("HTTP error: "..code)
	end
	return table.concat(response)
end

return m
