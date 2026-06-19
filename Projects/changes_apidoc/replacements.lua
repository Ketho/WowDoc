local pathlib = require("path")
local cfg = require("wowdoc.config")
local log = require("wowdoc.util.log")

local category
local sections = {}

local function CreateLink(category, name)
	if category == "Functions" then
		return string.format("{{api|t=a|%s}}", name)
	elseif category == "ScriptObjects" then
		return string.format("{{api|t=w|noparens=1|%s}}", name)
	elseif category == "Events" then
		return string.format("{{api|t=e|%s}}", name)
	elseif category == "Enumerations" then
		return string.format("[[Enum.%s]]", name)
	elseif category == "Structures" then
		return string.format("[[Structure %s|%s]]", name, name)
	end
end

local function ReplaceText(s)
	s = s:gsub("<table> ", "")
	s = s:gsub(" = true", "")
	s = s:gsub(" = {}", "")
	s = s:gsub("Arguments%.%[(%d+)%]", "arg%1")
	s = s:gsub("Returns%.%[(%d+)%]", "ret%1")
	s = s:gsub("Payload%.", "")
	s = s:gsub("Fields%.", "")
	s = s:gsub("%[%d+%] = ", "")
	return s
end

local colors = {
	["+"] = "#00b400",
	["-"] = "#ff6767",
	["#"] = "#ecbc2a",
}

local function parseLine(file, line)
	local symbol = line:sub(1, 1)
	if symbol == "=" then
		category = line:match("===(.+)===")
		file:write(string.format("\n===%s===\n", category))
	elseif symbol == "@" then
		local t = {}
		local name = line:match("@ ([%w_%.:]+)")
		local link = CreateLink(category, name)
		table.insert(t, link)
		local parents = line:match(" %- (.+)")
		if parents then
			table.insert(t, string.format(" <small>(%s)</small>", parents))
		end
		file:write(string.format(" %s\n", table.concat(t)))
	elseif symbol == "-" or symbol == "+" or symbol == "#" then
		local change = line:sub(3)
		change = ReplaceText(change)
		file:write(string.format('   %s <font color="%s">%s</font>\n', symbol, colors[symbol], change))
	end
end

local function main()
	local file1 = io.open(pathlib.join(cfg.path.changes_apidoc, "apidoc1.txt"), "r")
	local file2 = io.open(pathlib.join(cfg.path.changes_apidoc, "apidoc2.txt"), "w")
	for line in file1:lines() do
		parseLine(file2, line)
	end
	file1:close()
	file2:close()
	log.success("Done")
end

main()
