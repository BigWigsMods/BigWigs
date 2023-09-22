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

------------------------------------------------------------------2--------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fieryGrowthMarker = mod:AddMarkerOption(true, "player", 1, 424581, 1, 2, 3) -- Fiery Growth
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Moonkin of the Flame
		{422000, "TANK"}, -- Searing Wrath
		423260, -- Blazing Mushroom
		{424581, "SAY"}, -- Fiery Growth
		fieryGrowthMarker,
		424499, -- Scorching Ground
		420236, -- Falling Stars
		{422503, "SAY", "SAY_COUNTDOWN"}, -- Star Fragments
		{424495, "SAY", "SAY_COUNTDOWN"}, -- Mass Entanglement
		420540, -- Incarnation: Moonkin
		420239, -- Sunfire
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
	self:Log("SPELL_AURA_APPLIED", "SunfireApplied", 420239)
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
	self:GetStage(1)
	blazingMushroomCount = 1
	fieryGrowthCount = 1
	fallingStarsCount = 1
	massEntanglementCount = 1
	incarnationMoonkinCount = 1
	incarnationTreeOfFlameCount = 1

	self:Bar(420236, 6, CL.count:format(self:SpellName(420236), fallingStarsCount)) -- Falling Stars
	self:Bar(424495, 14, CL.count:format(self:SpellName(424495), massEntanglementCount)) -- Mass Entanglement
	self:Bar(423260, 22, CL.count:format(self:SpellName(423260), blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, 25, CL.count:format(self:SpellName(424581), fieryGrowthCount)) -- Fiery Growth
	self:Bar(420540, 28, CL.count:format(self:SpellName(420540), incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:Bar(421398, 40) -- Fire Beam
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
	self:StopBar(CL.count:format(args.spellName, blazingMushroomCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, blazingMushroomCount))
	if self:Tank() then
		self:PlaySound(args.spellId, "alert")
	end
	blazingMushroomCount = blazingMushroomCount + 1
	if self:GetStage() == 3 then
		local cd = {8, 30, 36.5, 40.5}
		self:Bar(args.spellId, cd[blazingMushroomCount], CL.count:format(args.spellName, blazingMushroomCount))
	elseif blazingMushroomCount < 3 then -- 2 per rotation?
		self:Bar(args.spellId, self:GetStage() == 2 and 48 or 40, CL.count:format(args.spellName, blazingMushroomCount))
	end
end

do
	local playerList = {}
	function mod:FieryGrowth(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, fieryGrowthCount))
		fieryGrowthCount = fieryGrowthCount + 1
		if self:GetStage() == 3 then
			local cd = {5, 87, 49, 55}
			self:Bar(args.spellId, cd[fieryGrowthCount], CL.count:format(args.spellName, fieryGrowthCount))
		elseif fieryGrowthCount < 3 then -- 2 per rotation?
			self:Bar(args.spellId, self:GetStage() == 2 and 48 or 40, CL.count:format(args.spellName, fieryGrowthCount))
		end
	end

	function mod:FieryGrowthApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.rticon:format(args.spellName, count))
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, fieryGrowthCount - 1))
		self:CustomIcon(fieryGrowthMarker, args.destName, count)
	end

	function mod:FieryGrowthRemoved(args)
		self:CustomIcon(fieryGrowthMarker, args.destName)
	end
end

function mod:FallingStars(args)
	self:StopBar(CL.count:format(args.spellName, fallingStarsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, fallingStarsCount))
	self:PlaySound(args.spellId, "alert")
	fallingStarsCount = fallingStarsCount + 1
	if self:GetStage() == 3 then
		local cd = {22, 48.5, 65.5, 46}
		self:Bar(args.spellId, cd[fallingStarsCount], CL.count:format(args.spellName, fallingStarsCount))
	elseif fallingStarsCount < 3 then -- 2 per rotation?
		self:Bar(args.spellId, self:GetStage() == 2 and 48 or 42, CL.count:format(args.spellName, fallingStarsCount))
	end
end

function mod:FallingStarsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(422503)
		self:PlaySound(422503, "warning")
		self:Say(422503)
		self:SayCountdown(422503, 5)
	end
end

function mod:FallingStarsRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(422503)
	end
end

function mod:MassEntanglement(args)
	self:StopBar(CL.count:format(args.spellName, massEntanglementCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, massEntanglementCount))
	massEntanglementCount = massEntanglementCount + 1
	if self:GetStage() == 3 then
		local cd = {15.5, 50, 64, 62.5}
		self:Bar(args.spellId, cd[massEntanglementCount], CL.count:format(args.spellName, massEntanglementCount))
	elseif massEntanglementCount < 3 then -- 2 per rotation?
		self:Bar(args.spellId, self:GetStage() == 2 and 48 or 40, CL.count:format(args.spellName, massEntanglementCount))
	end
end

