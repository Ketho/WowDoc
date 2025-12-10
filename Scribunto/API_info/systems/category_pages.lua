-- https://wowpedia.fandom.com/wiki/Category:API_namespaces
local get_framexml = require("wowdoc.loader.get_framexml_path")
local pathlib = require("path")
local util = require("wowdoc")
local m = {}

function m:NonApidocCompat()
	APIDocumentation = {
		AddDocumentationTable = function(_self, documentationInfo)
			self.documentationInfo = documentationInfo -- set current apidoc
		end,
	}

	Enum = {
		SecretAspect = {},
		CalendarGetEventType = {},
		PlayerCurrencyFlagsDbFlags = {
			InBackpack = 0,
			UnusedInUI = 0,
		},
		EditModePresetLayouts = {},
		LFGRoleMeta = {},
	}

	Constants = {
		CharCustomizationConstants = {
			CHAR_CUSTOMIZE_CUSTOM_DISPLAY_OPTION_LAST = 0,
			CHAR_CUSTOMIZE_CUSTOM_DISPLAY_OPTION_FIRST = 0,
		},
		PetConsts_PostCata = {
			MAX_STABLE_SLOTS = 0,
			NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = 0,
		},
		PetConsts = {},
	}
end

-- this is horrible and idek the proper way to load documentation tables anymore
function m:LoadApiDocs()
	local latestLocal = util:GetLatestLocalBuild("live")
	local version = latestLocal:match("(%d+%.%d+%.%d+ %(%d+%))")
	-- print("version", version)
	local framexml = get_framexml:GetFramexmlPath(version)
	local TOC_PATH = pathlib.join(framexml, "Blizzard_APIDocumentationGenerated.toc")
	local TOC_FILE = io.open(TOC_PATH)
	local isDoc
	local t = {}
	table.insert(t, "namespaces = [")
	if TOC_FILE then
		for line in TOC_FILE:lines() do
			if line:find("%.lua") then
				local path = framexml.."/"..line
				local file = assert(loadfile(path))
				file()
				if isDoc then -- write to emmylua
					local doc = self.documentationInfo
					-- print(path, doc.Name, doc.Namespace)
					local s = string.format('\t["%s", %s, %s],', line,
						doc.Name and string.format('"%s"', doc.Name) or "None",
						doc.Namespace and string.format('"%s"', doc.Namespace) or "None")
					table.insert(t, s)
				end
			elseif line == "# Start documentation files here" then
				isDoc = true
			end
		end
		TOC_FILE:close()
	end
	table.insert(t, "]\n")
	return t
end

function m:WritePythonCategories(t)
	local OUT = pathlib.join("Pywikibot/category/namespace.py")
	local f = io.open(OUT, "w")
	if f then
		f:write(table.concat(t, "\n"))
		f:close()
	end
end

local function main()
	m:NonApidocCompat()
	local categories = m:LoadApiDocs()
	m:WritePythonCategories(categories)
	print("done")
end

main()
