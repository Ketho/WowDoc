import sys
import pywikibot
from pathlib import Path

site = pywikibot.Site("en", "warcraftwiki")
root = Path(".wow")
# SUMMARY = "update predicates"

files = [
	[root / "scribunto" / "gametype" / "function.lua",     "Module:Wowapi/data/gametype/function"],
	[root / "scribunto" / "gametype" / "event.lua",        "Module:Wowapi/data/gametype/event"],
	[root / "scribunto" / "gametype" / "scriptobject.lua", "Module:Wowapi/data/gametype/scriptobject"],
	[root / "scribunto" / "gametype" / "widget.lua",       "Module:Wowapi/data/gametype/widget"],
  
	[root / "scribunto" / "system" / "system.lua",         "Module:Wowapi/data/system"],
	[root / "scribunto" / "system" / "function.lua",       "Module:Wowapi/data/system/function"],
	[root / "scribunto" / "system" / "event.lua",          "Module:Wowapi/data/system/event"],
	[root / "scribunto" / "system" / "table.lua",          "Module:Wowapi/data/system/table"],

	[root / "scribunto" / "patch" / "mainline" / "function.lua", "Module:Wowapi/data/patch/mainline/function"],
	[root / "scribunto" / "patch" / "mainline" / "event.lua",    "Module:Wowapi/data/patch/mainline/event"],

	[root / "scribunto" / "patch" / "bcc" / "function.lua", "Module:Wowapi/data/patch/bcc/function"],

	[root / "scribunto" / "patch" / "classic" / "function.lua", "Module:Wowapi/data/patch/mists/function"],
	[root / "scribunto" / "patch" / "classic" / "event.lua",    "Module:Wowapi/data/patch/mists/event"],

	[root / "scribunto" / "patch" / "vanilla" / "function.lua", "Module:Wowapi/data/patch/vanilla/function"],

	[root / "scribunto" / "predicate" / "function.lua",        "Module:Wowapi/data/predicate/function"],
	[root / "scribunto" / "predicate" / "event.lua",           "Module:Wowapi/data/predicate/event"],
	[root / "scribunto" / "predicate" / "secretargument.lua",  "Module:Wowapi/data/predicate/secretargument"],
	[root / "scribunto" / "predicate" / "secretaspect.lua",    "Module:Wowapi/data/predicate/secretaspect"],
	[root / "scribunto" / "predicate" / "forbiddenaspect.lua", "Module:Wowapi/data/predicate/forbiddenaspect"],
]

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)

def saveFile(text, wikipath):
	page = pywikibot.Page(site, wikipath)
	# only update the data section
	end_marker = "-- <END DATA>"
	end_index = page.text.find(end_marker)
	if end_index != -1:
		page.text = text + page.text[end_index:]
	else:
		page.text = text
	page.save(summary = SUMMARY or sys.argv)

def main():
	for v in files:
		text = getFileText(v[0])
		saveFile(text, v[1])
	print("done upload")

if __name__ == "__main__":
	main()
