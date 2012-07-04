if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Empress Shek'zeer", 897, 743)
if not mod then return end
mod:RegisterEnableMob(10000000)


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
		"berserk", "bosskill",
	}, {
		berserk = "general",
	}
end

function mod:OnBossEnable()

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 10000000)
end

function mod:OnEngage(diff)

	self:Berserk(360) -- assume

end

--------------------------------------------------------------------------------
-- Event Handlers
--


