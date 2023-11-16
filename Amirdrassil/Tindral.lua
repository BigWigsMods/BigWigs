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
local fallingStarsCount = 1
local massEntanglementCount = 1
local incarnationMoonkinCount = 1
local incarnationTreeOfFlameCount = 1
local flamingGerminationCount = 1
local fireBeamCount = 1
local dreamEssenceOnYou = 0
local supernovaStart = 0

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = { -- 11:16
	[1] = {
		[423260] = { 19.1, 34.0, 0 }, -- Blazing Mushroom
		[424581] = { 14.1, 37.0, 0 }, -- Fiery Growth
		[420236] = { 24.1, 35.0, 0 }, -- Falling Stars
		[424495] = { 6.1, 37.0, 0 }, -- Mass Entanglement
		[421398] = { 34.1, 34.0, 0 }, -- Fire Beam
	},
	[2] = {
		[423260] = { 49.0, 44.0, 0 }, -- Blazing Mushroom
		[424581] = { 56.1, 42.0, 0 }, -- Fiery Growth
		[420236] = { 41.0, 44.0, 0 }, -- Falling Stars
		[424495] = { 31.0, 44.0, 0 }, -- Mass Entanglement
		[424579] = { 58.0, 31.1, 0 }, -- Suppressive Ember
		[423265] = { 62.0, 48.0, 0 }, -- Flaming Germination
	},
	[3] = { -- 6:44 p3, lol
		[423260] = { 36.1, 31.0, 40.0, 33.0, 110.0, 31.0, 40.0, 36.0 }, -- Blazing Mushroom
		[424581] = { 30.0, 91.0, 50.9, 49.0, 23.0, 94.0, 53.0 }, -- Fiery Growth
		[420236] = { 53.1, 48.0, 67.0, 37.0, 60.0, 50.0, 72.0 }, -- Falling Stars
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
		[420236] = { 6.2, 42.0, 0 }, -- Falling Stars
		[424495] = { 10.2, 40.0, 0 }, -- Mass Entanglement
		[421398] = { 34.2, 40.0, 0 }, -- Fire Beam
	},
	[2] = {
		[423260] = { 43.1, 48.0, 0 }, -- Blazing Mushroom
		[424581] = { 48.1, 48.0, 0 }, -- Fiery Growth
		[420236] = { 35.1, 48.0, 0 }, -- Falling Stars
		[424495] = { 25.1, 48.0, 0 }, -- Mass Entanglement
		[424579] = { 51.1, 26.0, 0 }, -- Suppressive Ember
		[423265] = { 60.0, 48.0, 0 }, -- Flaming Germination
	},
	[3] = {
		[423260] = { 30.9, 31.0, 43.5, 49.5, 76.0, 0 }, -- Blazing Mushroom
		[424581] = { 28.9, 100.0, 60.0, 58.0, 0 }, -- Fiery Growth
		[420236] = { 43.9, 58.5, 68.5, 57.0, 0 }, -- Falling Stars
		[424495] = { 32.9, 57.0, 86.0, 61.5, 0 }, -- Mass Entanglement
		[421398] = { 55.9, 59.5, 49.5, 55.0, 0 }, -- Fire Beam
		[424579] = { 65.9, 48.0, 42.0, 32.0, 0 }, -- Suppressive Ember
		[423265] = { 71.9, 64.0, 62.0, 54.0, 0 }, -- Flaming Germination
	}
}
local timers = mod:Easy() and timersNormal or timersHeroic

