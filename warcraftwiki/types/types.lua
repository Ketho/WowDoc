-- local TYPEDOC_PATH = "wowdoc.loader.doc.TypeDocumentation"

WarcraftWiki.basicTypes = {
	bool = "boolean",
	number = "number",
	luaIndex = "number",
	string = "string",
	cstring = "string",
	table = "table",
	["function"] = "function",
}

WarcraftWiki.blizzardTypes = {}

function WarcraftWiki:InitTypeDocumentation()
	for _, v in ipairs(TypeDocumentation.Tables) do
		self.blizzardTypes[v.Name] = v
	end
end

-- function m:LoadTypeDocumentation()
-- 	local data = require(TYPEDOC_PATH)
-- 	local Types = {Tables = data}
-- 	APIDocumentation:AddDocumentationTable(Types)
-- 	TypeDocumentation = Types
-- end
