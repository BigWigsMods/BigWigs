
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Majordomo Executus", 409)
if not mod then return end
mod:RegisterEnableMob(12018, 11663, 11664)
mod:SetAllowWin(true)
mod.engageId = 671

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Majordomo Executus"

	L.disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!"
	L.power_next = "Next Power"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		20619, -- Magic Reflection
		21075, -- Damage Shield
		{20534, "TANK"}, -- Teleport
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "MagicReflection", self:SpellName(20619))
	self:Log("SPELL_CAST_SUCCESS", "DamageShield", self:SpellName(21075))
	self:Log("SPELL_CAST_SUCCESS", "Teleport", self:SpellName(20534))

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

function mod:OnEngage()
	self:Bar(20534, 20) -- Teleport
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg:find(L.disabletrigger, nil, true) then
		self:Win()
	end
end

function mod:MagicReflection(args)
	self:Bar(20619, 10)
	self:Message(20619, "red")
	self:PlaySound(20619, "info")
	self:Bar(20619, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(20619, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

function mod:DamageShield(args)
	self:Bar(21075, 10)
	self:Message(21075, "red")
	self:PlaySound(21075, "info")
	self:Bar(21075, 30, L.power_next, "ability_warlock_improvedsoulleech")
	self:DelayedMessage(21075, 25, "orange", CL.custom_sec:format(L.power_next, 5))
end

function mod:Teleport(args)
	self:CDBar(20534, 25) -- 25-30
end
