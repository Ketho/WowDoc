import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime, timedelta, timezone
from collections import defaultdict

NS = {'mw': 'http://www.mediawiki.org/xml/export-0.11/'}

def parse_timestamp(s):
	dt = datetime.strptime(s, '%Y-%m-%dT%H:%M:%SZ') # ISO 8601
	dt = dt.replace(tzinfo=timezone.utc)
	return dt

def parse_xml(filepath):
	tree = ET.parse(filepath)
	root = tree.getroot()
	
	dict = defaultdict(list)
	
	for page in root.findall('mw:page', NS):
		title_el = page.find('mw:title', NS)
		title = title_el.text

		revision = page.find('mw:revision', NS)
		timestamp_el = revision.find('mw:timestamp', NS)
		timestamp_str = timestamp_el.text
		timestamp = parse_timestamp(timestamp_str)

		# comment_el = revision.find('mw:comment', NS)
		# comment = comment_el.text

		contributor = revision.find('mw:contributor', NS)
		username_elem = contributor.find('mw:username', NS)
		username = username_elem.text
		
		dict[username].append({
			'title': title,
			'timestamp': timestamp,
			# 'comment': comment,
		})

	return dict

def read_xml_folder(path):
	dict = defaultdict(list)
	export_dir = Path(path)
	xml_files = sorted(export_dir.glob('*.xml'))
	for xml_file in xml_files:
		print(f"Processing: {xml_file.name}")
		try:
			pages_by_creator = parse_xml(xml_file)
			for username, pages in pages_by_creator.items():
				dict[username].extend(pages)
		except Exception as e:
			print(f"Error parsing {xml_file.name}: {e}")
	return dict

def main():
	pages = read_xml_folder('.wow/wiki_export')
	kethobot_pages = pages['Ketho']

	now = datetime.now(timezone.utc)
	days = 80
	delta = now - timedelta(days=days)

	recent_pages = [page for page in kethobot_pages if page['timestamp'] >= delta and not "CHAT " in page['title']]
	recent_pages.sort(key=lambda page: page['timestamp'])
	print(f"{len(recent_pages)} pages edited by KethoBot in the last {days} days (since {delta.strftime('%Y-%m-%d')})")
	
	for i, page in enumerate(recent_pages, start=1):
		timestamp = page['timestamp'].strftime('%Y-%m-%d %H:%M:%S')
		print(f"{i:3d}, {timestamp}, {page['title']}")

	return recent_pages

if __name__ == '__main__':
	main()
