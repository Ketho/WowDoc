local m = {}
local strlib = require("wowdoc.util.string")

local function print_msg(symbol, msg)
	print(string.format("[%s] %s", symbol, msg))
end

function m.success(msg)
	local symbol = strlib.color("+", strlib.style.green)
	print_msg(symbol, msg)
end

function m.warn(msg)
	local symbol = strlib.color("!", strlib.style.yellow)
	print_msg(symbol, msg)
end

function m.failure(msg)
	local symbol = strlib.color("-", strlib.style.red)
	print_msg(symbol, msg)
end

function m.important(msg)
	local symbol = strlib.color("#", strlib.style.purple)
	print_msg(symbol, msg)
end

function m.info(msg)
	local symbol = strlib.color("*", strlib.style.blue)
	print_msg(symbol, msg)
end

function m.debug(msg)
	local symbol = strlib.color("D", strlib.style.teal)
	print_msg(symbol, msg)
end

return m
