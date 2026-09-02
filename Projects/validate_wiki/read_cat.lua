local m = {
	export = require("wowdoc.web.wiki.export"),
}

local p = {}

function p:GetCategory(cat)
	local text = m.export:get_api_cat(cat)
end

local categories = {
	"Structures",
	"Enums",
}

function p:main()
	-- print(m.export:get_page("API:C_AccountInfo.GetIDFromBattleNetAccountGUID"))
	for _, cat in pairs(categories) do
		local pages = m.export:get_cat(cat)
		for _, page in pairs(pages) do
			print(page)
		end
	end
	print("done")
end

p:main()
