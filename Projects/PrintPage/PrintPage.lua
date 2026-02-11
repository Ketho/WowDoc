local wowdocloader = require("wowdoc.loader")
wowdocloader:main(CONFIG.TACT_PRODUCT)

require("Documenter.Wowpedia")
local TestPages = require("Documenter.Tests.Pages")

TestPages.TestTable("TooltipDataLineType")
