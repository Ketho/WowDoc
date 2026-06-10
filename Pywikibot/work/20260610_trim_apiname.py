import re
import util.warcraftwiki

def update_text(name: str, s: str):
	l = s.splitlines()
	isUpdate = False
	for i, v in enumerate(l):
		regex = r"(\{\{apiname\.added\|[^}]+\}\}) -"
		if re.search(regex, v):
			l[i] = re.sub(regex, r"\1", v)
			isUpdate = True
	if isUpdate:
		return str.join("\n", l)

def main():
	util.warcraftwiki.main(update_text, summary="Update apiname.added")

if __name__ == "__main__": 
	main()
