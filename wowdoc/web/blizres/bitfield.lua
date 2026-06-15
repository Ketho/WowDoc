local pathlib = require("path")
local tablelib = require("wowdoc.util.table")
local dl = require("wowdoc.web.download")
local cfg = require("wowdoc.config")
local blizres = require("wowdoc.web.blizres.get")
local m = {}

---@type GetheBranch[]
local gethe_branches = {
	"live", -- mainline
	"classic", -- mists
	"classic_anniversary", -- bc anniversary
	"classic_era", -- vanilla
}

local ptr_products = {
	wowt = "ptr",
	wowxptr = "ptr2"
}

if ptr_products[cfg.TACT_PRODUCT] then
	gethe_branches[1] = ptr_products[cfg.TACT_PRODUCT]
end

---@alias ResourceType
---|"CVars"
---|"Events"
---|"Frames"
---|"FrameXML"
---|"GlobalAPI"
---|"LuaEnum"
---|"Mixins"
---|"Templates"

local function CopyTableTrue(t, tbl)
	for k in pairs(tbl) do
		t[k] = true
	end
end

---@type table<ResourceType, function>
local ToMap = {
	CVars = function(tbl)
		local t = {}
		CopyTableTrue(t, tbl[1].var)
		CopyTableTrue(t, tbl[1].command)
		CopyTableTrue(t, tbl[2].var)
		CopyTableTrue(t, tbl[2].command)
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
		if options.combine then
			return tablelib.ToMap(table.unpack(tbl)) -- include loadondemand
		else
			return tablelib.ToMap(tbl[1])
		end
	end,
	FrameXML = function(tbl, options)
		if options.combine then
			return tablelib.ToMap(table.unpack(tbl)) -- include loadondemand
		else
			return tablelib.ToMap(tbl[1])
		end
	end,
	GlobalAPI = function(tbl, options)
		if options.combine then
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
		CopyTableTrue(t, tbl)
		return t
	end,
}

local function GetBranchMap(branches, resource, options)
	local map = {}
	for _, branch in pairs(branches) do
		local data = blizres:GetResource(resource, branch)
		map[branch] = ToMap[resource](data, options)
	end
	return map
end

local function GetUnifiedTable(tbl)
	local t = {}
	for _, branch in pairs(tbl) do
		for k in pairs(branch) do
			t[k] = true
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
	local map = GetBranchMap(gethe_branches, resource, options)
	local unified = GetUnifiedTable(map)
	local bitflags = GetBitFlags(unified, gethe_branches, map)
	return bitflags
end

return m
