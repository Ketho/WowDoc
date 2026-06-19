local loader = require("wowdoc.loader")
local dl = require("wowdoc.web.download")
local strlib = require("wowdoc.util.string")
local tablelib = require("wowdoc.util.table")
local table_sort = require("wowdoc.util.table_sort")
local products = require("wowdoc.products.branches")
local cfg = require("wowdoc.config")
local WikiText = require("Pages/World of Warcraft API/WikiText")
local blizres = require("wowdoc.web.blizres.get")
local m = {}

function m:ParseWikitext(wikitext)
	local api_names, tag_data = {}, {}
	for line in string.gmatch(wikitext, "[^\r\n]+") do
		local name = line:match(": %[%[API (.-)|")
		local tag = line:match("{{apitag|(.-)}}")
		table.insert(api_names, name) -- allow finding duplicates
		if name and tag then
			tag_data[name] = tag
		end
	end
	return api_names, tag_data
end

function m:FindDuplicates(wowpedia)
	print("-- duplicates")
	local t = {}
	for _, v in pairs(wowpedia) do
		if t[v] then
			print(v)
		else
			t[v] = true
		end
	end
end

local ignoredTags = {
	deprecated = true,
	framexml = true,
}

function m:HasIgnoredTag(str)
	local tags = strlib.strsplit(str, ", ")
	for _, tag in pairs(tags) do
		if ignoredTags[tag] then
			return true
		end
	end
end

function m:FindMissing(wowpedia, wowpedia_tags, global_api)
	local signatures_parse = require("Pages.World of Warcraft API.signatures.parse")
	local signatures = signatures_parse:GetSignatures()
	local map = tablelib.ToMap(wowpedia)
	print("\n-- to add")
	for _, k in pairs(table_sort.ByKey(global_api)) do
		if not map[k] then
			if signatures[k] then
				print(string.format(": %s", signatures[k]))
			else
				print(string.format(": [[API %s|%s]]()", k, k))
			end
		end
	end
	print("\n-- to remove")
	table.sort(wowpedia)
	for _, k in pairs(wowpedia) do
		local hasIgnoredTag = wowpedia_tags[k] and self:HasIgnoredTag(wowpedia_tags[k])
		if not global_api[k] and not hasIgnoredTag then
			print(k)
		end
	end
end

function m:main()
	loader:LoadDocumentation()
	WikiText:SaveExport()
	local text = WikiText:GetWikitext(true)
	local api, tags = m:ParseWikitext(text)
	m:FindDuplicates(api)
	local global_api = blizres:GetResource("GlobalAPI")
	local global_api_map = tablelib.ToMap(global_api[1])
	m:FindMissing(api, tags, global_api_map)
	print("done")
end
m:main()
