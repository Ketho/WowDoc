local wowdocloader = require("wowdoc.loader")

wowdocloader:main(CONFIG.TACT_PRODUCT)
require("Documenter.Wowpedia")
--require("Documenter.Tests.Tests")

local Exporter = require("Documenter.Exporter")
Exporter:ExportSystems(PATHS.DOCUMENTER)
