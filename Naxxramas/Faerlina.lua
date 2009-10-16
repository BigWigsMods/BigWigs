----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Grand Widow Faerlina", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(15953)
mod.toggleOptions = {28732, {28794, "FLASHSHAKE"}, 28798, "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local frenzied = nil
local frenzyName = GetSpellInfo(28798)
local frenzyMessageId = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Grand Widow Faerlina", "enUS", true)
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
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Grand Widow Faerlina")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Silence", 28732, 54097)
	self:Log("SPELL_AURA_APPLIED", "Rain", 28794, 54099)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28798, 54100) --Norm/Heroic
	self:Death("Win", 15953)

	started = nil
	frenzyMessageId = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Silence(unit, spellId, _, _, spellName, _, _, _, dGUID)
	local target = QueryQuestsCompleted and tonumber(dGUID:sub(-12, -9), 16) or tonumber(dGUID:sub(-12, -7), 16)
	if target ~= 15953 then return end
	if not frenzied then
		-- preemptive, 30s silence
		self:Message(28732, L["silencewarn"], "Positive", spellId)
		self:Bar(28732, L["silencebar"], 30, spellId)
		self:DelayedMessage(28732, 25, L["silencewarn5sec"], "Urgent")
	else
		-- Reactive enrage removed
		self:Message(28798, L["enrageremovewarn"], "Positive")
		frenzyMessageId = self:DelayedMessage(28798, 45, L["enragewarn2"], "Important")
		self:Bar(28798, frenzyName, 60, 28798)

		self:Bar(28732, L["silencebar"], 30, spellId)
		self:DelayedMessage(28732, 25, L["silencewarn5sec"], "Urgent")
		frenzied = nil
	end
end

function mod:Rain(player)
	if player == pName then
		self:LocalMessage(28794, L["rain_message"], "Personal", 54099, "Alarm")
		self:FlashShake(28794)
	end
end

function mod:Frenzy(unit, spellId, _, _, spellName, _, _, _, dGUID)
	local target = QueryQuestsCompleted and tonumber(dGUID:sub(-12, -9), 16) or tonumber(dGUID:sub(-12, -7), 16)
	if target ~= 15953 then return end
	self:Message(28798, L["enragewarn"], "Urgent", spellId)
	self:SendMessage("BigWigs_StopBar", self, spellName)
	if frenzyMessageId then
		self:CancelScheduledEvent(frenzyMessageId)
	end
	frenzied = true
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if not started and (msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"]) then
		self:Message(28798, L["startwarn"], "Urgent")
		frenzyMessageId = self:DelayedMessage(28798, 45, L["enragewarn2"], "Important")
		self:Bar(28798, frenzyName, 60, 28798)
		started = true --If I remember right, we need this as she sometimes uses an engage trigger mid-fight
		frenzied = nil
	end
end


