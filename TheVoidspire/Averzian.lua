
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Averzian", 2912, 2733)
if not mod then return end
mod:RegisterEnableMob(240435) -- Imperator Averzian
mod:SetEncounterID(3176)
mod:SetPrivateAuraSounds({
	{1255680, sound = "alarm"}, -- Gnashing Void
	{1275059, sound = "alert"}, -- Black Miasma
	{1249265, 1260203}, -- Umbral Collapse (Targetted)
	-- {1249309, sound = "alarm"}, -- Umbral Collapse (DoT effect), still used?
	-- {1249716, 1265398}, -- Umbral Collapse (Unknown Aura)
	1280023, -- Void Marked
	{1280075, sound = "info"}, -- Lingering Darkness (DoT effect after dispel)
	{1260981, sound = "underyou"}, -- March of the Endless
	{1265540, sound = "alarm"}, -- Blackening Wounds
	1283069, -- Weakened
})

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

