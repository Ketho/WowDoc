APIDocumentation = {
	AddDocumentationTable = function(_self, tbl)
		_self.data = _self.data or {}
		table.insert(_self.data, tbl)
	end
}
require("wow-ui-source/Interface/AddOns/Blizzard_APIDocumentationGenerated/SecretPredicatesDocumentation")
local m = {}

function m:PrintWikiTable()
	local t = {}
	table.insert(t, "! Type !! Predicate !! Description")
	local fs = "|-\n| %s || %s || %s"
	for _, v in pairs(APIDocumentation.data[1].Predicates) do
		local name = string.format("{{apiname|%s}}", v.Name)
		local doc = {}
		if v.Documentation then
			table.insert(doc, table.concat(v.Documentation, "; "))
		end
		if v.FailureMode then
			table.insert(doc, string.format('<font color="plum">Failure Mode: %s</font> ', v.FailureMode))
		end
		table.insert(t, fs:format(v.Type, name, table.concat(doc, "<br>")))
	end
	print(table.concat(t, "\n"))
end
-- m:PrintWikiTable()

function m:PrintLuaTable()
	local t = {}
	for _, v in pairs(APIDocumentation.data[1].Predicates) do
		print(string.format('\t%s = "%s",', v.Name, table.concat(v.Documentation or {}, "; ")))
	end
end
m:PrintLuaTable()
