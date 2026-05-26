local system = require("wowdoc.util.system")
local log = require("wowdoc.util.log")
local request = require("wowdoc.web.request")
local m = {}

local INVALIDATION_TIME = 60*60

--- Downloads a file
---@param url string URL to download from
---@param path string Path to write the file to
---@param isCache? number|boolean If the file should be redownloaded after `INVALIDATION_TIME`
function m:DownloadFile(url, path, isCache)
	if self:ShouldDownload(path, isCache) then
		log.info(string.format('Downloading %s to "%s"', url, path))
		local body = request.HttpsRequest(url)
		system:WriteFile(path, body, true)
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
		local body = request.HttpsPostRequest(url, requestBody)
		if body then
			system:WriteFile(path, body, true)
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

return m
