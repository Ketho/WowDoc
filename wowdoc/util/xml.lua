local m = {
	xml2lua = require("xml2lua"),
	xmlhandler = require("xmlhandler.tree"),
}
local p = {}

local symbols = {
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&amp;"] = "&",
}

local function ReplaceHtml(text)
	return text:gsub("&.-;", symbols)
end

local function GetPageText(page)
	local text = page.revision.text[1]
	text = ReplaceHtml(text)
	return text
end

function p:ReadXmlString(xmlstr)
	local handler = m.xmlhandler:new()
	local parser = m.xml2lua.parser(handler)
	parser:parse(xmlstr)
	local page = handler.root.mediawiki.page
	if #page > 0 then
		local t = {}
		for _, v in pairs(page) do
			local text = GetPageText(v)
			t[v.title] = text
		end
		return t
	else
		local text = GetPageText(page)
		return text
	end
end

function p:ReadXmlFile(path)
	local xmlstr = m.xml2lua.loadFile(path)
	local text = self:ReadXmlString(xmlstr)
	return text
end

return p
