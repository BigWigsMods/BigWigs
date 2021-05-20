--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Soulrender Dormazain", 2450, 2445)
if not mod then return end
mod:RegisterEnableMob(175727, 175728) -- Soulrender Dormazain, Garrosh Hellscream
mod:SetEncounterID(2434)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local timers = {
	[350411] = {80.5, 162, 132.5, 65.0, 61, 60, 90, 64.5, 60, 63.5}, -- Hellscream _START
	[350615] = {28.5, 162.5, 60, 97, 60, 100, 60, 101, 60, 97.5}, -- Call Mawsworn _START
	[350217] = {12, 45.5, 45.5, 74, 45.5, 45.5, 68, 45.5, 45.5, 60, 45.5, 45.5, 80, 45.5, 45.5, 69.5} -- Torment
}

local brandCount = 1
local callMawswornCount = 1
local ruinbladeCount = 1
local hellscreamCount = 1
local encoreOfTormentCount = 1
local tormentCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cones = "Cones" -- Torment
	L.dance = "Dance" -- Encore of Torment
	L.brands = "Brands" -- Brand of Torment
	L.brand = "Brand" -- Single Brand of Torment
	L.spike = "Spike" -- Short for Agonizing Spike
	L.chains = "Chains" -- Hellscream
	L.chain = "Chain" -- Soul Manacles
	L.souls = "Souls" -- Rendered Soul
end

--------------------------------------------------------------------------------
-- Initialization
--


local brandOfTormentMarker = mod:AddMarkerOption(false, "player", 1, 350647, 1, 2) -- Brand of Torment
local agonizerMarker = mod:AddMarkerOption(false, "npc", 8, -23289, 8, 7, 6, 5) -- Mawsworn Agonizer
function mod:GetOptions()
	return {
		-- Soulrender Dormazain
		350217, -- Torment
		349985, -- Encore of Torment
		{350647, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Brand of Torment
		brandOfTormentMarker,
		{350422, "TANK"}, -- Ruinblade
		350615, -- Call Mawsworn
		agonizerMarker,
		351779, -- Agonizing Spike
		350650, -- Defiance
		350411, -- Hellscream
		354231, -- Soul Manacles
		351229, -- Rendered Soul
	},{
		[350217] = mod:SpellName(-22914), -- Soulrender Dormazain
	},{
		[350217] = L.cones, -- Torment (Cones)
		[349985] = L.dance, -- Encore of Torment (Dance)
		[350647] = L.brands, -- Brand of Torment (Brands)
		[350615] = CL.adds, -- Call Mawsworn (Adds)
		[351779] = L.spike, -- Agonizing Spike (Spike)
		[350411] = L.chains, -- Hellscream (Chains)
		[354231] = L.chain, -- Soul Manacles (Chain)
		[351229] = L.souls, -- Rendered Soul (Souls)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Soulrender Dormazain
	--self:Log("SPELL_CAST_SUCCESS", "Torment", 351581) -- USSC for the boss cast
	self:Log("SPELL_CAST_SUCCESS", "EncoreOfTorment", 349985)
	self:Log("SPELL_CAST_SUCCESS", "BrandOfTorment", 350648)
	self:Log("SPELL_AURA_APPLIED", "BrandOfTormentApplied", 350647)
	self:Log("SPELL_AURA_REMOVED", "BrandOfTormentRemoved", 350647)
	self:Log("SPELL_CAST_SUCCESS", "Ruinblade", 350422)
	self:Log("SPELL_AURA_APPLIED", "RuinbladeApplied", 350422)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RuinbladeApplied", 350422)
	self:Log("SPELL_CAST_START", "CallMawsworn", 350615)
	self:Log("SPELL_SUMMON", "AgonizerSpawn", 346459)
	self:Log("SPELL_CAST_START", "AgonizingSpike", 351779)
	self:Log("SPELL_AURA_APPLIED", "DefianceApplied", 350650)
	self:Log("SPELL_CAST_START", "Hellscream", 350411)
	self:Log("SPELL_AURA_APPLIED", "SoulManacles", 354231)
end

function mod:OnEngage()
	callMawswornCount = 1
	ruinbladeCount = 1
	hellscreamCount = 1
	encoreOfTormentCount = 1
	tormentCount = 1

	self:Bar(350422, 10.7) -- Ruinblade
	self:Bar(350217, 12, CL.count:format(L.cones, tormentCount)) -- Torment
	self:Bar(350615, 29.2, CL.count:format(CL.adds, callMawswornCount)) -- Call Mawsworn
	self:Bar(350411, 81.1, CL.count:format(L.chains, hellscreamCount)) -- Hellscream
	self:Bar(349985, 132, CL.count:format(L.dance, encoreOfTormentCount)) -- Encore of Torment
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:RenderedSoul()
	self:Bar(351229, 5, CL.count:format(L.souls, 1))
	self:ScheduleTimer("Message", 5, 351229, "yellow", CL.count:format(L.souls, 1))
	self:ScheduleTimer("Bar", 5, 351229, 5, CL.count:format(L.souls, 2))
	self:ScheduleTimer("Message", 10, 351229, "yellow", CL.count:format(L.souls, 2))
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 349873 then -- Boss casting Torment
		self:Message(350217, "yellow", CL.count:format(L.cones, tormentCount))
		tormentCount = tormentCount + 1
		self:Bar(350217, timers[350217][tormentCount], CL.count:format(L.cones, tormentCount))
		self:RenderedSoul()
	end
end

function mod:EncoreOfTorment(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.dance, encoreOfTormentCount))
	self:PlaySound(args.spellId, "alert")
	encoreOfTormentCount = encoreOfTormentCount + 1
	self:Bar(args.spellId, 161.1, CL.count:format(L.dance, encoreOfTormentCount))
end

do
	local playerList = {}
	function mod:BrandOfTorment(args)
		playerList = {}
		brandCount = brandCount + 1
		if brandCount < 4 then -- Comes in waves of 3 sets
			self:Bar(350647, 17, CL.count:format(L.brands, brandCount))
		end
	end

	function mod:BrandOfTormentApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(L.brand, brandCount-1))
			self:PlaySound(args.spellId, "warning")
			self:SayCountdown(args.spellId, 16)
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(L.brand, brandCount-1))
		self:CustomIcon(brandOfTormentMarker, args.destName, count)
	end

	function mod:BrandOfTormentRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(brandOfTormentMarker, args.destName)
	end
