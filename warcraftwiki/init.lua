local loader = require("wowdoc.loader")
loader:LoadDocumentation(nil, {getMissingDocs = true})

local export = require("warcraftwiki.export")
export:ExportDocumentation()
