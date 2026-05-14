-- systems that have only empty tables
local m = {}

if not APIDocumentation then
	require("wowdoc.loader"):LoadDocumentation()
end

local function IsSystemEmpty(tbl)
	for k, v in pairs(tbl) do
		-- ignore documentation table (see Pony)
		if type(v) == "table" and k ~= "Documentation" and next(v) then
			return false
		end
	end
	return true
end

-- constraint it with it having at least a namespace
-- for easier comparison with namespace names instead of system names
local function SystemHasFunctions(tbl)
	return tbl.Namespace and next(tbl.Functions) -- no need to guard against missing Functions table
end

function m:get()
	local t = {
		isEmpty = {},
		hasFunctions = {},
	}
	for _, systemTbl in pairs(APIDocumentation.systems) do
		if IsSystemEmpty(systemTbl) then
			t.isEmpty[systemTbl.Name] = true
			-- print(systemTbl.Name)
		end
		if SystemHasFunctions(systemTbl) then
			t.hasFunctions[systemTbl.Namespace] = true
		end
	end
	return t
end
m:get()

-- # all found systems at least have a name; some dont have a namespace, like the scriptobject ones
-- AccessibilityOptions
-- CursorUtil
-- FrameAPIArchaeologyDigSiteFrame
-- PingPinFrameAPI
-- Pony
-- SimpleAnimScaleLineAPI
-- SimpleAnimTranslationLineAPI
-- SimpleMaskTextureAPI
-- TraitConfig

return m
