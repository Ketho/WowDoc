local pathlib = require("path")
local loader = require("wowdoc.loader")
local wowdoc = require("wowdoc")
local util = require("util")

local m = {}
local OUT_DIR = pathlib.join("out", "scribuntu", "systems")
pathlib.mkdir(OUT_DIR)

function m:main(product)
	loader:main(product)
	self:GetFunctionList()
	self:GetEventList()
	print("Done")
end

function m:GetFunctionList()
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		local name = wowdoc:GetFullName(v)
		table.insert(t, {
			name = name,
			system = v.System.Name,
			apiTable = v,
		})
	end
	table.sort(t, function(a, b)
		if a.system ~= b.system then
			return a.system < b.system
		else
			return a.name < b.name
		end
	end)
	util:WriteScribuntoData(OUT_DIR, "functions_systems.lua", function(file)
		for _, v in pairs(t) do
			file:write(string.format('\t["%s"] = "%s",\n', v.name, v.apiTable.System.Name))
		end
	end)
end

function m:GetEventList()
	local t = {}
	for _, v in pairs(APIDocumentation.events) do
		table.insert(t, {
			name = v.LiteralName,
			system = v.System.Name,
			apiTable = v,
		})
	end
	table.sort(t, function(a, b)
		if a.system ~= b.system then
			return a.system < b.system
		else
			return a.name < b.name
		end
	end)
	util:WriteScribuntoData(OUT_DIR, "events_systems.lua", function(file)
		for _, v in pairs(t) do
			file:write(string.format('\t%s = "%s",\n', v.name, v.apiTable.System.Name))
		end
	end)
end

m:main("wow") ---@type TactProduct
