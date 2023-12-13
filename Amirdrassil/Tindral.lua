--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tindral Sageswift, Seer of the Flame", 2549, 2565)
if not mod then return end
mod:RegisterEnableMob(209090) -- Tindral Sageswift <Seer of Flame>
mod:SetEncounterID(2786)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local blazingMushroomCount = 1
local fieryGrowthCount = 1
local fallingStarCount = 1
local massEntanglementCount = 1
local incarnationMoonkinCount = 1
local incarnationTreeOfFlameCount = 1
local flamingGerminationCount = 1
local fireBeamCount = 1
local flareBombCount = 1
local dreamEssenceOnYou = 0
local supernovaCasting = false
local seedsSoaked = 0
local dispelCount = 1
local searingWrathOnMe = false

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = { -- 11:16
	[1] = {
		[423260] = { 19.1, 34.0, 0 }, -- Blazing Mushroom
		[424581] = { 14.1, 37.0, 0 }, -- Fiery Growth
		[420236] = { 24.1, 35.0, 0 }, -- Falling Star
		[424495] = { 6.1, 37.0, 0 }, -- Mass Entanglement
		[421398] = { 34.1, 34.0, 0 }, -- Fire Beam
	},
	[2] = {
		[423260] = { 49.0, 44.0, 0 }, -- Blazing Mushroom
		[424581] = { 56.1, 42.0, 0 }, -- Fiery Growth
		[420236] = { 41.0, 44.0, 0 }, -- Falling Star
		[424495] = { 31.0, 44.0, 0 }, -- Mass Entanglement
		[424579] = { 58.0, 31.1, 0 }, -- Suppressive Ember
		[423265] = { 62.0, 48.0, 0 }, -- Flaming Germination
	},
	[3] = { -- 6:44 p3, lol
		[423260] = { 36.1, 31.0, 40.0, 33.0, 110.0, 31.0, 40.0, 36.0 }, -- Blazing Mushroom
		[424581] = { 30.0, 91.0, 50.9, 49.0, 23.0, 94.0, 53.0 }, -- Fiery Growth
		[420236] = { 53.1, 48.0, 67.0, 37.0, 60.0, 50.0, 72.0 }, -- Falling Star
		[424495] = { 42.1, 47.0, 68.0, 55.0, 41.0, 50.0, 73.0 }, -- Mass Entanglement
		[421398] = { 57.1, 59.0, 34.0, 47.0, 74.0, 59.0, 37.0 }, -- Fire Beam
		[424579] = { 75.0, 39.0, 36.0, 29.0, 47.5, 42.0, 36.0 }, -- Suppressive Ember
		[423265] = { 83.1, 49.0, 46.0, 48.0, 70.9, 52.0, 46.0 }, -- Flaming Germination
	}
}
local timersHeroic = { -- 9:25
	[1] = {
		[423260] = { 22.2, 40.0, 0 }, -- Blazing Mushroom
		[424581] = { 26.2, 40.0, 0 }, -- Fiery Growth
		[420236] = { 6.2, 42.0, 0 }, -- Falling Star
		[424495] = { 10.2, 40.0, 0 }, -- Mass Entanglement
		[421398] = { 34.2, 40.0, 0 }, -- Fire Beam
	},
	[2] = {
		[423260] = { 43.1, 48.0, 0 }, -- Blazing Mushroom
		[424581] = { 48.1, 48.0, 0 }, -- Fiery Growth
		[420236] = { 35.1, 48.0, 0 }, -- Falling Star
		[424495] = { 25.1, 48.0, 0 }, -- Mass Entanglement
		[424579] = { 51.1, 26.0, 0 }, -- Suppressive Ember
		[423265] = { 60.0, 48.0, 0 }, -- Flaming Germination
	},
	[3] = {
		[423260] = { 30.9, 31.0, 43.5, 49.5, 76.0, 0 }, -- Blazing Mushroom
		[424581] = { 28.9, 100.0, 60.0, 58.0, 0 }, -- Fiery Growth
		[420236] = { 43.9, 58.5, 68.5, 57.0, 0 }, -- Falling Star
		[424495] = { 32.9, 57.0, 86.0, 61.5, 0 }, -- Mass Entanglement
		[421398] = { 55.9, 59.5, 49.5, 55.0, 0 }, -- Fire Beam
		[424579] = { 65.9, 48.0, 42.0, 32.0, 0 }, -- Suppressive Ember
		[423265] = { 71.9, 64.0, 62.0, 54.0, 0 }, -- Flaming Germination
	}
}
local timersMythic = {
	[1] = {
		[423260] = { 18.1, 40.0, 0 }, -- Blazing Mushroom
		[424581] = { 21.1, 40.0, 0 }, -- Fiery Growth
		[420236] = { 14.1, 40.0, 0 }, -- Falling Star
		[424495] = { 27.1, 20.0, 20.0, 0 }, -- Mass Entanglement
		[421398] = { 7.1, 26.0, 7.0, 33.0, 0 }, -- Fire Beam
		[425576] = { 23.1, 40.0, 0 }, -- Flare Bomb
	},
	[2] = {
		[423260] = { 26.0, 46.0, 0 }, -- Blazing Mushroom
		[424581] = { 28.5, 21.5, 25.0, 0 }, -- Fiery Growth
		[420236] = { 22.1, 35.0, 39.0, 0 }, -- Falling Star
		[424495] = { 34.0, 31.0, 20.0, 0 }, -- Mass Entanglement
		[424579] = { 38.1, 13.0, 25.1, 0 }, -- Suppressive Ember
		[423265] = { 39.1, 22.0, 29.0, 0 }, -- Flaming Germination
		[425576] = { 30.0, 51.0, 0 }, -- Flare Bomb
	},
	[3] = {
		[423260] = { 50.0, 60.0, 67.0 }, -- Blazing Mushroom
		[424581] = { 53.1, 40.0, 35.0, 45.0 }, -- Fiery Growth
		[420236] = { 22.1, 38.0, 40.0, 40.0, 40.0 }, -- Falling Star
		[424495] = { 26.2, 41.9, 19.0, 29.0, 19.0, 24.0, 24.0 }, -- Mass Entanglement
		[421398] = { 33.1, 63.0, 49.0, 46.0 }, -- Fire Beam
		[424579] = { 38.1, 27.0, 38.1, 37.1 }, -- Suppressive Ember
		[423265] = { 39.0, 35.0, 47.0, 43.0 }, -- Flaming Germination
		[425576] = { 24.1, 39.9, 48.0, 42.0 }, -- Flare Bomb
	}
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

------------------------------------------------------------------2--------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.seed_soaked = "Seed soaked"
	L.all_seeds_soaked = "Seeds done!"

	L.blazing_mushroom = "Mushrooms"
	L.fiery_growth = "Dispels"
	L.mass_entanglement = "Roots"
	L.incarnation_moonkin = "Moonkin Form"
	L.incarnation_tree_of_flame = "Tree Form"
	L.flaming_germination = "Seeds"
	L.suppressive_ember = "Heal Absorbs"
	L.suppressive_ember_single = "Heal Absorb"
	L.flare_bomb = "Feathers"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fieryGrowthMarker = mod:AddMarkerOption(false, "player", 1, 424581, 1, 2, 3, 4) -- Fiery Growth
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Moonkin of the Flame
		{422000, "TANK"}, -- Searing Wrath
		423260, -- Blazing Mushroom
		{424581, "SAY"}, -- Fiery Growth
		fieryGrowthMarker,
		424499, -- Scorching Ground
		420236, -- Falling Star
		422503, -- Star Fragments
		424495, -- Mass Entanglement
		420540, -- Incarnation: Moonkin
		421398, -- Fire Beam
		-- Intermission: Burning Pursuit
		421636, -- Typhoon
		424258, -- Dream Essence
		{422509, "EMPHASIZE"}, -- Empowered Feather
		421939, -- Scorching Plume
		{424140, "CASTBAR"}, -- Supernova
		-- Stage Two: Tree of the Flame
		422115, -- Incarnation: Tree of Flame
		424579, -- Suppressive Ember
		423265, -- Tranquility of Flame
		424665, -- Seed of Flame
		422325, -- Flaming Tree
		-- Mythic
		425576, -- Flare Bomb
		425606, -- Empowering Flame
		424582, -- Lingering Cinder
		430583, -- Germinating Aura
	},{
		["stages"] = "general",
		[422000] = -27488, -- Stage One: Moonkin of the Flame
		[421636] = -27500, -- Intermission: Burning Pursuit
		[422115] = -27506, -- Stage Two: Tree of the Flame
		[425576] = "mythic",
	},{
		[423260] = L.blazing_mushroom, -- Blazing Mushroom (Mushrooms)
		[424581] = L.fiery_growth, -- Fiery Growth (Pool Dispels)
		[424495] = L.mass_entanglement, -- Mass Entanglement (Roots)
		[420540] = L.incarnation_moonkin, -- Incarnation: Moonkin (Moonkin Form)
		[421636] = CL.pushback, -- Typhoon (Pushback)
		[422115] = L.incarnation_tree_of_flame, -- Incarnation: Tree of Flame (Tree Form)
		[423265] = L.flaming_germination, -- Tranquility of Flame (Seeds)
		[424579] = L.suppressive_ember, -- Suppressive Ember (Healing Absorbs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SearingWrathApplied", 422000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingWrathApplied", 422000)
	self:Log("SPELL_AURA_REMOVED", "SearingWrathRemoved", 422000)
	self:Log("SPELL_CAST_START", "BlazingMushroom", 423260, 426669) -- Blazing Mushroom, Wild Mushrooms
	self:Log("SPELL_CAST_SUCCESS", "FieryGrowth", 424581)
	self:Log("SPELL_AURA_APPLIED", "FieryGrowthApplied", 424581)
	self:Log("SPELL_AURA_REMOVED", "FieryGrowthRemoved", 424581)
	self:Log("SPELL_CAST_START", "FallingStar", 420236)
	self:Log("SPELL_CAST_SUCCESS", "MassEntanglement", 424495)
	self:Log("SPELL_AURA_APPLIED", "MassEntanglementTargetApplied", 424495)
	self:Log("SPELL_AURA_REMOVED", "MassEntanglementTargetRemoved", 424495)
	self:Log("SPELL_AURA_REMOVED", "MassEntanglementRemoved", 424497)
	self:Log("SPELL_AURA_APPLIED", "IncarnationMoonkinApplied", 420540)
	self:Log("SPELL_AURA_REMOVED", "IncarnationMoonkinRemoved", 420540)
	self:Log("SPELL_CAST_START", "FireBeam", 421398)

	-- Intermission: Burning Pursuit
	self:Log("SPELL_CAST_START", "IncarnationOwlOfTheFlame", 421603)
	self:Log("SPELL_CAST_START", "Typhoon", 421636)
	self:Log("SPELL_AURA_APPLIED", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredFeatherApplied", 422509)
	self:Log("SPELL_CAST_START", "Supernova", 424140, 429169) -- intermission, enrage
	self:Log("SPELL_AURA_REMOVED", "SupernovaRemoved", 424140)

	-- Stage Two: Tree of the Flame
	self:Log("SPELL_AURA_APPLIED", "IncarnationTreeOfFlameApplied", 422115)
	self:Log("SPELL_AURA_REMOVED", "IncarnationTreeOfFlameRemoved", 422115)
	self:Log("SPELL_AURA_APPLIED", "SuppressiveEmberApplied", 424579)
	self:Log("SPELL_CAST_START", "FlamingGermination", 423265)
	self:Log("SPELL_AURA_APPLIED", "SeedOfFlameApplied", 424665)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SeedOfFlameApplied", 424665)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 424499, 422503, 421939, 422325) -- Scorching Ground, Star Fragments, Scorching Plume, Flaming Tree
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 424499, 422503, 421939, 422325)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 424499, 422503, 421939, 422325)
	self:Log("SPELL_AURA_APPLIED", "GroundDamageFireBeam", 423649) -- Fire Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamageFireBeam", 423649)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamageFireBeam", 423649)

	-- Mythic
	self:Log("SPELL_CAST_START", "FlareBomb", 425576)
	self:Log("SPELL_DAMAGE", "FlareBombDamage", 425602)
	self:Log("SPELL_MISSED", "FlareBombDamage", 425602)
	self:Log("SPELL_AURA_APPLIED", "EmpoweringFlameApplied", 425606)
	self:Log("SPELL_AURA_APPLIED", "LingeringCinderApplied", 424582)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringCinderApplied", 424582)
	self:Log("SPELL_AURA_APPLIED", "GerminatingAuraApplied", 430583)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic
	self:SetStage(1)
	blazingMushroomCount = 1
	fieryGrowthCount = 1
	fallingStarCount = 1
	massEntanglementCount = 1
	incarnationMoonkinCount = 1
	incarnationTreeOfFlameCount = 1
	fireBeamCount = 1
	flamingGerminationCount = 1
	flareBombCount = 1
	dreamEssenceOnYou = 0
	supernovaCasting = false
	searingWrathOnMe = false

	self:Bar(420236, timers[1][420236][fallingStarCount], CL.count:format(self:SpellName(420236), fallingStarCount)) -- Falling Star
	self:Bar(424495, timers[1][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	self:Bar(423260, timers[1][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, timers[1][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	-- self:Bar(420540, timers[1][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:Bar(421398, timers[1][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	if self:Mythic() then
		self:Bar(425576, timers[1][425576][1], CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb
	end
	self:Bar("stages", 80, CL.count:format(CL.intermission, 1), 421603)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SearingWrathApplied(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		if self:Me(args.destGUID) then
			searingWrathOnMe = true
			self:StackMessage(args.spellId, "purple", args.destName, amount, 6)
			if amount >= 6 then
				self:PlaySound(args.spellId, "alarm")
			end
		else
			self:StackMessage(args.spellId, "purple", args.destName, amount, searingWrathOnMe and 100 or 6)
			if not searingWrathOnMe and amount >= 6 then
				self:PlaySound(args.spellId, "warning") -- taunt
			end
		end
	end
end

function mod:SearingWrathRemoved(args)
	if self:Me(args.destGUID) then
		searingWrathOnMe = false
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "warning") -- taunt
	end
end

function mod:BlazingMushroom(args)
	self:StopBar(CL.count:format(L.blazing_mushroom, blazingMushroomCount))
	self:Message(423260, "purple", CL.count:format(L.blazing_mushroom, blazingMushroomCount))
	if self:Tank() then
		self:PlaySound(423260, "warning")
	end
	blazingMushroomCount = blazingMushroomCount + 1
	self:Bar(423260, timers[self:GetStage()][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount))
end

do
	local playerList = {}
	function mod:FieryGrowth(args)
		dispelCount = 1
		playerList = {}
		self:StopBar(CL.count:format(L.fiery_growth, fieryGrowthCount))
		fieryGrowthCount = fieryGrowthCount + 1
		self:Bar(args.spellId, timers[self:GetStage()][args.spellId][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount))
	end

	function mod:FieryGrowthApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.fiery_growth, nil, "Dispels")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.fiery_growth, fieryGrowthCount - 1))
		self:CustomIcon(fieryGrowthMarker, args.destName, count)
	end

	function mod:FieryGrowthRemoved(args)
		self:CustomIcon(fieryGrowthMarker, args.destName)
	end
end

function mod:FallingStar(args)
	self:StopBar(CL.count:format(args.spellName, fallingStarCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, fallingStarCount))
	self:PlaySound(args.spellId, "alert")
	fallingStarCount = fallingStarCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][fallingStarCount], CL.count:format(args.spellName, fallingStarCount))
end

function mod:MassEntanglement(args)
	self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount))
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.mass_entanglement, massEntanglementCount)))
	massEntanglementCount = massEntanglementCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount))
