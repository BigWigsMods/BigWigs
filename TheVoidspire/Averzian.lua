if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Averzian", 2912, 2733)
if not mod then return end
mod:RegisterEnableMob(240435) -- Imperator Averzian
mod:SetEncounterID(3176)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() -- SetOption:skip-unused
	return {
		"stages",

		1249251, -- Dark Upheaval
		1251361, -- Shadow's Advance
		1249265, -- Umbral Collapse
		1260712, -- Oblivion's Wrath
		1270949, -- Desolation
		1258880, -- Void Fall
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

