import pywikibot

site = pywikibot.Site("en", "warcraftwiki")
page = pywikibot.Page(site, "Struct EncounterTimelineTrackInfo")

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)

page.text = getFileText(".wow/documenter/struct/Struct EncounterTimelineTrackInfo.txt")
page.save(summary = "12.0.0 (65028)")
