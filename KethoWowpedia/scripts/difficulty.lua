local eb = KethoEditBox

function KethoWowpedia:GetDifficultyIDs()
	eb:Show()
	--local header = '{| class="sortable darktable zebra"\n|-\n! ID !! Name !! Type !! isHeroic !! isChallengeMode !! displayHeroic !! displayMythic !! toggleDifficultyID\n'
	--local fs = "|-\n| %d |||| %s |||| %s |||| %s |||| %s |||| %s |||| %s |||| %d\n"
	local header = '{| class="sortable darktable zebra col1-center"\n! ID !! Name !! Type !! Notes'
	local fs = '|-\n| %d |||| %s |||| %s |||| %s'

	eb:InsertLine(header)

	for i = 1, 500 do -- where did that 147 come from
		if GetDifficultyInfo(i) then
			local difficultyName, instanceType, isHeroic, isChallengeMode, displayHeroic, displayMythic, toggleDifficultyID = GetDifficultyInfo(i)

			local t = {}
			if isHeroic then table.insert(t, "isHeroic") end
			if isChallengeMode then table.insert(t, "isChallengeMode") end
			if displayHeroic then table.insert(t, "displayHeroic") end
			if displayMythic then table.insert(t, "displayMythic") end
			if toggleDifficultyID then table.insert(t, "toggleDifficultyID: "..toggleDifficultyID) end

			eb:InsertLine(fs:format(i, difficultyName, instanceType,
				table.concat(t, ", ")))
		end
	end

	eb:InsertLine("|}")
end
--[[
DifficultyUtil.ID = {
	DungeonNormal = 1,
	DungeonHeroic = 2,
	Raid10Normal = 3,
	Raid25Normal = 4,
	Raid10Heroic = 5,
	Raid25Heroic = 6,
	RaidLFR = 7,
	DungeonChallenge = 8,
	Raid40 = 9,
	PrimaryRaidNormal = 14,
	PrimaryRaidHeroic = 15,
	PrimaryRaidMythic = 16,
	PrimaryRaidLFR = 17,
	DungeonMythic = 23,
	DungeonTimewalker = 24,
	RaidTimewalker = 33,
	RaidStory = 220,
};

local DIFFICULTY_NAMES =
{
	[DifficultyUtil.ID.DungeonNormal] = PLAYER_DIFFICULTY1,
	[DifficultyUtil.ID.DungeonHeroic] = PLAYER_DIFFICULTY2,
	[DifficultyUtil.ID.Raid10Normal] = PLAYER_DIFFICULTY1,
	[DifficultyUtil.ID.Raid25Normal] = PLAYER_DIFFICULTY1,
	[DifficultyUtil.ID.Raid10Heroic] = PLAYER_DIFFICULTY2,
	[DifficultyUtil.ID.Raid25Heroic] = PLAYER_DIFFICULTY2,
	[DifficultyUtil.ID.RaidLFR] = PLAYER_DIFFICULTY3,
	[DifficultyUtil.ID.DungeonChallenge] = PLAYER_DIFFICULTY_MYTHIC_PLUS,
	[DifficultyUtil.ID.Raid40] = LEGACY_RAID_DIFFICULTY,
	[DifficultyUtil.ID.PrimaryRaidNormal] = PLAYER_DIFFICULTY1,
	[DifficultyUtil.ID.PrimaryRaidHeroic] = PLAYER_DIFFICULTY2,
	[DifficultyUtil.ID.PrimaryRaidMythic] = PLAYER_DIFFICULTY6,
	[DifficultyUtil.ID.PrimaryRaidLFR] = PLAYER_DIFFICULTY3,
	[DifficultyUtil.ID.DungeonMythic] = PLAYER_DIFFICULTY6,
	[DifficultyUtil.ID.DungeonTimewalker] = PLAYER_DIFFICULTY_TIMEWALKER,
	[DifficultyUtil.ID.RaidTimewalker] = PLAYER_DIFFICULTY_TIMEWALKER,
	[DifficultyUtil.ID.Raid40] = PLAYER_DIFFICULTY1,
	[DifficultyUtil.ID.RaidStory] = PLAYER_DIFFICULTY_STORY_RAID,
}
]]
