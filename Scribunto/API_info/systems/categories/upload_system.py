import csv
import pywikibot
import requests
import time

site = pywikibot.Site("en", "warcraftwiki")
url = 'https://warcraft.wiki.gg'

headers = { # https://foundation.wikimedia.org/wiki/Policy:Wikimedia_Foundation_User-Agent_Policy
    'User-Agent': 'KethoBot/1.0 (https://warcraft.wiki.gg/wiki/User:KethoBot)'
}

def main():
	systems = read_csv('.wow/scribunto/systems/systems.csv')
	category_members = get_category_members('API systems')
	for row in systems:
		file, system, namespace, *_ = row
		title = f"Category:API systems/{system}"
		if title in category_members:
			continue
		text = get_system_page(file, system, namespace)
		save_page(title, text, "12.1.0 (68209)")
	print("done")

def get_category_members(catname):
	params = {
		'action': 'query',
		'list': 'categorymembers',
		'cmtitle': f'Category:{catname}',
		'cmlimit': 'max',
		'format': 'json',
		'formatversion': 2,
	}
	members = set()
	while True:
		resp = requests.post(f'{url}/api.php', params, headers=headers)
		data = resp.json()
		for page in data['query']['categorymembers']:
			members.add(page['title'])
		if data.get('continue'):
			params.update(data['continue'])
			time.sleep(1)
		else:
			break
	return members

def read_csv(file_path):
	with open(file_path, newline='', encoding='utf-8') as csvfile:
		reader = csv.reader(csvfile)
		next(reader) # skip header
		return list(reader)

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	time.sleep(3)
	page.text = text
	page.save(summary=summary)

def get_system_page(file, system, namespace):
    args = [f"file={file}", f"system={system}"]
    if namespace:
        args.append(f"namespace={namespace}")
    args_str = "|".join(args)
    return f"{{{{#invoke:API info/systems|main|{args_str}}}}}"

if __name__ == "__main__":
	main()
