if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Wrathion", 2217, 2368)
if not mod then return end
mod:RegisterEnableMob(156523) -- Wrathion
mod.engageId = 2329
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
