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
	L.stacks_onboss = "%dx %s on BOSS"

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
			438481, -- Toxic Waves (Damage)
			437078, -- Acid (Damage)
		437417, -- Venom Nova
			441556, -- Reactive Vapor
		439814, -- Silken Tomb
			441958, -- Grasping Silk (Damage)
		440899, -- Liquefy
		{437093, "TANK_HEALER"}, -- Feast
		439299, -- Web Blades

		-- Intermission: The Spider's Web
		447207, -- Predation
		447456, -- Paralyzing Venom
		447411, -- Wrest

		-- Stage Two: Royal Ascension
		-- Queen Ansurek
		449940, -- Acidic Apocalypse
		-- Ascended Voidspeaker
		447950, -- Shadowblast
		-- Devoted Worshipper
		464056, -- Gloom Touch
		443403, -- Gloom (Damage)
		462558, -- Cosmic Rupture
		448458, -- Cosmic Apocalypse
		-- Chamber Guardian
		{448147, "NAMEPLATE"}, -- Oust
		-- Chamber Expeller
		{451600, "NAMEPLATE"}, -- Expulsion Beam
		-- Caustic Skitterer
		449236, -- Caustic Fangs

		-- Stage Three: Paranoia's Feast
		-- {449986, "CASTBAR"}, -- Aphotic Communion
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
		451832, -- Cataclysmic Evolution
	}, {
		[437592] = -28754, -- Stage 1
		[447207] = -28755, -- Intermission
		[449940] = -28756, -- Stage 2
		[443888] = -28757, -- Stage 3
	}
end

function mod:OnBossEnable()
	-- Stage One: A Queen's Venom
	self:Log("SPELL_CAST_START", "ReactiveToxin", 437592)
	self:Log("SPELL_AURA_APPLIED", "ReactiveToxinApplied", 437586)
	self:Log("SPELL_AURA_APPLIED", "ConcentratedToxinApplied", 451278)
	self:Log("SPELL_AURA_APPLIED", "FrothyToxinApplied", 464638)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrothyToxinApplied", 464638)
	self:Log("SPELL_DAMAGE", "ToxicWavesDamage", 438481)
	self:Log("SPELL_CAST_START", "VenomNova", 437417)
	self:Log("SPELL_AURA_APPLIED", "ReactiveVaporApplied", 441556)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ReactiveVaporApplied", 441556)
	self:Log("SPELL_CAST_START", "SilkenTomb", 439814)
	self:Log("SPELL_AURA_APPLIED", "GraspingSilkDamage", 441958)
	self:Log("SPELL_DAMAGE", "GraspingSilkDamage", 441958)
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
	-- Queen Ansurek
	self:Log("SPELL_CAST_START", "WrestStageTwo", 450191)
	self:Log("SPELL_CAST_START", "AcidicApocalypse", 449940)
	self:Log("SPELL_CAST_SUCCESS", "AcidicApocalypseSuccess", 449940)
	-- Ascended Voidspeaker
	self:Log("SPELL_CAST_START", "Shadowblast", 447950)
	self:Death("VoidspeakerDeath", 223150)
	-- Devoted Worshipper
	self:Log("SPELL_AURA_APPLIED", "GloomTouchApplied", 464056)
	self:Log("SPELL_CAST_SUCCESS", "CosmicApocalypseSuccess", 448458)
	self:Death("WorshipperDeath", 223318)
	self:Log("SPELL_AURA_APPLIED", "CosmicRuptureApplied", 462558)
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
	self:Log("SPELL_AURA_APPLIED", "RoyalCondemnationApplied", 438974)
	self:Log("SPELL_CAST_START", "Infest", 443325)
	self:Log("SPELL_AURA_APPLIED", "InfestApplied", 443656)
	self:Log("SPELL_AURA_REMOVED", "InfestRemoved", 443656)
	self:Log("SPELL_AURA_APPLIED", "GloomHatchlingAppliedOnBoss", 443726)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GloomHatchlingAppliedOnBoss", 443726)
	self:Log("SPELL_CAST_START", "Gorge", 443336)
	self:Log("SPELL_AURA_APPLIED", "GorgeApplied", 443342)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GorgeApplied", 443342)
	self:Log("SPELL_CAST_SUCCESS", "CataclysmicEvolution", 451832)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 437078, 443403) -- Acid, Gloom
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 437078, 443403)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 437078, 443403)
end

