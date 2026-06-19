local table_sort = require("wowdoc.util.table_sort")
local m = {}

function m:PrintWikiTable()
	-- local DOC_TABLES_ARCHIVE = require("warcraftwiki.archive.tables"):main()
	APIDocumentation = {
		AddDocumentationTable = function(_self, tbl)
			_self.data = _self.data or {}
			table.insert(_self.data, tbl)
		end
	}
	require("wow-ui-source/Interface/AddOns/Blizzard_APIDocumentationGenerated/SecretPredicatesDocumentation")
	local t = {}
	table.insert(t, "! !! Secret !! Description")
	local fs = "|-\n| {{tlydoc|s:%s}} || {{apiname|%s}} || %s"
	for _, v in pairs(APIDocumentation.data[1].Predicates) do
		if v.Type == "Secret" then
			local doc = {}
			-- if DOC_TABLES_ARCHIVE[v.Name] then
			-- 	table.insert(doc, DOC_TABLES_ARCHIVE[v.Name])
			-- end
			if v.Documentation then
				table.insert(doc, table.concat(v.Documentation, "; "))
			end
			table.insert(t, fs:format(v.Name, v.Name, table.concat(doc)))
		end
	end
	for k, v in pairs({"SecretWhenCurveSecret", "SecretWhenNumericFormatterSecret"}) do
		table.insert(t, fs:format(v, v, ""))
	end
	table.sort(t)
	for k, v in pairs(t) do
		print(v)
	end
end
m:PrintWikiTable()

function m:FindSecretPredicates()
	local loader = require("wowdoc.loader")
	loader:LoadDocumentation()
	local t = {}
	for _, apiTable in pairs(APIDocumentation.functions) do
		for k, v in pairs(apiTable) do
			if k:find("^Secret") and not k:find("^SecretArguments") and not k:find("^SecretReturns") then
				t[k] = true
			end
		end
	end
	for _, k in pairs(table_sort.ByKey(t)) do
		print(k)
	end
end	
-- m:FindSecretPredicates()

--- defined in EncounterTimelineDocumentation.lua
-- SecretWhenEncounterEvent

--- missing
-- SecretWhenCurveSecret
-- SecretWhenNumericFormatterSecret

--- unused
-- SecretOnRestrictedMaps
