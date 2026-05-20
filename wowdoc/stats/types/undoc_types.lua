local tablelib = require("wowdoc.util.table")
local cfg = require("wowdoc.config")
local missing_structures = require("wowdoc.loader.doc.missing_structures")
local TypeDocumentation = require("wowdoc.loader.doc.TypeDocumentation")
local types_api = require("wowdoc.stats.types.api")
local enum = require("wowdoc.web.blizres.enum")
local get_types = require("wowdoc.stats.types.get_types")
local m = {}

-- documented types are Structure and Enumeration tables with a Name
function m:GetDocTypes()
	local s = get_types:GetSets()
	return s.table_docs
end

function m:types_GetUndocTypes()
	local all_types = get_types:GetAllTypes()
	local t = tablelib.CopyTable(all_types)
	local docTypes = self:GetDocTypes()
	for k in pairs(docTypes) do
		t[k] = nil
	end
	local missing_enums = types_api:GetMissingEnums()
	for k in pairs(missing_enums) do
		t[k] = nil
	end
	for _, v in pairs(missing_structures.Tables) do
		t[v.Name] = nil
	end
	for k, v in pairs(TypeDocumentation) do
		t[v.Name] = nil
	end
	return t
end

return m