function mod:OnEngage()
	self:SetStage(1)
	reactiveToxinCount = 1
	venomNovaCount = 1
	silkenTombCount = 1
	liquefyCount = 1
	feastCount = 1
	webBladesCount = 1

	self:Bar(440899, 8.5, CL.count:format(self:SpellName(440899), liquefyCount)) -- Liquefy
	self:Bar(437093, 12.5, CL.count:format(self:SpellName(437093), feastCount)) -- Feast
	self:Bar(437592, 18.5, CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
	self:Bar(437417, 29.5, CL.count:format(self:SpellName(437417), venomNovaCount)) -- Venom Nova
	self:Bar(439814, 57.5, CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
	self:Bar(439299, 76.5, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades

	self:Bar("stages", 153.9, CL.intermission, 447207) -- Predation
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 37 then -- Intermission forced at 35%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage One: A Queen's Venom
function mod:ReactiveToxin(args)
	self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount))
	self:Message(437592, "yellow", CL.casting:format(CL.count:format(L.reactive_toxin, reactiveToxinCount)))
	reactiveToxinCount = reactiveToxinCount + 1
	if reactiveToxinCount < 4 then
		self:Bar(437592, 56.0, CL.count:format(L.reactive_toxin, reactiveToxinCount))
	end
end

function mod:ReactiveToxinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(437592)
		self:PlaySound(437592, "warning") -- position?
		self:Say(437592, nil, nil, "Reactive Toxin")
		self:SayCountdown(437592, 5)
	end
end

function mod:ConcentratedToxinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- avoid others
		self:Say(args.spellId, nil, nil, "Concentrated Toxin")
		self:SayCountdown(args.spellId, 6)
	end
end

function mod:FrothyToxinApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 3)
		if amount > 3 then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:ToxicWavesDamage(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "underyou")
		self:PlaySound(args.spellId, "underyou")
	end
end

function mod:VenomNova(args)
	self:StopBar(CL.count:format(args.spellName, venomNovaCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, venomNovaCount)))
	self:PlaySound(args.spellId, "alert")
	venomNovaCount = venomNovaCount + 1
	if venomNovaCount < 4 then
		self:Bar(args.spellId, 56.0, CL.count:format(args.spellName, venomNovaCount))
	end
end

function mod:ReactiveVaporApplied(args)
	if self:Me(args.destGUID) then
		-- self:PersonalMessage(args.spellId)
		self:StackMessage(args.spellId, "red", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm") -- failed
	end
end

function mod:SilkenTomb(args)
	self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.silken_tomb, silkenTombCount)))
	self:PlaySound(args.spellId, "alarm") -- spread
	silkenTombCount = silkenTombCount + 1

	local cd
	if self:Easy() then
		local timers = { 57.5, 54.0 } -- normal
		cd = timers[silkenTombCount]
	else
		local timers = { 57.5, 47.9, 16.0 } -- heroic
		cd = timers[silkenTombCount]
	end

	self:Bar(args.spellId, cd, CL.count:format(L.silken_tomb, silkenTombCount))
end

do
	local prev = 0
	function mod:GraspingSilkDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:Liquefy(args)
	self:StopBar(CL.count:format(args.spellName, liquefyCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, liquefyCount)))
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	else -- rest of the raid
		self:PlaySound(args.spellId, "alert")
	end
	liquefyCount = liquefyCount + 1

	local cd
	if self:Easy() then
		local timers = { 8.5, 40.0, 55.0 } -- normal
		cd = timers[liquefyCount]
	else
		local timers = { 8.5, 39.9, 50.9 } -- heroic
		cd = timers[liquefyCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, liquefyCount))
end

function mod:LiquefyApplied(args)
	if self:Tank() then
		self:TargetMessage(440899, "purple", args.destName)
		if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
			self:PlaySound(440899, "warning") -- tauntswap
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

	local cd
	if self:Easy() then
		local timers = { 12.5, 40.1, 55.0 } -- normal
		cd = timers[feastCount]
	else
		local timers = { 11.4, 40.0, 51.0 } -- heroic
		cd = timers[feastCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, feastCount))
end

function mod:FeastApplied(args)
	self:TargetMessage(437093, "purple", args.destName)
	if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(437093, "warning") -- tauntswap
	end
end

do
	local prev = 0
	function mod:WebBlades(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, webBladesCount))
			self:Message(args.spellId, "cyan", CL.incoming:format(CL.count:format(args.spellName, webBladesCount)))
			self:PlaySound(args.spellId, "long")
			webBladesCount = webBladesCount + 1

			local cd
			if self:GetStage() == 1 then
				if self:Easy() then
					local timers = { 12.5, 48.0 } -- normal
					cd = timers[webBladesCount]
				else
					local timers = { 20.4, 47.0, 47.0, 25.0 } -- heroic
					cd = timers[webBladesCount]
				end
			else -- stage 3
				cd = 0 -- mystery
			end
			self:Bar(args.spellId, cd, CL.count:format(args.spellName, webBladesCount))
		end
	end
