-- compares framexml versions
local pathlib = require("path")
local table_sort = require("wowdoc.util.table_sort")
local log = require("wowdoc.util.log")
local cfg = require("wowdoc.config")
local loader = require("wowdoc.loader")
local products = require("wowdoc.products.branches")

local FRAMEXML_PATH = pathlib.join("FrameXML", "live")

local BUILD1 = "12.0.1 (66838)"
local BUILD2 = "12.0.5 (67602)"

ChangeDiff = {}
require("Projects.ChangeDiff.Compare")
local table_diff = require("wowdoc.util.table_compare")
local m = ChangeDiff
local PrintView = require("Projects.ChangeDiff.PrintView")

m.apiTypes = {
	Function = {
		map = function(v)
			local t = {}
			for _, apiTable in pairs(v.functions or {}) do
				if apiTable.System.Namespace then
					local fullName = string.format("%s.%s", apiTable.System.Namespace, apiTable.Name)
					t[fullName] = apiTable
				else
					t[apiTable.Name] = apiTable
				end
			end
			return t
		end,
		params = {"Arguments", "Returns"},
	},
	Event = {
		map = function(v)
			local t = {}
			for _, apiTable in pairs(v.events or {}) do
				t[apiTable.LiteralName] = apiTable
			end
			return t
		end,
		params = {"Payload"},
	},
	Enumeration = {
		map = function(v)
			local t = {}
			for _, apiTable in pairs(v.tables or {}) do
				if apiTable.Type == "Enumeration" then
					t[apiTable.Name] = apiTable
				end
			end
			return t
		end,
		params = {"Fields"},
	},
	Structure = {
		map = function(v)
			local t = {}
			for _, apiTable in pairs(v.tables or {}) do
				if apiTable.Type == "Structure" then
					t[apiTable.Name] = apiTable
				end
			end
			return t
		end,
		params = {"Fields"},
	},
}
m.apiType_order = {"Function", "Event", "Enumeration", "Structure"}

function m:LoadFrameXML(versions)
	local t = {}
	for _, version in pairs(versions) do
		local patch = version:match("%d+%.%d+%.%d+")
		local path = pathlib.join(FRAMEXML_PATH, version, "wow-ui-source-"..patch, "Interface", "AddOns")
		t[version] = {}
		APIDocumentation = nil
		local docs = loader:LoadDocumentation({path = path})
		for apiType, apiTable in pairs(self.apiTypes) do
			local map = apiTable.map(docs)
			t[version][apiType] = map
		end
	end
	return t
end

local function CompareVersions(versions, framexml)
	local ver_a, ver_b = table.unpack(versions)
	log.info(string.format("Comparing %s to %s ", ver_a, ver_b))
	local frame_a = framexml[ver_a]
	local frame_b = framexml[ver_b]
	local changes = {}
	local file = io.open(pathlib.join(cfg.path.change_wiki, "changes.txt"), "w")
	for _, v in pairs(m.apiType_order) do
		-- print("== "..v.." ==")
		file:write("== "..v.." ==\n")
		local changes = table_diff.print_table_diff(frame_a[v], frame_b[v])
		table.sort(changes["(root)"])
		-- changes["(root)"] = nil -- not currently interested in root level changes
		for _, k in pairs(table_sort.SortTable(changes)) do
			local v = changes[k]
			for k2, v2 in pairs(v) do
				-- print(v2)
				file:write(v2.."\n")
			end
		end
		file:write("\n")
	end
	file:close()
end

local function main(versions, isWiki)
	local framexml = m:LoadFrameXML(versions)
	CompareVersions(versions, framexml)
end

local function main2(versions, isWiki)
	local framexml = m:LoadFrameXML(versions)
	local changes = m:CompareVersions(versions, framexml)
	PrintView:PrintView(changes, isWiki)
end

main2({BUILD1, BUILD2}, true)
log.success("Done")
