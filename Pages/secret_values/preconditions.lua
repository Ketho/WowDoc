local loader = require("wowdoc.loader")
local m = {}

function m:main()
	loader:LoadDocumentation()
	print("! Precondition !! Failure Mode !! Description")
	local fs = "|-\n| {{apiname|%s}} || %s || %s"
	for _, system in pairs(APIDocumentation.systems) do
		for _, predicate in pairs(system.Predicates) do
			if predicate.Type == "Precondition" then
				local failure_mode = ""
				if predicate.FailureMode then
					failure_mode = string.format('<font color="plum">%s</font>', predicate.FailureMode)
				end
				local doc = ""
				if predicate.Documentation then
					doc = table.concat(predicate.Documentation, "; ")
				end
				print(fs:format(predicate.Name, failure_mode, doc))
			end
		end
	end
end
m:main()
