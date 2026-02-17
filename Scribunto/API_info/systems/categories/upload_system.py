import csv
import pywikibot
import time

site = pywikibot.Site("en", "warcraftwiki")

def main():
	systems = read_csv('.wow/wiki_categories/systems.csv')
	for row in systems:
		file, system, namespace, *_ = row
		text = get_system_page(file, system, namespace)
		save_page(f"Category:API_systems/{system}", text, "12.0.0 (65893) systems")

def read_csv(file_path):
	with open(file_path, newline='', encoding='utf-8') as csvfile:
		reader = csv.reader(csvfile)
		next(reader) # skip header
		return list(reader)

def save_page(title, text, summary):
	page = pywikibot.Page(site, title)
	time.sleep(4)
	if not page.exists():
		page.text = text
		page.save(summary=summary)
	else:
		print(f"Skipping {title}")

def get_system_page(file, system, namespace):
    args = [f"file={file}", f"system={system}"]
    if namespace:
        args.append(f"namespace={namespace}")
    args_str = "|".join(args)
    return f"{{{{#invoke:API info/systems|main|{args_str}}}}}"

if __name__ == "__main__":
	main()
