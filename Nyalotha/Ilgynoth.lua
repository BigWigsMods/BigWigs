if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Il'gynoth, Corruption Reborn", 2217, 2374)
if not mod then return end
mod:RegisterEnableMob(158328, 105393) -- l'gynoth <Corruption Reborn>, Il'gynoth <The Heart of Corruption>
mod.engageId = 2345
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
