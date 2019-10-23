if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Hivemind", 2217, 2372)
if not mod then return end
mod:RegisterEnableMob(157253, 157254) -- Ka'zir, Tek'ris
mod.engageId = 2333
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

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
