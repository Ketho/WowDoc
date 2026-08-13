import csv
from collections import defaultdict

def find_duplicate_names(file_path):
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        name_rows = defaultdict(list)
        for idx, row in enumerate(reader, start=2):
            name = row['Name']
            name_rows[name].append(idx)

    for name, rows in name_rows.items():
        if len(rows) > 1:
            print(f"Duplicate Name '{name}' found in rows: {rows}")

find_duplicate_names('Pywikibot/projects/20250816_systems/systems.csv')
# Duplicate Name 'BarberShop' found in rows: [25, 26]
