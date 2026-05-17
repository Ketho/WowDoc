-- systems with only a namespace and no name -> empty set
local m = {}

if not APIDocumentation then
	require("wowdoc.loader"):LoadDocumentation()
end

local function GetOnlyNamespaceSystems()
	local t = {
		namespace_only = {},
		name_only = {},
	}
	for _, v in pairs(APIDocumentation.systems) do
		if v.Namespace and not v.Name then
			t.namespace_only[v.Namespace] = true
		elseif v.Name and not v.Namespace then
			t.name_only[v.Name] = true
		end
	end
	return t
end

function m:test()
	local tbl = GetOnlyNamespaceSystems()
	print("-- systems with a namespace and no name") -- empty set
	for k in pairs(tbl.namespace_only) do
		print(k)
	end
	print("-- systems with a name and no namespace")
	for k in pairs(tbl.name_only) do
		print(k)
	end
end
m:test()

return m
