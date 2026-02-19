import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent))

import util.warcraftwiki
from replace_uiobject_pattern import replace_uiobject_pattern

def isFunction(s):
	return "(" in s

def isUIObject(s: str):
	return "apisig" in s

def isSignature(s: str):
	return s.startswith(" ") and isFunction(s) and isUIObject(s)
	
def update_text(name: str, s: str):
	lines = s.splitlines()
	isUpdate = False
	for i, v in enumerate(lines):
		if isSignature(v) and i<=5:
			x = replace_uiobject_pattern(v)
			if x != v:
				lines[i] = x
				isUpdate = True
				break
	if isUpdate:
		return str.join("\n", lines)

def main():
	util.warcraftwiki.main(update_text, summary="Apply apisig template")

if __name__ == "__main__": 
	main()
