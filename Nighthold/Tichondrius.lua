
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tichondrius", 1088, 1762)
if not mod then return end
mod:RegisterEnableMob(103685) -- fix me
mod.engageId = 1862
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
	self:Message("berserk", "Neutral", nil, "Tichondrius (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--