end

-- Intermission: The Spider's Web
do
	local predationApplied = 0
	function mod:Predation()
		self:StopBar(CL.intermission)
		self:StopBar(CL.count:format(self:SpellName(440899), liquefyCount)) -- Liquefy
		self:StopBar(CL.count:format(self:SpellName(437093), feastCount)) -- Feast
		self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
		self:StopBar(CL.count:format(self:SpellName(437417), venomNovaCount)) -- Venom Nova
		self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
		self:StopBar(CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades

		self:SetStage(1.5)
		self:Message("stages", "cyan", CL.intermission, false)

		paralyzingVenomCount = 1
		wrestCount = 1
		self:Bar(447411, 2.0, CL.count:format(L.wrest, wrestCount)) -- Wrest
		self:Bar(447456, 9.0, CL.count:format(self:SpellName(447456), paralyzingVenomCount)) -- Paralyzing Venom
	end

	function mod:PredationApplied(args)
		predationApplied = args.time
	end

	function mod:PredationRemoved(args)
		self:StopBar(CL.count:format(self:SpellName(447456), paralyzingVenomCount)) -- Paralyzing Venom
		self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest

		self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - predationApplied))

		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		wrestCount = 1
		self:Bar(447411, self:Easy() and 31.4 or 41.4, CL.count:format(L.wrest, wrestCount)) -- Wrest
	end
end

function mod:ParalyzingVenom(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, paralyzingVenomCount))
	-- self:PlaySound(args.spellId, "alert")
	paralyzingVenomCount = paralyzingVenomCount + 1
	self:Bar(args.spellId, paralyzingVenomCount % 3 == 1 and 11.0 or 4.0, CL.count:format(args.spellName, paralyzingVenomCount))
end

function mod:ParalyzingVenomApplied(args)
	-- if self:Me(args.destGUID) then
	-- 	self:StackMessage(447456, "blue", args.destName, args.amount, 2)
	-- 	self:PlaySound(447456, "warning")
	-- end
end

function mod:Wrest(args)
	self:Message(args.spellId, "orange", CL.count:format(L.wrest, wrestCount))
	self:PlaySound(args.spellId, "alert")
	wrestCount = wrestCount + 1
	self:Bar(args.spellId, 19.0, CL.count:format(L.wrest, wrestCount))
end

-- Stage Two: Royal Ascension
function mod:WrestStageTwo()
	self:Message(447411, "orange", CL.count:format(L.wrest, wrestCount))
	self:PlaySound(447411, "alert")
	wrestCount = wrestCount + 1
	self:Bar(447411, wrestCount % 3 == 1 and 18.5 or 8.0, CL.count:format(L.wrest, wrestCount))
end

function mod:AcidicApocalypse(args)
	-- self:Bar(args.spellId, 35)
end

