local lfs      = require("lfs")
local pathlib  = require("path")
local strlib   = require("wowdoc.util.string")
local system   = require("wowdoc.util.system")
local log      = require("wowdoc.util.log")
local products = require("wowdoc.products.branches")
local git      = require("wowdoc.web.git")
local enum     = require("wowdoc.web.blizres.enum")
local cfg      = require("wowdoc.loader.config")
-- local patches  = require("wowdoc.loader.doc.patches")
local m = {}

local COMPAT_PATH = pathlib.join("wowdoc", "loader", "compat")
local ADDONS_PATH = pathlib.join("wow-ui-source", "Interface", "AddOns")
-- local TYPEDOC_PATH = "wowdoc.loader.doc.TypeDocumentation"

-- loads the blizzard addons from the git checkout
function m:LoadDocumentation(product)
	product = product or cfg.TACT_PRODUCT
	local branch = products:GetBranch(product)
	if APIDocumentation then
		log.warn(string.format("wowdoc: [product %s, branch %s] APIDocumentation already loaded", product, branch))
		return
	else
		local pretty_product = strlib.colorize(product, 32)
		local pretty_branch = strlib.colorize(branch, 32)
		log.info(string.format("wowdoc: [product %s, branch %s] Loading APIDocumentation", pretty_product, pretty_branch))
	end
	git:checkout("https://github.com/Gethe/wow-ui-source", branch)
	-- compat code
	require(COMPAT_PATH)
	enum:LoadEnumTable(branch)
	-- load blizzard addons
	self:LoadAddOn(ADDONS_PATH, "Blizzard_APIDocumentation")
	self:LoadAddOn(ADDONS_PATH, "Blizzard_APIDocumentationGenerated")

	-- self:LoadTypeDocumentation()
	-- self:PrintSystems()
end

-- parses the TOC file of an addon
function m:LoadAddOn(framexml_path, addon_name)
	local addon_path = pathlib.join(framexml_path, addon_name)
	local toc_path   = pathlib.join(addon_path, addon_name..".toc")
	local toc_file = system:OpenFile(toc_path)
	for line in toc_file:lines() do
		local lua_filename = line:match(".-%.lua") -- trim the newline char
		if lua_filename then
			dofile(pathlib.join(addon_path, lua_filename))
		end
	end
	toc_file:close()
end

-- function m:LoadTypeDocumentation()
-- 	local data = require(TYPEDOC_PATH)
-- 	local Types = {Tables = data}
-- 	APIDocumentation:AddDocumentationTable(Types)
-- 	TypeDocumentation = Types
-- end

function m:PrintSystems()
	for k, v in pairs(APIDocumentation.systems) do
		print(k, v.Name)
	end
end

return m
