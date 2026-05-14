-- systems with only a namespace and no name -> empty set

if not APIDocumentation then
	require("wowdoc.loader"):LoadDocumentation()
end

local m = {}

local function OnlyNamespace()
	local t = {}
	for _, v in pairs(APIDocumentation.systems) do
		if v.Namespace and not v.Name then
			t[v.Namespace] = true
			print(v.Namespace)
		end
	end
	return t
end

function m:test()
	local tbl = OnlyNamespace()
	if not next(tbl) then
		print("there are no systems with a namespace and no name")
	end
end
m:test()

return m
