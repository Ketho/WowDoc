-- C_ConfigurationWarnings is a documented system with functions, but it does not exist
-- # it has a documented namespace which does not exist
-- # the Functions table is not empty 

local namespace_ghost = require("wowdoc.analyse.systems.namespace_ghost")
local system_empty = require("wowdoc.analyse.systems.system_empty")

local m = {}

-- systems that are documented with functions but do not actually exist, like C_ConfigurationWarnings
function m:GetGhostSystems()
	local noexist = namespace_ghost:GetGhostNamespaces()
	local info = system_empty:get()
	local t = {}
	print("-- ghost systems")
	for k in pairs(noexist) do
		if info.hasFunctions[k] then
			t[k] = true
			-- print(k)
		end
	end
	return t
end

function m:test()
	self:GetGhostSystems()
end
m:test()

-- # these systems are partially documented on the wiki and should be marked as ghost/restricted
-- C_BarberShopInternal
-- C_CinematicList
-- C_CombatLogInternal
-- C_CombatLogSecure
-- C_ConfigurationWarnings
-- C_LiveEvent
-- C_MacOptions
-- C_PingSecure
-- C_SecureTransfer
-- C_WorldSafeLocsUIInternal
