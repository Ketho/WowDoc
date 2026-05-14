-- mostly vibecoded
local M = {}

local function pathtostring(path)
	if #path == 0 then return "(root)" end
	local parts = {}
	for _, seg in ipairs(path) do
		if type(seg) == "string" and seg:match("^%a[%w_]*$") then
			table.insert(parts, seg)
		else
			if type(seg) == "number" then
				table.insert(parts, "["..tostring(seg).."]")
			else
				table.insert(parts, "["..tostring(seg).."]")
			end
		end
	end
	return table.concat(parts, ".")
end

local function vtostring(v)
	if type(v) == "table" then
		if v.Name then
			return string.format("<table> %s", v.Name)
		elseif #v > 0 then
			local t = {}
			for k, v in pairs(v) do
				table.insert(t, v.Name)
			end
			return string.format("<table> %s", table.concat(t, ", "))
		end
	else
		return tostring(v)
	end
end

local function append_path(path, key)
	local p = {}
	for i = 1, #path do p[i] = path[i] end
	p[#p + 1] = key
	return p
end

local function diff_internal(x, y, path, t)
	path = path or {}
	if x == y then return end
	t = t or {}
	local base = path[1] or "(root)"
	t[base] = t[base] or {}
	local tx, ty = type(x), type(y)
	if tx == "table" and ty == "table" then
		for k, vx in pairs(x) do
			if y[k] == nil then
				table.insert(t[base], string.format("- %s = %s", pathtostring(append_path(path, k)), vtostring(vx)))
			else
				diff_internal(vx, y[k], append_path(path, k), t)
			end
		end
		for k, vy in pairs(y) do
			if x[k] == nil then
				table.insert(t[base], string.format("+ %s = %s", pathtostring(append_path(path, k)), vtostring(vy)))
			end
		end
	else
		table.insert(t[base], string.format("# %s %s -> %s", pathtostring(path), vtostring(x), vtostring(y)))
	end
	return t
end

function M.print_table_diff(a, b)
	return diff_internal(a, b)
end

return M
