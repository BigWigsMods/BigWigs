if not BigWigsLoader.isBeta then return end -- Beta check

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Eggtender Ovi'nax", 2657, 2612)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(2919)
mod:SetRespawnTime(30)

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
		"stages",
	}
end

function mod:OnBossEnable()

end

function mod:OnEngage()
	self:Message("stages", "cyan", CL.stage:format(1), false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--
