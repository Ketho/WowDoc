local tablelib = require("wowdoc.util.table")
local cfg = require("wowdoc.config")
local TypeDoc = require("wowdoc.loader.doc.TypeDocumentation")
local MissingDoc = require("wowdoc.loader.doc.MissingDocumentation")
local enum = require("wowdoc.web.blizres.enum")
local get_types = require("wowdoc.analyse.types.get_types")
local m = {}

-- documented types are Structure and Enumeration tables with a Name
function m:GetDocTypes()
	local s = get_types:GetSets()
	return s.table_docs
end

function m:GetUndocTypes()
	local all_types = get_types:GetAllTypes()
	local t = tablelib.CopyTable(all_types)
	local docTypes = self:GetDocTypes()
	for k in pairs(docTypes) do
		t[k] = nil
	end
	enum:LoadEnumTable(cfg.TACT_PRODUCT)
	for k in pairs(Enum) do
		t[k] = nil
	end
	for _, v in pairs(TypeDoc) do
		t[v.Name] = nil
	end
	for _, v in pairs(MissingDoc.Tables) do
		t[v.Name] = nil
	end
	return t
end

return m
