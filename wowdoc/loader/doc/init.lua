local missing_enum       = require("wowdoc.loader.doc.missing_enums")
local missing_structures = require("wowdoc.loader.doc.missing_structures")
local undoc_types = require("wowdoc.stats.types.undoc_types")
local log = require("wowdoc.util.log")
local strlib = require("wowdoc.util.string")
local m = {}

function m:LoadMissingDocumentation()
	local enums = missing_enum:GetMissingEnumTable()
	APIDocumentation:AddDocumentationTable(enums)
	APIDocumentation:AddDocumentationTable(missing_structures)
end

function m:VerifyMissingTypes()
	local undoc = undoc_types:types_GetUndocTypes()
	if next(undoc) then
		log.failure("Found undocumented types:")
		for k in pairs(undoc) do
			local pretty = strlib.color(k, strlib.style.red)
			print("- "..pretty)
		end
	else
		log.success("No remaining undocumented types found")
	end
end

return m