end

function mod:MassEntanglementTargetApplied(args)
	if self:Me(args.destGUID) then
		self:TargetBar(args.spellId, self:Mythic() and 4 or 6, args.destName, L.mass_entanglement)
	end
end

function mod:MassEntanglementTargetRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(L.mass_entanglement, args.destName)
	end
end

function mod:MassEntanglementRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(424495, "green", CL.removed:format(L.mass_entanglement))
		self:PlaySound(424495, "info")
	end
end

function mod:IncarnationMoonkinApplied(args)
	-- self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	-- self:PlaySound(args.spellId, "info")
	incarnationMoonkinCount = incarnationMoonkinCount + 1
	-- self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
end

function mod:IncarnationMoonkinRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	-- self:PlaySound(args.spellId, "info")
end

function mod:FireBeam(args)
	self:StopBar(CL.count:format(args.spellName, fireBeamCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, fireBeamCount))
	self:PlaySound(args.spellId, "alert")
	fireBeamCount = fireBeamCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][fireBeamCount], CL.count:format(args.spellName, fireBeamCount))
end

-- Intermission: Burning Pursuit
function mod:IncarnationOwlOfTheFlame(args)
	self:StopBar(CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:StopBar(CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	self:StopBar(CL.count:format(self:SpellName(420236), fallingStarCount)) -- Falling Star
	self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	-- self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:StopBar(CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	-- self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
	self:StopBar(CL.count:format(L.suppressive_ember, incarnationTreeOfFlameCount)) -- Suppressive Ember
	self:StopBar(CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Tranquility of Flame
	self:StopBar(CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb

	local stage = self:GetStage()
	self:StopBar(CL.count:format(CL.intermission, stage))
	self:Message("stages", "cyan", CL.count:format(CL.intermission, stage), false)
	self:PlaySound("stages", "long")
	stage = stage + 0.5
	self:SetStage(stage)

	dreamEssenceOnYou = 0
	supernovaCasting = false

	self:CDBar(421636, 5.5, CL.pushback) -- Typhoon
end

function mod:Typhoon(args)
	self:StopBar(CL.pushback)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.pushback))
	self:PlaySound(args.spellId, "alarm")

	-- maybe a bit more reliable than owl?
	local stage = self:GetStage()
	self:Bar(424140, stage == 1 and 39.4 or 25.6, CL.count:format(self:SpellName(424140), stage)) -- Supernova
end

function mod:DreamEssenceApplied(args)
	if self:Me(args.destGUID) then
		dreamEssenceOnYou = args.amount or 1
		if supernovaCasting then
			self:Message(args.spellId, "green", CL.count:format(args.spellName, dreamEssenceOnYou))
		end
	end
end

function mod:EmpoweredFeatherApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "long")
	end
end

function mod:Supernova(args)
	local stage = math.floor(self:GetStage())
	self:StopBar(424140, CL.count:format(args.spellName, stage))
	self:Message(424140, "red", CL.count:format(args.spellName, stage))
	self:PlaySound(424140, "long")

	if stage < 3 then
		self:Message(424258, "green", CL.count:format(self:SpellName(424258), dreamEssenceOnYou)) -- Dream Essence

		supernovaCasting = true
		blazingMushroomCount = 1
		fieryGrowthCount = 1
		fallingStarCount = 1
		massEntanglementCount = 1
		incarnationMoonkinCount = 1
		incarnationTreeOfFlameCount = 1
		flamingGerminationCount = 1
		fireBeamCount = 1
		flareBombCount = 1

		stage = stage + 1
		if self:Mythic() then
			self:Bar(425576, timers[stage][425576][flareBombCount], CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb
		end
		self:Bar(423260, timers[stage][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
		self:Bar(424581, timers[stage][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
		self:Bar(420236, timers[stage][420236][fallingStarCount], CL.count:format(self:SpellName(420236), fallingStarCount)) -- Falling Star
		self:Bar(424495, timers[stage][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
		-- self:Bar(422115, timers[stage][422115][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(424579, timers[stage][424579][incarnationTreeOfFlameCount], CL.count:format(L.suppressive_ember, incarnationTreeOfFlameCount)) -- Suppressive Ember
		self:Bar(423265, timers[stage][423265][flamingGerminationCount], CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Tranquility of Flame
		if stage == 2 then
			self:Bar("stages", (self:Easy() and 115 or self:Mythic() and 102 or 125), CL.count:format(CL.intermission, 2), 421603)
		elseif stage == 3 then
			-- self:Bar(420540, timers[stage][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
			self:Bar(421398, timers[stage][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
			if not self:Easy() then
				self:Bar(424140, self:Mythic() and 251 or 271, CL.count:format(args.spellName, stage)) -- Supernova
			end
		end
	end
end

function mod:SupernovaRemoved(args)
	supernovaCasting = false
	local stage = math.floor(self:GetStage())
	stage = stage + 1
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

end

-- Stage Two: Tree of the Flame
function mod:IncarnationTreeOfFlameApplied(args)
	-- self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	-- self:PlaySound(args.spellId, "info")
	-- incarnationTreeOfFlameCount = incarnationTreeOfFlameCount + 1
	-- self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
end

function mod:IncarnationTreeOfFlameRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
	-- self:PlaySound(args.spellId, "info")
	incarnationTreeOfFlameCount = incarnationTreeOfFlameCount + 1
	self:Bar(424579, timers[self:GetStage()][424579][incarnationTreeOfFlameCount], CL.count:format(L.suppressive_ember, incarnationTreeOfFlameCount)) -- Suppressive Ember
end

function mod:SuppressiveEmberApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.suppressive_ember_single)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FlamingGermination(args)
	self:StopBar(args.spellName, CL.count:format(L.flaming_germination, flamingGerminationCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.flaming_germination, flamingGerminationCount))
	self:PlaySound(args.spellId, "info")
	flamingGerminationCount = flamingGerminationCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][flamingGerminationCount], CL.count:format(L.flaming_germination, flamingGerminationCount))

	if self:Mythic() then
		local playersAlive = 0
		for unit in self:IterateGroup() do
			if not UnitIsDead(unit) and UnitIsConnected(unit) then
				playersAlive = playersAlive + 1
			end
		end
		seedsSoaked = math.floor(playersAlive * 0.8) -- XXX might not be linear, but this is mostly right?
	end
end

function mod:SeedOfFlameApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end

	function mod:GroundDamageFireBeam(args) -- Seperate function to deal with option key being different
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(421398, "underyou")
			self:PersonalMessage(421398, "underyou")
		end
	end
end

-- Mythic
function mod:FlareBomb(args)
	self:StopBar(CL.count:format(L.flare_bomb, flareBombCount))
	self:Message(args.spellId, "red", CL.incoming:format(CL.count:format(L.flare_bomb, flareBombCount)))
	self:PlaySound(args.spellId, "alarm")
	flareBombCount = flareBombCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][flareBombCount], CL.count:format(L.flare_bomb, flareBombCount))
end

function mod:EmpoweringFlameApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info") -- dive bomb gooooo
	end
end

function mod:LingeringCinderApplied(args)
	if self:Me(args.destGUID) then
		-- self:PersonalMessage(args.spellId)
		-- self:PlaySound(args.spellId, "info")
		self:StopBar(CL.count:format(args.spellName, dispelCount-1))
		self:TargetBar(args.spellId, 2, args.destName, CL.count:format(args.spellName, dispelCount))
		dispelCount = dispelCount + 1
	end
end

function mod:GerminatingAuraApplied(args)
	seedsSoaked = seedsSoaked - 1
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "blue", L.seed_soaked)
		if seedsSoaked > 0 then
			self:PlaySound(args.spellId, "warning")
		end
	end
	if seedsSoaked == 0 then
		self:Message(args.spellId, "green", L.all_seeds_soaked)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local prev = 0
	function mod:FlareBombDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 3 then
			prev = args.time
			self:Message(425576, "red")
			self:PlaySound(425576, "alarm")
		end
	end
end
