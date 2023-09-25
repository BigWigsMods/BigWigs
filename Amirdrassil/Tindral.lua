if not BigWigsLoader.onTestBuild then return end
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
local tranquilityOfFlameCount = 1
local fireBeamCount = 1
local dreamEssenceOnYou = 0

------------------------------------------------------------------2--------------
-- Timers
--

local timersNormal = {
	[1] = {
		[423260] = {12.0, 35.0}, -- Blazing Mushroom
		[420236] = {15.3, 34.7}, -- Falling Stars
		[424581] = {35.0, 35.0}, -- Fiery Growth
		[424495] = {6.0, 35.0}, -- Mass Entanglement
		[420540] = {20.0, 35.0}, -- Incarnation: Moonkin
		[421398] = {25.0, 35.0}, -- Fire Beam
	},
	[2] = {
		[423260] = {18.0, 48.0}, -- Blazing Mushroom
		[420236] = {10.0, 48.0}, -- Falling Stars
		[424581] = {22.0, 48.0}, -- Fiery Growth
		[424495] = {5.0, 48.0}, -- Mass Entanglement
		[422115] = {26.0, 48.0}, -- Incarnation: Tree of Flame
		[423265] = {35.0, 48.0}, -- Tranquility of Flame
	},
	[3] = {
		[423260] = {7.0, 30.0, 36.5, 40.5}, -- Blazing Mushroom
		[420236] = {20.0, 48.5, 65.5, 46.0}, -- Falling Stars
		[424581] = {5.0, 87.0, 49.0, 55.0}, -- Fiery Growth
		[424495] = {14.0, 50.0, 64.0, 62.5}, -- Mass Entanglement
		[420540] = {26.0, 49.5, 43.5, 50.0}, -- Incarnation: Moonkin
		[421398] = {34.0, 46.5, 43.5, 50.0}, -- Fire Beam
		[422115] = {42.0, 52.0, 56.0, 48.0}, -- Incarnation: Tree of Flame
		[423265] = {48.0, 47.0, 59.0, 47.0}, -- Tranquility of Flame
	},
}

