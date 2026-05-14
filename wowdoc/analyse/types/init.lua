local m = {}
local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")

function m:main(runTests)
    loader:LoadDocumentation()
	if runTests then
		local test_types = require("wowdoc.analyse.types.test_types")
		test_types:Run()
	end

	-- local get_types = require("wowdoc.analyse.types.get_types")
	-- local all_types = get_types:GetAllTypes()
	-- for _, k in pairs(table_sort.SortTable(all_types)) do
	-- 	print(k)
	-- end

	local get_doc_types = require("wowdoc.analyse.types.undoc_types")
	local undoc_types = get_doc_types:GetUndocTypes()
	if next(undoc_types) then
		print("-- Printing undocumented types:")
		for _, k in pairs(table_sort.SortTable(undoc_types)) do
			print(k)
		end
	else
		print("All types are documented")
	end
end

m:main(true)
return m
