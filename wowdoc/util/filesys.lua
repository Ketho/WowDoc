local lfs = require("lfs")
local pathlib = require("path")
local log = require("wowdoc.util.log")

local m = {}

function m:FolderExists(path)
	return lfs.attributes(path, "mode") == "directory"
end

-- use pathlib.mkdir instead of lfs.mkdir since creates parent folders as needed
-- also returns the path for the created folder
---@param ... string
---@return string path
function m:mkdir(path, ...)
	local p
	if ... then
		p = pathlib.join(path, ...)
	else
		p = path
	end
	if not pathlib.exists(p) then
		pathlib.mkdir(p)
	end
	return p
end

function m:WriteFile(path, text)
	log:info(string.format('Writing "%s"', path))
	local file = io.open(path, "w")
	if file then
		file:write(text)
		file:close()
	end
end

-- while in a file with the meta tag it will not show completion context and ignores find references
-- Giving the name _ will make it unable to be required.
-- https://luals.github.io/wiki/annotations/#meta
function m:WriteFileMeta(path, text)
	text = "---@meta _\n"..text
	self:WriteFile(path, text)
end

return m
