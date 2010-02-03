--------------------------------------------------------------------------------
-- Module Declaration
--
--[[
local mod = BigWigs:NewBoss("The Lich King", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(29983)
mod.toggleOptions = {"bosskill"}

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


function mod:OnBossEnable()
	

	self:Death("Win", 29983)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

]]

