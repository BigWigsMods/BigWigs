------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Lurker Below"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lurker",

	dive = "Dive",
	dive_desc = ("Timers for when %s dives.\n\nThese timers my be innacurate, they are scheduled from pull."):format(boss),

	lazer = "Water Lazer",
	lazer_desc = "Timers for Water Lazer(name?).\n\nThese timers my be innacurate, they are scheduled from pull.",

	dive_warning1 = "%s Engaged - Dives in 90sec",
	dive_warning2 = "Dives in 60sec",
	dive_warning3 = "Dives in 30sec",
	dive_warning4 = "Dives in 10sec",
	dive_warning5 = "Dives in 5sec",
	dive_bar1 = "Dives in",

	dive_message1 = "Dives - Back in 60sec",
	dive_message2 = "Back in 30sec",
	dive_message3 = "Back in 10sec",
	dive_message4 = "Back in 5sec",
	dive_message5 = "Back - Dives in 90sec",
	dive_bar2 = "Back in",

	lazer_message1 = "Water Lazer!",
	lazer_message2 = "Water Lazer Over!",
	lazer_bar1 = "Water Lazer 1",
	lazer_bar2 = "Water Lazer 2",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"dive", "lazer", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	started = nil
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		self:NextDive()
		if self.db.profile.under then
			self:Message(L["dive_warning1"]:format(boss), "Attention")
		end
	end
end

--loop diving and lazer, no combat log events to register this, can become innacurate
function mod:NextDive()
	if self.db.profile.under then
		self:DelayedMessage(30, L["dive_warning2"], "Positive")
		self:DelayedMessage(60, L["dive_warning3"], "Positive")
		self:DelayedMessage(80, L["dive_warning4"], "Positive")
		self:DelayedMessage(85, L["dive_warning5"], "Urgent", nil, "Alarm")
		self:Bar(L["dive_bar1"], 90, "Spell_Frost_ArcticWinds")
	end

	self:ScheduleEvent("bwdive", self.NextSurface, 90, self)
end

function mod:NextSurface()
	if self.db.profile.under then
		self:Message(L["dive_message1"], "Attention")
		self:DelayedMessage(30, L["dive_message2"], "Positive")
		self:DelayedMessage(50, L["dive_message3"], "Positive")
		self:DelayedMessage(55, L["dive_message4"], "Urgent", nil, "Alert")
		self:DelayedMessage(60, L["dive_message5"], "Attention")
		self:Bar(L["dive_bar2"], 60, "Spell_Frost_Stun")
	end
	if self.db.profile.lazer then
		self:Bar(L["lazer_bar1"], 65, "INV_Weapon_Rifle_02")
		self:Bar(L["lazer_bar2"], 115, "INV_Weapon_Rifle_02")
		self:DelayedMessage(65, L["lazer_message1"], "Attention")
		self:DelayedMessage(85, L["lazer_message2"], "Positive")
		self:DelayedMessage(115, L["lazer_message1"], "Attention")
		self:DelayedMessage(135, L["lazer_message2"], "Positive")
		self:ScheduleEvent("bwlazerbar1", self.LazerBar, 65, self)
		self:ScheduleEvent("bwlazerbar2", self.LazerBar, 115, self)
	end

	self:ScheduleEvent("bwsurface", self.NextDive, 60, self)
end

function mod:LazerBar()
	self:Bar(L["lazer_message1"], 20, "INV_Weapon_Rifle_02")
end
