
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nythendra", 1520)
if not mod then return end
mod:RegisterEnableMob(103160) -- fix me
--mod.engageId = 1000000
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
	self:Message("berserk", "Neutral", nil, "Nythendra (Beta) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

