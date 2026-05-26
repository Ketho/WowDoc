-- compares Blizzard_APIDocumentation
local pathlib = require("path")
local cfg = require("wowdoc.config")
local loader = require("wowdoc.loader")
local log = require("wowdoc.util.log")
local strlib = require("wowdoc.util.string")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local table_compare = require("wowdoc.util.table_compare")
local scriptobjects = require("wowdoc.namingway.scriptobjects")
local m = {}

local BUILD1 = "12.0.5 (67602)"
local BUILD2 = "12.0.7 (67669)"

local FRAMEXML_PATH = pathlib.join("FrameXML", "live")

local DocGroups = {
	"Functions",
	"ScriptObjects",
	"Events",
	"Enumerations",
	"Structures",
}

function m:main(versions)
	local docs = m:LoadVersionDocs(versions)
	log.info(string.format("Comparing %s to %s", versions[1], versions[2]))
	local file = io.open(pathlib.join(cfg.path.changes_apidoc, "apidoc1.txt"), "w")
	for _, v in pairs(DocGroups) do
		log.info("Comparing "..v)
		file:write(string.format("\n===%s===\n", v))
		self:CompareDocs(file, docs, v)
	end
	file:close()
	log.success("Done")
end

function m:LoadVersionDocs(versions)
	local t = {}
	for _, version in pairs(versions) do
		local release = version:match("%d+%.%d+%.%d+")
		local path = pathlib.join(FRAMEXML_PATH, version, "wow-ui-source-"..release, "Interface", "AddOns")
		local docs = loader:LoadDocumentation({path = path, force = true, plain = true})
		table.insert(t, self:ParsePlainDocs(docs.docTables))
	end
	return t
end

local function GetProperPlainName(systemTable, apiTable)
	if apiTable.Namespace or systemTable.Namespace then
		return string.format("%s.%s", apiTable.Namespace or systemTable.Namespace, apiTable.Name)
	elseif systemTable.Type == "ScriptObject" then
		return string.format("%s:%s", scriptobjects:shorten(systemTable.Name), apiTable.Name)
	else
		return apiTable.Name
	end
end

function m:ParsePlainDocs(docs)
	local t = {}
	for _, v in pairs(DocGroups) do
		t[v] = {}
	end
	for _, systemTable in pairs(docs) do
		if systemTable.Type == "System" then
			for _, apiTable in pairs(systemTable.Functions) do
				local name = GetProperPlainName(systemTable, apiTable)
				t.Functions[name] = apiTable
			end
		elseif systemTable.Type == "ScriptObject" then
			for _, apiTable in pairs(systemTable.Functions) do
				local name = GetProperPlainName(systemTable, apiTable)
				t.ScriptObjects[name] = apiTable
			end
		end
		for _, apiTable in pairs(systemTable.Events or {}) do
			t.Events[apiTable.LiteralName] = apiTable
		end
		for _, apiTable in pairs(systemTable.Tables) do
			if apiTable.Type == "Structure" then
				t.Structures[apiTable.Name] = apiTable
			elseif apiTable.Type == "Enumeration" then
				t.Enumerations[apiTable.Name] = apiTable
			end
		end
	end
	return t
end

function m:CompareDocs(file, docs, group)
	local a, b = docs[1], docs[2]
	for _, k in pairs(table_sort.ByKey(a[group])) do
		if not b[group][k] then
			print(string.format(strlib.color("- %s", strlib.style.red), k))
			-- file:write(string.format("- %s\n", k))
		end
	end
	for _, k in pairs(table_sort.ByKey(b[group])) do
		if not a[group][k] then
			print(string.format(strlib.color("+ %s", strlib.style.green), k))
			-- file:write(string.format("+ %s\n", k))
		end
	end
	for _, k in pairs(table_sort.ByKey(b[group])) do
		local v = b[group][k]
		if a[group][k] and not tablelib.equals(v, a[group][k])then
			print(string.format(strlib.color("@ %s", strlib.style.yellow), k))
			file:write(string.format("@ %s\n", k))
			local changes = table_compare.print_table_diff(a[group][k], v)
			m:PrintChanges(file, changes)
		end
	end
end

function m:PrintChanges(file, changes)
	for _, v in pairs(changes) do
		for _, v2 in pairs(v) do
			print(v2)
			file:write(v2.."\n")
		end
	end
end

m:main({BUILD1, BUILD2})
return m
