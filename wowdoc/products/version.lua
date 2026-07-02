local m = {}

function m.ToTable(v)
	local major, minor, patch, build
	if v:find("%(") then
		major, minor, patch, build = v:match("(%d+)%.(%d+)%.(%d+) %((%d+)%)")
	else
		major, minor, patch, build = v:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
	end
	if not major then
		error(string.format("Invalid version format: %s", v))
	end
	local t = {
		major = tonumber(major),
		minor = tonumber(minor),
		patch = tonumber(patch),
		build = tonumber(build),
	}
	return t
end

function m.SortLatest(a, b)
	if a.major ~= b.major then
		return a.major > b.major
	elseif a.minor ~= b.minor then
		return a.minor > b.minor
	elseif a.patch ~= b.patch then
		return a.patch > b.patch
	elseif a.build ~= b.build then
		return a.build > b.build
	end
end

function m.SortOldest(a, b)
	if a.major ~= b.major then
		return a.major < b.major
	elseif a.minor ~= b.minor then
		return a.minor < b.minor
	elseif a.patch ~= b.patch then
		return a.patch < b.patch
	elseif a.build ~= b.build then
		return a.build < b.build
	end
end

return m
