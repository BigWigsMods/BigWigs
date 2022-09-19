if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Basrikron, The Shale Wing", -2022, 2506)
if not mod then return end
mod:RegisterEnableMob(193535) -- Basrikron
mod.otherMenu = -1978
mod.worldBoss = 193535

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

	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2640 then
		self:Win()
	end
end
