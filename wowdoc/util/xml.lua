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

function p:ReadXmlString(xmlstr, multiple)
	local handler = m.xmlhandler:new()
	local parser = m.xml2lua.parser(handler)
	parser:parse(xmlstr)
	if multiple then
		local t = {}
		for _, v in pairs(handler.root.mediawiki.page) do
			local text = GetPageText(v)
			table.insert(t, text)
		end
		return t
	else
		local text = GetPageText(handler.root.mediawiki.page)
		return text
	end
end

function p:ReadXmlFile(path, multiple)
	local xmlstr = m.xml2lua.loadFile(path)
	local text = self:ReadXmlString(xmlstr, multiple)
	return text
end

return p
