if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Beloren", 2913, 2739)
if not mod then return end
mod:RegisterEnableMob(240387) -- Beloren
mod:SetEncounterID(3182)
-- mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		"berserk",
	}
end

function mod:OnRegister()

end

function mod:OnBossEnable()

end

function mod:OnEngage()
	self:Message("berserk", "red", "Beloren Engaged!", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

