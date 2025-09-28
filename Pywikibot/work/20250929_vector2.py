import util.warcraftwiki

def update_text(name: str, s: str):
	replacements = {
		"{{apitype|Vector2DMixin": "{{apitype|vector2",
		"{{apitype|Vector3DMixin": "{{apitype|vector3",
		"{{apitype|ColorMixin": "{{apitype|colorRGB",
		"{{apitype|ItemLocationMixin": "{{apitype|ItemLocation",
		"{{apitype|PlayerLocationMixin": "{{apitype|PlayerLocation",
		"{{apitype|TransmogLocationMixin": "{{apitype|TransmogLocation",
		"{{apitype|ItemTransmogInfoMixin": "{{apitype|ItemTransmogInfo",
		"{{apitype|TransmogPendingInfoMixin": "{{apitype|TransmogPendingInfo",
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
	util.warcraftwiki.main(update_text, summary="Update blizzard types")

if __name__ == "__main__": 
	main()
