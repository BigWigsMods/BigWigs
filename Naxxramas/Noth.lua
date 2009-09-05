----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Noth the Plaguebringer"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = boss
mod.zoneName = "Naxxramas"
mod.enabletrigger = 15954
mod.guid = 15954
mod.toggleOptions = {"blink", "teleport", 29213, "wave", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local timeroom = 90
local timebalcony = 70
local cursetime = 55
local wave1time = 10
local wave2time = 41

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Noth the Plaguebringer", "enUS", true)
if L then
	L.starttrigger1 = "Die, trespasser!"
	L.starttrigger2 = "Glory to the master!"
	L.starttrigger3 = "Your life is forfeit!"
	L.startwarn = "Noth the Plaguebringer engaged! 90 sec till teleport"

	L.blink = "Blink"
	L.blink_desc = "Warnings when Noth blinks."
	L.blinktrigger = "%s blinks away!"
	L.blinkwarn = "Blink!"
	L.blinkwarn2 = "Blink in ~5 sec!"
	L.blinkbar = "Blink"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnings and bars for teleport."
	L.teleportbar = "Teleport!"
	L.backbar = "Back in room!"
	L.teleportwarn = "Teleport! He's on the balcony!"
	L.teleportwarn2 = "Teleport in 10 sec!"
	L.backwarn = "He's back in the room for %d sec!"
	L.backwarn2 = "10 sec until he's back in the room!"

	L.curseexplosion = "Curse explosion!"
	L.cursewarn = "Curse! next in ~55 sec"
	L.curse10secwarn = "Curse in ~10 sec"
	L.cursebar = "Next Curse"

	L.wave = "Waves"
	L.wave_desc = "Alerts for the different waves."
	L.addtrigger = "Rise, my soldiers! Rise and fight once more!"
	L.wave1bar = "Wave 1"
	L.wave2bar = "Wave 2"
	L.wave2_message = "Wave 2 in 10 sec"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Noth the Plaguebringer")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Curse", 29213, 54835)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Curse(_, spellId)
	self:IfMessage(L["cursewarn"], "Important", spellId, "Alarm")
	self:ScheduleEvent("bwnothcurse", "BigWigs_Message", cursetime - 10, L["curse10secwarn"], "Urgent")
	self:Bar(L["cursebar"], cursetime, spellId)
	self:Bar(L["curseexplosion"], 10, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if msg == L["blinktrigger"] and self.db.profile.blink then
		self:IfMessage(L["blinkwarn"], "Important", 29208)
		self:ScheduleEvent("bwnothblink", "BigWigs_Message", 34, L["blinkwarn2"], "Attention")
		self:Bar(L["blinkbar"], 39, 29208)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		timeroom = 90
		timebalcony = 70
		cursetime = 55
		wave1time = 10
		wave2time = 41

		if self.db.profile.teleport then
			self:Message(L["startwarn"], "Important")
			self:DelayedMessage(timeroom - 10, L["teleportwarn2"], "Urgent")
			self:Bar(L["teleportbar"], timeroom, "Spell_Magic_LesserInvisibilty")
		end
		if GetRaidDifficulty() == 2 and self.db.profile.blink then
			self:DelayedMessage(25, L["blinkwarn2"], "Attention")
			self:Bar(L["blinkbar"], 30, 29208)
		end
		self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, timeroom, self)
	end
end

function mod:teleportToBalcony()
	if timeroom == 90 then
		timeroom = 110
	elseif timeroom == 110 then
		timeroom = 180
	end

	self:CancelScheduledEvent("bwnothblink")
	self:CancelScheduledEvent("bwnothcurse")
	self:SendMessage("BigWigs_StopBar", self, L["blinkbar"])
	self:SendMessage("BigWigs_StopBar", self, L["cursebar"])

	if self.db.profile.teleport then
		self:Message(L["teleportwarn"], "Important")
		self:Bar(L["backbar"], timebalcony, "Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothback", "BigWigs_Message", timebalcony - 10, L["backwarn2"], "Urgent")
	end
	if self.db.profile.wave then
		self:Bar(L["wave1bar"], wave1time, "Spell_ChargePositive")
		self:Bar(L["wave2bar"], wave2time, "Spell_ChargePositive")
		self:ScheduleEvent("bwnothwave2inc", "BigWigs_Message", wave2time - 10, L["wave2_message"], "Urgent")
	end
	self:ScheduleEvent("bwnothtoroom", self.teleportToRoom, timebalcony, self)
	wave2time = wave2time + 15
end

function mod:teleportToRoom()
	if timebalcony == 70 then
		timebalcony = 95
	elseif timebalcony == 95 then
		timebalcony = 120
	end

	if self.db.profile.teleport then
		self:Message(L["backwarn"]:format(timeroom), "Important")
		self:Bar(L["teleportbar"], timeroom, "Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothteleport", "BigWigs_Message", timeroom - 10, L["teleportwarn2"], "Urgent")
	end
	self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, timeroom, self)
end

