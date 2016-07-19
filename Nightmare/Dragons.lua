
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dragons of Nightmare", 1094, 1704)
if not mod then return end
mod:RegisterEnableMob( -- fix me
	102679, -- Ysondre
	102681, -- Taerar
	102682, -- Lethon
	102683  -- Emeriss
)
mod.engageId = 1854
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
	self:Message("berserk", "Neutral", nil, "Dragons of Nightmare (Alpha) Engaged")
end

--------------------------------------------------------------------------------
-- Event Handlers
--
