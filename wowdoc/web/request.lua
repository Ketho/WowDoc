local https = require("ssl.https")
local ltn12 = require("ltn12")
local m = {}

function m.HttpsRequest(url)
	local res, code, headers, status = https.request(url)
	if code ~= 200 then
		error("HTTP error: "..code)
	end
	return res
end

-- https://github.com/lunarmodules/luasec/wiki/LuaSec-1.3.x#https_request
function m.HttpsPostRequest(url, request)
	local res = {}
	local _, code = https.request{
		url = url,
		method = "POST",
		headers = {
			["Content-Length"] = string.len(request),
			["Content-Type"] = "application/x-www-form-urlencoded"
		},
		source = ltn12.source.string(request),
		sink = ltn12.sink.table(res)
	}
	if code == 204 then -- tly no result
		return false
	elseif code ~= 200 then
		error("HTTP error: "..code)
	end
	return table.concat(res)
end

return m
