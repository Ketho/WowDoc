local changes_apidoc = require("Projects.changes_apidoc")
local strlib = require("wowdoc.util.string")
local m = {}

local BUILD1 = "12.0.7 (68256)"
local BUILD2 = "12.1.0 (68209)"

local function GetFieldNames(apiTable)
	local t = {}
	for _, v in pairs(apiTable.Fields) do
		t[v.Name] = true
	end
	return t
end

function m:main()
	local docs = changes_apidoc:LoadVersionDocs({BUILD1, BUILD2})
	m:CompareTypes(docs, "Enumerations", "FragmentID")
	m:CompareTypes(docs, "Enumerations", "HousingResult")
	m:CompareTypes(docs, "Structures", "AddPrivateAuraAnchorArgs")
	m:CompareTypes(docs, "Structures", "BNetAccountInfo")
	m:CompareTypes(docs, "Structures", "BNetGameAccountInfo")
	m:CompareTypes(docs, "Structures", "CooldownViewerCooldown")
	m:CompareTypes(docs, "Structures", "HousingDecorInstanceInfo")
	m:CompareTypes(docs, "Structures", "LfgEntryData")
	m:CompareTypes(docs, "Structures", "LfgSearchResultData")
	m:CompareTypes(docs, "Structures", "PlayerChoiceInfo")
	m:CompareTypes(docs, "Structures", "TieredEntranceTierInfo")
	m:CompareTypes(docs, "Structures", "UnitPrivateAuraAnchorInfo")
end

function m:CompareTypes(docs, group, name)
	print("\n-- "..name)
	local a = GetFieldNames(docs[1][group][name])
	local b = GetFieldNames(docs[2][group][name])
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

m:main()
