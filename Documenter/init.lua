local loader = require("wowdoc.loader")
local cfg = require("wowdoc.loader.config")
loader:LoadDocumentation(cfg.TACT_PRODUCT)
require("Documenter.Wowpedia")
--require("Documenter.Tests.Tests")

local Exporter = require("Documenter.Exporter")
Exporter:ExportSystems(cfg.path.DOCUMENTER)
