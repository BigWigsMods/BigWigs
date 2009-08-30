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

plugin.consoleCmd = L["RaidIcon"]
plugin.advancedOptions = {
	type = "group",
	name = L["Raid Icons"],
	desc = L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."],
	args   = {
		place = {
			type = "toggle",
			name = L["Place Raid Icons"],
			desc = L["Toggle placing of Raid Icons on players."],
			get = function() return plugin.db.profile.place end,
			set = function(v) plugin.db.profile.place = v end,
			order = 1,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		Star = {
			type = "toggle",
			name = L["Star"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Star"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 101,
			passValue = 1,
		},
		Circle = {
			type = "toggle",
			name = L["Circle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Circle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 102,
			passValue = 2,
		},
		Diamond = {
			type = "toggle",
			name = L["Diamond"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Diamond"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 103,
			passValue = 3,
		},
		Triangle = {
			type = "toggle",
			name = L["Triangle"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Triangle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 104,
			passValue = 4,
		},
		Moon = {
			type = "toggle",
			name = L["Moon"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Moon"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 105,
			passValue = 5,
		},
		Square = {
			type = "toggle",
			name = L["Square"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Square"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 106,
			passValue = 6,
		},
		Cross = {
			type = "toggle",
			name = L["Cross"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Cross"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 107,
			passValue = 7,
		},
		Skull = {
			type = "toggle",
			name = L["Skull"],
			desc = fmt(L["Use the %q icon when automatically placing raid icons for boss abilities."], L["Skull"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 108,
			passValue = 8,
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

