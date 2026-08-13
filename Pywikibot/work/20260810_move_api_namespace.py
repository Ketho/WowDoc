import requests
import pywikibot
import time

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

def main():
	catNames = [
		# 'API functions',
		# 'Widget methods',
		# 'ScriptObject methods',
		'Banana',
	]
	print("Querying wiki pages...")
	cats = []
	for v in catNames:
		for member in category_members(v):
			cats.append(member['title'])

	start = time.time()
	count = 0
	for v in sorted(cats):
		print(v)
		count = count + 1
		page = pywikibot.Page(site, v)
		new_name = v.replace("API ", "API:")
		page.move(new_name, reason='Banana? Banana 🍌')

		end = time.time()
		print(f"count={count}, seconds={end - start:.2f}, pages/minute={(count/(end - start))*60}")


if __name__ == "__main__":
	main()
