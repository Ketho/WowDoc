-- # documented namespaces that dont actually exist

require("wowdoc.utils")

if not APIDocumentation then
	require("wowdoc.loader"):main()
end

local m = {}

local function GetNamespaces()
	local t = {}
	for _, v in pairs(APIDocumentation.systems) do
		if v.Namespace then
			t[v.Namespace] = true
			print(v.Namespace)
		end
	end
	return t
end

function m:get()
	return GetNamespaces()
end
m:get()

return m
