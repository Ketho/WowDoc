local m = {}

-- https://stackoverflow.com/a/7615129/1297035
function m.strsplit(input, sep)
	local t = {}
	for s in string.gmatch(input, "([^"..sep.."]+)") do
		table.insert(t, s)
	end
	return t
end

m.style = {
	bold = 1,
	italic = 3,
	underline = 4,
	strikethrough = 9,
	double_underline = 21,
	gray = 30,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	purple = 35,
	teal = 36,
	white = 37,
	black_bg = 40,
	red_bg = 41,
	green_bg = 42,
	yellow_bg = 43,
	blue_bg = 44,
	purple_bg = 45,
	teal_bg = 46,
	white_bg = 47,
	clear_gray = 90,
	clear_red = 91,
	clear_green = 92,
	clear_yellow = 93,
	clear_blue = 94,
	clear_purple = 95,
	clear_teal = 96,
	clear_white = 97,
}

function m.color(msg, color_id)
	return string.format("\27[%dm%s\27[0m", color_id, msg)
end

return m
