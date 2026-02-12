
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Midnight Falls", 2913, 2740)
if not mod then return end
mod:RegisterEnableMob(240391) -- L'ura
mod:SetEncounterID(3183)
mod:SetPrivateAuraSounds({
	{1282027, sound = "underyou"}, -- The Darkwell
	{1282470, sound = "underyou"}, -- Dark Quasar
	-- {1254077, "underyou"}, -- Heaven's Glaives, Used?
	{1284984, 1286294, sound = "long"}, -- Grim Symphony
	-- 1249615, -- Death's Dirge, Used?
	{ 1249609, 1249565, 1249558, 1249562, 1249566, 1249550, 1273133 }, -- Dark Rune
	1249584, -- Dissonance
	1251789, -- Cosmic Fracture
	1284699, -- Light's End
	{1253031, sound = "info"}, -- Glimmering
	{1265842, sound = "alarm"}, -- Impaled
	{1262055, sound = "alert"}, -- Eclipsed
	{1279512, 1285510}, -- Starsplinter
	-- {1282035, 1282036, 1282039, 1282049, 1286406}, -- Into the Darkwell, Used?
	1282016, -- Iris of Oblivion
	1284527, -- Galvanize, also has a 2m duration 1284533, Used?
	1281184, -- Criticality
	{1284531, sound = "none"}, -- Decay
	{1263514, sound = "underyou"}, -- Midnight, also has 1266623, Used?
	-- 1266587, -- Dark Constellation, Used?
	{1275429, sound = "info"}, -- Severance (RIGHT?)
	{1266946, sound = "info"}, -- Severance (other side?)
	-- 1276531, -- Dimension Breach, Used?
	{1266113, 1266627, sound = "info"}, -- Tochbrearer
	{1253770, 1253104, sound = "info"}, -- Dawnlight Barrier
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
	}
end

function mod:OnRegister()

end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

