
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Crown of the Cosmos", 2912, 2738)
if not mod then return end
mod:RegisterEnableMob(240430, 243805, 243810, 243811) -- Alleria, Morium, Demiar, Vorelus
mod:SetEncounterID(3181)
mod:SetPrivateAuraSounds({
	1233602, -- Silverstrike Arrow (Targetted)
	{1232470, 1260027, sound = "alert"}, -- Grasp of Emptiness
	1283236, -- Void Expulsion (Targetted)
	{1242553, sound = "underyou"}, -- Void Remnants
	{1233865, 1233887, sound = "alarm"}, -- Null Corona
	{1243753, sound = "alert"}, -- Ravenous Abyss
	{1243981, sound = "none"}, -- Silverstrike Barrage
	{1234570, sound = "alert"}, -- Stellar Emission
	{1246462, sound = "alarm"}, -- Rift Slash
	{1238206, sound = "underyou"}, -- Volatile Fissure
	{1237623, 1259861}, -- Ranger Captain's Mark (Targetted)
	{1237038, sound = "alarm"}, -- Voidstalker's Sting
	{1227557, sound = "underyou"}, -- Devouring Cosmos
	1239111, -- Aspect of the End
	{1255453, sound = "alarm"}, -- Gravity Collapse
	{1238708, sound = "info"}, -- Dark Rush
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

		-- Stage One: The Void's Spire
		1233602, -- Silverstrike Arrow
		1232467, -- Grasp of Emptiness
		1255368, -- Void Expulsion
		1233865, -- Null Corona
		1233787, -- Dark Hand (Morium)
		1243743, -- Interrupting Tremor (Demiar)
		1243753, -- Ravenous Abyss (Vorelus)

		-- Intermission: Crushing Singularity
		1234569, -- Stellar Emission
		1243982, -- Silverstrike Barrage
		1235622, -- Singularity Eruption

		-- Stage Two: The Severed Rift
		1238206, -- Volatile Fissure
		1237614, -- Ranger Captain's Mark
		-- 1255368, -- Void Expulsion
		1237038, -- Voidstalker's Sting
		1237837, -- Call of the Void
		1246918, -- Comsmic Barrier
		1246461, -- Rift Slash

		-- Intermission: Shattering Singularity
		-- 1234569, -- Stellar Emission
		-- 1243982, -- Silverstrike Barrage
		1245874, -- Orbiting Matter

		-- Stage Three: The End of the End
		1238843, -- Devoiring Cosmos
		1239080, -- Aspect of the End
		-- 1232470, -- Grasp of Emptiness
		-- 1233865, -- Null Corona
		-- 1237038, -- Voidstalker's Sting
		1238708, -- Dark Rush
	},{
		[1233602] = -32196, -- Stage 1
		[1234569] = -32454, -- Intermission 1
		[1238206] = -32455, -- Stage 2
		[1245874] = -33091, -- Intermission 2
		[1238843] = -32456, -- Stage 3
	}
end

function mod:OnEngage()
	self:Message("stages", "yellow", mod.displayName .. " engaged", false)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