------------------------------------------------------------------2--------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.blazing_mushroom = "Mushrooms"
	L.fiery_growth = "Pool Dispels"
	L.falling_stars = "Stars"
	L.falling_stars_single = "Star"
	L.mass_entanglement = "Roots"
	L.mass_entanglement_single = "Root"
	L.incarnation_moonkin = "Moonkin Form"
	L.incarnation_tree_of_flame = "Tree Form"
	L.flaming_germination = "Seeds"
	L.suppressive_ember = "Heal Absorbs"
	L.suppressive_ember_single = "Heal Absorb"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fieryGrowthMarker = mod:AddMarkerOption(false, "player", 1, 424581, 1, 2, 3) -- Fiery Growth
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Moonkin of the Flame
		{422000, "TANK"}, -- Searing Wrath
		423260, -- Blazing Mushroom
		{424581, "SAY"}, -- Fiery Growth
		fieryGrowthMarker,
		424499, -- Scorching Ground
		{420236, "SAY", "SAY_COUNTDOWN"}, -- Falling Stars
		422503, -- Star Fragments
		{424495, "SAY_COUNTDOWN"}, -- Mass Entanglement
		420540, -- Incarnation: Moonkin
		--420239, -- Sunfire
		421398, -- Fire Beam
		-- Intermission: Burning Pursuit
		424258, -- Dream Essence
		422509, -- Empowered Feather
		421939, -- Scorching Plume
		{424140, "CASTBAR"}, -- Supernova
		-- Stage Two: Tree of the Flame
		422115, -- Incarnation: Tree of Flame
		424579, -- Suppressive Ember
		423265, -- Tranquility of Flame
		424665, -- Seed of Flame
		422325, -- Flaming Tree
		-- Mythic
		424582, -- Lingering Cinder
	},{
		["stages"] = "general",
		[422000] = -27488, -- Stage One: Moonkin of the Flame
		[424258] = -27500, -- Intermission: Burning Pursuit
		[422115] = -27506, -- Stage Two: Tree of the Flame
		[424582] = "mythic",
	},{
		[423260] = L.blazing_mushroom, -- Blazing Mushroom (Mushrooms)
		[424581] = L.fiery_growth, -- Fiery Growth (Pool Dispels)
		[420236] = L.falling_stars, -- Falling Stars (Stars)
		[424495] = L.mass_entanglement, -- Mass Entanglement (Roots)
		[420540] = L.incarnation_moonkin, -- Incarnation: Moonkin (Moonkin Form)
		[422115] = L.incarnation_tree_of_flame, -- Incarnation: Tree of Flame (Tree Form)
		[423265] = L.flaming_germination, -- Tranquility of Flame (Seeds)
		[424579] = L.suppressive_ember,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SearingWrathApplied", 422000)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingWrathApplied", 422000)
	self:Log("SPELL_CAST_START", "BlazingMushroom", 423260)
	self:Log("SPELL_CAST_SUCCESS", "FieryGrowth", 424581)
	self:Log("SPELL_AURA_APPLIED", "FieryGrowthApplied", 424581)
	self:Log("SPELL_AURA_REMOVED", "FieryGrowthRemoved", 424581)
	self:Log("SPELL_CAST_START", "FallingStars", 420236)
	self:Log("SPELL_AURA_APPLIED", "FallingStarsApplied", 424580)
	self:Log("SPELL_AURA_REMOVED", "FallingStarsRemoved", 424580)
	self:Log("SPELL_CAST_SUCCESS", "MassEntanglement", 424495)
	self:Log("SPELL_AURA_APPLIED", "MassEntanglementApplied", 424495)
	self:Log("SPELL_AURA_REMOVED", "MassEntanglementRemoved", 424495)
	self:Log("SPELL_AURA_APPLIED", "IncarnationMoonkinApplied", 420540)
	self:Log("SPELL_AURA_REMOVED", "IncarnationMoonkinRemoved", 420540)
	--self:Log("SPELL_AURA_APPLIED", "SunfireApplied", 420239)
	self:Log("SPELL_CAST_START", "FireBeam", 421398)

	-- Intermission: Burning Pursuit
	self:Log("SPELL_CAST_START", "IncarnationOwlOfTheFlame", 421603)
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
	self:Log("SPELL_AURA_APPLIED", "LingeringCinderApplied", 424582)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringCinderApplied", 424582)
end

function mod:OnEngage()
	timers = self:Easy() and timersNormal or timersHeroic
	self:SetStage(1)
	blazingMushroomCount = 1
	fieryGrowthCount = 1
	fallingStarsCount = 1
	massEntanglementCount = 1
	incarnationMoonkinCount = 1
	incarnationTreeOfFlameCount = 1
	fireBeamCount = 1
	flamingGerminationCount = 1
	dreamEssenceOnYou = 0

	self:Bar(420236, timers[1][420236][fallingStarsCount], CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:Bar(424495, timers[1][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	self:Bar(423260, timers[1][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, timers[1][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	-- self:Bar(420540, timers[1][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:Bar(421398, timers[1][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	self:Bar("stages", 80, CL.intermission, 421603)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SearingWrathApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then -- 1, 3, 5...
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			if self:Me(args.destGUID) then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:BlazingMushroom(args)
	self:StopBar(CL.count:format(L.blazing_mushroom, blazingMushroomCount))
	self:Message(args.spellId, "purple", CL.count:format(L.blazing_mushroom, blazingMushroomCount))
	if self:Tank() then
		self:PlaySound(args.spellId, "alert")
	end
	blazingMushroomCount = blazingMushroomCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount))
end

do
	local playerList = {}
	function mod:FieryGrowth(args)
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
			self:Say(args.spellId, L.fiery_growth)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.fiery_growth, fieryGrowthCount - 1))
		self:CustomIcon(fieryGrowthMarker, args.destName, count)
	end

	function mod:FieryGrowthRemoved(args)
		self:CustomIcon(fieryGrowthMarker, args.destName)
	end
end

function mod:FallingStars(args)
	self:StopBar(CL.count:format(L.falling_stars, fallingStarsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.falling_stars, fallingStarsCount))
	self:PlaySound(args.spellId, "alert")
	fallingStarsCount = fallingStarsCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][fallingStarsCount], CL.count:format(L.falling_stars, fallingStarsCount))
end

function mod:FallingStarsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(420236, nil, L.falling_stars_single)
		self:PlaySound(420236, "warning")
		self:Say(420236, L.falling_stars_single)
		self:SayCountdown(420236, 5)
	end
end

function mod:FallingStarsRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(420236)
	end
end

function mod:MassEntanglement(args)
	self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount))
	-- self:Message(args.spellId, "yellow", CL.count:format(L.mass_entanglement, massEntanglementCount))
	massEntanglementCount = massEntanglementCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount))
