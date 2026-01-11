import util.warcraftwiki

def update_text(name: str, s: str):
	lines = s.splitlines()
	isUpdate = False
	isApisig = False
	for i, v in enumerate(lines):
		if "{{apisig|" in v and v.endswith("}}"):
			isApisig = True
			lines[i] = v[:-2]
			continue
		if isApisig and lines[i].startswith(" ") and not "{{=}}" in lines[i]:
			lines[i] = v[1:]
			lines[i] = lines[i].replace("=", "{{=}}")
			lines[i] = lines[i] + "}}"
			isUpdate = True
			# print(f"Found multiline apisig at index {i} in {name}")
		if not lines[i].startswith(" "):
			isApisig = False
	if isUpdate:
		return str.join("\n", lines)


def main():
	util.warcraftwiki.main(update_text, summary="Fix multiline apisig")

if __name__ == "__main__": 
	main()
