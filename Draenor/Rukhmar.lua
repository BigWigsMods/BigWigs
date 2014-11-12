
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rukhmar", 948, 1262)
if not mod then return end
mod:RegisterEnableMob(83746)
mod.otherMenu = 962
mod.worldBoss = 83746

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{167615, "TANK"}, 167687, 167650, "bosskill"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_AURA_APPLIED", "PierceArmor", 167615)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PierceArmor", 167615)
	self:Log("SPELL_CAST_START", "SolarBreath", 167687)
	self:Log("SPELL_AURA_APPLIED", "LooseQuills", 167650)

	self:Death("Win", 83746)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PierceArmor(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Warning")
end

function mod:SolarBreath(args)
	self:Message(args.spellId, "Urgent")
end

function mod:LooseQuills(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 30)
end