end

function mod:MassEntanglementApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.mass_entanglement)
		self:PlaySound(args.spellId, "warning")
		self:TargetBar(args.spellId, 6, args.destName)
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

-- function mod:SunfireApplied(args)
-- 	if self:Me(args.destGUID) then
-- 		self:PersonalMessage(args.spellId)
-- 		self:PlaySound(args.spellId, "alarm")
-- 	end
-- end

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
	self:StopBar(CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	-- self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:StopBar(CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	-- self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
	self:StopBar(L.suppressive_ember) -- Suppressive Ember
	self:StopBar(CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Tranquility of Flame
	self:StopBar(CL.intermission)

	local stage = self:GetStage()
	stage = stage + 0.5
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	self:Bar(424140, stage == 1.5 and 44 or 34) -- Supernova
	dreamEssenceOnYou = 0
end

function mod:DreamEssenceApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		dreamEssenceOnYou = amount
	end
end

function mod:EmpoweredFeatherApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "long")
	end
end

function mod:Supernova(args)
	supernovaStart = args.time
	self:StopBar(424140)
	self:Message(424140, "red")
	self:PlaySound(424140, "long")
	if self:GetStage() < 3 then
		self:Message(424258, "green", CL.you:format(CL.count:format(self:SpellName(424258), dreamEssenceOnYou)))
	end
end

function mod:SupernovaRemoved(args)
	-- should probably just start things in the Supernova cast, but meeeeeh
	local offset = math.max(0, args.time - supernovaStart)
	supernovaStart = 0

	local stage = math.floor(self:GetStage())
	stage = stage + 1
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	blazingMushroomCount = 1
	fieryGrowthCount = 1
	fallingStarsCount = 1
	massEntanglementCount = 1
	incarnationMoonkinCount = 1
	incarnationTreeOfFlameCount = 1
	flamingGerminationCount = 1
	fireBeamCount = 1

	self:Bar(423260, timers[stage][423260][blazingMushroomCount] - offset, CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, timers[stage][424581][fieryGrowthCount] - offset, CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	self:Bar(420236, timers[stage][420236][fallingStarsCount] - offset, CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:Bar(424495, timers[stage][424495][massEntanglementCount] - offset, CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	-- self:Bar(422115, timers[stage][422115][incarnationTreeOfFlameCount] - offset, CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
	self:Bar(424579, timers[stage][424579][incarnationTreeOfFlameCount] - offset, L.suppressive_ember) -- Suppressive Ember
	self:Bar(423265, timers[stage][423265][flamingGerminationCount] - offset, CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Tranquility of Flame
	if stage == 2 then
		self:Bar("stages", (self:Easy() and 115 or 125) - offset, CL.intermission, 421603)
	elseif stage == 3 then
		-- self:Bar(420540, timers[stage][420540][incarnationMoonkinCount] - offset, CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
		self:Bar(421398, timers[stage][421398][fireBeamCount] - offset, CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
		if not self:Easy() then
			self:Bar(424140, 271 - offset) -- Supernova
		end
	end
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
	self:Bar(424579, timers[self:GetStage()][424579][incarnationTreeOfFlameCount], L.suppressive_ember) -- Suppressive Ember
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
function mod:LingeringCinderApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "cyan", args.destName, args.amount, 1)
		if amount > 1 then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end
