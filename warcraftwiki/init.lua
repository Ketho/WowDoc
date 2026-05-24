-- hack for getting archive data first
DOC_TABLES_ARCHIVE = require("warcraftwiki.archive.tables"):main()

local loader = require("wowdoc.loader")
loader:LoadDocumentation({force = true, missing = true})

local export = require("warcraftwiki.export")
export:ExportDocumentation()
