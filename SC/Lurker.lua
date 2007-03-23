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

	spout = "Spout",
	spout_desc = "Timers for Spout.\n\nThese timers my be innacurate, they are scheduled from pull.",

	engage_warning = "%s Engaged - Dives in 90sec",

	dive_warning = "Dives in %dsec!",
	dive_bar = "Dives in",
	dive_message = "Dives - Back in 60sec",

	emerge_warning = "Back in %dsec",
	emerge_message = "Back - Dives in 90sec",
	emerge_bar = "Back in",

	spout_message1 = "Spout!",
	spout_message2 = "Spout Over!",
	spout_bar1 = "Spout 1",
	spout_bar2 = "Spout 2",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Coilfang Reservoir"]
mod.otherMenu = "Serpentshrine Cavern"
mod.enabletrigger = boss
mod.toggleoptions = {"dive", "spout", "bosskill"}
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
			self:Message(L["engage_warning"]:format(boss), "Attention")
		end
	end
end

--loop diving and lazer, no combat log events to register this, can become innacurate
function mod:NextDive()
	if self.db.profile.under then
		self:DelayedMessage(30, L["dive_warning"]:format(60), "Positive")
		self:DelayedMessage(60, L["dive_warning"]:format(30), "Positive")
		self:DelayedMessage(80, L["dive_warning"]:format(10), "Positive")
		self:DelayedMessage(85, L["dive_warning"]:format(5), "Urgent", nil, "Alarm")
		self:Bar(L["dive_bar"], 90, "Spell_Frost_ArcticWinds")
	end

	self:ScheduleEvent("bwdive", self.NextSurface, 90, self)
end

function mod:NextSurface()
	if self.db.profile.under then
		self:Message(L["dive_message"], "Attention")
		self:DelayedMessage(30, L["emerge_warning"]:format(30), "Positive")
		self:DelayedMessage(50, L["emerge_warning"]:format(10), "Positive")
		self:DelayedMessage(55, L["emerge_warning"]:format(5), "Urgent", nil, "Alert")
		self:DelayedMessage(60, L["emerge_message"], "Attention")
		self:Bar(L["emerge_bar"], 60, "Spell_Frost_Stun")
	end
	if self.db.profile.sprout then
		self:Bar(L["spout_bar1"], 65, "INV_Weapon_Rifle_02")
		self:Bar(L["spout_bar2"], 115, "INV_Weapon_Rifle_02")
		self:DelayedMessage(65, L["spout_message1"], "Attention")
		self:DelayedMessage(85, L["spout_message2"], "Positive")
		self:DelayedMessage(115, L["spout_message1"], "Attention")
		self:DelayedMessage(135, L["spout_message2"], "Positive")
		self:ScheduleEvent("bwspoutbar1", self.SpoutBar, 65, self)
		self:ScheduleEvent("bwspoutbar2", self.SpoutBar, 115, self)
	end

	self:ScheduleEvent("bwsurface", self.NextDive, 60, self)
end

function mod:SpoutBar()
	self:Bar(L["spout_message1"], 20, "INV_Weapon_Rifle_02")
end
