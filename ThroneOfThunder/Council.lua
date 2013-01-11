--[[
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Boss", 1000, 1000) -- module name, zone id, ej boss id
if not mod then return end
mod:RegisterEnableMob(100000)

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
		--"berserk", "bosskill",
	}, {
		--[] = "general",
	}
end

function mod:OnBossEnable()
	--self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	--self:Death("Win", 100000)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--
]]--

