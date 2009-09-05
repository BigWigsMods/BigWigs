----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Grand Widow Faerlina"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15953
mod.toggleOptions = {28732, 28794, "enrage", "bosskill"}
mod.consoleCmd = "Faerlina"

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local enraged = nil
local enrageName = GetSpellInfo(28798)
local enrageMessageId = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faerlina", "enUS", true)
if L then
	L.starttrigger1 = "Kneel before me, worm!"
	L.starttrigger2 = "Slay them in the master's name!"
	L.starttrigger3 = "You cannot hide from me!"
	L.starttrigger4 = "Run while you still can!"

	L.startwarn = "Faerlina engaged, 60 sec to frenzy!"
	L.enragewarn15sec = "15 sec to frenzy!"
	L.enragewarn = "Frenzied!"
	L.enragewarn2 = "Frenzied Soon!"
	L.enrageremovewarn = "Frenzy removed! ~60 sec until next!"

	L.silencewarn = "Silenced!"
	L.silencewarn5sec = "Silence ends in 5 sec"
	L.silencebar = "Silence"

	L.rain_message = "Fire on YOU!"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Faerlina")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Silence", 28732, 54097)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rain", 28794, 54099)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 28798, 54100) --Norm/Heroic
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	enrageMessageId = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Silence(unit, spellId)
	if not UnitIsUnit(unit, boss) then return end
	if not enraged then
		-- preemptive, 30s silence
		self:IfMessage(L["silencewarn"], "Positive", spellId)
		self:Bar(L["silencebar"], 30, spellId)
		self:DelayedMessage(25, L["silencewarn5sec"], "Urgent")
	else
		-- Reactive enrage removed
		if self.db.profile.enrage then
			self:Message(L["enrageremovewarn"], "Positive")
			enrageMessageId = self:DelayedMessage(45, L["enragewarn2"], "Important")
			self:Bar(enrageName, 60, 28798)
		end
		self:Bar(L["silencebar"], 30, spellId)
		self:DelayedMessage(25, L["silencewarn5sec"], "Urgent")
		enraged = nil
	end
end

function mod:Rain(player)
	if player == pName then
		self:LocalMessage(L["rain_message"], "Personal", 54099, "Alarm")
	end
end

function mod:Enrage(unit, spellId, _, _, spellName)
	if not UnitIsUnit(unit, boss) then return end
	if self.db.profile.enrage then
		self:IfMessage(L["enragewarn"], "Urgent", spellId)
	end
	self:SendMessage("BigWigs_StopBar", self, enrageName)
	if enrageMessageId then
		self:CancelScheduledEvent(enrageMessageId)
	end
	enraged = true
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not started and (msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"]) then
		self:Message(L["startwarn"], "Urgent")
		if self.db.profile.enrage then
			enrageMessageId = self:DelayedMessage(45, L["enragewarn2"], "Important")
			self:Bar(enrageName, 60, 28798)
		end
		started = true --If I remember right, we need this as she sometimes uses an engage trigger mid-fight
		enraged = nil
	end
end


