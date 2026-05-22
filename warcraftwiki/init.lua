local loader = require("wowdoc.loader")
loader:LoadDocumentation({missing = true})

local export = require("warcraftwiki.export")
export:ExportDocumentation()
