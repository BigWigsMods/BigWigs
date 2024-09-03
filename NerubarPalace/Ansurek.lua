--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Queen Ansurek", 2657, 2602)
if not mod then return end
mod:RegisterEnableMob(218370)
mod:SetEncounterID(2922)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local reactiveToxinCount = 1
local venomNovaCount = 1
local silkenTombCount = 1
local liquefyCount = 1
local feastCount = 1
local webBladesCount = 1

local paralyzingVenomCount = 1
local wrestCount = 1

local abyssalInfusionCount = 1
local frothingGluttonyCount = 1
local queensSummonsCount = 1
local royalCondemnationCount = 1
local infestCount = 1
local gorgeCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.reactive_toxin = "Toxins"
	L.silken_tomb = "Roots" -- Raid being rooted in place
	L.wrest = "Pull In"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		-- Stage One: A Queen's Venom
		{437592, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Reactive Toxin
			{451278, "SAY", "SAY_COUNTDOWN"}, -- Concentrated Toxin
			464638, -- Frothy Toxin
			438481, -- Toxic Waves
			437078, -- Acid
		437417, -- Venom Nova
			441556, -- Reactive Vapor
		439814, -- Silken Tomb
			441958, -- Grasping Silk
		440899, -- Liquefy
		{437093, "TANK"}, -- Feast
		439299, -- Web Blades

		-- Intermission: The Spider's Web
		447207, -- Predation
		447456, -- Paralyzing Venom
		447411, -- Wrest

		-- Stage Two: Royal Ascension
		-- Ascended Voidspeaker
		447950, -- Shadowblast
		-- Devoted Worshipper
		464056, -- Gloom Touch
		443403, -- Gloom
		-- Chamber Guardian
		{448147, "NAMEPLATE"}, -- Oust
		-- Chamber Expeller
		{451600, "NAMEPLATE"}, -- Expulsion Beam
		-- Caustic Skitterer
		449236, -- Caustic Fangs

		-- Stage Three: Paranoia's Feast
		{449986, "CASTBAR"}, -- Aphotic Communion
		{443888, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Abyssal Infusion
			{455387, "SAY", "SAY_COUNTDOWN"}, -- Abyssal Reverberation
		445422, -- Frothing Gluttony
			445880, -- Froth Vapor
		444829, -- Queen's Summons
			445152, -- Acolyte's Essence
			445021, -- Null Detonation
		{438976, "SAY", "ME_ONLY_EMPHASIZE"}, -- Royal Condemnation
		{443325, "SAY", "SAY_COUNTDOWN"}, -- Infest
			443726, -- Gloom Hatchling
		443336, -- Gorge
	}
end

function mod:OnBossEnable()
	-- Stage One: A Queen's Venom
	self:Log("SPELL_CAST_START", "ReactiveToxin", 437592)
	self:Log("SPELL_AURA_APPLIED", "ReactiveToxinApplied", 437586)
	self:Log("SPELL_AURA_APPLIED", "ConcentratedToxinApplied", 451278)
	self:Log("SPELL_AURA_APPLIED", "FrothyToxinApplied", 464638)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrothyToxinApplied", 464638)
	self:Log("SPELL_DAMAGE", "ToxicWaves", 438481)
	self:Log("SPELL_CAST_START", "VenomNova", 437417)
	self:Log("SPELL_AURA_APPLIED", "ReactiveVaporApplied", 441556)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ReactiveVaporApplied", 441556)
	self:Log("SPELL_CAST_START", "SilkenTomb", 439814)
	self:Log("SPELL_CAST_START", "Liquefy", 440899)
	self:Log("SPELL_AURA_APPLIED", "LiquefyApplied", 436800)
	self:Log("SPELL_CAST_START", "Feast", 437093)
	self:Log("SPELL_AURA_APPLIED", "FeastApplied", 455404)
	self:Log("SPELL_CAST_SUCCESS", "WebBlades", 439299)

	-- Intermission: The Spider's Web
	self:Log("SPELL_CAST_START", "Predation", 447076)
	self:Log("SPELL_AURA_APPLIED", "PredationApplied", 447207)
	self:Log("SPELL_AURA_REMOVED", "PredationRemoved", 447207)
	self:Log("SPELL_CAST_START", "ParalyzingVenom", 447456)
	self:Log("SPELL_AURA_APPLIED", "ParalyzingVenomApplied", 447532)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ParalyzingVenomApplied", 447532)
	self:Log("SPELL_CAST_START", "Wrest", 447411)

	-- Stage Two: Royal Ascension
	self:Log("SPELL_CAST_START", "WrestStageTwo", 450191)
	-- Ascended Voidspeaker
	self:Log("SPELL_CAST_START", "Shadowblast", 447950)
	self:Death("VoidspeakerDeath", 223150)
	-- Devoted Worshipper
	self:Log("SPELL_AURA_APPLIED", "GloomTouchApplied", 464056)
	self:Death("WorshipperDeath", 223318)
	-- Chamber Guardian
	self:Log("SPELL_CAST_START", "Oust", 448147)
	self:Death("GuardianDeath", 223204)
	-- Chamber Expeller
	self:Log("SPELL_CAST_START", "ExpulsionBeam", 451600)
	self:Death("ExpellerDeath", 224368)
	-- Caustic Skitterer
	self:Log("SPELL_AURA_APPLIED", "CausticFangsApplied", 449236)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CausticFangsApplied", 449236)

	-- Stage Three: Paranoia's Feast
	self:Log("SPELL_CAST_START", "AphoticCommunion", 449986)
	self:Log("SPELL_CAST_START", "AbyssalInfusion", 443888)
	self:Log("SPELL_AURA_APPLIED", "AbyssalInfusionApplied", 443903)
	self:Log("SPELL_AURA_APPLIED", "AbyssalReverberationApplied", 455387)
	self:Log("SPELL_CAST_START", "FrothingGluttony", 445422)
	self:Log("SPELL_AURA_APPLIED", "FrothVaporAppliedOnBoss", 445880)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrothVaporAppliedOnBoss", 445880)
	self:Log("SPELL_CAST_START", "QueensSummons", 444829)
	self:Log("SPELL_AURA_APPLIED", "AcolytesEssenceApplied", 445152)
	self:Log("SPELL_CAST_START", "NullDetonation", 445021)
	self:Log("SPELL_CAST_START", "RoyalCondemnation", 438976)
	self:Log("SPELL_CAST_START", "RoyalCondemnationApplied", 438974)
	self:Log("SPELL_CAST_START", "Infest", 443325)
	self:Log("SPELL_AURA_APPLIED", "InfestApplied", 443656)
	self:Log("SPELL_AURA_APPLIED", "GloomHatchlingAppliedOnBoss", 443726)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GloomHatchlingAppliedOnBoss", 443726)
	self:Log("SPELL_CAST_START", "Gorge", 443336)
	self:Log("SPELL_AURA_APPLIED", "GorgeApplied", 443342)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GorgeApplied", 443342)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 437078, 441958, 443403) -- Acid, Grasping Silk, GLoom
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 437078, 441958, 443403)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 437078, 441958, 443403)
end

