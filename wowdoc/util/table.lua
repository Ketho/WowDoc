local m = {}

function m.count(tbl)
	local n = 0
	for _ in pairs(tbl) do
		n = n + 1
	end
	return n
end

function m.explode(tbl, count)
	local n = 0
    for k, v in pairs(tbl) do
        print(k, v)
		n = n + 1
    end
	if count then
		print(n)
	end
end

function m.CopyTable(tbl)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = v
	end
	return t
end

function m.Wipe(tbl)
	for k in pairs(tbl) do
		tbl[k] = nil
	end
end

--- copies the values of all given tables into a map
---@param ... table
---@return table
function m.ToMap(...)
	local t = {}
	for i = 1, select("#", ...) do
		local tbl = select(i, ...)
		for _, v in pairs(tbl) do
			t[v] = true
		end
	end
	return t
end

function m.ToList(tbl, func)
	local t = {}
	for _, v in pairs(tbl) do
		table.insert(t, v)
	end
	table.sort(t, func)
	return t
end

--- combines all maps into a map
---@vararg table
---@return table
function m.CombineTable(...)
	local t = {}
	for i = 1, select("#", ...) do
		local tbl = select(i, ...)
		for k, v in pairs(tbl) do
			t[k] = true
		end
	end
	return t
end

--- child maps to map
function m.CombineChildMaps(tbl)
	local t = {}
	for _, v in pairs(tbl) do
		for k, v2 in pairs(v) do
			t[k] = v2
		end
	end
	return t
end

--- combines all lists into a lists
---@vararg table
---@return table
function m.CombineList(...)
	local t = {}
	for i = 1, select("#", ...) do
		local tbl = select(i, ...)
		for _, v in pairs(tbl) do
			table.insert(t, v)
		end
	end
	return t
end

function m.tInvert(a)
	local t = {}
	for k, v in pairs(a) do
		t[v] = k
	end
	return t
end

function m.CompareTable(a, b)
	local x, y = 0, 0
    for k in pairs(a) do
        if not b[k] then
            print("not in b", k)
			x = x + 1
        end
    end
    for k in pairs(b) do
        if not a[k] then
            print("not in a", k)
			y = y + 1
        end
    end
	print("count a not in b", x)
	print("count b not in a", y)
end

-- https://stackoverflow.com/a/32660766/1297035
function m.equals(a, b)
	if a == b then return true end
	local type_a, type_b = type(a), type(b)
	if type_a ~= type_b then return false end
	-- at this point they are the same type but not equal
	if type_a ~= "table" then return false end
	-- now we only need to do table comparison
	for k, v in pairs(a) do
		if b[k] == nil or not m.equals(v, b[k]) then return false end
	end
	for k in pairs(b) do
		if a[k] == nil then return false end
	end
	return true
end

-- lazy check if a documented enum is a bitfield
function m.IsBitEnum(apiTbl)
	local t = {}
	for _, v in pairs(apiTbl.Fields) do
		t[v.EnumValue] = true
	end
	if apiTbl.name == "Damageclass" then
		return true
	end
	for i = 1, 3 do
		if not t[2^i] then
			return false
		end
	end
	if t[3] or t[5] or t[7] then
		return false
	end
	return true
end

return m