end

function mod:Ruinblade(args)
	ruinbladeCount = ruinbladeCount + 1
	self:Bar(args.spellId, ruinbladeCount % 4 == 1 and 62.5 or 33)
end

function mod:RuinbladeApplied(args)
	local amount = args.amount or 1
	self:NewStackMessage(args.spellId, "purple", args.destName, amount)
	self:PlaySound(args.spellId, "alarm")
end

do
	local agonizersMarked = 0
	local agonizersSpawned = 0
	local agonizerTracker = {}
	function mod:AgonizerMarking(event, unit, guid)
		if self:MobId(guid) == 177594 and agonizerTracker[guid] then -- Mawsworn Agonizer
			agonizersMarked = agonizersMarked + 1
			self:CustomIcon(agonizerMarker, unit, agonizerTracker[guid]) -- 8, 7, 6, 5
			if agonizersMarked == 4 then -- All 4 marked
				self:UnregisterTargetEvents()
			end
		end
	end

	function mod:AgonizerSpawn(args)
		agonizersSpawned = agonizersSpawned + 1
		agonizerTracker[args.destGUID] = 9-agonizersSpawned -- icon 8, 7, 6... etc
	end

	function mod:CallMawsworn(args)
		self:Message(args.spellId, "yellow", CL.count:format(CL.adds, callMawswornCount))
		self:PlaySound(args.spellId, "info")
		callMawswornCount = callMawswornCount + 1
		self:Bar(args.spellId, timers[args.spellId][callMawswornCount], CL.count:format(CL.adds, callMawswornCount))

		-- Start brand timers
		brandCount = 1
		self:Bar(350647, 7.5, CL.count:format(L.brands, brandCount))

		if self:GetOption(agonizerMarker) then
			agonizersSpawned = 0
			agonizersMarked = 0
			agonizerTracker = {}
			self:RegisterTargetEvents("AgonizerMarking")
			self:ScheduleTimer("UnregisterTargetEvents", 20)
		end
	end
end

function mod:AgonizingSpike(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local prev = 0
	function mod:DefianceApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:TargetMessage(args.spellId, "orange", args.destName)
		end
	end
end

function mod:Hellscream(args)
	self:Message(args.spellId, "red", L.chains)
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 35, CL.cast:format(L.chains))
	hellscreamCount = hellscreamCount + 1
	self:Bar(args.spellId, timers[args.spellId][hellscreamCount], CL.count:format(L.chains, hellscreamCount))

	self:RenderedSoul()
end

function mod:SoulManacles(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, L.chain)
		self:PlaySound(args.spellId, "info")
	end
end
