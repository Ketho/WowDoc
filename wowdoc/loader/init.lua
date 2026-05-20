local pathlib  = require("path")
local strlib   = require("wowdoc.util.string")
local system   = require("wowdoc.util.system")
local log      = require("wowdoc.util.log")
local cfg      = require("wowdoc.config")
local doc      = require("wowdoc.loader.doc")
local products = require("wowdoc.products.branches")
local git      = require("wowdoc.web.git")
local enum     = require("wowdoc.web.blizres.enum")
local m = {}

local COMPAT_PATH = pathlib.join("wowdoc", "loader", "compat")
local ADDONS_PATH = pathlib.join("wow-ui-source", "Interface", "AddOns")

-- loads the blizzard addons from the git checkout
function m:LoadDocumentation(product, options)
	product = product or cfg.TACT_PRODUCT
	options = options or {}
	local branch = products:GetBranch(product)
	if APIDocumentation then
		log.warn(string.format("wowdoc: [product %s, branch %s] APIDocumentation already loaded", product, branch))
		return
	else
		local color_product = strlib.color(product, strlib.style.clear_green)
		local color_branch = strlib.color(branch, strlib.style.clear_blue)
		log.info(string.format("wowdoc: [product %s, branch %s] Loading APIDocumentation", color_product, color_branch))
	end
	git:checkout("https://github.com/Gethe/wow-ui-source", branch)
	-- compat code
	require(COMPAT_PATH)
	enum:LoadEnumTable(branch)
	-- load blizzard addons
	self:LoadAddOn(ADDONS_PATH, "Blizzard_APIDocumentation")
	self:LoadAddOn(ADDONS_PATH, "Blizzard_APIDocumentationGenerated")
	-- missing tables
	if options.getMissingDocs then
		doc:VerifyMissingTypes()
		doc:LoadMissingDocumentation()
	end
	-- APIDocumentation:OutputStats()
end

-- parses the TOC file of an addon
function m:LoadAddOn(framexml_path, addon_name)
	local addon_path = pathlib.join(framexml_path, addon_name)
	local toc_path   = pathlib.join(addon_path, addon_name..".toc")
	local toc_file = system:OpenFile(toc_path)
	for line in toc_file:lines() do
		local lua_filename = line:match(".-%.lua") -- avoid matching the newline
		if lua_filename then
			dofile(pathlib.join(addon_path, lua_filename))
		end
	end
	toc_file:close()
end

return m
