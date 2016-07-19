
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elerethe Renferal", 1094, 1744)
if not mod then return end
mod:RegisterEnableMob(106087) -- fix me
mod.engageId = 1876
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
	self:Message("berserk", "Neutral", nil, "Elerethe Renferal (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--
