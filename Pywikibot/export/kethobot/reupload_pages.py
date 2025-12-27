import pywikibot
import os
import time
from pathlib import Path
from kethobot_pages import main as kethobot_pages_main

site = pywikibot.Site("en", "warcraftwiki")
url = 'https://warcraft.wiki.gg'

headers = { # https://foundation.wikimedia.org/wiki/Policy:Wikimedia_Foundation_User-Agent_Policy
	'User-Agent': 'KethoBot/1.0 (https://warcraft.wiki.gg/wiki/User:KethoBot)'
}

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)
	
def recursiveFiles(path, l):
	for base in os.listdir(path):
		newPath = Path(path, base)
		if os.path.isdir(newPath):
			if base != "widget":
				recursiveFiles(newPath, l)
		else:
			name = base[:-4].replace("_", " ")
			l.update({name: getFileText(newPath)})

def get_documented_api():
	fullpath = Path(".wow", "documenter")
	l = {}
	recursiveFiles(fullpath, l)
	return l

def main():
	recent_pages = kethobot_pages_main()
	recent_titles = {page['title'] for page in recent_pages}
	
	for i, xml_page in enumerate(recent_pages, start=1):
		timestamp = xml_page['timestamp'].strftime('%Y-%m-%d %H:%M:%S')
		print(f"{i:3d}, {timestamp}, {xml_page['comment']}, {xml_page['title']}")

	docApi = get_documented_api()
	i = 0
	for v in docApi:
		if v in recent_titles:
			i += 1
			print(f"{i}, {v}")
			page = pywikibot.Page(site, v)
			page.text = docApi[v]
			page.save(summary="12.0.0 (65028)")
			time.sleep(3)
	print("done")

if __name__ == "__main__":
	main()
