import csv
import pywikibot

site = pywikibot.Site("en", "warcraftwiki")

def main():
	systems = read_csv('Pywikibot/projects/20250816_systems/systems.csv')
	for row in systems:
		file, system, namespace, *a = row
		if namespace and namespace != "table":
			save_page(namespace, f"#REDIRECT [[Category:API_systems/{system}]]", "Undo wrong redirect")

def read_csv(file_path):
	with open(file_path, newline='', encoding='utf-8') as csvfile:
		reader = csv.reader(csvfile)
		next(reader)
		return list(reader)

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	page.text = text
	page.save(summary=summary)

if __name__ == "__main__":
	main()
