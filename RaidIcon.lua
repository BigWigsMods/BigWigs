assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsRaidIcon")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Raid Icons"] = true,

	["raidicon"] = true,
	["place"] = true,
	["icon"] = true,

	["Place"] = true,
	["Place Raid Icons"] = true,
	["Toggle placing of Raid Icons on players."] = true,
	
	["Icon"] = true,
	["Set Icon"] = true,
	["Set which icon to place on players."] = true,
	
	["Options for Raid Icons."] = true,

	["star"] = true,
	["circle"] = true,
	["diamond"] = true,
	["triangle"] = true,
	["moon"] = true,
	["square"] = true,
	["cross"] = true,
	["skull"] = true,

} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRaidIcon = BigWigs:NewModule(L"Raid Icons")
BigWigsRaidIcon.defaultDB = {
	place = true,
	icon = L"skull",
}
BigWigsRaidIcon.icontonumber = {
	[L"star"] = 1,
	[L"circle"] = 2,
	[L"diamond"] = 3,
	[L"triangle"] = 4,
	[L"moon"] = 5,
	[L"square"] = 6,
	[L"cross"] = 7,
	[L"skull"] = 8,
}
BigWigsRaidIcon.consoleCmd = L"raidicon"
BigWigsRaidIcon.consoleOptions = {
	type = "group",
	name = L"Raid Icons",
	desc = L"Options for Raid Icons.",
	args   = {
		[L"place"] = {
			type = "toggle",
			name = L"Place Raid Icons",
			desc = L"Toggle placing of Raid Icons on players.",
			get = function() return BigWigsRaidIcon.db.profile.place end,
			set = function(v) BigWigsRaidIcon.db.profile.place = v end,		
		},
		[L"icon"] = {
			type = "text",
			name = L"Set Icon",
			desc = L"Set which icon to place on players.",
			get = function() return BigWigsRaidIcon.db.profile.icon end,
			set = function(v) BigWigsRaidIcon.db.profile.icon = v end,
			validate = {L"star", L"circle", L"diamond", L"triangle", L"moon", L"square", L"cross", L"skull" },
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsRaidIcon:OnEnable()
	self:RegisterEvent("BigWigs_SetRaidIcon")
end

function BigWigsRaidIcon:BigWigs_SetRaidIcon(player)
	if not self.db.profile.place or not player then return end
	local icon = self.db.profile.icon
	if not self.icontonumber[icon] then
		icon = L"skull"
	end
	icon = self.icontonumber[icon]
	for i=1,GetNumRaidMembers() do
		if UnitName("raid"..i) == player then
			SetRaidTargetIcon("raid"..i, icon)
		end
	end
end
