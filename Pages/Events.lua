-- https://warcraft.wiki.gg/wiki/Events
local pathlib = require("path")
local cfg = require("wowdoc.config")
local wowdoc = require("wowdoc.loader")

wowdoc:LoadDocumentation()
local OUTPUT = pathlib.join(cfg.path.wiki, "Events.txt")

table.sort(APIDocumentation.systems, function(a, b)
	return a.Name < b.Name
end)

print("writing to", OUTPUT)
local file = io.open(OUTPUT, "w")

function IsMultiStride(paramTbl)
	for _, param in pairs(paramTbl) do
		if param.StrideIndex and param.StrideIndex >= 2 then
			return true
		end
	end
end

local function GetEventPayload(paramTbl)
	local t = {}
	local multiStride = IsMultiStride(paramTbl)
	for _, param in pairs(paramTbl) do
		local r = {}
		if param.StrideIndex and not multiStride then
			table.insert(r, "...")
		end
		table.insert(r, param.Name)
		table.insert(t, table.concat(r))
	end
	if multiStride then
		table.insert(t, "...")
	end
	return table.concat(t, ", ")
end

for _, system in pairs(APIDocumentation.systems) do
	if system.Events and #system.Events > 0 then
		local systemLink = string.format("{{api.system|%s}}", system.Name)
		file:write(format("==%s==\n", systemLink))
		for _, event in pairs(system.Events) do
			local link = format("{{api|t=e|%s}}", event.LiteralName)
			local payload = ""
			if event.Payload then
				payload = GetEventPayload(event.Payload)
				if #payload>160 and (event.LiteralName:find("^CHAT_MSG") or event.LiteralName:find("^CHAT_COMBAT_MSG")) then
					payload = "''CHAT_MSG''"
				end
				payload = #payload>0 and format("<small>: %s</small>", payload) or payload
			end
			file:write(format(": %s%s\n", link, payload))
		end
		file:write("\n")
	end
end

file:close()
print("done")
