---@diagnostic disable: need-check-nil
local pathlib = require("path")
local serpent = require("serpent")
local loader = require("wowdoc.loader")
local naming = require("wowdoc.namingway.naming")
local cfg = require("wowdoc.config")
local m = {}

function m:main()
	loader:LoadDocumentation()
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
		local name = naming:GetProperName(v)
		t[v.System.Name] = t[v.System.Name] or {}
		table.insert(t[v.System.Name], name)
	end
	local path = pathlib.join(cfg.path.scribunto_systems, "functions_systems.lua")
	WriteScribuntoData(path, t)
end

function m:GetEventList()
	local t = {}
	for _, v in pairs(APIDocumentation.events) do
		t[v.System.Name] = t[v.System.Name] or {}
		table.insert(t[v.System.Name], v.LiteralName)
	end
	local path = pathlib.join(cfg.path.scribunto_systems, "events_systems.lua")
	WriteScribuntoData(path, t)
end

m:main()
