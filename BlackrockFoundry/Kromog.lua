
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kromog", 1162, 868)
if not mod then return end
mod:RegisterEnableMob(
	77692, -- Kromog (unconfirmed)
)
mod.engageId = 1713

--------------------------------------------------------------------------------
-- Locals
--



--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		
	}
end

function mod:OnBossEnable()
	if self.lastKill and (GetTime() - self.lastKill) < 120 then -- Temp for outdated users enabling us
		self:ScheduleTimer("Disable", 5)
		return
	end

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
end

--------------------------------------------------------------------------------
-- Event Handlers
--
