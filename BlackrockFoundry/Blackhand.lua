
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Blackhand", 959, 868)
if not mod then return end
mod:RegisterEnableMob(
	72249, 72358, -- Galakras, Kor'kron Cannon
	72560, 72561, 73909, -- Horde: Lor'themar Theron, Lady Sylvanas Windrunner, Archmage Aethas Sunreaver
	72311, 72302, 73910 -- Alliance: King Varian Wrynn, Lady Jaina Proudmoore, Vereesa Windrunner
)
mod.engageId = 1622

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
