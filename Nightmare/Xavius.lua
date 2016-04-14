
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Xavius", 1094, 1726)
if not mod then return end
mod:RegisterEnableMob(103769) -- fix me
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
	self:Message("berserk", "Neutral", nil, "Xavius (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

