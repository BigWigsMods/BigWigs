
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rukhmar", 948, 1262)
if not mod then return end
mod:RegisterEnableMob(83746)
mod.otherMenu = 962
mod.worldBoss = 83746
--BOSS_KILL#1755#Rukhmar, Sun-God of the Arakkoa

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
		{167615, "TANK"}, -- Pierce Armor
		167679, -- Solar Breath
		167647, -- Loose Quills
		{167757, "FLASH"}, -- Fixate
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Log("SPELL_AURA_APPLIED", "PiercedArmor", 167615)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PiercedArmor", 167615)
	self:Log("SPELL_CAST_START", "SolarBreath", 167679)
	self:Log("SPELL_AURA_APPLIED", "LooseQuills", 167647)
	self:Log("SPELL_AURA_REMOVED", "LooseQuillsOver", 167647)

	self:RegisterEvent("RAID_BOSS_WHISPER")

	self:Death("Win", 83746)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:RAID_BOSS_WHISPER()
	-- RAID_BOSS_WHISPER_SYNC#|TInterface\\Icons\\ability_fixated_state_red:20|tA Phoenix has |cFFFF0000fixated|r on you! If it reaches you it will |cFFFF0000|Hspell:167630|h[Explode]|h|r!
	self:Message(167757, "Personal", "Alarm", CL.you:format(self:SpellName(167757)))
	self:Flash(167757)
end

function mod:PiercedArmor(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Warning")
end

function mod:SolarBreath(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 28)
end

function mod:LooseQuills(args)
	self:Message(args.spellId, "Attention", "Long")
	self:Bar(args.spellId, 30)
	self:StopBar(167679) -- Solar Breath
end

function mod:LooseQuillsOver(args)
	self:Message(args.spellId, "Attention", nil, CL.over:format(args.spellName))
end

