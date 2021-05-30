-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Raid Icons")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local lastplayer = {}
local SetRaidTarget = BigWigsLoader.SetRaidTarget

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
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
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Markers:20|t ".. L.icons,
		order = 11,
		get = get,
		set = set,
		args = {
			disabled = {
				type = "toggle",
				name = L.disabled,
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

do
	local function updateProfile()
		local db = plugin.db.profile

		for k, v in next, db do
			local defaultType = type(plugin.defaultDB[k])
			if defaultType == "nil" then
				db[k] = nil
			elseif type(v) ~= defaultType then
				db[k] = plugin.defaultDB[k]
			end
		end

		if db.icon < 1 or db.icon > 8 then
			db.icon = plugin.defaultDB.icon
		end
		if db.secondIcon < 1 or db.secondIcon > 8 then
			db.secondIcon = plugin.defaultDB.secondIcon
		end
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_SetRaidIcon")
		self:RegisterMessage("BigWigs_RemoveRaidIcon")
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")

		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()
	end
end

function plugin:BigWigs_OnBossDisable()
	if lastplayer[1] then
		SetRaidTarget(lastplayer[1], 0)
	end
	if lastplayer[2] then
		SetRaidTarget(lastplayer[2], 0)
	end
	lastplayer = {}
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_SetRaidIcon(_, player, icon)
	if not player or self.db.profile.disabled then return end
	local index = (not icon or icon == 1) and self.db.profile.icon or self.db.profile.secondIcon
	if not index then return end

	local oldIndex = GetRaidTargetIndex(player)
	if not oldIndex then
		SetRaidTarget(player, index)
		lastplayer[icon or 1] = player
	end
end

function plugin:BigWigs_RemoveRaidIcon(_, icon)
	if not lastplayer[icon or 1] or self.db.profile.disabled then return end
	SetRaidTarget(lastplayer[icon or 1], 0)
	lastplayer[icon or 1] = nil
end
