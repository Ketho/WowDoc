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
	self:GetTableList()
	print("Done")
end

local function WriteScribuntoData(path, tbl)
	local options = {
		comment = false,
		indent = "\t",
	}
	print("writing", path)
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

function m:GetTableList()
	local t = {}
	for _, v in pairs(APIDocumentation.tables) do
		local systemName
		if v.System then
			systemName = v.System.Name
		else
			systemName = "Systemless"
		end
		t[systemName] = t[systemName] or {}

		local tableName = string.format("%s:%s", v.Type, v.Name)
		table.insert(t[systemName], tableName)
	end
	for _, v in pairs(t) do
		table.sort(v)
	end
	local path = pathlib.join(cfg.path.scribunto_systems, "tables_system.lua")
	WriteScribuntoData(path, t)
end

m:main()
