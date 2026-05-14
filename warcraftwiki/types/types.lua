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
