local pathlib = require("path")
local cfg = require("wowdoc.config")
local loader = require("wowdoc.loader")
local csv_write = require("wowdoc.util.csv_write")

local m = {}

function m:main()
	loader:LoadDocumentation()
	local t = {}
	for _, system in pairs(APIDocumentation.systems) do
		if system.Namespace then
			table.insert(t, {system.Namespace, system.Name})
		end
	end
	local header = {"Namespace", "Name"}
	local path = pathlib.join(cfg.path.scribunto_namespaces, "namespaces.csv")
	csv_write.main(path, t, header)
end

m:main()
return m
