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

-- only care about functions and events
local function IsSystemIrrelevant(tbl)
	return not next(tbl.Functions) and not next(tbl.Events)
end

-- constrain it with it having at least a namespace
-- for easier comparison with namespace names instead of system names
local function SystemHasFunctions(tbl)
	return tbl.Namespace and next(tbl.Functions) -- no need to guard against missing Functions table
end

function m:get()
	local t = {
		empty = {},
		irrelevant = {},
		hasFunctions = {},
	}
	for _, systemTbl in pairs(APIDocumentation.systems) do
		if IsSystemEmpty(systemTbl) then
			t.empty[systemTbl.Name] = true
			-- print(systemTbl.Name)
		end
		if IsSystemIrrelevant(systemTbl) then
			t.irrelevant[systemTbl.Name] = true
			-- print(systemTbl.Name)
		end
		if SystemHasFunctions(systemTbl) then
			t.hasFunctions[systemTbl.Namespace] = true
			-- print(systemTbl.Namespace)
		end
	end
	return t
end
m:get()

return m

-- # IsSystemEmpty
-- AccessibilityOptions
-- CursorUtil
-- FrameAPIArchaeologyDigSiteFrame
-- PingPinFrameAPI
-- Pony
-- SimpleAnimScaleLineAPI
-- SimpleAnimTranslationLineAPI
-- SimpleMaskTextureAPI
-- TraitConfig

-- # IsSystemIrrelevant
-- AccessibilityOptions
-- BagIndexConstants
-- CursorUtil
-- FrameAPIArchaeologyDigSiteFrame
-- PingPinFrameAPI
-- Platform
-- Pony
-- SimpleAnimScaleLineAPI
-- SimpleAnimTranslationLineAPI
-- SimpleMaskTextureAPI
-- TraitConfig
