

local system = require("wowdoc.util.system")
local m = {}

function m:checkout(url, branch)
	local user, repo = url:match("https://github.com/([^/]+)/([^/]+)")
	-- clone if it doesn't exist
	if not system:FolderExists(repo) then
		print(system:run_command(string.format("git clone %s", url)))
	end
	system:run_command(string.format("git -C %s checkout %s", repo, branch))
	system:run_command(string.format("git -C %s pull", repo, repo))
	-- show latest commit
	local msg = system:run_command(string.format("git -C %s log -1", repo))
	print("Patch:", msg:match("%d+%.%d+%.%d+ %(%d+%)"))
	print("Date:", msg:match("Date:%s+(.-)\n"))
	print("Commit:", msg:match("commit (%w+)"))
end

return m
