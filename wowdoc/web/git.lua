local system = require("wowdoc.util.system")
local strlib = require("wowdoc.util.string")
local m = {}

function m:checkout(url, branch)
	local user, repo = url:match("https://github.com/([^/]+)/([^/]+)")
	-- clone if it doesn't exist
	if not system:FolderExists(repo) then
		print(system:RunCommand(string.format("git clone %s", url)))
	end
	system:RunCommand(string.format("git -C %s checkout %s", repo, branch))
	system:RunCommand(string.format("git -C %s pull", repo, repo))
	-- show latest commit
	local msg = system:RunCommand(string.format("git -C %s log -1", repo))
	local patch, build = msg:match("(%d+%.%d+%.%d+) %((%d+)%)")
	local color_patch = strlib.color(patch, strlib.style.green)
	local color_build = strlib.color(build, strlib.style.blue)
	print("Patch:", string.format("%s (%s)", color_patch, color_build))
	print("Date:", msg:match("Date:%s+(.-)\n"))
	print("Commit:", msg:match("commit (%w+)"))
end

return m
