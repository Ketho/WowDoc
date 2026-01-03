import util.warcraftwiki

def isFunction(s):
	return "(" in s

def isEvent(s: str):
	return s.isupper() or ": " in s

def isSignature(s: str):
	return s.startswith(" ") and (isFunction(s) or isEvent(s))

def update_text(name: str, s: str):
	lines = s.splitlines()
	isUpdate = False
	for i, v in enumerate(lines):
		if isSignature(v) and i<=5:
			isUpdate = True
			if i != 2:
				print(f"Found signature at index {i} instead in {name}")
				isUpdate = False
			if isUpdate:
				s = v.replace("=", "{{=}}")
				lines[i] = f"{{{{apisig|{s.lstrip()}}}}}"
				break
	if isUpdate:
		return str.join("\n", lines)

def main():
	util.warcraftwiki.main(update_text, summary="Apply apisig template")

if __name__ == "__main__": 
	main()
