local tablelib = require("wowdoc.util.table")
local naming = require("wowdoc.namingway.naming")
local m = {}

function m:FindFunctionTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		local found
		if v.Arguments then
			for _, v2 in pairs(v.Arguments) do
				if naming:GetActualType(v2) == name then
					found = true
				end
			end
		end
		if v.Returns then
			for _, v2 in pairs(v.Returns) do
				if naming:GetActualType(v2) == name then
					found = true
				end
			end
		end
		if found then
			table.insert(t, v)
		end

	end
	return t
end

function m:FindEventTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.events) do
		local found
		if v.Payload then
			for _, v2 in pairs(v.Payload) do
				if naming:GetActualType(v2) == name then
					found = true
				end
			end
		end
		if found then
			table.insert(t, v)
		end
	end
	return t
end

function m:FindTableTypes(name)
	local t = {}
	for _, v in pairs(APIDocumentation.tables) do
		if v.Type == "Structure" then -- enums are not relevant
			local found
			if v.Fields then
				for _, v2 in pairs(v.Fields) do
					if naming:GetActualType(v2) == name then
						found = true
					end
				end
			end
			if found then
				table.insert(t, v)
			end
		end
	end
	return t
end

function m:GetTypeOrigin(type_name, map)
	local locations = tablelib.CombineList(
		self:FindFunctionTypes(type_name),
		self:FindEventTypes(type_name),
		self:FindTableTypes(type_name)
	)
	for _, v in pairs(locations) do
		if v.Type ~= "Structure" then
			local proper_name = naming:GetProperName(v)
			map[proper_name] = v
		else
			self:GetTypeOrigin(v.Name, map)
		end
	end
end

return m
