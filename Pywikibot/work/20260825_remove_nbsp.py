import util.warcraftwiki

def update_text(name: str, s: str):
	lines = s.splitlines()
	filtered_lines = [line for i, line in enumerate(lines) if i >= 4 or line != "&nbsp;"]
	isUpdate = len(filtered_lines) != len(lines)
	if isUpdate:
		return str.join("\n", filtered_lines)

def main():
	util.warcraftwiki.main(update_text, summary="Remove whitespace summary placeholder")

if __name__ == "__main__": 
	main()
