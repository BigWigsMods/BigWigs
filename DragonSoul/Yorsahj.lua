--[[if tonumber((select(4, GetBuildInfo()))) < 40300 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Yor'sahj the Unsleeping", 824, EJBossId)
if not mod then return end
mod:RegisterEnableMob(npcId)

--------------------------------------------------------------------------------
-- Locales
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

	}, {

	}
end

function mod:OnBossEnable()

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", npcId)
end

function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--
]]--

