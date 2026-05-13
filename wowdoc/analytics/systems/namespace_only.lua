-- # systems with only a namespace and no name -> empty set

if not APIDocumentation then
	require("wowdoc.loader"):main()
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

function m:get()
	local t = OnlyNamespace()
	if not next(t) then
		print("there are no systems with a namespace and no name")
	end
	return t
end
m:get()

return m
