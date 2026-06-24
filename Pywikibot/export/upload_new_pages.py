import requests
import pywikibot
import os
import time
from pathlib import Path

site = pywikibot.Site("en", "warcraftwiki")
url = 'https://warcraft.wiki.gg'

headers = { # https://foundation.wikimedia.org/wiki/Policy:Wikimedia_Foundation_User-Agent_Policy
    'User-Agent': 'KethoBot/1.0 (https://warcraft.wiki.gg/wiki/User:KethoBot)'
}

def category_members(catname):
	params = {
		'action': 'query',
		'list': 'categorymembers',
		'cmtitle': f'Category:{catname}',
		'cmlimit': 'max',
		'format': 'json',
		'formatversion': 2,
	}
	while True:
		resp = requests.post(f'{url}/api.php', params, headers=headers)
		data = resp.json()
		if 'error' in data:
			if data['error']['code'] == 'ratelimited':
				print(f"Rate limited, waiting 60 seconds...")
				time.sleep(60)
				continue
		for page in data['query']['categorymembers']:
			yield page
		if data.get('continue'):
			params.update(data['continue'])
			time.sleep(1) # delay between requests
		else:
			break

def getFileText(p):
	f = open(p)
	lines = f.readlines()
	return "".join(lines)

def recursiveFiles(path, l):
	for base in os.listdir(path):
		newPath = Path(path, base)
		if os.path.isdir(newPath):
			if base != "Constants":
				recursiveFiles(newPath, l)
		else:
			name = base[:-4].replace("_", " ")
			l.update({name: getFileText(newPath)})

def get_documented_api():
	fullpath = Path(".wiki")
	l = {}
	recursiveFiles(fullpath, l)
	return l

def main():
	# apiPages = ([ page['title'] for page in category_members('API functions') ])
	catNames = [
		'API functions',
		'API events',
		'Widget methods',
		'Structures',
		'Enums',
	]
	cats = []
	for v in catNames:
		for member in category_members(v):
			cats.append(member['title'])

	docApi = get_documented_api()
	for v in docApi:
		if not v in cats:
			page = pywikibot.Page(site, v)
			if not page.exists():
				page.text = docApi[v]
				page.save(summary="12.1.0 (68301)")
				time.sleep(3)
			else: # probably a redirect page
				print(f"- {v}")
				time.sleep(.2)
	print("done")

if __name__ == "__main__":
	main()
