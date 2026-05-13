-- compares framexml versions
local table_sort = require("wowdoc.util.table_sort")
local log = require("wowdoc.util.log")
local products = require("wowdoc.products")
local enum = require("wowdoc.web.enum")
local pathlib = require("path")

local PRODUCT = CONFIG.TACT_PRODUCT
local branch = products:GetBranch(PRODUCT)
enum:LoadLuaEnums(branch)
local apidoc_nontoc = require("wowdoc.loader.nontoc")

local BUILD1 = "12.0.1 (66838)"
local BUILD2 = "12.0.5 (67186)"

ChangeDiff = {}
require("Projects.ChangeDiff.Compare")
local table_diff = require("wowdoc.util.table_compare")
local m = ChangeDiff
local PrintView = require("Projects.ChangeDiff.PrintView")

m.apiTypes = {
	Function = {
		map = function(tbl)
			local t = {}
			for _, system in pairs(tbl) do
				for _, apiTable in pairs(system.Functions or {}) do
					if system.Namespace then
						local fullName = string.format("%s.%s", system.Namespace, apiTable.Name)
						t[fullName] = apiTable
					else
						t[apiTable.Name] = apiTable
					end
				end
			end
			return t
		end,
		params = {"Arguments", "Returns"},
	},
	Event = {
		map = function(tbl)
			local t = {}
			for _, system in pairs(tbl) do
				for _, apiTable in pairs(system.Events or {}) do
					t[apiTable.LiteralName] = apiTable
				end
			end
			return t
		end,
		params = {"Payload"},
	},
	Enumeration = {
		map = function(tbl)
			local t = {}
			for _, system in pairs(tbl) do
				for _, apiTable in pairs(system.Tables or {}) do
					if apiTable.Type == "Enumeration" then
						t[apiTable.Name] = apiTable
					end
				end
			end
			return t
		end,
		params = {"Fields"},
	},
	Structure = {
		map = function(tbl)
			local t = {}
			for _, system in pairs(tbl) do
				for _, apiTable in pairs(system.Tables or {}) do
					if apiTable.Type == "Structure" then
						t[apiTable.Name] = apiTable
					end
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
		t[version] = {}
		local docs = apidoc_nontoc:LoadBlizzardDocs(version)
		for apiType, apiTable in pairs(self.apiTypes) do
			local map = apiTable.map(docs)
			t[version][apiType] = map
		end
	end
	return t
end

local function CompareVersions(versions, framexml)
	local ver_a, ver_b = table.unpack(versions)
	log:info(string.format("Comparing %s to %s ", ver_a, ver_b))
	local frame_a = framexml[ver_a]
	local frame_b = framexml[ver_b]
	local changes = {}
	local file = io.open(pathlib.join(PATHS.WIKI_DIFF, "changes.txt"), "w")
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
log:success("Done")
