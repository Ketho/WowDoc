local lfs = require("lfs")
local pathlib = require("path")
local log = require("wowdoc.util.log")

local m = {}

--- Runs a commmand in the shell
---@param cmd string
---@return string result
function m:run_command(cmd)
	log.important("Running command: "..cmd)
	local handle = io.popen(cmd)
	local result = handle:read("a")
	handle:close()
	return result
end

function m:FolderExists(path)
	return lfs.attributes(path, "mode") == "directory"
end

-- use pathlib.mkdir instead of lfs.mkdir since it creates parent folders as needed
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

function m:OpenFile(path)
	local f = assert(io.open(path, "r"))
	return f
end

---@param path string
---@param text string
function m:WriteFile(path, text)
	log.info(string.format('Writing "%s"', path))
	local f = assert(io.open(path, "w"))
	f:write(text)
	f:close()
end

-- while in a file with the meta tag it will not show completion context and ignores find references
-- Giving the name _ will make it unable to be required.
-- https://luals.github.io/wiki/annotations/#meta
function m:WriteFileMeta(path, text)
	text = "---@meta _\n"..text
	self:WriteFile(path, text)
end

m.RelativePath = {
	["."] = true,
	[".."] = true,
}

function m:IterateFiles(folder, func)
	for fileName in lfs.dir(folder) do
		local path = folder.."/"..fileName
		local attr = lfs.attributes(path)
		if attr.mode == "directory" then
			if not self.RelativePath[fileName] then
				self:IterateFiles(path, func)
			end
		else
			local ext = fileName:match("%.(%a+)")
			if ext == "lua" or ext == "xml" then
				func(path)
			end
		end
	end
end

return m
