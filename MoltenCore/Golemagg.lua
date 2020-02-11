
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Golemagg the Incinerator", 409)
if not mod then return end
mod:RegisterEnableMob(11988)
mod:SetAllowWin(true)
mod.engageId = 670

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
	}
end

function mod:OnBossEnable()
	self:Death("Win", 11988)
 end

--------------------------------------------------------------------------------
-- Event Handlers
--

