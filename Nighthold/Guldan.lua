
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Gul'dan", 1088, 1737)
if not mod then return end
mod:RegisterEnableMob(105503) -- fix me
mod.engageId = 1866
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"berserk",
	}
end

function mod:OnBossEnable()
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Gul'dan (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--
