local m = {}

local classicVersions = {
	"^1.13.",
	"^1.14.",
	"^1.15.",
	"^2.5.",
	"^3.4.",
}

function m:IsClassicVersion(v)
	for _, pattern in pairs(classicVersions) do
		if v:find(pattern) then
			return true
		end
	end
	return false
end

return m
