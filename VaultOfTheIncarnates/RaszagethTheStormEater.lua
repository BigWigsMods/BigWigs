if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Raszageth the Storm-Eater", 2522, 2499)
if not mod then return end
mod:RegisterEnableMob(182492) -- Raszageth the Storm-Eater (TODO confirm NPC ID)
mod:SetEncounterID(2607)
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

	}, {

	}
end

function mod:OnBossEnable()

end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

