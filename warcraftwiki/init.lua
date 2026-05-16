local loader = require("wowdoc.loader")
loader:LoadDocumentation()

local exporter = require("warcraftwiki.exporter")
exporter:ExportDocumentation()
