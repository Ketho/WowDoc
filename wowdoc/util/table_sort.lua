local m = {}

function m.SortTable(tbl, func)
	local t = {}
	for k in pairs(tbl) do
		table.insert(t, k)
	end
	table.sort(t, func)
	return t
end

function m.SortTableValue(tbl, func)
	local t = {}
	for k, v in pairs(tbl) do
		table.insert(t, v)
	end
	table.sort(t, func)
	return t
end

function m.SortTableKV(tbl, func)
	local t = {}
	for k, v in pairs(tbl) do
		table.insert(t, {
			k = k,
			v = v
		})
	end
	table.sort(t, func)
	return t
end

function m.SortNocase(a, b)
	return a:lower() < b:lower()
end

function m.SortTableByType(tbl, sortType)
	local t = {}
	for k, v in pairs(tbl) do
		tinsert(t, {
			key = k,
			value = v
		})
	end
	table.sort(t, function(a, b)
		local va, vb = a[sortType], b[sortType]
		local ta, tb = type(va), type(vb)
		if ta ~= tb then
			if ta == "boolean" and tb == "number" then
				return true
			elseif ta == "number" and tb == "boolean" then
				return false
			end
		end
		if ta == "boolean" then
			if va ~= vb then
				return va and not vb
			end
		elseif ta == "string" then
			return va < vb
		elseif ta == "number" then
			if va == vb then
				return a.key < b.key
			else
				return va < vb
			end
        ---@diagnostic disable-next-line: missing-return
		end
	end)
	return t
end

-- useful when using PTR builds and a retail build is higher than a PTR build
-- e.g. PTR 10.1.7.50587 vs retail 10.1.5.50622
function m.SortPatch(a, b)
	local major_a, minor_a, patch_a, build_a = a:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
	local major_b, minor_b, patch_b, build_b = b:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
	major_a = tonumber(major_a); major_b = tonumber(major_b)
	minor_a = tonumber(minor_a); minor_b = tonumber(minor_b)
	patch_a = tonumber(patch_a); patch_b = tonumber(patch_b)
	build_a = tonumber(build_a); build_b = tonumber(build_b)
	if major_a ~= major_b then
		return major_a < major_b
	elseif minor_a ~= minor_b then
		return minor_a < minor_b
	elseif patch_a ~= patch_b then
		return patch_a < patch_b
	elseif build_a ~= build_b then
		return build_a < build_b
	end
end

function m.SortBuild(a, b)
	local build_a = tonumber(a:match("(%d+)$"))
	local build_b = tonumber(b:match("(%d+)$"))
	if build_a ~= build_b then
		return build_a < build_b
	end
end

function m.SortVersionTable(a, b)
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
