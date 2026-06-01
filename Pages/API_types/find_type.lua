local tablelib = require("wowdoc.util.table")
local loader = require("wowdoc.loader")
local apilink = require("wowdoc.namingway.wiki.apilink")

local function FindFunctionTypes(name)
    local t = {}
    for _, v in pairs(APIDocumentation.functions) do
        local found
        if v.Arguments then
            for _, v2 in pairs(v.Arguments) do
                if v2.Type == name then
                    found = true
                end
            end
        end
        if v.Returns then
            for _, v2 in pairs(v.Returns) do
                if v2.Type == name then
                    found = true
                end
            end
        end
        if found then
            table.insert(t, v)
        end

    end
    return t
end

local function FindEventTypes(name)
    local t = {}
    for _, v in pairs(APIDocumentation.events) do
        local found
        if v.Payload then
            for _, v2 in pairs(v.Payload) do
                local actualType = v2.InnerType or v2.Type
                if actualType == name then
                    found = true
                end
            end
        end
        if found then
            table.insert(t, v)
        end
    end
    return t
end

local function FindTableTypes(name)
    local t = {}
    for _, v in pairs(APIDocumentation.tables) do
        local found
        if v.Fields then
            for _, v2 in pairs(v.Fields) do
                local actualType = v2.InnerType or v2.Type
                if actualType == name then
                    found = true
                end
            end
        end
        if found then
            table.insert(t, v)
        end
    end
    return t
end

local function main(name)
    loader:LoadDocumentation()
    local locations = tablelib.CombineList(
        FindFunctionTypes(name),
        FindEventTypes(name),
        FindTableTypes(name)
    )
    table.sort(locations, apilink.SortApiLink)
    for k, v in pairs(locations) do
        print(string.format(": %s", apilink:GetWikiTemplate(v)))
    end
end

main("WOWGUID")
