
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Botanist Tel'arn", 1033, 1761)
if not mod then return end
mod:RegisterEnableMob(109038) -- fix me
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
	self:Message("berserk", "Neutral", nil, "High Botanist Tel'arn (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

