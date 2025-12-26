import sys
import pywikibot

site = pywikibot.Site("en", "warcraftwiki")

files = [
	[".wow/scribunto/API_info.flavor.api.lua", "Module:API_info/flavor/api"],
	[".wow/scribunto/API_info.flavor.event.lua", "Module:API_info/flavor/event"],

	[".wow/scribunto/API_info.elink.api.lua", "Module:API_info/elink/api"],
	[".wow/scribunto/API_info.elink.event.lua", "Module:API_info/elink/event"],

	[".wow/scribunto/API_info.patch.api_retail.lua", "Module:API_info/patch/api_retail"],
	[".wow/scribunto/API_info.patch.api_classic.lua", "Module:API_info/patch/api_classic"],
	[".wow/scribunto/API_info.patch.api_classic_era.lua", "Module:API_info/patch/api_classic_era"],
	[".wow/scribunto/API_info.patch.event_retail.lua", "Module:API_info/patch/event_retail"],
	[".wow/scribunto/API_info.patch.event_classic.lua", "Module:API_info/patch/event_classic"],

	[".wow/wiki_categories/systems_data.lua", "Module:API_info/systems/metadata"],
	[".wow/wiki_categories/events_systems.lua", "Module:API_info/systems/events"],
	[".wow/wiki_categories/functions_systems.lua", "Module:API_info/systems/functions"],

	[".wow/predicates/API_info.predicates.lua", "Module:API_info/predicates/predicates"],
	[".wow/predicates/API_info.SecretArguments.lua", "Module:API_info/predicates/secret_arguments"],
	[".wow/predicates/API_info.SecretAspects.lua", "Module:API_info/predicates/secret_aspects"],
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
