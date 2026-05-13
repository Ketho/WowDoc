-- # systems that have only empty tables

if not APIDocumentation then
	require("wowdoc.loader"):main()
end

local m = {}

local function IsSystemEmpty(tbl)
    for k, v in pairs(tbl) do
        -- ignore documentation table (see Pony)
        if type(v) == "table" and k ~= "Documentation" and next(v) then
            return false
        end
    end
    return true
end

function m:get()
    local t = {}
	for _, systemTbl in pairs(APIDocumentation.systems) do
		if IsSystemEmpty(systemTbl) then
            t[systemTbl.Name] = true
            -- print(systemTbl.Name)
		end
	end
	return t
end
m:get()

-- # all found systems at least have a name
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
