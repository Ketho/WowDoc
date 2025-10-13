function GetGameFonts()
	TestDB = {}
	local fs = "%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s"
	for _, v in pairs(GetFonts()) do
		local info = GetFontInfo(v)
		local fstring = _G[v]
		-- if not string.find(v, "table:") then
			local file = info.fontObject:GetFont()
			local parent = _G[v]:GetFontObject()
			if parent then
				parent = parent:GetName()
			end
			local color = info.color
			local color_hex = string.sub(color:GenerateHexColor(), 3)
			if color_hex == "ffffff" then -- missing color
				color_hex = ""
			end
			local shadow = {
				hex = "",
				x = "",
				y = "",
			}
			if info.shadow then
				shadow.hex = string.sub(info.shadow.color:GenerateHexColor(), 3)
				shadow.x = info.shadow.x
				shadow.y = info.shadow.y
			end
			local justifyH = fstring:GetJustifyH()
			if justifyH == "CENTER" then
				justifyH = ""
			end
			local justifyV = fstring:GetJustifyV()
			if justifyV == "MIDDLE" then
				justifyV = ""
			end
			table.insert(TestDB, fs:format(
				v,
				file or "",
				info.height,
				info.outline,
				color_hex,
				shadow.hex,
				shadow.x,
				shadow.y,
				parent or "",
				justifyH,
				justifyV
			))
		-- end
	end
end
