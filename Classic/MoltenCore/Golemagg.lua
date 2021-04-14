
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Golemagg the Incinerator", 409)
if not mod then return end
mod:RegisterEnableMob(11988)
mod:SetAllowWin(true)
mod:SetEncounterID(670)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Golemagg the Incinerator"
end
L = mod:GetLocale()

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

