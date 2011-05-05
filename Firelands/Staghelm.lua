--[[if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Majordomo Staghelm", 800)
if not mod then return end
mod:RegisterEnableMob(52571)

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		"bosskill"
	}, {
		bosskill = "general"
	}
end

function mod:OnBossEnable()

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 52571)
end

function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--
]]

