--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Precious", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37217)
mod:RegisterEnableMob(37025)
mod.toggleOptions = {71123}
 --71123: Decimate
 --71127: Mortal wound
 --71159: Zombies

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.wound_message = "%2$dx Mortal Wound on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "Wound", 71127)
	self:Death("Disable", 37212, 37025)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Wound(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 5 then
		self:TargetMessage(71127, L["wound_message"], player, "Important", icon, nil, stack)
	end
end

