local changes_apidoc = require("Projects.changes_apidoc")
local strlib = require("wowdoc.util.string")
local m = {}

local BUILD1 = "12.0.5 (67602)"
local BUILD2 = "12.0.7 (67669)"

local function GetEnumNames(apiTable)
	local t = {}
	for _, v in pairs(apiTable.Fields) do
		t[v.Name] = true
	end
	return t
end

function m:main(versions, name)
	local docs = changes_apidoc:LoadVersionDocs(versions)
	local a = GetEnumNames(docs[1].Enumerations[name])
	local b = GetEnumNames(docs[2].Enumerations[name])
	for k in pairs(a) do
		if not b[k] then
			print(string.format(strlib.color("- %s", strlib.style.red), k))
		end
	end
	for k in pairs(b) do
		if not a[k] then
			print(string.format(strlib.color("+ %s", strlib.style.green), k))
		end
	end
end

m:main({BUILD1, BUILD2}, "FragmentID")
