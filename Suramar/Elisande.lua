if select(4, GetBuildInfo()) < 70000 then return end -- XXX legion check for live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Magistrix Elisande", 1033, 1743)
if not mod then return end
mod:RegisterEnableMob(106643) -- fix me
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
	self:Message("berserk", "Neutral", nil, "Grand Magistrix Elisande (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

