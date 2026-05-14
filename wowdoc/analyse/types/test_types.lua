local u = require("wowdoc.util.table")
local utest = require("wowdoc.util.utest")
local get_types = require("wowdoc.analyse.types.get_types")
local m = {}

local Tests = {
	function()
		-- function, event, table fields == field types
		local name = "set of field types"
		local s = get_types:GetSets()
		local combined_fields = u.CombineTable(
			s.function_types,
			s.event_types,
			s.table_field_types
		)
		-- u.explode(combined_fields)
		u.CompareTable(combined_fields, s.field_types)
		print(u.count(combined_fields), u.count(s.field_types))
		local equals = u.equals(combined_fields, s.field_types)
		print("equals", equals)
		return name, utest.assert_true(equals)
	end,
	function()
		-- all types == table types + field types
		local name = "set of all types"
		local s = get_types:GetSets()
		local all_types_1 = u.CombineTable(
			s.function_types,
			s.event_types,
			s.table_field_types,
			s.table_types,
			s.field_types
		)
		local all_types_2 = u.CombineTable(
			s.table_types,
			s.field_types
		)
		-- u.explode(all_types_2)
		u.CompareTable(all_types_1, all_types_2)
		print(u.count(all_types_1), u.count(all_types_2))
		local equals = u.equals(all_types_1, all_types_2)
		print("equals", equals)
		return name, utest.assert_true(equals)
	end,
}

function m:Run()
    for i, test in pairs(Tests) do
        print("## test "..i)
        print(test())
        print()
    end
end

return m
