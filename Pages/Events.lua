-- https://warcraft.wiki.gg/wiki/Events
local pathlib = require("path")
local wowdoc = require("wowdoc.loader")

local PRODUCT = "wowxptr" ---@type TactProduct
wowdoc:main(PRODUCT)
local OUTPUT = pathlib.join(PATHS.WIKI_PAGE, "Events.txt")

table.sort(APIDocumentation.systems, function(a, b)
	return a.Name < b.Name
end)

print("writing to", OUTPUT)
local file = io.open(OUTPUT, "w")

for _, system in pairs(APIDocumentation.systems) do
	if system.Events and #system.Events > 0 then
		file:write(format("==%s==\n", system.Name))
		for _, event in pairs(system.Events) do
			local link = format("{{api|t=e|%s}}", event.LiteralName)
			local payload = event:GetPayloadString(false, false)
			if #payload>160 and (event.LiteralName:find("^CHAT_MSG") or event.LiteralName:find("^CHAT_COMBAT_MSG")) then
				payload = "''CHAT_MSG''"
			end
			payload = #payload>0 and format("<small>: %s</small>", payload) or payload
			file:write(format(": %s%s\n", link, payload))
		end
		file:write("\n")
	end
end

file:close()
print("done")
