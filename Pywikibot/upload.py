import os
import pywikibot
# import export.parse_html as parse_html
import time

site = pywikibot.Site("en", "warcraftwiki")
PATH = ".wiki/Enumeration"
EditSummary = "upload enums"

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)

def saveFile(path, fileName):
	name = fileName.replace(".txt", "")
	page = pywikibot.Page(site, name)
	time.sleep(3)
	if not page.exists():
		text = getFileText(path)
		page.text = text
		page.save(summary = EditSummary)
	else:
		print("- "+name)

def recursiveFiles(path):
	for base in sorted(os.listdir(path)):
		newPath = path+"/"+base
		if os.path.isdir(newPath):
			if base != "widget":
				recursiveFiles(newPath)
		else:
			saveFile(newPath, base)

def main():
	# parse_html.main()
	recursiveFiles(PATH)
	print("done upload")

if __name__ == "__main__":
	main()
