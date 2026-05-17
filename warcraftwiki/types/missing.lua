local log = require("wowdoc.util.log")
local types_api = require("wowdoc.stats.types.api")
--[[
function WarcraftWiki:FindMissingTypes()
	local missingTypes = {}
	for _, field in ipairs(APIDocumentation.fields) do
		local parent = field.Function or field.Event or field.Table
		local typeName = field.InnerType or field.Type
		if not self.basicTypes[typeName] and parent.Type ~= "Enumeration" then
			if not self.blizzardTypes[typeName] and not self.complexTypes[typeName] then
				missingTypes[typeName] = {field=field, parent=parent}
			end
		end
	end
	return missingTypes
end

function WarcraftWiki:PullMissingTypes(missingTypes)
	local missingDocs = {Tables = {}}

	local MissingDocumentation = require("wowdoc.loader.doc.MissingDocumentation")
	local missingStructures = {} -- lookup table
	for _, v in pairs(MissingDocumentation.Tables) do
		missingStructures[v.Name] = v
	end

	for complexType, info in pairs(missingTypes) do
		-- only fetch a type if its missing so as to not overwrite any Blizzard docs if they appear
		if Enum[complexType] then
			log.debug("Fetching missing: Enum."..complexType)
			table.insert(missingDocs.Tables, self:CreateMissingEnum(complexType))
		elseif missingStructures[complexType] then
			log.debug("Fetching missing: struct "..complexType)
			table.insert(missingDocs.Tables, missingStructures[complexType])
		else
			log.debug(string.format("Undocumented type: %s (source: %s - %s)",
				complexType, info.parent.Type, info.parent.Name))
		end
	end
	APIDocumentation:AddDocumentationTable(missingDocs)
end
]]

