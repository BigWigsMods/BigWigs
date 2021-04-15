--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Curator Raid", 532, 1557)
if not mod then return end
mod:RegisterEnableMob(15691)
mod:SetAllowWin(true)
mod:SetEncounterID(2448)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "The Menagerie is for guests only."

	L.weaken_message = "Evocation - Weakened for 20sec!"
	L.weaken_fade_message = "Evocation Finished - Weakened Gone!"
	L.weaken_fade_warning = "Evocation over in 5sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		30254, 30403, "proximity", "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Evocate", 30254)
	self:Log("SPELL_CAST_SUCCESS", "Infusion", 30403)

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 15691)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
	self:OpenProximity("proximity", 10)
	self:Berserk(600)
	self:CDBar(30254, 109)
	local evocation = self:SpellName(30254)
	self:DelayedMessage(30254, 39, "green", CL["custom_sec"]:format(evocation, 70))
	self:DelayedMessage(30254, 79, "yellow", CL["custom_sec"]:format(evocation, 30))
	self:DelayedMessage(30254, 99, "orange", CL["custom_sec"]:format(evocation, 10))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Evocate(args)
	self:MessageOld(args.spellId, "red", "alarm", L["weaken_message"])
	self:Bar(args.spellId, 20, CL["cast"]:format(args.spellName))
	self:DelayedMessage(args.spellId, 15, "orange", L["weaken_fade_warning"])
	self:DelayedMessage(args.spellId, 20, "red", L["weaken_fade_message"], false, "alarm")

	self:Bar(args.spellId, 115)
	self:DelayedMessage(args.spellId, 45, "green", CL["custom_sec"]:format(args.spellName, 70))
	self:DelayedMessage(args.spellId, 85, "yellow", CL["custom_sec"]:format(args.spellName, 30))
	self:DelayedMessage(args.spellId, 105, "orange", CL["custom_sec"]:format(args.spellName, 10))
end

function mod:Infusion(args)
	self:MessageOld(args.spellId, "red", nil, "15% - "..args.spellName)

	self:CancelAllTimers()
	self:StopBar(30254) -- Evocation
	self:StopBar(CL["cast"]:format(self:SpellName(30254))) -- Evocation
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 15691 then
		local hp = self:GetHealth(unit)
		if hp > 15 and hp < 20 then
			self:MessageOld(30403, "green", nil, CL["soon"]:format(self:SpellName(30403)), false) -- Arcane Infusion
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

