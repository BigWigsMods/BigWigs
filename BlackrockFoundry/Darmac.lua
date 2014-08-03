
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Beastlord Darmac", 988, 1122)
if not mod then return end
mod:RegisterEnableMob(
	76865 -- Beastlord Darmac (Unconfirmed)
)
mod.engageId = 1694

-- TODO: 
-- Transition warnings on 85%, 65%, 45%
-- Marking for spear, debuff on players (155365)
-- Announce Conflag for dispel (154981)
-- Announce add spawn (http://wod.wowhead.com/spell=154975) ~every 27s
-- Warn for Breath http://wod.wowhead.com/spell=154989
-- 7y range check caster/ranged when cruelfang is active, 
-- Announce Savage Howl (155198) for classes who can remove Enrage
-- For Tanks: Rend and Tear (http://wod.wowhead.com/spell=155061, taunt all 2 stacks?, Cruelfang), Seared Flesh (http://wod.wowhead.com/spell=155030, 6 stacks probably for taunt, Dreadwing), Crush Armor (http://wod.wowhead.com/spell=155236, Ironcrusher) 


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
