local util = require("wowdoc.util")
local pathlib = require("path")
require("wowdoc.config")

local category
local sections = {}

local function createHyperLink(s)
	return string.format("{{api|%s}}", s)
end

local function replaceText(s)
	s = s:gsub(" = true", "")
	s = s:gsub("<table> ", "")
	s = s:gsub("%.Arguments%.%[(%d+)%]", "arg%1")
	s = s:gsub("%.Returns%.%[(%d+)%]", "ret%1")
	s = s:gsub("%.Arguments", "arg1")
	s = s:gsub("%.Returns", "ret1")
	s = s:gsub("%.(%[%d+%])", "%1")
	s = s:gsub("SimpleFontStringAPI ", "FontString:")
	s = s:gsub("AbbreviateConfigAPI ", "AbbreviateConfig:")
	s = s:gsub("HousingCatalogSearcherAPI ", "HousingCatalogSearcher:")
	s = s:gsub("FrameAPICharacterModelBase ", "PlayerModel:")
	s = s:gsub("FrameAPICooldown ", "Cooldown:")
	s = s:gsub("FrameAPIModelSceneFrameActorBase ", "ModelSceneActorBase:")
	return s
end

local multiline_replace = {
	{
		[[   %- <font color="#ff6767">SecretWhenActionCooldownRestricted</font>
   %+ <font color="#00b400">SecretWhenCooldownsRestricted</font>]],
		'   <font color="#ecbc2a">SecretWhenActionCooldownRestricted -> SecretWhenCooldownsRestricted</font>'
	},
	{
		[[   %- <font color="#ff6767">SecretWhenSpellCooldownRestricted</font>
   %+ <font color="#00b400">SecretWhenCooldownsRestricted</font>]],
		'   # <font color="#ecbc2a">SecretWhenSpellCooldownRestricted -> SecretWhenCooldownsRestricted</font>'
	},
	{
		[[   %- <font color="#ff6767">SecretWhenSpellAuraRestricted</font>
   %+ <font color="#00b400">SecretWhenUnitAuraRestricted</font>]],
		'   # <font color="#ecbc2a">SecretWhenSpellAuraRestricted -> SecretWhenUnitAuraRestricted</font>'
	},
}

local colors = {
	["+"] = "#00b400",
	["-"] = "#ff6767",
	["#"] = "#ecbc2a",
}

local function parseLine(file, line)
	local symbol = line:sub(1, 1)
	if symbol == "=" then
		category = line:match("== (.+) ==")
		if category then
			file:write("\n== "..category.." ==\n")
		end
	elseif symbol == "-" or symbol == "+" or symbol == "#" then
		line = replaceText(line)
		if category == "Function" then
			local name, change = line:sub(3):match("%[(.-)%]%.?(.+)")
			local system
			if name and name:find(" ") then
				system, name = name:match("(%w+) (%w+)")
			end
			local linkname = createHyperLink(name)
			local fullName = system and string.format("%s %s", system, linkname) or linkname
			if not sections[name] then
				sections[name] = true
				file:write(" "..fullName.."\n")
			end
			if colors[symbol] then
				file:write(string.format('   %s <font color="%s">%s</font>\n', symbol, colors[symbol], change))
			end
		elseif category == "Event" then
			local name, change = line:sub(3):match("(.+)%.Payload(.+)")
			if name then
				local linkname = createHyperLink(name)
				if not sections[name] then
					sections[name] = true
					file:write(" "..name.."\n")
				end
				if colors[symbol] then
					file:write(string.format('   %s <font color="%s">%s</font>\n', symbol, colors[symbol], change))
				end
			end
		end
	end
end

local function main()
	local file = io.open(pathlib.join(PATHS.WIKI_DIFF, "changes.txt"), "r")
	local file2 = io.open(pathlib.join(PATHS.WIKI_DIFF, "changes2.txt"), "w")
	for line in file:lines() do
		parseLine(file2, line)
	end
	file:close()
	file2:close()

	local file2 = io.open(pathlib.join(PATHS.WIKI_DIFF, "changes2.txt"), "r")
	local contents = file2:read("a")
	file2:close()

	for _, v in pairs(multiline_replace) do
		contents = contents:gsub(v[1], v[2])
	end
	local file3 = io.open(pathlib.join(PATHS.WIKI_DIFF, "changes3.txt"), "w")
	file3:write(contents)
	file3:close()
end

main()
