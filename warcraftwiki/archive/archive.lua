local archive = require("warcraftwiki.archive.framexml")

local m = {}

function m:main()
	local archives = archive:GetDocArchive("live")
	for _, v in pairs(archives) do
		print(v.version, #v.docs.systems)
	end
end
m:main()

return m
