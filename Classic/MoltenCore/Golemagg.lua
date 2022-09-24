
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Golemagg the Incinerator", 409, 1526)
if not mod then return end
mod:RegisterEnableMob(11988)
mod:SetEncounterID(670)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
	}
end

function mod:OnBossEnable()
 end

--------------------------------------------------------------------------------
-- Event Handlers
--

