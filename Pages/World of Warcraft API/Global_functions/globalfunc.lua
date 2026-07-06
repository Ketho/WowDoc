local blizres = require("wowdoc.web.blizres.get")
local latest_product = require("wowdoc/products/latest_product")
local m = {}

function m:main()
	local game_type = latest_product.game_type.wow
	local version_tbl = latest_product:GetLatestVersions(game_type)
	local options = {product = version_tbl[1].product}
	local globalapi = blizres:GetResource("GlobalAPI", options)
	for _, v in pairs(globalapi[1]) do
		print(string.format("*{{apilnk|%s}}", v))
	end
end

m:main()
return m
