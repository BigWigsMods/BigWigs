
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vaelgor & Ezzorak", 2912, 2735)
if not mod then return end
mod:RegisterEnableMob(242056, 244552) -- Vaelgor, Ezzorak
mod:SetEncounterID(3178)
mod:SetPrivateAuraSounds({
	{1262656, 1262676, 1262999, sound = "alarm"}, -- Nullbeam
	{1244672, sound = "underyou"}, -- Nullzone
	{1252157, sound = "alert"}, -- Nullzone Implosion
	1255612, -- Dread Breath (Targetted)
	{1255979, sound = "alarm"}, -- Dread Breath (Feared)
	{1264467, sound = "underyou"}, -- Tail Lash
	{1245554, sound = "alert"},-- Gloomtouched
	{1270852, sound = "none"}, -- Diminish
	{1245421, sound = "underyou"}, -- Gloomfield
	{1245059, sound = "alarm"}, -- Void Howl
	{1245175, sound = "none"}, -- Voidbolt
	-- {1280355, sound = "alarm"}, -- Rakfang Too spammy?
	1265152, -- Impale
	{1248865, 1249595, sound = "info"}, -- Radiant Barrier
	1270497, -- Shadowmark
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
		1249748, -- Midnight Flames
		1248847, -- Radiant Barrier

		-- Vaelgor
		{1244221, "PRIVATE"}, -- Dread Breath
		1262623, -- Nullbeam
		1265131, -- Vaelwing

		-- Ezzorak
		1244917, -- Void Howl
		1245391, -- Gloom
		1245645, -- Rakfang
	}, {
		[1244221] = -33241, -- Vaelgor
		[1244917] = -33255, -- Ezzorak
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

