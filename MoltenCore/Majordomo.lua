
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Majordomo Executus", 409)
if not mod then return end
mod:RegisterEnableMob(12018, 11663, 11664)
mod.toggleOptions = {20619, 21075}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!"
	L.power_next = "Next Power"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "MagicReflection", 20619)
	self:Log("SPELL_CAST_SUCCESS", "DamageShield", 21075)

	self:Yell("Win", L.disabletrigger)
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MagicReflection(args)
	self:Bar(args.spellId, 10)
	self:Message(args.spellId, "red", "Info")
	self:Bar(args.spellId, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(args.spellId, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

function mod:DamageShield(args)
	self:Bar(args.spellId, 10)
	self:Message(args.spellId, "red", "Info")
	self:Bar(args.spellId, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(args.spellId, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

