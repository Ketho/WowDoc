import time
import csv
import pywikibot

site = pywikibot.Site("en", "warcraftwiki")

def main():
	systems = read_csv('.wow/scribunto/namespaces/namespaces.csv')
	for row in systems:
		namespace, system = row
		save_page(namespace, f"#REDIRECT [[Category:API_systems/{system}]]", "Update namespace redirects")

def read_csv(file_path):
	with open(file_path, newline='', encoding='utf-8') as csvfile:
		reader = csv.reader(csvfile)
		next(reader)
		return list(reader)

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	page.text = text
	page.save(summary=summary)
	time.sleep(4)

if __name__ == "__main__":
	main()
