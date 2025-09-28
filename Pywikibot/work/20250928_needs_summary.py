import util.warcraftwiki

def update_text(name: str, s: str):
	line = s.splitlines()
	isUpdate = False
	for i, v in enumerate(line):
		if v.startswith("Needs summary."):
			line[i] = v.replace("Needs summary.", "&nbsp;")
			isUpdate = True
	if isUpdate:
		return str.join("\n", line)

def main():
	util.warcraftwiki.main(update_text, summary="Remove \"Needs summary.\"")

if __name__ == "__main__": 
	main()
