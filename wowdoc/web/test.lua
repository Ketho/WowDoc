local wago = require("wowdoc.web.wago")

local iter = wago:GetCSV("mount", {header = true, build = "10.0.2.47657", locale = "deDE"})

for line in iter:lines() do
	print(line.ID, line.Name_lang)
end
