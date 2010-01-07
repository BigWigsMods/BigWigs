--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Putricide Dogs", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(37217, 37025)
mod.toggleOptions = {71123}

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

do
	local prevStack = 0
	function mod:Wound(player, spellId, _, _, spellName)
		local _, _, icon, stack = UnitDebuff(player, spellName)
		if stack and stack > 5 and stack ~= prevStack then
			self:TargetMessage(71127, L["wound_message"], player, "Important", icon, nil, stack)
			prevStack = stack
		end
	end
end

