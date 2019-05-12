if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Queen's Court", 2164, 2359)
if not mod then return end
mod:RegisterEnableMob(152853, 152852) -- Silivaz the Zealous, Pashmar the Fanatical
mod.engageId = 2311
--mod.respawnTime = 31


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

function mod:OnBossEnable()

end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--
