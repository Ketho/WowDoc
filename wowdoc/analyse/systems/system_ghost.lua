-- C_ConfigurationWarnings is a documented system with functions, but it does not exist
-- # it has a documented namespace which does not exist
-- # the Functions table is not empty 
local namespace_ghost = require("wowdoc.analyse.systems.namespace_ghost")
local system_empty = require("wowdoc.analyse.systems.system_empty")
local m = {}

-- systems that are documented with functions but do not actually exist, like C_ConfigurationWarnings
function m:GetGhostSystems()
	local noexist = namespace_ghost:GetGhostNamespaces()
	local hasFunctions = system_empty:get().hasFunctions
	local t = {}
	for k in pairs(noexist) do
		if hasFunctions[k] then
			t[k] = true
			-- print(k)
		end
	end
	return t
end
function m:get()
	return self:GetGhostSystems()
end

return m

-- # these systems are partially documented on the wiki and should be marked as ghost/restricted
-- C_BarberShopInternal, BarberShop
-- C_CinematicList, CinematicList
-- C_CombatLogInternal, CombatLogInternal
-- C_CombatLogSecure, CombatLogSecure
-- C_ConfigurationWarnings, ConfigurationWarnings
-- C_LiveEvent, LiveEvent
-- C_MacOptions, MacOptions
-- C_PingSecure, PingManagerSecure
-- C_SecureTransfer, SecureTransfer
-- C_WorldSafeLocsUIInternal, WorldSafeLocsUIInternal
