local framexml = require("warcraftwiki.archive.framexml")
local table_sort = require("wowdoc.util.table_sort")
local naming_version = require("wowdoc.namingway.version")

local m = {}

function m:main()
	if not self.enum_archive then
		local archives = framexml:GetDocArchive("live")
		-- self:GetEnumFirstAdded(archives)
		self.enum_archive = self:GetEnumFieldAdded(archives)
	end
	return self.enum_archive
end

function m:GetEnumFirstAdded(archives)
	local t = {}
	for _, docInfo in pairs(archives) do
		for _, enum in pairs(docInfo.docs.tables) do
			if enum.Type == "Enumeration" then
				if not t[enum.Name] then
					local major, minor, patch, build = naming_version:ParseVersion(docInfo.version)
					t[enum.Name] = {
						added = {
							version = docInfo.version,
							major = major,
							minor = minor,
							patch = patch,
							build = build,
						},
						enum = enum,
					}
				end
			end
		end
	end
	local sort_enum = function(a, b)
		if a.added.major ~= b.added.major then
			return a.added.major < b.added.major
		elseif a.added.minor ~= b.added.minor then
			return a.added.minor < b.added.minor
		elseif a.added.patch ~= b.added.patch then
			return a.added.patch < b.added.patch
		elseif a.added.build ~= b.added.build then
			return a.added.build < b.added.build
		elseif a.enum.Name ~= b.enum.Name then
			return a.enum.Name < b.enum.Name
		end
	end
	-- for _, v in pairs(table_sort.SortTableValue(t, sort_enum)) do
	-- 	print(v.added.version, v.enum.Name)
	-- end
	return t
end

function m:GetEnumFieldAdded(archives)
	local t = {}
	for _, docInfo in pairs(archives) do
		for _, enum in pairs(docInfo.docs.tables) do
			if enum.Type == "Enumeration" then
				if not t[enum.Name] then
					t[enum.Name] = {}
					for _, field in pairs(enum.Fields) do
						t[enum.Name][field.Name] = true
					end
				else
					for _, field in pairs(enum.Fields) do
						if not t[enum.Name][field.Name] then
							local semantic = naming_version:GetSemanticVersion(docInfo.version)
							t[enum.Name][field.Name] = semantic
						end
					end
				end
			end
		end
	end
	-- for _, k in pairs(table_sort.SortTable(t)) do
	-- 	print(k)
	-- 	for k2, v2 in pairs(t[k]) do
	-- 		if v2 and type(v2) == "string" then
	-- 			print("  ", v2, k2)
	-- 		end
	-- 	end
	-- end
	return t
end

return m
