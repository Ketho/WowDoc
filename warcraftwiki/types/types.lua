
-- local TYPEDOC_PATH = "wowdoc.loader.doc.TypeDocumentation"

WarcraftWiki.Types = {}

WarcraftWiki.Types.basic = {
	bool = "boolean",
	number = "number",
	luaIndex = "number",
	string = "string",
	cstring = "string",
	table = "table",
	["function"] = "function",
}

WarcraftWiki.Types.blizzard = {}

-- function WarcraftWiki.Types:LoadTypeDocumentation()
-- 	local data = require(TYPEDOC_PATH)
-- 	local Types = {Tables = data}
-- 	APIDocumentation:AddDocumentationTable(Types)
-- 	self.Types = Types
-- 	for _, v in ipairs(self.Tables) do
-- 		self.blizzardTypes[v.Name] = v
-- 	end
-- end

-- function WarcraftWiki.Types:GetBlizzardType(name)
-- 	if self.Types[name] then
-- 		if self.Types[name].Replace then
-- 			return self.Types[name].Type
-- 		else
-- 			return name
-- 		end
-- 	end
-- end


function WarcraftWiki.Types:GetType(name)
	return name
end

function WarcraftWiki.Types:GetPrettyType(apiTable, isArgument)
	return string.format("{{apitype|%s}}", apiTable.Type)
	-- local apiText
	-- if apiTable.Type == "table" then
	-- 	if apiTable.Mixin then
	-- 		apiText = apiTable.Mixin
	-- 	elseif apiTable.InnerType then
	-- 		if self.blizzardTypes[apiTable.InnerType] then
	-- 			apiText = self:GetBlizzardType(apiTable.InnerType).."[]"
	-- 		else
	-- 			log.failure("Unknown InnerType: "..apiTable.InnerType)
	-- 			apiText = "Unknown"
	-- 		end
	-- 	else
	-- 		apiText = "Unknown"
	-- 	end
	-- elseif self.basicTypes[apiTable.Type] then
	-- 	apiText = self.basicTypes[apiTable.Type]
	-- elseif self.blizzardTypes[apiTable.Type] then
	-- 	apiText = self:GetBlizzardType(apiTable.Type)
	-- else
	-- 	log.failure("Unknown Type: "..apiTable.Type)
	-- 	apiText = "Unknown"
	-- end
	-- -- `Default` implies `Nilable`, even if nilable is false
	-- if apiTable.Nilable or apiTable.Default ~= nil then
	-- 	apiText = apiText.."?"
	-- end
	-- if apiTable.Default ~= nil then
	-- 	apiText = apiText..format("|default=%s", tostring(apiTable.Default))
	-- end
	-- if apiTable.NeverSecret then
	-- 	apiText = apiText.."|secret=NeverSecret"
	-- elseif apiTable.ConditionalSecret then
	-- 	apiText = apiText.."|secret=ConditionalSecret"
	-- end
	-- local str = string.format("{{apitype|%s}}", apiText)
	-- return str
end
