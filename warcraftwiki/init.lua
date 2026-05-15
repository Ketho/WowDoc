local loader = require("wowdoc.loader")
loader:LoadDocumentation()

local wcw = require("warcraftwiki.page")

local exporter = require("warcraftwiki.exporter")
exporter:ExportSystems()
