
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
--mod.engageId = 1691

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
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "ExpelMagicFireApplied", 162185)
	self:Log("SPELL_AURA_REMOVED", "ExpelMagicFireRemoved", 162185)

	self:Death("Win", 79015) -- Ko'ragh

end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function openProxitiy()
	if mod:Healer() or mod:DAMAGER() == "RANGED" then
		mod:OpenProximity("proximity", 7)
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:CheckBossStatus()
end

function mod:ExpelMagicFireApplied(args)
	openProxitiy()
end

function mod:ExpelMagicFireRemoved(args)
	self:CloseProximity()
end