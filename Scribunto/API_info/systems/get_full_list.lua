---@diagnostic disable: need-check-nil
local pathlib = require("path")
local loader = require("wowdoc.loader")
local wowdoc = require("wowdoc")
local serpent = require("serpent")

local m = {}
local OUT_DIR = pathlib.join(".wow", "api_systems", "systems")
pathlib.mkdir(OUT_DIR)

function m:main(product)
	loader:main(product, nil, true)
	self:GetFunctionList()
	self:GetEventList()
	print("Done")
end

local function WriteScribuntoData(path, tbl)
	local options = {
		comment = false,
		indent = "\t",
	}
	local file = io.open(path, "w")
	file:write("local t = ", serpent.block(tbl, options), "\n\n")
	file:write([[
local r = {}

for system, v in pairs(t) do
	for _, name in pairs(v) do
		r[name] = system
	end
end

return r
]])
	file:close()
end

function m:GetFunctionList()
	local t = {}
	for _, v in pairs(APIDocumentation.functions) do
		local name = wowdoc:api_func_GetFullName(v)
		t[v.System.Name] = t[v.System.Name] or {}
		table.insert(t[v.System.Name], name)
	end
	local path = pathlib.join(OUT_DIR, "functions_systems.lua")
	WriteScribuntoData(path, t)
end

function m:GetEventList()
	local t = {}
	for _, v in pairs(APIDocumentation.events) do
		t[v.System.Name] = t[v.System.Name] or {}
		table.insert(t[v.System.Name], v.LiteralName)
	end
	local path = pathlib.join(OUT_DIR, "events_systems.lua")
	WriteScribuntoData(path, t)
end

m:main(CONFIG.TACT_PRODUCT) ---@type TactProduct