function mod:OnEngage()
	self:SetStage(1)
	reactiveToxinCount = 1
	venomNovaCount = 1
	silkenTombCount = 1
	liquefyCount = 1
	feastCount = 1
	webBladesCount = 1

	--self:Bar(437592, 60, CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
	--self:Bar(437417, 60, CL.count:format(self:SpellName(437417), venomNovaCount)) -- Venom Nova
	--self:Bar(439814, 60, CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
	--self:Bar(436800, 60, CL.count:format(self:SpellName(436800), liquefyCount)) -- Liquefy
	--self:Bar(437093, 60, CL.count:format(self:SpellName(437093), feastCount)) -- Feast
	--self:Bar(439299, 60, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades

	--self:Bar("stages", 180, CL.intermission, 447207) -- Predation
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: A Queen's Venom
function mod:ReactiveToxin(args)
	self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.reactive_toxin, reactiveToxinCount)))
	reactiveToxinCount = reactiveToxinCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(L.reactive_toxin, reactiveToxinCount))
end

function mod:ReactiveToxinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(437592)
		self:PlaySound(437592, "warning") -- position?
		self:Say(437592, args.spellName, nil, "Reactive Toxin")
		self:SayCountdown(437592, 5)
	end
end

function mod:ConcentratedToxinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- avoid others
		self:Say(args.spellId, args.spellName, nil, "Concentrated Toxin")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:FrothyToxinApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 2)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:ToxicWaves(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou")
	end
end

function mod:VenomNova(args)
	self:StopBar(CL.count:format(args.spellId, venomNovaCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellId, venomNovaCount)))
	self:PlaySound(args.spellId, "alert")
	venomNovaCount = venomNovaCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellId, venomNovaCount))
end

function mod:ReactiveVaporApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "warning") -- big dot / failed
	end
end

function mod:SilkenTomb(args)
	self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.silken_tomb, silkenTombCount)))
	self:PlaySound(args.spellId, "alert")
	silkenTombCount = silkenTombCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(L.silken_tomb, silkenTombCount))
end

function mod:Liquefy(args)
	self:StopBar(CL.count:format(L.reactive_toxin, liquefyCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(L.reactive_toxin, liquefyCount)))
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	else -- rest of the raid
		self:PlaySound(args.spellId, "alert")
	end
	liquefyCount = liquefyCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(L.reactive_toxin, liquefyCount))
