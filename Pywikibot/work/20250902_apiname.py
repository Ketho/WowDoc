import re
import util.warcraftwiki

def update_text(name: str, s: str):
	line = s.splitlines()
	isWikiTable = False
	isUpdate = False
	for i, v in enumerate(line):
		if v.startswith("! Field !! Type !! Description"):
			isWikiTable = True
		elif not v.startswith("|"):
			isWikiTable = False
		elif isWikiTable and v.startswith("|") and "apiname" not in v:
			line[i] = re.sub(r"\| *([A-Za-z0-9]+) *\|\|", r"| {{apiname|\1}} ||", v)
			isUpdate = True
	if isUpdate:
		return str.join("\n", line)

def main():
	util.warcraftwiki.main(update_text, summary="format apiname")

if __name__ == "__main__":
	main()
