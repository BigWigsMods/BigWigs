if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Primal Council", 2522, 2486)
if not mod then return end
mod:RegisterEnableMob(
	187771, -- Kadros Icewrath
	189816, -- Dathea Stormlash
	187772, -- Opalfang
	187767  -- Embar Firepath
)
mod:SetEncounterID(2590)
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

