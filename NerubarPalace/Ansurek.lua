if not C_Spell then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Queen Ansurek", 2657, 2602)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(2922)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then

end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
	}
end

function mod:OnBossEnable()

end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--
