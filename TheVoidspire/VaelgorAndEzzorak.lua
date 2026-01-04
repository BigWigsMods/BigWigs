if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vaelgor & Ezzorak", 2912, 2735)
if not mod then return end
mod:RegisterEnableMob(242056, 244552) -- Vaelgor, Ezzorak
mod:SetEncounterID(3178)
mod:SetPrivateAuraSounds({
	1255612, -- Dread Breath
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

