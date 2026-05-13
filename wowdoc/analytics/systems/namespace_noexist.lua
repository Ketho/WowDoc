-- # documented namespaces that dont actually exist

require("wowdoc.utils")

if not APIDocumentation then
	require("wowdoc.loader"):main()
end

local m = {}

local function GetNamespaces()
    for _, v in pairs(APIDocumentation.systems) do
        if v.Namespace then
            print(v.Namespace)
        end
    end
end

function m:get()
    GetNamespaces()
end
m:get()

return m
