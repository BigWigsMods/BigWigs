
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

	self:Log("SPELL_CAST_SUCCESS", "MagicReflection", self:SpellName(20619))
	self:Log("SPELL_CAST_SUCCESS", "DamageShield", self:SpellName(21075))

	self:Yell("Win", L.disabletrigger)
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MagicReflection(args)
	self:Bar(20619, 10)
	self:Message(20619, "red", "Info")
	self:Bar(20619, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(20619, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

function mod:DamageShield(args)
	self:Bar(21075, 10)
	self:Message(21075, "red", "Info")
	self:Bar(21075, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(21075, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

