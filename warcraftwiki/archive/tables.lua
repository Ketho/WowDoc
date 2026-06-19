local framexml = require("warcraftwiki.archive.framexml")
local table_sort = require("wowdoc.util.table_sort")
local naming_version = require("wowdoc.namingway.version")
local m = {}

function m:main()
	if not self.data then
		local archives = framexml:GetDocArchive("live")
		self.data = self:GetFieldAdded(archives)
	end
	return self.data
end

function m:GetFieldAdded(archives)
	local t = {}
	for _, docInfo in pairs(archives) do
		local release = naming_version:GetReleaseVersion(docInfo.version)
		for _, apiTable in pairs(docInfo.docs.tables) do
			if apiTable.Type == "Enumeration" or apiTable.Type == "Structure" then
				if not t[apiTable.Name] then
					t[apiTable.Name] = {}
					for _, field in pairs(apiTable.Fields) do
						t[apiTable.Name][field.Name] = true
					end
				else
					for _, field in pairs(apiTable.Fields) do
						if not t[apiTable.Name][field.Name] then
							t[apiTable.Name][field.Name] = release
						end
					end
				end
			end
		end
		for _, apiTable in pairs(docInfo.docs.systems) do
			if apiTable.Predicates and #apiTable.Predicates > 0 then
				for k, v in pairs(apiTable.Predicates) do
					if not t[v.Name] then
						t[v.Name] = release
					end
				end
			end
		end
	end
	-- for _, k in pairs(table_sort.ByKey(t)) do
	-- 	print(k)
	-- 	for k2, v2 in pairs(t[k]) do
	-- 		if v2 and type(v2) == "string" then
	-- 			print("", v2, k2)
	-- 		end
	-- 	end
	-- end
	return t
end
m:main()
return m
