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
	L["Star"],
	L["Circle"],
	L["Diamond"],
	L["Triangle"],
	L["Moon"],
	L["Square"],
	L["Cross"],
	L["Skull"],
	L["|cffff0000Disable|r"],
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
	name = L["Icons"],
	get = get,
	set = set,
	args = {
		description = {
			type = "description",
			name = L.raidIconDescription,
			order = 1,
			width = "full",
			fontSize = "medium",
		},
		icon = {
			type = "select",
			name = L["Primary"],
			desc = L["The first raid target icon that a encounter script should use."],
			order = 2,
			values = icons,
			width = "full",
		},
		secondIcon = {
			type = "select",
			name = L["Secondary"],
			desc = L["The second raid target icon that a encounter script should use."],
			order = 3,
			values = icons,
			width = "full",
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_SetRaidIcon")
	self:RegisterMessage("BigWigs_RemoveRaidIcon")
	self:RegisterMessage("BigWigs_OnBossDisable")
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
	if not BigWigs.db.profile.raidicon then return end
	if not player then return end
	if not GetRaidTargetIndex(player) then
		local index = (not icon or icon == 1) and self.db.profile.icon or self.db.profile.secondIcon
		if not index then return end
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

