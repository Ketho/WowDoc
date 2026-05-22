local loader = require("wowdoc.loader")
loader:LoadDocumentation({getMissingDocs = true})

local export = require("warcraftwiki.export")
export:ExportDocumentation()
