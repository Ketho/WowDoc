# from BryghtShadow on Fandom discord
import datetime as dt
from pathlib import Path
import requests
import time
from pathlib import Path

url = 'https://warcraft.wiki.gg/'
EXPORT_PATH = Path(".wow", "wiki_export")

headers = { # https://foundation.wikimedia.org/wiki/Policy:Wikimedia_Foundation_User-Agent_Policy
    'User-Agent': 'KethoBot/1.0 (https://warcraft.wiki.gg/wiki/User:KethoBot)'
}

categories = [
	"API functions",
	"Lua functions",
	"Widget methods",
	"Widget script handlers",
	"API events",
	"Structs",
	"Enums",
]

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
				print(f"Rate limited, waiting 90 seconds...")
				time.sleep(90)
				continue

		for page in data['query']['categorymembers']:
			yield page
		if data.get('continue'):
			params.update(data['continue'])
			time.sleep(1)  # delay between requests
		else:
			break

def export(catname):
	pages = sorted([ page['title'] for page in category_members(catname) ])
	params = {
		'title': 'Special:Export',
		'catname': catname,
		'pages': '\r\n'.join(pages),
		'curonly': '1',
		'wpDownload': '1',
		'wpEditToken': '%2B%5C',
	}
	print(f'Exporting {len(pages)} page(s) found in "Category:{catname}"')
	resp = requests.post(f'{url}/index.php', params, headers=headers)
	data = resp.content
	return data

def main(catname):
	dir_path = EXPORT_PATH
	dir_path.mkdir(parents=True, exist_ok=True)

	xml = export(catname)
	now = dt.datetime.utcnow().strftime('%Y%m%d%H%M%S')
	filename = f'{catname}-{now}.xml'
	fullpath = Path(dir_path, filename).absolute()
	print(f'Dumping to "{fullpath}"')
	with open(fullpath, 'wb') as f:
		f.write(xml)

if __name__ == '__main__':
	for v in categories:
		main(v)
		time.sleep(5)
	print("done.")
