import csv
import pywikibot

site = pywikibot.Site("en", "warcraftwiki")

def main():
	systems = read_csv('Pywikibot/projects/20250816_systems/systems.csv')
	for row in systems:
		file, system, namespace = row
		text = get_system_page(file, system, namespace)
		save_page(f"Category:API_systems/{system}", text, "system page")

def read_csv(file_path):
	with open(file_path, newline='', encoding='utf-8') as csvfile:
		reader = csv.reader(csvfile)
		next(reader) # skip header
		return list(reader)

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	page.text = text
	page.save(summary=summary)

def get_system_page(file, system, namespace):
    args = [f"file={file}", f"system={system}"]
    if namespace:
        args.append(f"namespace={namespace}")
    args_str = "|".join(args)
    return f"{{{{#invoke:API systems|main|{args_str}}}}}\n[[Category:API systems|{system}]]"

if __name__ == "__main__":
	main()
