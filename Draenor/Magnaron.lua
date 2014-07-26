--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Magnaron", 962, 1212)
if not mod then return end
mod:RegisterEnableMob(69099)
mod.otherMenu = 6
mod.worldBoss = 69099

--------------------------------------------------------------------------------
-- Locals
--

local openedForMe = nil
local stormcloudTargets = {}

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
	return { }
end

function mod:OnBossEnable()
	
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 69099)
end

function mod:OnEngage()
	
end

--------------------------------------------------------------------------------
-- Event Handlers
--

