--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Grand Widow Faerlina", 533)
if not mod then return end
mod:RegisterEnableMob(15953, 16506, 16505) -- Faerlina, Worshipper, Follower
mod:SetAllowWin(true)
mod.engageId = 1110
mod.toggleOptions = {28732, {28794, "FLASHSHAKE"}, 28798, "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local started = nil
local frenzied = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Grand Widow Faerlina"

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
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Silence", 28732, 54097)
	self:Log("SPELL_AURA_APPLIED", "Rain", 28794, 54099)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28798, 54100)
	self:Death("Win", 15953)

	started = nil

	self:Yell("Engage", L["starttrigger1"], L["starttrigger2"], L["starttrigger3"], L["starttrigger4"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function mod:OnEngage()
	if not started then
		self:Message(28798, L["startwarn"], "Urgent")
		self:DelayedMessage(28798, 45, L["enragewarn2"], "Important")
		local frenzyName = GetSpellInfo(28798)
		self:Bar(28798, frenzyName, 60, 28798)
		started = true --If I remember right, we need this as she sometimes uses an engage trigger mid-fight
		frenzied = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Silence(unit, spellId)
	if unit ~= self.displayName then return end
	if not frenzied then
		-- preemptive, 30s silence
		self:Message(28732, L["silencewarn"], "Positive", spellId)
		self:Bar(28732, L["silencebar"], 30, spellId)
		self:DelayedMessage(28732, 25, L["silencewarn5sec"], "Urgent")
	else
		-- Reactive enrage removed
		self:Message(28798, L["enrageremovewarn"], "Positive")
		self:DelayedMessage(28798, 45, L["enragewarn2"], "Important")
		local frenzyName = GetSpellInfo(28798)
		self:Bar(28798, frenzyName, 60, 28798)

		self:Bar(28732, L["silencebar"], 30, spellId)
		self:DelayedMessage(28732, 25, L["silencewarn5sec"], "Urgent")
		frenzied = nil
	end
end

function mod:Rain(player)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(28794, L["rain_message"], "Personal", 54099, "Alarm")
		self:FlashShake(28794)
	end
end

function mod:Frenzy(unit, spellId, _, _, spellName)
	if unit == self.displayName then
		self:Message(28798, L["enragewarn"], "Urgent", spellId)
		self:SendMessage("BigWigs_StopBar", self, spellName)
		self:CancelDelayedMessage(L["enragewarn2"])
		frenzied = true
	end
end