function mod:AcidicApocalypseSuccess(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

-- Ascended Voidspeaker

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

-- Devoted Worshipper
function mod:GloomTouchApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm") -- spread
	end
end

function mod:CosmicRuptureApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning") -- gate
	end
end

do
	local prev = 0
	function mod:CosmicApocalypseSuccess(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:WorshipperDeath(args)
	self:Message("stages", "cyan", CL.killed:format(args.destName), false) -- XXX Count how many?
end

-- Chamber Guardian
function mod:Oust(args)
	if self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
	end
	self:Nameplate(args.spellId, 10, args.sourceGUID)
end

do
	local prev = 0
	function mod:GuardianDeath(args)
		-- if args.time - prev > 2 then
		-- 	prev = args.time
		-- 	self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		-- end
		self:ClearNameplate(args.destGUID)
	end
end

-- Chamber Expeller
function mod:ExpulsionBeam(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if not unit or self:UnitWithinRange(unit, 30) then
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alert")
	end
	self:Nameplate(args.spellId, 10, args.sourceGUID)
end

do
	local prev = 0
	function mod:ExpellerDeath(args)
		-- if args.time - prev > 2 then
		-- 	prev = args.time
		-- 	self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		-- end
		self:ClearNameplate(args.destGUID)
	end
end


-- Caustic Skitterer
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
	self:StopBar(449940) -- Acidic Apocalypse

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	--self:CastBar(args.spellId, 20)

	abyssalInfusionCount = 1
	frothingGluttonyCount = 1
	queensSummonsCount = 1
	royalCondemnationCount = 1
	infestCount = 1
	gorgeCount = 1
	webBladesCount = 1

	self:Bar(443325, 29.8, CL.count:format(self:SpellName(443325), infestCount)) -- Infest
	self:Bar(443336, self:Easy() and 35.8 or 32.6, CL.count:format(self:SpellName(443336), gorgeCount)) -- Gorge
	self:Bar(438976, 48.3, CL.count:format(self:SpellName(438976), royalCondemnationCount)) -- Royal Condemnation
	self:Bar(443888, 57.8, CL.count:format(self:SpellName(443888), abyssalInfusionCount)) -- Abyssal Infusion
	self:Bar(445422, 68.8, CL.count:format(self:SpellName(445422), frothingGluttonyCount)) -- Frothing Gluttony
	self:Bar(444829, 114.5, CL.count:format(self:SpellName(444829), queensSummonsCount)) -- Queen's Summons
	self:Bar(439299, self:Heroic() and 85.6 or 0, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades (XXX didn't see normal cast)
end

function mod:AbyssalInfusion(args)
	self:StopBar(CL.count:format(args.spellName, abyssalInfusionCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, abyssalInfusionCount)))
	abyssalInfusionCount = abyssalInfusionCount + 1
	--self:Bar(args.spellId, 60, CL.count:format(args.spellName, abyssalInfusionCount))
end

function mod:AbyssalInfusionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(443888)
		self:PlaySound(443888, "warning") -- position?
		self:Say(443888, nil, nil, "Abyssal Infusion")
		self:SayCountdown(443888, 6)
	end
end

function mod:AbyssalReverberationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, nil, nil, "Abyssal Reverberation")
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

do
	local stacks = 0
	local scheduled = nil
	function mod:FrothVaporStacksMessage()
		self:Message(445880, "red", L.stacks_onboss:format(stacks, self:SpellName(445880)))
		self:PlaySound(445880, "alarm") -- fail
		scheduled = nil
	end

	function mod:FrothVaporAppliedOnBoss(args)
		stacks = args.amount or 1
		if not scheduled then
			scheduled = self:ScheduleTimer("FrothVaporStacksMessage", 0.4)
		end
	end
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
	if unit and not self:UnitBuff(unit, 445013) then -- Dark Barrier XXX Assumption you cannot kick whilst barrier is up
		local canDo, ready = self:Interrupter(args.sourceGUID)
		if canDo then
			self:Message(args.spellId, "orange")
			if ready then
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
end

function mod:RoyalCondemnation(args)
	self:StopBar(CL.count:format(args.spellName, royalCondemnationCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, royalCondemnationCount)))
	self:PlaySound(args.spellId, "alert")
	-- castbar?
	royalCondemnationCount = royalCondemnationCount + 1
	-- XXX only saw 1 cast in normal, 2 in heroic
	self:Bar(args.spellId, 58.5, CL.count:format(args.spellName, royalCondemnationCount))
end

function mod:RoyalCondemnationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(438976)
		self:PlaySound(438976, "warning")
		self:Say(438976, nil, nil, "Royal Condemnation")
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
	-- XXX only saw 1 cast in normal, 2 in heroic
	self:Bar(args.spellId, 66.0, CL.count:format(args.spellName, infestCount))
end

function mod:InfestApplied(args)
	self:TargetMessage(443325, "purple", args.destName)
	if not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(443325, "warning") -- tauntswap
	end
	self:TargetBar(443325, 5, args.destName)
	if self:Me(args.destGUID) then
		self:Say(443325, nil, nil, "Infest")
		self:SayCountdown(443325, 5)
	end
end

function mod:InfestRemoved(args)
	self:StopBar(443325, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(443325)
	end
end

do
	local stacks = 0
	local scheduled = nil
	function mod:GloomHatchlingStacksMessage()
		self:Message(443726, "red", L.stacks_onboss:format(stacks, self:SpellName(443726)))
		self:PlaySound(443726, "alarm")
		scheduled = nil
	end

	function mod:GloomHatchlingAppliedOnBoss(args)
		stacks = args.amount or 1
		if not scheduled then
			scheduled = self:ScheduleTimer("GloomHatchlingStacksMessage", 1)
		end
	end
end

function mod:Gorge(args)
	self:StopBar(CL.count:format(args.spellName, gorgeCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, gorgeCount)))
	self:PlaySound(args.spellId, "alert")
	gorgeCount = gorgeCount + 1
	-- XXX only saw 1 cast in normal, 2 in heroic
	self:Bar(args.spellId, 66, CL.count:format(args.spellName, gorgeCount))
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

function mod:CataclysmicEvolution(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
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
