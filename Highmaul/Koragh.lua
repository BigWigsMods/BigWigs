
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Ko'ragh", 994, 1153)
if not mod then return end
mod:RegisterEnableMob(79015)
--mod.engageId = 1691

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
	return { "proximity", "bosskill" }
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

function mod:ExpelMagicFireApplied(args)
	if self:Healer() or self:Damager() == "RANGED" then
		self:OpenProximity("proximity", 7)
	end
end

function mod:ExpelMagicFireRemoved(args)
	self:CloseProximity()
end

