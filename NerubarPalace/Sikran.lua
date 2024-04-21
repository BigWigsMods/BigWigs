if not C_Spell then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sikran, Captain of the Sureki", 2657, 2599)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(2898)
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
