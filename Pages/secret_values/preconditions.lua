DOC_TABLES_ARCHIVE = require("warcraftwiki.archive.tables"):main()
local loader = require("wowdoc.loader")
local m = {}

function m:main()
	loader:LoadDocumentation({force = true})
	print("! !! Precondition !! Failure Mode !! Description")
	local fs = "|-\n| %s || {{apiname|%s}} || %s || %s"
	local t = {}
	for _, system in pairs(APIDocumentation.systems) do
		for _, predicate in pairs(system.Predicates) do
			if predicate.Type == "Precondition" then
				local tly = string.format("{{tlydoc|s:%s}}", predicate.Name)
				local failure_mode = ""
				if predicate.FailureMode then
					failure_mode = string.format('<font color="plum">%s</font>', predicate.FailureMode)
				end
				local doc = {}
				local added = DOC_TABLES_ARCHIVE[predicate.Name]
				if added and added ~= "12.0.5" then
					table.insert(doc, string.format("{{apiname.added|%s}} ", added))
				end
				if predicate.Documentation then
					table.insert(doc, table.concat(predicate.Documentation, "; "))
				end
				table.insert(t, fs:format(tly, predicate.Name, failure_mode, table.concat(doc)))
			end
		end
	end
	table.sort(t)
	for _, line in ipairs(t) do
		print(line)
	end
end
m:main()
