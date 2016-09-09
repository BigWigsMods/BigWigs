-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Raid Icons")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local lastplayer = {}

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
local icons = {
	RAID_TARGET_1,
	RAID_TARGET_2,
	RAID_TARGET_3,
	RAID_TARGET_4,
	RAID_TARGET_5,
	RAID_TARGET_6,
	RAID_TARGET_7,
	RAID_TARGET_8,
}

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	disabled = false,
	icon = 8,
	secondIcon = 7,
}

do
	local disabled = function() return plugin.db.profile.disabled end
	local function get(info)
		local key = info[#info]
		return plugin.db.profile[key]
	end
	local function set(info, index)
		plugin.db.profile[info[#info]] = index
	end
	plugin.pluginOptions = {
		type = "group",
		name = L.icons,
		get = get,
		set = set,
		args = {
			disabled = {
				type = "toggle",
				name = L.disabled,
				desc = L.raidIconsDesc,
				order = 1,
			},
			description = {
				type = "description",
				name = L.raidIconsDescription,
				order = 2,
				width = "full",
				fontSize = "medium",
				disabled = disabled,
			},
			icon = {
				type = "select",
				name = L.primary,
				desc = L.primaryDesc,
				order = 3,
				values = icons,
				width = "full",
				itemControl = "DDI-RaidIcon",
				disabled = disabled,
			},
			secondIcon = {
				type = "select",
				name = L.secondary,
				desc = L.secondaryDesc,
				order = 4,
				values = icons,
				width = "full",
				itemControl = "DDI-RaidIcon",
				disabled = disabled,
			},
		},
	}
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	-- XXX temp [v7.0]
	if self.db.profile.icon == 9 then self.db.profile.icon = 8 end
	if self.db.profile.secondIcon == 9 then self.db.profile.secondIcon = 7 end
	--

	self:RegisterMessage("BigWigs_SetRaidIcon")
	self:RegisterMessage("BigWigs_RemoveRaidIcon")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossReboot", "BigWigs_OnBossDisable")
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
	if not player or self.db.profile.disabled then return end
	local index = (not icon or icon == 1) and self.db.profile.icon or self.db.profile.secondIcon
	if not index then return end

	local oldIndex = GetRaidTargetIndex(player)
	if not oldIndex then
		SetRaidTarget(player, index)
		lastplayer[icon or 1] = player
	end
end

function plugin:BigWigs_RemoveRaidIcon(message, icon)
	if not lastplayer[icon or 1] or self.db.profile.disabled then return end
	SetRaidTarget(lastplayer[icon or 1], 0)
	lastplayer[icon or 1] = nil
end

