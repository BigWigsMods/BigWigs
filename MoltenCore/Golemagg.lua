
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Golemagg the Incinerator", 409)
if not mod then return end
mod:RegisterEnableMob(11988)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 11988)
 end

--------------------------------------------------------------------------------
-- Event Handlers
--

