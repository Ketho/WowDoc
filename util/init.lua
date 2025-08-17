---@diagnostic disable: need-check-nil
local pathlib = require("path")

local m = {}

function m:WriteScribuntoData(path, fileName, func)
	local filePath = pathlib.join(path, fileName)
	local file = io.open(filePath, "w")
	file:write("local data = {\n")
    func(file)
	file:write("}\n\nreturn data")
	file:close()
end

return m
