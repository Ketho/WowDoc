---@diagnostic disable: need-check-nil
-- https://warcraft.wiki.gg/wiki/Module:API_info/flavor/api
-- https://warcraft.wiki.gg/wiki/Module:API_info/flavor/event
local util = require("wowdoc")
local branch_flags = require("wowdoc.bitflags")

---@type table<ResourceType, table>
local sources = {
	GlobalAPI = {
		out = pathlib.join(PATHS.SCRIBUNTO, "API_info.flavor.api.lua"),
	},
	Events = {
		out = pathlib.join(PATHS.SCRIBUNTO, "API_info.flavor.event.lua"),
	},
}

local function main()
	for source, info in pairs(sources) do
		local data = branch_flags:main(source)
		print("writing", info.out)
		local file = io.open(info.out, "w")
		file:write("-- https://github.com/Ketho/WowDoc/blob/master/Scribunto/API_info/flavor/flavor.lua\n")
		file:write('local data = {\n')
		for _, name in pairs(util:SortTable(data)) do
			local flavors = data[name]
			file:write(string.format('\t["%s"] = 0x%X,\n', name, flavors))
		end
		file:write("}\n\nreturn data\n")
		file:close()
	end
end

main()
