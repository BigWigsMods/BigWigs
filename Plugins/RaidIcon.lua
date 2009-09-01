----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("Raid Icons", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local lastplayer = nil

local fmt = string.format
local SetIcon = SetRaidTarget

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	place = true,
	icon = 8,
}

local function get(key)
	return plugin.db.profile.icon == key
end
local function set(key, val)
	plugin.db.profile.icon = key
end
local function disabled()
	return not plugin.db.profile.place
end

plugin.pluginOptions = {
	type = "group",
	name = L["Raid Icons"],
	desc = L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."],
	args = {
		Star = {
			type = "toggle",
			name = L["Star"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Star"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 101,
		},
		Circle = {
			type = "toggle",
			name = L["Circle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Circle"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 102,
		},
		Diamond = {
			type = "toggle",
			name = L["Diamond"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Diamond"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 103,
		},
		Triangle = {
			type = "toggle",
			name = L["Triangle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Triangle"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 104,
		},
		Moon = {
			type = "toggle",
			name = L["Moon"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Moon"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 105,
		},
		Square = {
			type = "toggle",
			name = L["Square"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Square"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 106,
		},
		Cross = {
			type = "toggle",
			name = L["Cross"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Cross"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 107,
		},
		Skull = {
			type = "toggle",
			name = L["Skull"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Skull"]),
			get = get,
			set = set,
			disabled = disabled,
			order = 108,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_SetRaidIcon")
	self:RegisterEvent("BigWigs_RemoveRaidIcon")

	if type(self.db.profile.icon) ~= "number" then
		self.db.profile.icon = 8
	end
end

function plugin:BigWigs_SetRaidIcon(player)
	if not player or not self.db.profile.place then return end
	if not GetRaidTargetIndex(player) then
		SetIcon(player, self.db.profile.icon or 8)
		lastplayer = player
	end
end

function plugin:BigWigs_RemoveRaidIcon()
	if not lastplayer or not self.db.profile.place then return end
	SetIcon(lastplayer, 0)
	lastplayer = nil
end

