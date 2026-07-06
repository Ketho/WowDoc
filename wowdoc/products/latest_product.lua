local cjson = require("cjson")
local request = require("wowdoc.web.request")
local m_version = require("wowdoc.products.version")
local table_sort = require("wowdoc.util.table_sort")
local log = require("wowdoc.util.log")
local strlib = require("wowdoc.util.string")
local m = {}

local wago_builds_latest_url = "https://wago.tools/api/builds/%s/latest"
m.game_type = {
	wow = {
		"wow",
		"wow_beta",
		"wowt",
		"wowxptr",
	},
	wow_classic = {
		"wow_classic",
		"wow_classic_ptr",
		"wow_classic_beta",
	},
	wow_anniversary = {
		"wow_anniversary",
		"wow_classic_era_ptr", -- seems to be interchanged with classic era
	},
	wow_classic_era = {
		"wow_classic_era",
		-- "wow_classic_era_ptr",
	},
}

function m:GetLatestVersions(products)
	local t = {}
	for _, v in pairs(products) do
		local json = request.HttpsRequest(wago_builds_latest_url:format(v))
		local data = cjson.decode(json)
		local version_tbl = m_version.ToTable(data.version)
		table.insert(t, {
			product = v,
			version = data.version,
			major = version_tbl.major,
			minor = version_tbl.minor,
			patch = version_tbl.patch,
			build = version_tbl.build
		})
	end
	table.sort(t, m_version.SortLatest)
	-- for k, v in pairs(t) do
	-- 	print(v.version, v.product)
	-- end
	return t
end

function m:GetLatestProducts()
	local t = {}
	for k, v in pairs(self.game_type) do
		local versions = self:GetLatestVersions(v)
		t[k] = {
			version = versions[1].version,
			product = versions[1].product
		}
		local color_game_type = strlib.color(k, strlib.style.yellow)
		local color_product = strlib.color(versions[1].product, strlib.style.blue)
		local color_version = strlib.color(versions[1].version, strlib.style.green)
		log.info(string.format("[latest_product] %s, gametype: %s, product %s", color_version, color_game_type, color_product))
	end
	return t
end

return m
