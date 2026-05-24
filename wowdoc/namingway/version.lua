local log = require("wowdoc.util.log")
local m = {}

function m:ParseVersion(v)
	local major, minor, patch, build = v:match("^(%d+)%.(%d+)%.(%w+) %((%d+)%)$")
	major = tonumber(major)
	minor = tonumber(minor)
	patch = patch:match("%d+") -- 4.2.0a (14480)
	patch = tonumber(patch)
	build = tonumber(build)
	if not (major and minor and patch and build) then
		log.failure(string.format("namingway.version: Failed to parse version: %s", v))
	end
	return major, minor, patch, build
end

function m:GetSemanticVersion(v)
	local major, minor, patch, build = self:ParseVersion(v)
	return string.format("%d.%d.%d", major, minor, patch)
end

return m
