if not IsTestBuild() then return end
if UnitFactionGroup("player") ~= "Alliance" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("King Rastakhan", 2070, 2335)
if not mod then return end
mod:RegisterEnableMob(0)
mod.engageId = 2272
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

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