end

function mod:LiquefyApplied(args)
	if self:Tank() then
		self:TargetMessage(440899, "purple", args.destName)
		if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then -- Taunt
			self:PlaySound(440899, "warning")
		end
	end
end

function mod:Feast(args)
	self:StopBar(CL.count:format(args.spellName, feastCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, feastCount)))
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	feastCount = feastCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, feastCount))
end

function mod:FeastApplied(args)
	self:TargetMessage(437093, "purple", args.destName)
	if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(437093, "warning") -- tauntswap
	end
end

function mod:WebBlades(args)
	self:StopBar(CL.count:format(args.spellName, webBladesCount))
	self:Message(args.spellId, "cyan", CL.incoming:format(CL.count:format(args.spellName, webBladesCount)))
	self:PlaySound(args.spellId, "long")
	webBladesCount = webBladesCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, webBladesCount))
end

-- Intermission: The Spider's Web
do
	local predationApplied = 0
	function mod:Predation()
		self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
		self:StopBar(CL.count:format(self:SpellName(437417), venomNovaCount)) -- Venom Nova
		self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
		self:StopBar(CL.count:format(self:SpellName(436800), liquefyCount)) -- Liquefy
		self:StopBar(CL.count:format(self:SpellName(437093), feastCount)) -- Feast
		self:StopBar(CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades

		self:SetStage(1.5)
		self:Message("stages", "cyan", CL.intermission, false)

		paralyzingVenomCount = 1
		wrestCount = 1
		--self:Bar(447456, 60, CL.count:format(self:SpellName(447456), paralyzingVenomCount)) -- Paralyzing Venom
		--self:Bar(447411, 60, CL.count:format(L.wrest, wrestCount)) -- Wrest
	end

	function mod:PredationApplied(args)
		predationApplied = args.time
	end

	function mod:PredationRemoved(args)
		self:Message(args.spellId, "cyan", CL.removed_after:format(args.spellName, args.time - predationApplied))

		self:StopBar(CL.count:format(self:SpellName(447456), paralyzingVenomCount)) -- Paralyzing Venom
		self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest

		self:SetStage(2)
		self:Message("stages", "green", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		wrestCount = 1
		--self:Bar(447411, 60, CL.count:format(L.wrest, wrestCount)) -- Wrest
	end
end

function mod:ParalyzingVenom(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, paralyzingVenomCount))
	self:PlaySound(args.spellId, "alert")
	paralyzingVenomCount = paralyzingVenomCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, paralyzingVenomCount))
end

function mod:ParalyzingVenomApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(447456, "blue", args.destName, args.amount, 2)
		self:PlaySound(447456, "warning")
	end
end

function mod:Wrest(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.wrest, wrestCount))
	self:PlaySound(args.spellId, "alert")
	wrestCount = wrestCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(L.wrest, wrestCount))
end

-- Stage Two: Royal Ascension
function mod:WrestStageTwo()
	self:Message(447411, "yellow", CL.count:format(L.wrest, wrestCount))
	self:PlaySound(447411, "alert")
	wrestCount = wrestCount + 1
	--self:Bar(447411, 60, CL.count:format(L.wrest, wrestCount))
end

function mod:Shadowblast(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:VoidspeakerDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		end
	end
end

function mod:GloomTouchApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:WorshipperDeath(args)
	self:Message("stages", "cyan", CL.killed:format(args.destName), false) -- XXX Count how many?
end

function mod:Oust(args)
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
	end
	self:Nameplate(args.spellId, 1, args.sourceGUID) -- fixme
	self:ClearNameplate(args.sourceGUID)
end

do
	local prev = 0
	function mod:GuardianDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		end
		self:ClearNameplate(args.destGUID)
	end
end

function mod:ExpulsionBeam(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if not unit or self:UnitWithinRange(unit, 30) then -- The right way to handle this?
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
	self:Nameplate(args.spellId, 1, args.sourceGUID) -- fixme
	self:ClearNameplate(args.sourceGUID)
end

do
	local prev = 0
	function mod:ExpellerDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		end
		self:ClearNameplate(args.destGUID)
	end
end

function mod:CausticFangsApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 4 == 0 or amount > 20 then -- XXX Check amounts
			self:StackMessage(args.spellId, "blue", args.destName, amount, 10)
			if amount > 20 then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

-- Stage Three: Paranoia's Feast
function mod:AphoticCommunion(args)
	self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	self:CastBar(args.spellId, 20)

	abyssalInfusionCount = 1
	frothingGluttonyCount = 1
	queensSummonsCount = 1
	royalCondemnationCount = 1
	infestCount = 1
	gorgeCount = 1
	webBladesCount = 1

	--self:Bar(443888, 60, CL.count:format(self:SpellName(443888), abyssalInfusionCount)) -- Abyssal Infusion
	--self:Bar(445422, 60, CL.count:format(self:SpellName(445422), frothingGluttonyCount)) -- Frothing Gluttony
	--self:Bar(444829, 60, CL.count:format(self:SpellName(444829), queensSummonsCount)) -- Queen's Summons
	--self:Bar(438976, 60, CL.count:format(self:SpellName(438976), royalCondemnationCount)) -- Royal Condemnation
	--self:Bar(443325, 60, CL.count:format(self:SpellName(443325), infestCount)) -- Infest
	--self:Bar(443336, 60, CL.count:format(self:SpellName(443336), gorgeCount)) -- Gorge
	--self:Bar(439299, 60, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades
end

function mod:AbyssalInfusion(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:AbyssalInfusion(args)
	self:StopBar(CL.count:format(args.spellName, abyssalInfusionCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, abyssalInfusionCount)))
	abyssalInfusionCount = abyssalInfusionCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, abyssalInfusionCount))
end

function mod:AbyssalInfusionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(443888)
		self:PlaySound(443888, "warning") -- position?
		self:Say(443888, args.spellName, nil, "Abyssal Infusion")
		self:SayCountdown(443888, 6)
	end
end

function mod:AbyssalReverberationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, args.spellName, nil, "Abyssal Reverberation")
		self:SayCountdown(args.spellId, 5)
	end
