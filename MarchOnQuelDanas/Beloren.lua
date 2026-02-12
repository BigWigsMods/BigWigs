
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Belo'ren, Child of Al'ar", 2913, 2739)
if not mod then return end
mod:RegisterEnableMob(240387) -- Belo'ren
mod:SetEncounterID(3182)
mod:SetPrivateAuraSounds({
	1241292, -- Light Dive
	{1241840, sound = "underyou"}, -- Light Patch
	1241339, -- Void Dive
	{1241841, sound = "underyou"}, -- Void Patch
	{1262861, sound = "alarm"}, -- Guardian's Edict
	{1244348, sound = "alarm"}, -- Holy Burn
	{1266404, sound = "alarm"}, -- Void Burn
	-- {1282768, 1282776}, -- Infused Quills, Used?
	1241992, -- Light Quill
	1242091, -- Void Quill
	{1242803, sound = "underyou"}, -- Light Flames
	{1242815, sound = "underyou"}, -- Void Flames
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

		1241282, -- Embers of Del'ren
		1242981, -- Radiant Echoes
		1260763, -- Guardian's Edict
		1244344, -- Eternal Burns
		1242260, -- Infused Quills
		1246709, -- Death Drop

		1241313, -- Rebirth
		1242792, -- Incubation of Flames
	}, {
		[1241282] = -33025, -- Stage One: Phoenix Reborn
		[1241313] = -32160, -- Stage Two: Ashen Shell
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

