
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Blast Furnace", 1154, 868)
if not mod then return end
mod:RegisterEnableMob(
	76809, -- Foreman Feldspar
	76809, -- Blackrock Security
	76809, -- Blackrock Engineer
	76809, -- Blackrock Bellows Operator
	76809, -- Primal Elementalist
	76809, -- Firecaller
	76809, -- Slag Elemental
	76809, -- Fury (just listed all the mobs from dungeon journal)
)
mod.engageId = 1690

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
