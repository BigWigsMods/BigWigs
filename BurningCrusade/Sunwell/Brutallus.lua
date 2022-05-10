--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Brutallus", 580, 1592)
if not mod then return end
mod:RegisterEnableMob(24882)
mod:SetAllowWin(true)
mod:SetEncounterID(725)
-- mod:SetRespawnTime(0) -- doesn't despawn

--------------------------------------------------------------------------------
-- Locals
--

local meteorCounter = 1
local sayTimer1, sayTimer2

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Ah, more lambs to the slaughter!"

	L.burnresist = "Burn Resist"
	L.burnresist_desc = "Warn who resists burn."
	L.burnresist_icon = 45141
	L.burn_resist = "%s resisted Burn"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{46394, "ICON", "SAY", "PROXIMITY"}, -- Burn
		"burnresist",
		45150, -- Meteor Slash
		45185, -- Stomp
		"berserk",
	}
end

function mod:OnBossEnable()
	-- self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage") -- you go into combat during the RP
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_AURA_APPLIED", "BurnApplied", 46394)
	self:Log("SPELL_AURA_REMOVED", "BurnRemoved", 46394)
	self:Log("SPELL_MISSED", "BurnResist", 45141)
	self:Log("SPELL_CAST_START", "Meteor", 45150)
	self:Log("SPELL_CAST_SUCCESS", "Stomp", 45185)

	self:BossYell("Engage", L.engage_trigger)

	self:Death("Win", 24882)
end

function mod:OnEngage()
	meteorCounter = 1
	self:Berserk(360)
	self:Bar(46394, 20) -- Burn
	self:DelayedMessage(46394, 16, "yellow", CL.soon:format(self:SpellName(46394))) -- Burn
	self:Bar(45185, 30) -- Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BurnApplied(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "warning")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 60, args.destName)
	self:Bar(args.spellId, 20)
	self:DelayedMessage(args.spellId, 16, "yellow", CL.soon:format(args.spellName))
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		sayTimer1 = self:ScheduleTimer("Say", 50, args.spellId, 10, true)
		sayTimer2 = self:ScheduleTimer("Say", 55, args.spellId, 5, true)
		self:ShowPromixty(args.spellId, 5) -- spread distance is 2 yards
	end
end

function mod:BurnRemoved(args)
	self:StopBar(args.spellName, args.destName)
	if self:Me(args.destGUID) then
		self:CancelTimer(sayTimer1)
		self:CancelTimer(sayTimer2)
		self:CloseProximity(args.spellId)
		self:MessageOld(args.spellId, "green", "info", CL.over:format(args.spellName))
	end
end

function mod:BurnResist(args)
	self:MessageOld("burnresist", "green", nil, L.burn_resist:format(args.destName), args.spellId)
end

function mod:Meteor(args)
	self:MessageOld(args.spellId, "orange", "alert", CL.count:format(args.spellName, meteorCounter))
	meteorCounter = meteorCounter + 1
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, meteorCounter))
end

function mod:Stomp(args)
	self:TargetMessageOld(args.spellId, args.destName, "orange")
	self:DelayedMessage(args.spellId, 25.5, "yellow", CL.custom_sec:format(args.spellName, 5))
	self:Bar(args.spellId, 30.5)
end
