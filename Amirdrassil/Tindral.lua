--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tindral Sageswift, Seer of the Flame", 2549, 2565)
if not mod then return end
mod:RegisterEnableMob(209090) -- Tindral Sageswift
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
local dispelCount = 1
local searingWrathOnMe = false

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = { -- Done
	[1] = {
		[423260] = { 19.1, 34.0, 0 }, -- Blazing Mushroom
		[424581] = { 14.1, 37.0, 0 }, -- Fiery Growth
		[420236] = { 24.1, 35.0, 0 }, -- Falling Star
		[424495] = { 6.1, 37.0, 0 }, -- Mass Entanglement
		[420540] = { 29.1, 35.0 }, -- Incarnation: Moonkin
		[421398] = { 34.1, 34.0, 0 }, -- Fire Beam
	},
	[2] = {
		[423260] = { 49.0, 44.0, 0 }, -- Blazing Mushroom
		[424581] = { 56.0, 42.0, 0 }, -- Fiery Growth
		[420236] = { 41.0, 44.0, 0 }, -- Falling Star
		[424495] = { 31.0, 44.0, 0 }, -- Mass Entanglement
		[422115] = { 58.0, 42.0, 0 }, -- Incarnation: Tree of Flame
		[423265] = { 62.0, 42.0, 0 }, -- Flaming Germination
	},
	[3] = {
		[423260] = { 35.0, 31.0, 40.0, 33.0, 110.0, 31.0, 40.0, 36.0, 0 }, -- Blazing Mushroom
		[424581] = { 29.1, 91.0, 51.0, 49.0, 23.0, 94.0, 53.0, 0 }, -- Fiery Growth
		[420236] = { 52.1, 48.5, 66.5, 37.0, 60.0, 50.0, 72.0, 0 }, -- Falling Star
		[424495] = { 41.1, 47.0, 68.0, 55.0, 41.0, 50.5, 72.5, 0 }, -- Mass Entanglement
		[420540] = { 54.0, 56.0, 36.0, 47.0, 73.0, 58.0, 39.0, 0 }, -- Incarnation: Moonkin
		[421398] = { 57.1, 59.0, 34.0, 47.0, 74.0, 59.0, 37.0, 0 }, -- Fire Beam
		[422115] = { 74.1, 52.0, 48.0, 48.0, 66.0, 55.0, 48.0, 0 }, -- Incarnation: Tree of Flame
		[423265] = { 82.1, 49.0, 46.0, 48.0, 70.9, 52.0, 46.0, 0 }, -- Flaming Germination
	}
}
local timersHeroic = { -- Done
	[1] = {
		[423260] = { 22.0, 40.0, 0 }, -- Blazing Mushroom
		[424581] = { 26.0, 40.0, 0 }, -- Fiery Growth
		[420236] = { 6.1, 42.0, 0 }, -- Falling Star
		[424495] = { 10.1, 40.0, 0 }, -- Mass Entanglement
		[420540] = { 28.0, 40.0, 0 }, -- Incarnation: Moonkin
		[421398] = { 34.0, 40.0, 0}, -- Fire Beam
	},
	[2] = {
		[423260] = { 43.0, 48.0, 0 }, -- Blazing Mushroom
		[424581] = { 48.0, 48.0, 0 }, -- Fiery Growth
		[420236] = { 35.0, 48.0, 0 }, -- Falling Star
		[424495] = { 25.0, 48.0, 0 }, -- Mass Entanglement
		[422115] = { 51.0, 48.0, 0 }, -- Incarnation: Tree of Flame
		[423265] = { 60.0, 48.0, 0 }, -- Flaming Germination
	},
	[3] = {
		[423260] = { 32.0, 31.0, 43.5, 49.5, 76.0, 0 }, -- Blazing Mushroom
		[424581] = { 30.0, 100.0, 60.0, 58.0, 0 }, -- Fiery Growth
		[420236] = { 45.0, 58.5, 68.5, 57.0, 0 }, -- Falling Star
		[424495] = { 34.0, 57.0, 86.0, 61.5, 0 }, -- Mass Entanglement
		[420540] = { 51.0, 57.6, 52.4, 57.0, 0 }, -- Incarnation: Moonkin
		[421398] = { 57.0, 59.5, 49.5, 55.0, 0 }, -- Fire Beam
		[422115] = { 67.0, 69.0, 58.0, 56.0, 0 }, -- Incarnation: Tree of Flame
		[423265] = { 73.0, 64.0, 62.0, 54.0, 0 }, -- Flaming Germination
	}
}
local timersMythic = { -- Not complete until Supernova Enrage
	[1] = {
		[423260] = { 18.1, 40.0, 0 }, -- Blazing Mushroom (Wild Mushrooms in Mythic)
		[424581] = { 21.1, 40.0, 0 }, -- Fiery Growth
		[420236] = { 14.1, 40.0, 0 }, -- Falling Star
		[424495] = { 27.1, 20.0, 20.0, 0 }, -- Mass Entanglement
		[420540] = { 6.2, 26.0, 40.0, 0 }, -- Incarnation: Moonkin
		[421398] = { 7.1, 33.0, 33.0, 0 }, -- Fire Beam
		[425576] = { 23.1, 40.0, 0 }, -- Flare Bomb
	},
	[2] = {
		[423260] = { 25.0, 47.0, 0 }, -- Blazing Mushroom (Wild Mushrooms in Mythic)
		[424581] = { 28.0, 22.0, 25.0, 0 }, -- Fiery Growth
		[420236] = { 22.0, 35.0, 39.0, 0 }, -- Falling Star
		[424495] = { 34.0, 31.0, 20.0, 0 }, -- Mass Entanglement
		[422115] = { 38.1, 22.0, 29.0, 0 }, -- Incarnation: Tree of Flame
		[423265] = { 39.0, 22.0, 29.0, 0 }, -- Flaming Germination
		[425576] = { 30.0, 51.0, 0 }, -- Flare Bomb
	},
	[3] = {
		[423260] = { 50.0, 60.0, 67.0, 52.0 }, -- Blazing Mushroom (Wild Mushrooms in Mythic)
		[424581] = { 53.0, 40.0, 35.0, 45.0, 40.0 }, -- Fiery Growth
		[420236] = { 22.0, 38.0, 40.0, 40.0, 40.0, 40.0 }, -- Falling Star
		[424495] = { 26.1, 41.9, 19.0, 29.0, 19.0, 24.0, 24.0, 21.0, 20.0}, -- Mass Entanglement
		[420540] = { 31.0, 63.0, 50.0, 46.0, 19.0 }, -- Incarnation: Moonkin
		[421398] = { 33.0, 63.0, 49.0, 46.0, 19.0 }, -- Fire Beam
		[422115] = { 38.0, 35.0, 47.0, 43.0, 51.0 }, -- Incarnation: Tree of Flame
		[423265] = { 39.0, 35.0, 47.0, 43.0, 51.0 }, -- Flaming Germination
		[425576] = { 24.0, 39.9, 48.0, 42.0, 47.0 }, -- Flare Bomb
	}
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
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
	L.flare_bomb = "Feathers"
	L.too_close_to_edge = "Too close to the edge"
	L.taking_damage_from_edge = "Taking damage from the edge"
	L.flying_available = "You can fly now"

	L.fly_time = "Fly Time"
	L.fly_time_desc = "Display a message showing you how long you took to fly over to the other platform in the intermissions."
	L.fly_time_icon = "inv_checkered_flag"
	L.fly_time_msg = "Fly Time: %.2f"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fieryGrowthMarker = mod:AddMarkerOption(false, "player", 1, 424581, 1, 2, 3, 4) -- Fiery Growth
function mod:GetOptions()
	return {
		"stages",
		427297, -- Flame Surge
		-- Stage One: Moonkin of the Flame
		{422000, "TANK"}, -- Searing Wrath
		423260, -- Blazing Mushroom
		{424581, "SAY"}, -- Fiery Growth
		fieryGrowthMarker,
		424499, -- Scorching Ground
		420236, -- Falling Star
		422503, -- Star Fragments
		424495, -- Mass Entanglement
		{420540, "OFF"}, -- Incarnation: Moonkin
		421398, -- Fire Beam
		-- Intermission: Burning Pursuit
		421636, -- Typhoon
		"fly_time",
		424258, -- Dream Essence
		{422509, "EMPHASIZE"}, -- Empowered Feather
		421939, -- Scorching Plume
		{424140, "CASTBAR"}, -- Supernova
		-- Stage Two: Tree of the Flame
		{422115, "OFF"}, -- Incarnation: Tree of Flame
		424579, -- Suppressive Ember
		423265, -- Flaming Germination
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
		[427297] = L.too_close_to_edge, -- Flame Surge (Too close to the edge)
		[423260] = L.blazing_mushroom, -- Blazing Mushroom (Mushrooms)
		[424581] = L.fiery_growth, -- Fiery Growth (Pool Dispels)
		[424495] = L.mass_entanglement, -- Mass Entanglement (Roots)
		[420540] = L.incarnation_moonkin, -- Incarnation: Moonkin (Moonkin Form)
		[421636] = CL.pushback, -- Typhoon (Pushback)
		[422509] = L.flying_available, -- Empowered Feather (You can fly now)
		[422115] = L.incarnation_tree_of_flame, -- Incarnation: Tree of Flame (Tree Form)
		[424579] = CL.heal_absorb, -- Suppressive Ember (Heal Absorb)
		[423265] = L.flaming_germination, -- Flaming Germination (Seeds)
		[425576] = L.flare_bomb, -- Flare Bomb (Feathers)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "FlameSurgeApplied", 427297)
	self:Log("SPELL_AURA_REMOVED", "FlameSurgeRemoved", 427297)
	self:Log("SPELL_DAMAGE", "FlameSurgeDamage", 427311)
	self:Log("SPELL_MISSED", "FlameSurgeDamage", 427311)

	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingWrathApplied", 422000)
	self:Log("SPELL_AURA_REMOVED", "SearingWrathRemoved", 422000)
	self:Log("SPELL_CAST_START", "BlazingMushroom", 423260, 426669) -- Blazing Mushroom, Wild Mushrooms (Mythic)
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
	self:Log("SPELL_AURA_APPLIED", "IncarnationOwlOfTheFlame", 421603)
	self:Log("SPELL_CAST_START", "Typhoon", 421636)
	self:Log("SPELL_AURA_APPLIED", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DreamEssenceApplied", 424258)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredFeatherApplied", 422509) -- XXX currently hidden
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- Feather alternative
	self:Log("SPELL_CAST_START", "Supernova", 424140, 429169) -- intermission, enrage
	self:Log("SPELL_AURA_APPLIED", "SupernovaApplied", 424140)
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
	self:Log("SPELL_AURA_APPLIED", "FallenFeatherApplied", 425657)
	self:Log("SPELL_CAST_START", "FlareBomb", 425576)
	self:Log("SPELL_AURA_APPLIED", "EmpoweringFlameApplied", 425606)
	self:Log("SPELL_DAMAGE", "FlareBombDamage", 425602)
	self:Log("SPELL_MISSED", "FlareBombDamage", 425602)
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
	self:Bar(420540, timers[1][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:Bar(421398, timers[1][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
	if self:Mythic() then
		self:Bar(425576, timers[1][425576][flareBombCount], CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb
	end
	self:Bar("stages", 82.0, CL.count:format(CL.intermission, 1), 421603)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local edgeTimer = nil
	function mod:FlameSurgeApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, false, L.too_close_to_edge)
			self:PlaySound(args.spellId, "warning")
			if edgeTimer then
				self:CancelTimer(edgeTimer)
			end
			edgeTimer = self:ScheduleRepeatingTimer("PersonalMessage", 1, 427297, false, L.too_close_to_edge)
		end
	end

	function mod:FlameSurgeRemoved(args)
		if self:Me(args.destGUID) and edgeTimer then
			self:CancelTimer(edgeTimer)
			edgeTimer = nil
		end
	end
end

function mod:FlameSurgeDamage(args) -- Every second, purposely not throttled
	if self:Me(args.destGUID) then
		self:PersonalMessage(427297, false, L.taking_damage_from_edge)
	end
end

function mod:SearingWrathApplied(args)
	local amount = args.amount
	if amount % 2 == 0 then
		if self:Me(args.destGUID) then
			searingWrathOnMe = true
			self:StackMessage(args.spellId, "purple", args.destName, amount, amount <= 10 and 6 or 100)
			if amount >= 6 then -- Always play a sound for the person tanking
				self:PlaySound(args.spellId, "alarm")
			end
		else
			if searingWrathOnMe then
				self:StackMessage(args.spellId, "purple", args.destName, amount, 100)
			else
				self:StackMessage(args.spellId, "purple", args.destName, amount, amount <= 10 and 6 or 100)
				if amount >= 6 and amount <= 10 and self:Tank() then -- Strictly tank only for taunt sound
					self:PlaySound(args.spellId, "warning") -- taunt
				end
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

function mod:BlazingMushroom()
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
		self:PlaySound(args.spellId, "warning") -- Move to position and aoe
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
	self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
	incarnationMoonkinCount = incarnationMoonkinCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount))
end

function mod:IncarnationMoonkinRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
end

function mod:FireBeam(args)
	self:StopBar(CL.count:format(args.spellName, fireBeamCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, fireBeamCount))
	self:PlaySound(args.spellId, "alert")
	fireBeamCount = fireBeamCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][fireBeamCount], CL.count:format(args.spellName, fireBeamCount))
end

-- Intermission: Burning Pursuit
do
	local mountUpTime = 0
	local mounted = false
	local function FlightTimeChecker()
		if not mod:IsEngaged() then return end
		local isMounted = IsMounted()
		if mounted and not isMounted and GetUnitSpeed("player") == 0 then -- Dismounted
			local timeSinceMountUp = GetTime() - mountUpTime
			if timeSinceMountUp > 10 then
				mod:Message("fly_time", "cyan", L.fly_time_msg:format(timeSinceMountUp), L.fly_time_icon)
			else -- Too fast, didn't fly !
				mod:SimpleTimer(FlightTimeChecker, 0.01)
			end
		elseif not mounted and isMounted then -- Mounted up
			mounted = isMounted
			mod:SimpleTimer(FlightTimeChecker, 0.01)
		else -- No Change
			if mod:GetStage() == 2 or mod:GetStage() == 3 then return end -- Too late, stop checking
			mod:SimpleTimer(FlightTimeChecker, 0.01)
		end
	end

	function mod:IncarnationOwlOfTheFlame()
		self:StopBar(CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
		self:StopBar(CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
		self:StopBar(CL.count:format(self:SpellName(420236), fallingStarCount)) -- Falling Star
		self:StopBar(CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
		self:StopBar(CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
		self:StopBar(CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
		self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:StopBar(CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Flaming Germination
		self:StopBar(CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb

		local stage = self:GetStage()
		self:StopBar(CL.count:format(CL.intermission, stage))
		self:Message("stages", "cyan", CL.count:format(CL.intermission, stage), false)
		self:PlaySound("stages", "long")
		stage = stage + 0.5
		self:SetStage(stage)

		dreamEssenceOnYou = 0
		supernovaCasting = false

		self:CDBar(421636, 3.5, CL.pushback) -- Typhoon

		if self:CheckOption("fly_time", "MESSAGE") then
			mountUpTime = 7 + GetTime() -- Estimated Feathers Spawn
			mounted = false
			self:SimpleTimer(FlightTimeChecker, 0.01)
		end
	end
end

function mod:Typhoon(args)
	self:StopBar(CL.pushback)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.pushback))
	self:PlaySound(args.spellId, "alarm")

	-- maybe a bit more reliable than owl?
	local stage = math.floor(self:GetStage())
	self:Bar(424140, stage == 1 and 39.4 or 25.6, CL.count:format(self:SpellName(424140), stage)) -- Supernova
end

function mod:DreamEssenceApplied(args)
	if self:Me(args.destGUID) then
		dreamEssenceOnYou = args.amount or 1
		if supernovaCasting or dreamEssenceOnYou % 2 == 0 or dreamEssenceOnYou >= 8 then
			self:StackMessage(args.spellId, "blue", args.destName, dreamEssenceOnYou, 10)
		end
	end
end

function mod:EmpoweredFeatherApplied(args)
	if self:Me(args.destGUID) then
		self:Error("Feather ID available")
		self:Message(args.spellId, "green", L.flying_available)
		self:PlaySound(args.spellId, "long")
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg)
	--|TInterface\\ICONS\\Ability_DragonRiding_DragonRiding01.BLP:20|t Take flight!
	if msg:find("Ability_DragonRiding_DragonRiding01", nil, true) then
		self:Message(422509, "green", L.flying_available)
		self:PlaySound(422509, "long")
	end
end

function mod:Supernova(args)
	local stage = math.floor(self:GetStage())
	self:StopBar(CL.count:format(args.spellName, stage))
	self:Message(424140, "red", CL.count:format(args.spellName, stage))
	self:PlaySound(424140, "long")

	if stage < 3 then
		stage = stage + 1
		self:SetStage(stage)

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

		self:Bar(423260, timers[stage][423260][blazingMushroomCount], CL.count:format(L.blazing_mushroom, blazingMushroomCount)) -- Blazing Mushroom
		self:Bar(424581, timers[stage][424581][fieryGrowthCount], CL.count:format(L.fiery_growth, fieryGrowthCount)) -- Fiery Growth
		self:Bar(420236, timers[stage][420236][fallingStarCount], CL.count:format(self:SpellName(420236), fallingStarCount)) -- Falling Star
		self:Bar(424495, timers[stage][424495][massEntanglementCount], CL.count:format(L.mass_entanglement, massEntanglementCount)) -- Mass Entanglement
		self:Bar(422115, timers[stage][422115][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(423265, timers[stage][423265][flamingGerminationCount], CL.count:format(L.flaming_germination, flamingGerminationCount)) -- Flaming Germination
		if self:Mythic() then
			self:Bar(425576, timers[stage][425576][flareBombCount], CL.count:format(L.flare_bomb, flareBombCount)) -- Flare Bomb
		end
		if stage == 2 then
			self:Bar("stages", self:Easy() and 117 or self:Mythic() and 104 or 127, CL.count:format(CL.intermission, stage), 421603)
		elseif stage == 3 then
			self:Bar(420540, timers[stage][420540][incarnationMoonkinCount], CL.count:format(L.incarnation_moonkin, incarnationMoonkinCount)) -- Incarnation: Moonkin
			self:Bar(421398, timers[stage][421398][fireBeamCount], CL.count:format(self:SpellName(421398), fireBeamCount)) -- Fire Beam
			if not self:Mythic() then -- Mythic TBD
				self:Bar(424140, self:Easy() and 410.0 or 272.0, CL.count:format(args.spellName, stage)) -- Supernova
			end
		end
	end
end

function mod:SupernovaApplied(args)
	local stage = self:GetStage()
	self:CastBar(424140, 20, CL.count:format(args.spellName, stage-1))
end

function mod:SupernovaRemoved(args)
	supernovaCasting = false
	local stage = self:GetStage()
	self:StopBar(CL.cast:format(CL.count:format(args.spellName, stage-1)))
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
end

-- Stage Two: Tree of the Flame
function mod:IncarnationTreeOfFlameApplied(args)
	self:StopBar(CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
	-- self:PlaySound(args.spellId, "info")
	incarnationTreeOfFlameCount = incarnationTreeOfFlameCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][incarnationTreeOfFlameCount], CL.count:format(L.incarnation_tree_of_flame, incarnationTreeOfFlameCount))
end

function mod:IncarnationTreeOfFlameRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(args.spellName))
end

function mod:SuppressiveEmberApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.heal_absorb)
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local seedsLeft = 12

	function mod:FlamingGermination(args)
		self:StopBar(CL.count:format(L.flaming_germination, flamingGerminationCount))
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
			-- XXX floor? ceil? math.max(1, 12 - (20 - playersAlive))?
			seedsLeft = math.ceil(playersAlive * 0.6)
		end
	end

	function mod:SeedOfFlameApplied(args)
		if self:Me(args.destGUID) then
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
			self:PlaySound(args.spellId, "alarm")
		end
	end

	function mod:GerminatingAuraApplied(args)
		seedsLeft = seedsLeft - 1
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "blue", L.seed_soaked)
			if seedsLeft > 0 then
				self:PlaySound(args.spellId, "warning")
			end
		end
		if seedsLeft == 0 then
			self:Message(args.spellId, "green", L.all_seeds_soaked)
			self:PlaySound(args.spellId, "info")
		end
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
function mod:FallenFeatherApplied(args)
	if self:Me(args.destGUID) then
		self:StopBar(L.mass_entanglement, args.destName)
	end
end

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
		self:StopBar(CL.count:format(args.spellName, dispelCount-1), args.destName)
		self:TargetBar(args.spellId, 2, args.destName, CL.count:format(args.spellName, dispelCount))
		dispelCount = dispelCount + 1
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
