
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Flamebender Ka'graz", 988, 1123)
if not mod then return end
mod:RegisterEnableMob(
	76814 -- Flamebender Ka'graz (Unconfirmed)
)
mod.engageId = 1689 --might be wrong

-- TODO 
-- Molten Torrent every ~14.5s starting at 25 energy, mark on target, reverse range check for clumping
-- Adds coming in at 50 energy (http://wod.wowhead.com/spell=155776), low HP warning for them, have to be killed at the same time.
-- Fiery Link has to be dodged, leaves debuff, can be dispelled http://wod.wowhead.com/spell=155049
-- Blazing Radiance (http://wod.wowhead.com/spell=155382) every ~12s starting from 75 energy
-- Mark on BR target, has to run out, 10y range (http://wod.wowhead.com/spell=155277)
-- 10yd rangecheck for blazing radiance target
-- Firestorm at 100 energy (http://wod.wowhead.com/spell=155493)
-- Tank debuff during storm http://wod.wowhead.com/spell=163284 taunterino

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
