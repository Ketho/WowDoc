local cfg = require("wowdoc.loader.config")
local loader = require("wowdoc.loader")
loader:LoadDocumentation(cfg.TACT_PRODUCT)

local wcw = require("warcraftwiki")
wcw:main()

local exporter = require("warcraftwiki.Eexporter")
exporter:ExportSystems(cfg.path.WARCRAFTWIKI)
