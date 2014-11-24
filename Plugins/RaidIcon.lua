-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Raid Icons")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local lastplayer = {}

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local icons = {
	RAID_TARGET_1,
	RAID_TARGET_2,
	RAID_TARGET_3,
	RAID_TARGET_4,
	RAID_TARGET_5,
	RAID_TARGET_6,
	RAID_TARGET_7,
	RAID_TARGET_8,
	("|cffff0000%s|r"):format(L.disable),
}

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	icon = 8,
	secondIcon = 7,
}

local function get(info)
	local key = info[#info]
	if not plugin.db.profile[key] then return 9
	else return plugin.db.profile[key] end
end
local function set(info, index)
	plugin.db.profile[info[#info]] = index > 8 and nil or index
end

plugin.pluginOptions = {
	type = "group",
	name = L.icons,
	get = get,
	set = set,
	args = {
		description = {
			type = "description",
			name = L.raidIconsDescription,
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		icon = {
			type = "select",
			name = L.primary,
			desc = L.primaryDesc,
			order = 2,
			values = icons,
			width = "full",
			itemControl = "DDI-RaidIcon",
		},
		secondIcon = {
			type = "select",
			name = L.secondary,
			desc = L.secondaryDesc,
			order = 3,
			values = icons,
			width = "full",
			itemControl = "DDI-RaidIcon",
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	if BigWigs.db.profile.raidicon then
		self:RegisterMessage("BigWigs_SetRaidIcon")
		self:RegisterMessage("BigWigs_RemoveRaidIcon")
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossReboot", "BigWigs_OnBossDisable")
	end
end

function plugin:BigWigs_OnBossDisable()
	if lastplayer[1] then
		SetRaidTarget(lastplayer[1], 0)
		lastplayer[1] = nil
	end
	if lastplayer[2] then
		SetRaidTarget(lastplayer[2], 0)
		lastplayer[2] = nil
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_SetRaidIcon(message, player, icon)
	if not player then return end
	local index = (not icon or icon == 1) and self.db.profile.icon or self.db.profile.secondIcon
	if not index or index == 9 then return end

	local oldIndex = GetRaidTargetIndex(player)
	if not oldIndex then
		SetRaidTarget(player, index)
		lastplayer[icon or 1] = player
	end
end

function plugin:BigWigs_RemoveRaidIcon(message, icon)
	if not BigWigs.db.profile.raidicon then return end
	if not lastplayer[icon or 1] then return end
	SetRaidTarget(lastplayer[icon or 1], 0)
	lastplayer[icon or 1] = nil
end

