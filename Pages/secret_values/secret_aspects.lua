local table_sort = require("wowdoc.util.table_sort")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")
local naming = require("wowdoc.namingway.naming")
local m = {}

DOC_TABLES_ARCHIVE = require("warcraftwiki.archive.tables"):main()

local function GetRevEnum()
	local t = {}
	for k, v in pairs(Enum.SecretAspect) do
		t[v] = k
	end
	return t
end

local function SortName(a, b)
	local a_name = naming:GetProperName(a)
	local b_name = naming:GetProperName(b)
	if a.System.Name ~= b.System.Name then
		return a_name < b_name
	else
		return a.Name < b.Name
	end
end

local function EnumPostCall()
	local t = {
		Attributes     = 0x10a,
		Hierarchy      = 0x10b,
		ObjectDebug    = 0x10c,
		ObjectName     = 0x10d,
		ObjectSecrets  = 0x10e,
		ObjectSecurity = 0x10f,
		ObjectType     = 0x110,
	}
	for k, v in pairs(t) do
		Enum.SecretAspect[k] = v
	end
end

local function GetAspect(t, apiTable, aspect_type)
	if apiTable[aspect_type] then
		for _, aspect in pairs(apiTable[aspect_type]) do
			t[aspect_type][aspect] = t[aspect_type][aspect] or {}
			t[aspect_type][aspect][apiTable] = true
		end
	end
end

function GetAddedPatch(apiTable, field)
	local archive_table = DOC_TABLES_ARCHIVE[apiTable.Name]
	if archive_table then
		local archive_field = DOC_TABLES_ARCHIVE[apiTable.Name][field.Name]
		if type(archive_field) == "string" then
			return archive_field
		end
	end
end

function m:GetAspectsDoc()
	local t = {
		SecretArgumentsAddAspect = {},
		SecretReturnsForAspect = {},
	}
	for _, apiTable in pairs(APIDocumentation.functions) do
		GetAspect(t, apiTable, "SecretArgumentsAddAspect")
		GetAspect(t, apiTable, "SecretReturnsForAspect")
	end
	return t
end

-- this whole thing is kinda ugly
function m:GetAspectsWiki(aspects)
	local revEnum = GetRevEnum()
	local t = {
		SecretArgumentsAddAspect = {},
		SecretReturnsForAspect = {},
	}
	for k, v in pairs(aspects.SecretArgumentsAddAspect) do
		local r = {}
		for _, k2 in pairs(table_sort.ByKey(v, SortName)) do
			table.insert(r, apilink:GetWikiTemplate(k2, {plain = true}))
		end
		t.SecretArgumentsAddAspect[revEnum[k]] = table.concat(r, ", ")
	end
	for k, v in pairs(aspects.SecretReturnsForAspect) do
		local r = {}
		for _, k2 in pairs(table_sort.ByKey(v, SortName)) do
			table.insert(r, apilink:GetWikiTemplate(k2, {plain = true}))
		end
		t.SecretReturnsForAspect[revEnum[k]] = table.concat(r, ", ")
	end
	return t
end

function m:main()
	Enum = nil
	loader:LoadDocumentation({force = true, enum_postcall = EnumPostCall})
	local aspects_doc = self:GetAspectsDoc()
	local aspects_wiki = self:GetAspectsWiki(aspects_doc)
	local secret_aspect_doc = APIDocumentation:FindAPIByName("table", "SecretAspect")
	print("! Value !! Field !! !! SecretArgumentsAddAspect !! SecretReturnsForAspect")
	local fs = "|-\n| %s || {{apiname|%s}} || %s || %s || %s"
	for _, field in pairs(secret_aspect_doc.Fields) do
		local hex = string.format("0x%x", field.EnumValue)
		local patch = GetAddedPatch(secret_aspect_doc, field)
		local patch_template = patch and string.format("{{apiname.added|%s}}", patch) or ""
		local arg = aspects_wiki.SecretArgumentsAddAspect[field.Name] or ""
		local ret = aspects_wiki.SecretReturnsForAspect[field.Name] or ""
		print(fs:format(hex, field.Name, patch_template, arg, ret))
	end
end

m:main()