end

function mod:FrothingGluttony(args)
	self:StopBar(CL.count:format(args.spellName, frothingGluttonyCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, frothingGluttonyCount)))
	self:PlaySound(args.spellId, "alert")
	frothingGluttonyCount = frothingGluttonyCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, frothingGluttonyCount))
end

function mod:FrothVaporAppliedOnBoss(args)
	self:StackMessage(args.spellId, "red", args.destName, args.amount, 1)
	self:PlaySound(args.spellId, "warning") -- failed?
end

function mod:QueensSummons(args)
	self:StopBar(CL.count:format(args.spellName, queensSummonsCount))
	self:Message(args.spellId, "cyan", CL.casting:format(CL.count:format(args.spellName, queensSummonsCount)))
	self:PlaySound(args.spellId, "info")
	queensSummonsCount = queensSummonsCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, queensSummonsCount))
end

function mod:AcolytesEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:NullDetonation(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit then
		local shield = self:UnitBuff(unit, 445013) -- Dark Barrier XXX Assumption you cannot kick whilst barrier is up
		if not shield then
			local canDo, ready = self:Interrupter(args.sourceGUID)
			if canDo then
				self:Message(args.spellId, "orange")
				if ready then
					self:PlaySound(args.spellId, "alarm")
				end
			end
		end
	end
end

function mod:RoyalCondemnation(args)
	self:StopBar(CL.count:format(args.spellName, royalCondemnationCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, royalCondemnationCount)))
	self:PlaySound(args.spellId, "alert")
	royalCondemnationCount = royalCondemnationCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, royalCondemnationCount))
end

function mod:RoyalCondemnationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(438976)
		self:PlaySound(438976, "warning")
		self:Say(438976, args.spellName, nil, "Royal Condemnation")
		--self:SayCountdown(438976, 6) -- XXX No debuff duration?
	end
end

function mod:Infest(args)
	self:StopBar(CL.count:format(args.spellName, infestCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, infestCount)))
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	infestCount = infestCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, infestCount))
end

function mod:InfestApplied(args)
	self:TargetMessage(443325, "purple", args.destName)
	if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(443325, "warning") -- tauntswap
	end
	if self:Me(args.destGUID) then
		self:Say(443325, args.spellName, nil, "Infest")
		self:SayCountdown(443325, 5)
	end
end

function mod:GloomHatchlingAppliedOnBoss(args) -- XXX Throttle incase of wipes?
	self:StackMessage(args.spellId, "red", args.destName, args.amount, 1)
	self:PlaySound(args.spellId, "info") -- beware
end

function mod:Gorge(args)
	self:StopBar(CL.count:format(args.spellName, gorgeCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, gorgeCount)))
	self:PlaySound(args.spellId, "alert")
	gorgeCount = gorgeCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, gorgeCount))
end

do
	local minTauntAmount = 4
	function mod:GorgeApplied(args)
		if self:Tank() then
			local amount = args.amount or 1
			if amount % 2 == 1 or amount >= minTauntAmount then
				self:StackMessage(443336, "purple", args.destName, amount, 1)
				if self:Me(args.destGUID) and amount >= minTauntAmount then
					self:PlaySound(443336, "alarm")
				elseif amount >= minTauntAmount then
					self:PlaySound(443336, "warning") -- Taunt?
				end
			end
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
end
