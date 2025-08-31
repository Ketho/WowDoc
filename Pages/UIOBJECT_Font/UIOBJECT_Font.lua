---@diagnostic disable: need-check-nil
local csv = require("wowdoc.lua-csv")

local function Round(v, decimals)
	local mult = 10^(decimals or 0)
	return math.floor(v * mult + 0.5) / mult
end

local iter = csv.open("Pages/UIOBJECT_Font/fonts.csv", {separator = ";"})
for line in iter:lines() do
	local name, file, height, outline, color, shadow_hex, shadow_x, shadow_y, parent, justifyH, justifyV = table.unpack(line)
	-- print(name, file, height, outline, color, shadow)
	color = string.format("<code><font color=\"#%s\">%s</font></code>", color, color)
	file = file:gsub([[Fonts\\]], "")
	if #outline > 0 then
		outline = string.format("<small>%s</small>", outline)
	end
	local shadow_str = ""
	if #shadow_hex > 0 then
		local t = {}
		shadow_hex = string.format("<code><font color=\"#%s\">%s</font></code>", shadow_hex, shadow_hex)
		table.insert(t, shadow_hex)
		if name == "NumberFont_Shadow_Large" then
			table.insert(t, Round(shadow_x, 2))
			table.insert(t, Round(shadow_y, 2))
		else
			table.insert(t, shadow_x)
			table.insert(t, shadow_y)
		end
		local shadow_concat = table.concat(t, ", ")
		shadow_str = string.format("%s", shadow_concat)
	end
	if #parent > 0 then
		parent = string.format("{{apiname|%s}}", parent)
	end
	local fs = "|-\n| {{apiname|%s}} || {{apiname|%s}} || %d || %s || %s || %s || %s || %s || %s"
	print(fs:format(name, file, height, outline, color, shadow_str, justifyH, justifyV, parent))
end
