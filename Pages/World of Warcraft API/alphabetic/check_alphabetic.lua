local WikiText = require("Pages/World of Warcraft API/WikiText")

local header1 = {
    ["=API systems="] = true,
    ["=Namespaces="] = true,
    ["=Categories="] = true,
}

local function ParseWikitext(text)
    local headings = {}
    local lastCategory
	for line in string.gmatch(text, "[^\r\n]+") do
        if header1[line] then
            lastCategory = ""
        end
        local category = line:match("^==(%w-)==")
        if category then
            local l_category = category:lower()
            if lastCategory > l_category then
                print(lastCategory, l_category)
            end
            lastCategory = l_category
        end
	end
end

local function main()
	WikiText:SaveExport()
	local text = WikiText:GetWikitext(true)
	ParseWikitext(text)
end

main()
print("done")
