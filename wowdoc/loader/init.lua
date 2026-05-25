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
function m:LoadDocumentation(options)
	options = options or {}
	options.product = options.product or cfg.TACT_PRODUCT
	options.branch = options.branch or products:GetBranch(options.product)
	if options.force then
		APIDocumentation = nil
	end
	if APIDocumentation then
		log.warn(string.format("wowdoc: [product %s, branch %s] APIDocumentation already loaded", options.product, options.branch))
		return
	else
		if options.path then
			color_path = strlib.color(options.path, strlib.style.green)
			log.info(string.format("wowdoc: [path %s]", color_path))
		else
			local color_product = strlib.color(options.product, strlib.style.clear_green)
			local color_branch = strlib.color(options.branch, strlib.style.clear_blue)
			log.info(string.format("wowdoc: [product %s, branch %s] Loading APIDocumentation", color_product, color_branch))
		end
	end
	-- compat code
	require(COMPAT_PATH)
	enum:LoadEnumTable(options)
	if not options.path then
		options.path = ADDONS_PATH
		git:checkout("https://github.com/Gethe/wow-ui-source", options.branch)
	end
	if not options.plain then
		self:LoadAddOn(options.path, "Blizzard_APIDocumentation")
	else -- plain docs for easier comparing
		APIDocumentation = {
			AddDocumentationTable = function(_self, apiTable)
				table.insert(APIDocumentation.systemTables, apiTable)
			end,
			systemTables = {},
		}
	end
	-- Blizzard_APIDocumentationGenerated was added in 10.x but we still need to support older versions
	local generated = pathlib.join(options.path, "Blizzard_APIDocumentationGenerated")
	if pathlib.exists(generated) then
		self:LoadAddOn(options.path, "Blizzard_APIDocumentationGenerated")
	end
	-- missing tables
	if options.missing then
		doc:VerifyMissingTypes()
		doc:LoadMissingDocumentation()
	end
	-- APIDocumentation:OutputStats()
	return APIDocumentation
end

-- parses the TOC file of an addon
function m:LoadAddOn(framexml_path, addon_name)
	local addon_path = pathlib.join(framexml_path, addon_name)
	local toc_path = pathlib.join(addon_path, addon_name..".toc")
	local toc_file = system:OpenFile(toc_path)
	for line in toc_file:lines() do
		local lua_filename = line:match(".-%.lua") -- avoid matching the newline
		if lua_filename then
			system:RunFile(pathlib.join(addon_path, lua_filename))
		end
	end
	toc_file:close()
end

return m
