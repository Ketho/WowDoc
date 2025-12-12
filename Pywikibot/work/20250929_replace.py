import util.warcraftwiki

def update_text(name: str, s: str):
	replacements = {
		"LuaDurationObject": "DurationObject",
		"LuaCurveObjectBase": "CurveObjectBase",
		"LuaCurveEvaluatedResult": "CurveEvaluatedResult",
	}
	
	lines = s.splitlines()
	is_updated = False
	
	for i, line in enumerate(lines):
		for old, new in replacements.items():
			if old in line:
				lines[i] = line.replace(old, new)
				is_updated = True
	
	if is_updated:
		return "\n".join(lines)

def main():
	util.warcraftwiki.main(update_text, summary="fix 12.0.1 types")

if __name__ == "__main__": 
	main()
