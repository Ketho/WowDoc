import sys
import pywikibot

site = pywikibot.Site("en", "warcraftwiki")

files = [
	[".wow/scribunto/flavor/API_info.flavor.api.lua", "Module:API_info/flavor/api"],
	[".wow/scribunto/flavor/API_info.flavor.event.lua", "Module:API_info/flavor/event"],

	[".wow/scribunto/elink/API_info.elink.api.lua", "Module:API_info/elink/api"],
	[".wow/scribunto/elink/API_info.elink.event.lua", "Module:API_info/elink/event"],

	[".wow/scribunto/patch/API_info.patch.api_retail.lua", "Module:API_info/patch/api_retail"],
	[".wow/scribunto/patch/API_info.patch.api_classic.lua", "Module:API_info/patch/api_classic"],
	[".wow/scribunto/patch/API_info.patch.api_classic_era.lua", "Module:API_info/patch/api_classic_era"],
	[".wow/scribunto/patch/API_info.patch.event_retail.lua", "Module:API_info/patch/event_retail"],
	[".wow/scribunto/patch/API_info.patch.event_classic.lua", "Module:API_info/patch/event_classic"],

	[".wow/scribunto/systems/systems_data.lua", "Module:API_info/systems/metadata"],
	[".wow/scribunto/systems/events_systems.lua", "Module:API_info/systems/events"],
	[".wow/scribunto/systems/functions_systems.lua", "Module:API_info/systems/functions"],

	[".wow/scribunto/predicates/API_info.predicates.lua", "Module:API_info/predicates/predicates"],
	[".wow/scribunto/predicates/API_info.SecretArguments.lua", "Module:API_info/predicates/secret_arguments"],
	[".wow/scribunto/predicates/API_info.SecretAspects.lua", "Module:API_info/predicates/secret_aspects"],
]

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)

def saveFile(text, wikipath):
	page = pywikibot.Page(site, wikipath)
	page.text = text
	page.save(summary = sys.argv[1])

def main():
	for v in files:
		text = getFileText(v[0])
		saveFile(text, v[1])
	print("done upload")

if __name__ == "__main__":
	main()