function mod:MassEntanglementApplied(args)
	if self:Me(args.destGUID) then
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
	self:StopBar(CL.count:format(args.spellName, incarnationMoonkinCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, incarnationMoonkinCount))
	self:PlaySound(args.spellId, "info")
	incarnationMoonkinCount = incarnationMoonkinCount + 1
	if self:GetStage() == 3 then
		local cd = {26, 49.7, 43.2, 50}
		self:Bar(args.spellId, cd[incarnationMoonkinCount], CL.count:format(args.spellName, incarnationMoonkinCount))
	elseif incarnationMoonkinCount < 3 then -- 2 per rotation?
		self:Bar(args.spellId, 40, CL.count:format(args.spellName, incarnationMoonkinCount))
	end
end

function mod:SunfireApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FireBeam(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	if self:GetStage() == 3 then
		local cd = {34, 46.5, 43.5, 50}
		self:Bar(args.spellId, cd[incarnationMoonkinCount])
	elseif incarnationMoonkinCount == 2 then -- 2 per rotation?
		self:Bar(args.spellId, 40)
	end
end

-- Intermission: Burning Pursuit
function mod:IncarnationOwlOfTheFlame(args) -- XXX Also used outside intermission in Mythic
	self:StopBar(CL.count:format(self:SpellName(423260), blazingMushroomCount)) -- Blazing Mushroom
	self:StopBar(CL.count:format(self:SpellName(424581), fieryGrowthCount)) -- Fiery Growth
	self:StopBar(CL.count:format(self:SpellName(420236), fallingStarsCount)) -- Falling Stars
	self:StopBar(CL.count:format(self:SpellName(424495), massEntanglementCount)) -- Mass Entanglement
	self:StopBar(CL.count:format(self:SpellName(420540), incarnationMoonkinCount)) -- Incarnation: Moonkin
	self:StopBar(CL.count:format(self:SpellName(422115), incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
	self:StopBar(CL.intermission)

	local stage = self:GetStage()
	stage = stage + 0.5
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")
end

function mod:DreamEssenceApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:Message(args.spellId, "green", CL.you:format(CL.count:format(args.spellName, amount)))
		self:PlaySound(args.spellId, "info")
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

	self:Bar(423260, self:GetStage() == 3 and 8.5 or 18, CL.count:format(self:SpellName(423260), blazingMushroomCount)) -- Blazing Mushroom
	self:Bar(424581, self:GetStage() == 3 and 5 or 22, CL.count:format(self:SpellName(424581), fieryGrowthCount)) -- Fiery Growth
	self:Bar(420236, self:GetStage() == 3 and 22 or 10, CL.count:format(self:SpellName(420236), fallingStarsCount)) -- Falling Stars
	self:Bar(424495, self:GetStage() == 3 and 15.5 or 5, CL.count:format(self:SpellName(424495), massEntanglementCount)) -- Mass Entanglement
	if stage == 2 then
		self:Bar(422115, 26, CL.count:format(self:SpellName(422115), incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(423265, 35) -- Tranquility of Flame
		self:Bar("stages", 102, CL.intermission, 421603)
	elseif stage == 3 then
		self:Bar(420540, 26, CL.count:format(self:SpellName(420540), incarnationMoonkinCount)) -- Incarnation: Moonkin
		self:Bar(422115, 41, CL.count:format(self:SpellName(422115), incarnationTreeOfFlameCount)) -- Incarnation: Tree of Flame
		self:Bar(423265, 50) -- Tranquility of Flame
		self:Bar(421398, 34) -- Fire Beam
		self:Bar(424140, 220) -- Supernova
	end
end

-- Stage Two: Tree of the Flame
function mod:IncarnationTreeOfFlame(args)
	self:StopBar(CL.count:format(args.spellName, incarnationTreeOfFlameCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, incarnationTreeOfFlameCount))
	self:PlaySound(args.spellId, "info")
	incarnationTreeOfFlameCount = incarnationTreeOfFlameCount + 1
	if self:GetStage() == 3 then
		local cd = {42.0, 52.0, 56.0, 48.0}
		self:Bar(args.spellId, cd[incarnationTreeOfFlameCount], CL.count:format(args.spellName, incarnationTreeOfFlameCount))
	elseif incarnationTreeOfFlameCount < 3 then -- 2 in stage 1 + 2
		self:Bar(args.spellId, 48, CL.count:format(args.spellName, incarnationTreeOfFlameCount))
	end
end

function mod:SuppressiveEmberApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:TranquilityOfFlame(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")

	if self:GetStage() == 3 then
		local cd = {50, 47, 59, 47}
		self:Bar(args.spellId, cd[incarnationTreeOfFlameCount])
	elseif incarnationTreeOfFlameCount == 2 then -- 2 per rotation?
		self:Bar(args.spellId, 48)
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
function mod:LingeringCinderApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "cyan", args.destName, args.amount, 1)
		if amount > 1 then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end
