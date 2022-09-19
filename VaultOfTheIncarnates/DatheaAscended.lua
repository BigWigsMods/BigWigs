if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dathea, Ascended", 2522, 2502)
if not mod then return end
mod:RegisterEnableMob(189813) -- Dathea, Ascended
mod:SetEncounterID(2635)
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

