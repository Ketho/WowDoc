
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

local function GetTypeText(apiTable)
	local t = {}
	if apiTable.Type == "table" and apiTable.InnerType then
		table.insert(t, apiTable.InnerType)
	else
		table.insert(t, apiTable.Type)
	end
	if apiTable.InnerType then
		table.insert(t, "[]")
	end
	-- Default implies Nilable, even if nilable is false
	if apiTable.Nilable or apiTable.Default ~= nil then
		table.insert(t, "?")
	end
	return table.concat(t, "")
end

function WarcraftWiki.Types:GetTypeTemplate(apiTable)
	local t = {}
	table.insert(t, "apitype")
	table.insert(t, GetTypeText(apiTable))
	if apiTable.Default ~= nil then
		local default = string.format("default=%s", tostring(apiTable.Default))
		table.insert(t, default)
	end
	if apiTable.NeverSecret then
		table.insert(t, "secret=NeverSecret")
	elseif apiTable.ConditionalSecret then
		table.insert(t, "secret=ConditionalSecret")
	end
	return string.format("{{%s}}", table.concat(t, "|"))
end
