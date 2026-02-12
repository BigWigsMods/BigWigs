
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen-King Salhadaar", 2912, 2736)
if not mod then return end
mod:RegisterEnableMob(240432) -- Fallen-King Salhadaar
mod:SetEncounterID(3179)
mod:SetPrivateAuraSounds({
	{1250828, sound = "underyou"}, -- Void Exposure
	{1250991, sound = "alarm"}, -- Dark Radiation
	1245960, -- Void Infusion
	{1245592, sound = "underyou"}, -- Torturous Extract
	{1260030, sound = "underyou"}, -- Umbral Beams
	{1253024, 1268992}, -- Shattering Twilight (tank, others)
	{1251213, sound = "underyou"}, -- Twilight Spikes
	1248697, -- Despotic Command
	{1248709, sound = "alarm"}, -- Oppressive Darkness
	{1250686, sound = "none"}, -- Twisting Obscurity (Raid damage/dot)
	{1271577, sound = "alarm"}, -- Destabilizing Strikes
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

		1247738, -- Desperate Measures
		1250686, -- Twisting Obscurity
		1254081, -- Fractured Projection
		1260823, -- Despotic Command
		1253911, -- Shattering Twilight
		1246175, -- Cosmic Unraveling
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

