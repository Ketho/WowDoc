-- https://warcraft.wiki.gg/wiki/Console_variables/Complete_list
local pathlib = require("path")
local util = require("wowdoc")
local products = require("wowdoc.products")

PRODUCT = "wowxptr" ---@type TactProduct
GETHE_BRANCH, BLIZZRES_BRANCH = products:GetBranch(PRODUCT)
OUTPUT_CVAR = pathlib.join(PATHS.WIKI_PAGE, "Console_variables_cvar.txt")
OUTPUT_COMMAND = pathlib.join(PATHS.WIKI_PAGE, "Console_variables_command.txt")

local m = {}

function m:main()
	local base_folder = pathlib.join("Pages", "Console variables")
	local blizzres_cvars = require(pathlib.join(base_folder, "blizzres"))()
	local framexml_strings = require(pathlib.join(base_folder, "framexml"))(blizzres_cvars)
	local binary_strings = require(pathlib.join(base_folder, "binaries"))(blizzres_cvars)
	self:WriteCVarList(blizzres_cvars[1].var, framexml_strings, binary_strings)
	self:WriteCommandList(blizzres_cvars[1].command)
end

local cvar_enum = {
	[0] = "Debug",
	[1] = "Graphics",
	[2] = "Console",
	[3] = "Combat",
	[4] = "Game",
	[5] = "", -- "Default",
	[6] = "Net",
	[7] = "Sound",
	[8] = "Gm",
	[9] = "Reveal",
	[10] = "None",
}

local long_names = {
	telemetryTargetPackage = true,
	serverAlert = true,
}

local false_positives = {
	AreaTriggers = true, -- 11.2.0 ptr
}

function m:WriteCVarList(blizzres_cvars, framexml_strings, binary_strings)
	print("writing to "..OUTPUT_CVAR)
	local file = io.open(OUTPUT_CVAR, "w")

	file:write('{| class="sortable darktable zebra col2-center col3-center"\n')
	file:write("! !! !! !! Name !! Default !! Category !! Scope !! Description\n")
	local githubLink = "{{framexml_search|t=icon|%s}}"
	local fs = "|-\n| %s || %s || %s || %s\n| %s || %s || %s\n| %s\n"
	for _, cvar in pairs(util:SortTable(blizzres_cvars, util.SortNocase)) do
		local v = blizzres_cvars[cvar]
		local default, category, server, character, secure, desc = table.unpack(v)
		local default_text
		if #default > 0 then
			default_text = string.format("<code>%s</code>", default)
		end
		if #default >= 16 then
			default_text = string.format('<small>%s</small>', default_text)
		end

		if long_names[cvar] then
			default_text = string.format('<span title="%s">...</span>', default)
		end
		local name = string.format("[[CVar %s|%s]]", cvar, cvar)
		desc = desc and desc:gsub("|", "&#124;")
		file:write(fs:format(
			not false_positives[cvar] and binary_strings[cvar] or "",
			framexml_strings[cvar] and githubLink:format(cvar) or "",
			secure and "<span title=secure>🛡️</span>" or "",
			name,
			default_text or "",
			cvar_enum[category],
			server and "Account" or character and "Character" or "",
			desc or ""
		))
	end
	file:close()
end

function m:WriteCommandList(blizzres_commands)
	print("writing to "..OUTPUT_COMMAND)
	local file = io.open(OUTPUT_COMMAND, "w")

	file:write('{| class="sortable darktable zebra col2-center"\n')
	file:write("! Name !! Category !! Description\n")
	local fs = "|-\n| %s\n| %s\n| %s\n"
	for _, command in pairs(util:SortTable(blizzres_commands, util.SortNocase)) do
		local v = blizzres_commands[command]
		local category, desc = table.unpack(v)
		local name = string.format("[[CVar %s|%s]]", command, command)
		file:write(fs:format(
			name,
			cvar_enum[category],
			desc or ""
		))
	end
	file:close()
end

m:main()
print("done")
