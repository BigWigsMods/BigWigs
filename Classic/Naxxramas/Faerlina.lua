--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Grand Widow Faerlina", 533)
if not mod then return end
mod:RegisterEnableMob(15953, 16505, 16506) -- Faerlina, Follower, Worshipper
mod:SetAllowWin(true)
mod:SetEncounterID(1110)

--------------------------------------------------------------------------------
-- Locals
--

local frenzied = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Grand Widow Faerlina"

	L.silencewarn = "Silenced!"
	L.silencewarn5sec = "Silence ends in 5 sec"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		28732, -- Widow's Embrace
		{28794, "FLASH"}, -- Rain of Fire
		28798, -- Enrage
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Silence", 28732)
	self:Log("SPELL_AURA_APPLIED", "Rain", 28794)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28798)
end

function mod:OnEngage()
	frenzied = nil
	self:Message(28798, "yellow", CL.custom_start_s:format(L.bossName, self:SpellName(28798), 60), false)
	self:DelayedMessage(28798, 45, "red", CL.soon:format(self:SpellName(28798)))
	self:Bar(28798, 60)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Silence(args)
	if not frenzied then
		-- preemptive, 30s silence
		self:Message(28732, "green", L.silencewarn)
		self:Bar(28732, 30, self:SpellName(15487)) -- 15487 = Silence
		self:DelayedMessage(28732, 25, "orange", L.silencewarn5sec)
	else
		-- Reactive enrage removed
		self:Message(28798, "green", CL.removed:format(self:SpellName(28798)))
		self:DelayedMessage(28798, 45, "red", CL.soon:format(self:SpellName(28798)))
		self:Bar(28798, 60)

		self:Bar(28732, 30, self:SpellName(15487)) -- 15487 = Silence
		self:DelayedMessage(28732, 25, "orange", L.silencewarn5sec)
		frenzied = nil
	end
end

function mod:Rain(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(28794)
		self:PlaySound(28794, "alarm")
		self:Flash(28794)
	end
end

function mod:Frenzy(args)
	self:StopBar(28798)
	self:CancelDelayedMessage(CL.soon:format(self:SpellName(28798)))

	frenzied = true
	self:Message(28798, "orange")
end

