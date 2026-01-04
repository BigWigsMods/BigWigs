if not BigWigsLoader.isBeta then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Crown of the Cosmos", 2912, 2738)
if not mod then return end
mod:RegisterEnableMob(240430, 243805, 243810, 243811) -- Alleria, Morium, Demiar, Vorelus
mod:SetEncounterID(3181)

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

