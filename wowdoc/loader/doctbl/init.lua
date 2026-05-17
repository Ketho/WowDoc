local missing_enum       = require("wowdoc.loader.doctbl.missing_enums")
local missing_structures = require("wowdoc.loader.doctbl.missing_structures")
local m = {}

function m:LoadMissingDocumentation()
	local enums = missing_enum:GetMissingEnums()
	APIDocumentation:AddDocumentationTable(enums)
	APIDocumentation:AddDocumentationTable(missing_structures)
end

return m
