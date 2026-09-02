local m = {
	pathlib = require("path"),
	gumbo = require("gumbo"),
	config = require("wowdoc.config"),
	strlib = require("wowdoc.util.string"),
	system = require("wowdoc.util.system"),
	xml = require("wowdoc.util.xml"),
	download = require("wowdoc.web.download"),
	request = require("wowdoc.web.request"),
}
local p = {}

local export_url = "https://warcraft.wiki.gg/wiki/Special:Export"

-- actually supposed to use mediawiki api
-- returns the page names for a category
local function get_cat_names(catname)
	local fileName = string.format("%s.html", catname)
	local path = m.pathlib.join(m.config.path.wiki_exportlua, fileName)
	local form = string.format("catname=%s&addcat=Add", catname)
	local res = m.download:DownloadFilePost(export_url, path, form, true)
	local document = m.gumbo.parseFile(path)
	local text = document:getElementById("ooui-php-2").childNodes[1].data
	local names = m.strlib.strsplit(text, "\n")
	table.sort(names)
	return names
end

-- downloads the given pages to xml, and then reads it
local function get_pages(fileBase, names)
	local fileName = string.format("%s.xml", fileBase)
	local path = m.pathlib.join(m.config.path.wiki_exportlua, fileName)
	local form = string.format("pages=%s&curonly=1", names)
	m.download:DownloadFilePost(export_url, path, form, 60)
	local pages = m.xml:ReadXmlFile(path, true)
	return pages
end

function p:GetCategory(catName)
	m.system:mkdir(m.config.path.wiki_exportlua)
	local names = get_cat_names(catName)
	local pages = get_pages(catName, table.concat(names, "\n"))
	return pages
end

-- requests a single page without caching
function p:GetPage(pageName)
	local form = string.format("pages=%s&curonly=1", pageName)
	local body = m.request.HttpsPostRequest(export_url, form)
	local text = m.xml:ReadXmlString(body)
	return text
end

return p
