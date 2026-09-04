local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.config")
local blizres = require("wowdoc.web.blizres.get")
local m_branches = require("wowdoc.products.branches")
local m_latest_product = require("wowdoc.products.latest_product")
local naming = require("wowdoc.namingway.scriptobjects")
local m = {}

---@alias ResourceType
---|"CVars"
---|"Events"
---|"Frames"
---|"FrameXML"
---|"GlobalAPI"
---|"LuaEnum"
---|"Mixins"
---|"Templates"
---|"Widgets

local function CopyTableTrue(t, tbl)
	for k in pairs(tbl) do
		t[k] = true
	end
end

local function CopyTableTemplate(t, tbl)
	for k, v in pairs(tbl) do
		t[k] = v.type
	end
end

local function CopyTableCVar(t, tbl)
	for k, v in pairs(tbl) do
		t[k] = v
	end
end

---@type table<ResourceType, function>
local ToMap = {
	CVars = function(tbl)
		local t = {}
		CopyTableCVar(t, tbl[1].var)
		-- CopyTableCVar(t, tbl[1].command)
		CopyTableCVar(t, tbl[2].var)
		-- CopyTableCVar(t, tbl[2].command)
		return t
	end,
	Events = function(tbl)
		local t = {}
		for _, system in pairs(tbl) do
			for _, event in pairs(system) do
				t[event] = true
			end
		end
		return t
	end,
	Frames = function(tbl, options)
		if options.combine_frames then
			return tablelib.ToMap(table.unpack(tbl)) -- include loadondemand
		else
			return tablelib.ToMap(tbl[1])
		end
	end,
	FrameXML = function(tbl, options)
		if options.combine_framexml then
			return tablelib.ToMap(table.unpack(tbl)) -- include loadondemand
		else
			return tablelib.ToMap(tbl[1])
		end
	end,
	GlobalAPI = function(tbl, options)
		if options.combine_globalapi then
			return tablelib.ToMap(table.unpack(tbl)) -- include lua api
		else
			return tablelib.ToMap(tbl[1])
		end
	end,
	LuaEnum = function()
		local t = {}
		CopyTableTrue(t, Enum)
		return t
	end,
	Mixins = function(tbl)
		return tablelib.ToMap(tbl)
	end,
	Templates = function(tbl)
		local t = {}
		CopyTableTemplate(t, tbl)
		return t
	end,
	WidgetAPI = function(tbl)
		local t = {}
		for widget, v in pairs(tbl) do
			for _, method in pairs(v.methods) do
				local name = string.format("%s:%s", widget, method)
				t[name] = true
			end
		end
		return t
	end,
	ScriptObjectAPI = function(tbl)
		local t = {}
		for scriptobject, v in pairs(tbl) do
			short_name = naming:shorten(scriptobject)
			for _, method in pairs(v) do
				local name = string.format("%s:%s", short_name, method)
				t[name] = true
			end
		end
		return t
	end,
}

local function GetLatestBranches()
	local products = m_latest_product:GetLatestProducts()
	local t = {
		m_branches.product_gethe[products.wow.product],
		m_branches.product_gethe[products.wow_classic.product],
		m_branches.product_gethe[products.wow_anniversary.product],
		m_branches.product_gethe[products.wow_classic_era.product],
	}
	return t
end

local function GetBranchMap(branches, resource, options)
	local map = {}
	for _, branch in pairs(branches) do
		local data = blizres:GetResource(resource, {branch = branch})
		map[branch] = ToMap[resource](data, options)
	end
	return map
end

local function GetUnifiedTable(tbl)
	local t = {}
	for _, branch in pairs(tbl) do
		for k, v in pairs(branch) do
			t[k] = v
		end
	end
	return t
end

local function GetBitFlags(unified, branches, map)
	local t = {}
	for k in pairs(unified) do
		for idx, name in pairs(branches) do
			if map[name][k] then
				t[k] = (t[k] or 0) | 1 << idx-1
			end
		end
	end
	return t
end

---@param resource ResourceType
function m:main(resource, options)
	options = options or {}
	local gethe_branches = GetLatestBranches()
	local map = GetBranchMap(gethe_branches, resource, options)
	local unified = GetUnifiedTable(map)
	local bitflags = GetBitFlags(unified, gethe_branches, map)
	return bitflags, unified
end

return m
