
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vorasius", 2912, 2734)
if not mod then return end
mod:RegisterEnableMob(240434) -- Vorasius
mod:SetEncounterID(3177)
mod:SetPrivateAuraSounds({
	-- {1243016, sound = "alarm"}, -- Blisterburst (15s debuff) still used?
	1259186, -- Blisterburst
	{1272527, sound = "none"}, -- Creep Spit
	{1243220, 1243270, sound = "underyou"}, -- Dark Goo
	1241844, -- Smashed
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

		1260046, -- Primoridal Roar
		1241836, -- Smashing Frenzy
		1254199, -- Parasite Expulsion
		1243853, -- Void Breath
		1258967, -- Focused Aggression
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