local timersHeroic = {
	[1] = {
		[423260] = {22, 40}, -- Blazing Mushroom
		[420236] = {6, 42}, -- Falling Stars
		[424581] = {25, 40}, -- Fiery Growth
		[424495] = {14, 40}, -- Mass Entanglement
		[420540] = {28, 40}, -- Incarnation: Moonkin
		[421398] = {40, 40}, -- Fire Beam
	},
	[2] = {
		[423260] = {18, 48}, -- Blazing Mushroom
		[420236] = {10, 48}, -- Falling Stars
		[424581] = {22, 48}, -- Fiery Growth
		[424495] = {5, 48}, -- Mass Entanglement
		[422115] = {26, 48}, -- Incarnation: Tree of Flame
		[423265] = {35, 48}, -- Tranquility of Flame
	},
	[3] = {
		[423260] = {8, 30, 36.5, 40.5}, -- Blazing Mushroom
		[420236] = {22, 48.5, 65.5, 46}, -- Falling Stars
		[424581] = {6, 87, 49, 55}, -- Fiery Growth
		[424495] = {15.5, 50, 64, 62.5}, -- Mass Entanglement
		[420540] = {26, 49.7, 43.2, 50}, -- Incarnation: Moonkin
		[421398] = {34, 46.5, 43.5, 50}, -- Fire Beam
		[422115] = {42.0, 52.0, 56.0, 48.0}, -- Incarnation: Tree of Flame
		[423265] = {50, 47, 59, 47}, -- Tranquility of Flame
	},
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
	L.tranquility_of_flame = "Seeds"
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
		[423265] = L.tranquility_of_flame, -- Tranquility of Flame (Seeds)
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
	self:Log("SPELL_AURA_APPLIED", "IncarnationMoonkin", 420540)
	--self:Log("SPELL_AURA_APPLIED", "SunfireApplied", 420239)
	self:Log("SPELL_CAST_START", "FireBeam", 421398)

	-- Intermission: Burning Pursuit
	self:Log("SPELL_CAST_START", "IncarnationOwlOfTheFlame", 421603)
	self:Log("SPELL_AURA_APPLIED", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredFeatherApplied", 422509)
	self:Log("SPELL_CAST_START", "Supernova", 424140, 426016)
	self:Log("SPELL_AURA_REMOVED", "SupernovaRemoved", 424180)

	-- Stage Two: Tree of the Flame
	self:Log("SPELL_AURA_APPLIED", "IncarnationTreeOfFlame", 422115)
	self:Log("SPELL_AURA_APPLIED", "SuppressiveEmberApplied", 424579)
	self:Log("SPELL_CAST_START", "TranquilityOfFlame", 423265)
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
	tranquilityOfFlameCount = 1
	dreamEssenceOnYou = 0

	self:Bar(420236, timers[1][420236][fallingStarsCount], CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:Bar(424495, timers[1][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	self:Bar(423260, timers[1][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, timers[1][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	self:Bar(420540, timers[1][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:Bar(421398, timers[1][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	self:Bar("stages", 82, CL.intermission, 421603)
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
	--self:Message(args.spellId, "yellow", CL.count:format(L.mass_entanglement, massEntanglementCount))
	massEntanglementCount = massEntanglementCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount))
end

function mod:MassEntanglementApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.mass_entanglement_single)
		self:PlaySound(args.spellId, "warning")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:MassEntanglementRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:IncarnationMoonkin(args)
	self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	self:PlaySound(args.spellId, "info")
	incarnationMoonkinCount = incarnationMoonkinCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
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
function mod:IncarnationOwlOfTheFlame(args) -- XXX Also used outside intermission in Mythic
	self:StopBar(CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:StopBar(CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	self:StopBar(CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:StopBar(CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
	self:StopBar(CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount)) -- Tranquility of Flame
	self:StopBar(CL.intermission)

	local stage = self:GetStage()
	stage = stage + 0.5
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	self:Bar(424140, stage == 1.5 and 44 or 34.0) -- Supernova
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
	self:Message(424140, "red")
	self:PlaySound(424140, "long")
	self:CastBar(424140, 20)
	if self:GetStage() < 3 then
		self:Message(424258, "green", CL.you:format(CL.count:format(self:SpellName(424258), dreamEssenceOnYou)))
	end
end

function mod:SupernovaRemoved(args)
	self:StopBar(CL.cast:format(args.spellName))

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
	tranquilityOfFlameCount = 1
	fireBeamCount = 1

	self:Bar(423260, timers[stage][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, timers[stage][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
	self:Bar(420236, timers[stage][420236][fallingStarsCount], CL.count:format(L.falling_stars, fallingStarsCount)) -- Falling Stars
	self:Bar(424495, timers[stage][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
	if stage == 2 then
		self:Bar(422115, timers[stage][422115][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(423265, timers[stage][423265][tranquilityOfFlameCount], CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount)) -- Tranquility of Flame
		self:Bar("stages", 100, CL.intermission, 421603)
	elseif stage == 3 then
		self:Bar(420540, timers[stage][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
		self:Bar(421398, timers[stage][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
		self:Bar(422115, timers[stage][422115][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(423265, timers[stage][423265][tranquilityOfFlameCount], CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount)) -- Tranquility of Flame
		self:Bar(424140, 220) -- Supernova
	end
end

-- Stage Two: Tree of the Flame
function mod:IncarnationTreeOfFlame(args)
	self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	self:PlaySound(args.spellId, "info")
	incarnationTreeOfFlameCount = incarnationTreeOfFlameCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
end

function mod:SuppressiveEmberApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:TranquilityOfFlame(args)
	self:StopBar(args.spellName, CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount))
	self:PlaySound(args.spellId, "info")
	tranquilityOfFlameCount = tranquilityOfFlameCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][tranquilityOfFlameCount], CL.count:format(L.tranquility_of_flame, tranquilityOfFlameCount))
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
