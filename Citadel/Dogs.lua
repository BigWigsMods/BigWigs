--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Putricide Dogs", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37217, 37025)
mod.toggleOptions = {71127}

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
	self:Death("Disable", 37217, 37025)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Wound(player, spellId, _, _, _, stack)
	if stack > 5 then
		self:TargetMessage(71127, L["wound_message"], player, "Important", spellId, nil, stack)
	end
end

