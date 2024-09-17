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

local gloomTouchCount = 1
local worshipperKilled = 0

local abyssalInfusionCount = 1
local frothingGluttonyCount = 1
local queensSummonsCount = 1
local royalCondemnationCount = 1
local infestCount = 1
local gorgeCount = 1

local iconOrder = {6, 3, 7, 1, 2} -- blue, diamond, red, circle, star, skipping green due to the encounter being green tinted
local addMarks = {8, 5, 4}
local queenSummonsCollector, queenSummonsMarks = {}, {}

local timersNormal = { -- 11:29
	[1] = {
		[439814] = { 57.5, 54.0, 0 }, -- Silken Tomb
		[440899] = { 8.5, 40.0, 55.0, 0 }, -- Liquefy
		[437093] = { 12.5, 40.0, 55.0, 0 }, -- Feast
		[439299] = { 76.4, 48.0, 0 }, -- Web Blades
	},
	[3] = {
		[444829] = { 113.7, 82.0 }, -- Queen's Summons
		[438976] = { 43.2, 141.6 }, -- Royal Condemnation
		[443325] = { 29.2, 66.0, 80.0 }, -- Infest
		[443336] = { 35.2, 66.0, 80.0 }, -- Gorge
		[439299] = { 201.2 }, -- Web Blades
	},
}

local timersHeroic = { -- 9:54
	[1] = {
		[439814] = { 57.5, 48.0, 16.0, 0 }, -- Silken Tomb
		[440899] = { 8.5, 40.0, 51.0, 0 }, -- Liquefy
		[437093] = { 11.4, 40.0, 51.0, 0 }, -- Feast
		[439299] = { 20.4, 47.0, 47.0, 25.0, 0 }, -- Web Blades
	},
	[3] = {
		[444829] = { 119.0, 75.0 }, -- Queen's Summons
		[438976] = { 43.2, 58.5, 99.5 }, -- Royal Condemnation
		[443325] = { 29.7, 66.0, 82.0 }, -- Infest
		[443336] = { 32.7, 66.0, 82.0 }, -- Gorge
		[439299] = { 85.0, 39.0, 41.0, 18.5, 49.5 }, -- Web Blades
	},
}

local timers = mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.stacks_onboss = "%dx %s on BOSS"

	L.reactive_toxin = "Toxins"
	L.reactive_toxin_say = "Toxin"
	L.venom_nova = "Nova"
	L.web_blades = "Blades"
	L.silken_tomb = "Roots" -- Raid being rooted in place
	L.wrest = "Pull In"
	L.slow = "Slow"
	L.royal_condemnation = "Shackles"
	L.frothing_gluttony = "Ring"
end

--------------------------------------------------------------------------------
-- Initialization
--

local reactiveToxinMarker = mod:AddMarkerOption(true, "player", 6, 437592, 6, 3, 7, 1, 2) -- Reactive Toxin
local abyssalInfusionMarker = mod:AddMarkerOption(true, "player", 6, 443888, 1, 2) -- Abyssal Infusion
local royalCondemnationMarker = mod:AddMarkerOption(true, "player", 6, 438976, 6, 3, 7) -- Royal Condemnation
local queensSummonsMarker = mod:AddMarkerOption(true, "npc", 8, 444829, 8, 5, 4) -- Queen's Summons
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: A Queen's Venom
		{437592, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Reactive Toxin
			reactiveToxinMarker,
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
		447076, -- Predation
		447456, -- Paralyzing Venom
		447411, -- Wrest

		-- Stage Two: Royal Ascension
		443403, -- Gloom (Damage)
		-- Queen Ansurek
		{449940, "CASTBAR"}, -- Acidic Apocalypse
		-- Ascended Voidspeaker
		447950, -- Shadowblast
		{448046, "COUNTDOWN"}, -- Gloom Eruption
		-- Devoted Worshipper
		{447967, "SAY", "ME_ONLY_EMPHASIZE"}, -- Gloom Touch
		462558, -- Cosmic Rupture
		{448458, "CASTBAR"}, -- Cosmic Apocalypse
		-- Chamber Guardian
		{448147, "NAMEPLATE"}, -- Oust
		-- Chamber Expeller
		{451600, "NAMEPLATE"}, -- Expulsion Beam
		-- Caustic Skitterer
		449236, -- Caustic Fangs

		-- Stage Three: Paranoia's Feast
		-- {449986, "CASTBAR"}, -- Aphotic Communion
		{443888, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Abyssal Infusion
			abyssalInfusionMarker,
			455387, -- Abyssal Reverberation
		445422, -- Frothing Gluttony
			445880, -- Froth Vapor
		444829, -- Queen's Summons
			queensSummonsMarker,
			445152, -- Acolyte's Essence
			445021, -- Null Detonation
		{438976, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Royal Condemnation
			royalCondemnationMarker,
			441865, -- Royal Shackles
		{443325, "SAY", "SAY_COUNTDOWN"}, -- Infest
			443726, -- Gloom Hatchling
		443336, -- Gorge
		451832, -- Cataclysmic Evolution
	}, {
		[437592] = -28754, -- Stage 1
		[447076] = -28755, -- Intermission
		[443403] = -28756, -- Stage 2
		[443888] = -28757, -- Stage 3
	}, {
		[437592] = L.reactive_toxin, -- Reactive Toxin (Toxins)
		[451278] = CL.bomb, -- Concentrated Toxin (Bomb)
		[439814] = L.silken_tomb, -- Silken Tomb (Roots)
		[440899] = CL.pools, -- Liquefy (Pools)
		[439299] = L.web_blades, -- Web Blades (Blades)
		[447456] = L.slow, -- Paralyzing Venom (Slow)
		[447411] = L.wrest, -- Wrest (Pull In)
		[448046] = CL.knockback, -- Gloom Eruption (Knockback)
		[443888] = CL.portals, -- Abyssal Infusion (Portals)
		[445422] = L.frothing_gluttony, -- Frothing Gluttony (Ring)
		[444829] = CL.big_adds, -- Queen's Summons (Big Adds)
		[438976] = L.royal_condemnation, -- Royal Condemnation (Shackles)
		[441865] = CL.link_with:format(L.royal_condemnation), -- Royal Shackles (Linked with Shackles)
		[443325] = CL.small_adds, -- Infest (Small Adds)
		[443336] = CL.pools, -- Gorge (Pools)
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
	self:Log("SPELL_AURA_APPLIED", "PredationThreadsApplied", 447170)

	self:Log("SPELL_CAST_START", "AcidicApocalypse", 449940)
	self:Log("SPELL_CAST_SUCCESS", "AcidicApocalypseSuccess", 449940)
	-- Ascended Voidspeaker
	self:Log("SPELL_CAST_START", "Shadowblast", 447950)
	self:Death("VoidspeakerDeath", 223150)
	-- Devoted Worshipper
	self:Log("SPELL_AURA_APPLIED", "GloomTouchApplied", 447967)
	self:Log("SPELL_CAST_START", "CosmicApocalypse", 448458)
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
	self:Log("SPELL_AURA_APPLIED", "DarkBarrierApplied", 445013)
	self:Log("SPELL_AURA_APPLIED", "AcolytesEssenceApplied", 445152)
	self:Log("SPELL_CAST_START", "NullDetonation", 445021)
	self:Log("SPELL_CAST_START", "RoyalCondemnation", 438976)
	self:Log("SPELL_AURA_APPLIED", "RoyalCondemnationApplied", 438974)
	self:Log("SPELL_AURA_APPLIED", "RoyalShacklesApplied", 441865)
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
	timers = self:Easy() and timersNormal or timersHeroic

	self:SetStage(1)
	reactiveToxinCount = 1
	venomNovaCount = 1
	silkenTombCount = 1
	liquefyCount = 1
	feastCount = 1
	webBladesCount = 1

	self:Bar(440899, timers[1][440899][1], CL.count:format(CL.pools, liquefyCount)) -- Liquefy
	self:Bar(437093, timers[1][437093][1], CL.count:format(self:SpellName(437093), feastCount)) -- Feast
	self:Bar(439299, timers[1][439299][1], CL.count:format(L.web_blades, webBladesCount)) -- Web Blades
	self:Bar(437592, 20.2, CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
	self:Bar(437417, 29.5, CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
	self:Bar(439814, timers[1][439814][1], CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb

	self:Bar("stages", 153.9, CL.intermission, 447207) -- Predation
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function addPlayerToIconList(list, playerName)
	list[#list+1] = {
		name = playerName,
		melee = mod:Melee(playerName),
		healer = mod:Healer(playerName),
		index = UnitInRaid(playerName) or 99,
	}
	return list
end

local function sortPriority(first, second)
	if first and second then
		if first.healer ~= second.healer then
			return not first.healer and second.healer
		end
		if first.melee ~= second.melee then
			return first.melee and not second.melee
		end
		return first.index < second.index
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 37 then -- Intermission forced at 35%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage One: A Queen's Venom
do
	local playerList, iconList = {}, {}
	local scheduled = nil
	function mod:MarkToxinPlayers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for melee > ranged > healer
		for i = 1, #iconList do
			local player = iconList[i].name
			local icon = self:GetOption(reactiveToxinMarker) and iconOrder[i] or nil
			if player == self:UnitName("player") then
				local text = icon and CL.rticon:format(L.reactive_toxin_say, icon) or L.reactive_toxin_say
				local msg = icon and CL.you_icon:format(L.reactive_toxin_say, icon) or nil
				self:PlaySound(437592, "warning") -- position?
				self:Say(437592, text, nil, icon and CL.rticon:format("Toxin", icon) or "Toxin")
				self:SayCountdown(437592, 5, icon)
			end
			playerList[#playerList+1] = player
			playerList[player] = icon
			self:TargetsMessage(437592, "yellow", playerList, nil, CL.count:format(L.reactive_toxin, reactiveToxinCount - 1))
			self:CustomIcon(reactiveToxinMarker, player, icon)
		end
	end

	function mod:ReactiveToxin()
		playerList, iconList = {}, {}
	end

	function mod:ReactiveToxinApplied(args)
		if not scheduled then
			self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount))
			reactiveToxinCount = reactiveToxinCount + 1
			if reactiveToxinCount < 4 then
				self:Bar(437592, 56.0, CL.count:format(L.reactive_toxin, reactiveToxinCount))
			end
			scheduled = self:ScheduleTimer("MarkToxinPlayers", 0.5)
		end
		iconList = addPlayerToIconList(iconList, args.destName)
		local requiredPlayers = self:Mythic() and 5 or self:Heroic() and 2 or 1
		if #iconList == requiredPlayers then
			self:MarkToxinPlayers()
		end
	end
end

function mod:ConcentratedToxinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:PlaySound(args.spellId, "alarm") -- avoid others
		self:Say(args.spellId, CL.bomb, nil, "Bomb")
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
	self:StopBar(CL.count:format(L.venom_nova, venomNovaCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.venom_nova, venomNovaCount)))
	self:PlaySound(args.spellId, "alert")
	venomNovaCount = venomNovaCount + 1
	if venomNovaCount < 4 then
		self:Bar(args.spellId, 56.0, CL.count:format(L.venom_nova, venomNovaCount))
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
	self:Bar(args.spellId, timers[1][args.spellId][silkenTombCount], CL.count:format(L.silken_tomb, silkenTombCount))
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
	self:StopBar(CL.count:format(CL.pools, liquefyCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(CL.pools, liquefyCount)))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	else -- rest of the raid
		self:PlaySound(args.spellId, "alert")
	end
	liquefyCount = liquefyCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][liquefyCount], CL.count:format(CL.pools, liquefyCount))
end

function mod:LiquefyApplied(args)
	if self:Tank() then
		self:TargetMessage(440899, "purple", args.destName)
		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if unit and not self:Tanking(unit) then
			self:PlaySound(440899, "warning") -- tauntswap
		end
	end
end

function mod:Feast(args)
	self:StopBar(CL.count:format(args.spellName, feastCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, feastCount)))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	feastCount = feastCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][feastCount], CL.count:format(args.spellName, feastCount))
end

function mod:FeastApplied(args)
	self:TargetMessage(437093, "purple", args.destName)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then
		self:PlaySound(437093, "warning") -- tauntswap
	end
end

do
	local prev = 0
	function mod:WebBlades(args)
		if args.time - prev > 5 then
			prev = args.time
			self:StopBar(CL.count:format(L.web_blades, webBladesCount))
			self:Message(args.spellId, "cyan", CL.incoming:format(CL.count:format(L.web_blades, webBladesCount)))
			self:PlaySound(args.spellId, "long")
			webBladesCount = webBladesCount + 1
			self:Bar(args.spellId, timers[self:GetStage()][args.spellId][webBladesCount], CL.count:format(L.web_blades, webBladesCount))
		end
	end
end

-- Intermission: The Spider's Web
do
	local predationApplied = 0
	function mod:Predation()
		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")
		self:StopBar(CL.intermission)
		self:StopBar(CL.count:format(CL.pools, liquefyCount)) -- Liquefy
		self:StopBar(CL.count:format(self:SpellName(437093), feastCount)) -- Feast
		self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
		self:StopBar(CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
		self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
		self:StopBar(CL.count:format(L.web_blades, webBladesCount)) -- Web Blades

		self:SetStage(1.5)
		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		paralyzingVenomCount = 1
		wrestCount = 1

		self:Bar(447411, 6.0, CL.count:format(L.wrest, wrestCount)) -- Wrest
		self:Bar(447456, 13.0, CL.count:format(L.slow, paralyzingVenomCount)) -- Paralyzing Venom
	end

	function mod:PredationApplied(args)
		predationApplied = args.time
	end

	function mod:PredationRemoved(args)
		self:StopBar(CL.count:format(L.slow, paralyzingVenomCount)) -- Paralyzing Venom
		self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest

		self:Message(447076, "green", CL.removed_after:format(args.spellName, args.time - predationApplied))

		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		wrestCount = 1
		gloomTouchCount = 1
		worshipperKilled = 0
	end
end

function mod:ParalyzingVenom(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.slow, paralyzingVenomCount))
	-- self:PlaySound(args.spellId, "alert")
	paralyzingVenomCount = paralyzingVenomCount + 1
	self:Bar(args.spellId, paralyzingVenomCount % 3 == 1 and 11.0 or 4.0, CL.count:format(L.slow, paralyzingVenomCount))
end

function mod:ParalyzingVenomApplied(args)
	-- if self:Me(args.destGUID) then
	-- 	self:StackMessage(447456, "blue", args.destName, args.amount, 2)
	-- 	self:PlaySound(447456, "warning")
	-- end
end

function mod:Wrest(args)
	self:Message(args.spellId, "red", CL.count:format(L.wrest, wrestCount))
	self:PlaySound(args.spellId, "alert")
	wrestCount = wrestCount + 1
	self:Bar(args.spellId, 19.0, CL.count:format(L.wrest, wrestCount))
end

-- Stage Two: Royal Ascension
do
	local prev, onMe, scheduled = 0, false, nil
	function mod:WrestTimers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		wrestCount = wrestCount + 1
		if not onMe then
				if wrestCount > 8 then return end
				self:CDBar(447411, {8.0, 16.0}, CL.count:format(L.wrest, wrestCount))
		else
				if wrestCount > 7 then return end
				self:CDBar(447411, 16.0, CL.count:format(L.wrest, wrestCount + 1))
		end
	end

	function mod:PredationThreadsApplied(args)
		if self:GetStage() == 2 then
			if args.time - prev > 2 then
				prev = args.time
				self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest
				onMe = false
				if not scheduled then
					scheduled = self:ScheduleTimer("WrestTimers", 0.1)
				end
			end
			if self:Me(args.destGUID) then
				self:Message(447411, "red", CL.count:format(L.wrest, wrestCount))
				self:PlaySound(447411, "alert")
				onMe = true
			end
		end
	end

	function mod:AcidicApocalypse(args)
		self:CancelTimer(scheduled)
		self:StopBar(CL.count:format(L.wrest, wrestCount))
		self:StopBar(CL.count:format(L.wrest, wrestCount + 1))
		self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
		self:CastBar(args.spellId, 35)
	end
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
			self:Bar(448046, self:Easy() and 7.1 or 5.9, CL.knockback) -- Gloom Eruption
			if wrestCount == 1 then
				self:CDBar(447411, self:Easy() and 13.5 or 11.8, CL.count:format(L.wrest, wrestCount)) -- Wrest
			end
		end
	end
end

-- Devoted Worshipper
do
	local prev, prevSource = 0, nil
	local playerList = {}
	function mod:GloomTouchApplied(args)
		if args.sourceGUID ~= prevSource or args.time - prev > 5 then
			prev = args.time
			prevSource = args.sourceGUID
			playerList = {}
			gloomTouchCount = gloomTouchCount + 1
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm") -- spread
			self:Say(args.spellId, nil, nil, "Gloom Touch")
		end

		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if unit and self:UnitWithinRange(unit, 40) then
			playerList[#playerList + 1] = args.destName
			self:TargetsMessage(args.spellId, "yellow", playerList, 2, CL.count:format(args.spellName, gloomTouchCount - 1))
		end
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
	function mod:CosmicApocalypse(args)
		if args.time - prev > 2 then
			prev = args.time
			self:CastBar(args.spellId, 85)
		end
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
	worshipperKilled = worshipperKilled + 1
	self:Message("stages", "cyan", CL.mob_remaining:format(args.destName, 2 - worshipperKilled), false)
	if worshipperKilled == 2 then
		self:StopBar(CL.cast:format(self:SpellName(448458))) -- Cosmic Apocalypse
	end
end

-- Chamber Guardian
function mod:Oust(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
	end
	self:Nameplate(args.spellId, 10, args.sourceGUID)
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
		if args.time - prev > 2 then
			prev = args.time
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
		end
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
	self:StopBar(CL.count:format(L.wrest, wrestCount + 1)) -- Wrest
	self:StopBar(CL.cast:format(self:SpellName(449940))) -- Acidic Apocalypse

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

	-- XXX variance on these?
	self:Bar(443325, timers[3][443325][1], CL.count:format(CL.small_adds, infestCount)) -- Infest
	self:Bar(443336, timers[3][443336][1], CL.count:format(CL.pools, gorgeCount)) -- Gorge
	self:CDBar(438976, timers[3][438976][1], CL.count:format(L.royal_condemnation, royalCondemnationCount)) -- Royal Condemnation
	self:Bar(443888, 59.1, CL.count:format(CL.portals, abyssalInfusionCount)) -- Abyssal Infusion
	self:Bar(445422, 68.8, CL.count:format(L.frothing_gluttony, frothingGluttonyCount)) -- Frothing Gluttony
	self:Bar(444829, timers[3][444829][1], CL.count:format(CL.big_adds, queensSummonsCount)) -- Queen's Summons
	self:Bar(439299, timers[3][439299][1], CL.count:format(L.web_blades, webBladesCount)) -- Web Blades
end

do
	local playerList, iconList = {}, {}
	local scheduled = nil
	function mod:MarkAbyssalInfusionPlayers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for melee > ranged > healer
		for i = 1, #iconList do
			local player = iconList[i].name
			local icon = self:GetOption(abyssalInfusionMarker) and i or nil
			if player == self:UnitName("player") then
				local text = icon and CL.rticon:format(CL.portal, icon) or CL.portal
				local msg = icon and CL.you_icon:format(CL.portal, icon) or nil
				self:PlaySound(443888, "warning") -- position?
				self:Say(443888, text, nil, icon and CL.rticon:format("Portal", icon) or "Portal")
				self:SayCountdown(443888, 6, icon)
			end
			playerList[#playerList+1] = player
			playerList[player] = icon
			self:TargetsMessage(438976, "yellow", playerList, nil, CL.count:format(CL.portals, abyssalInfusionCount - 1), 2)
			self:CustomIcon(abyssalInfusionMarker, player, icon)
		end
	end

	function mod:AbyssalInfusion()
		playerList, iconList = {}, {}
	end

	function mod:AbyssalInfusionApplied(args)
		if not scheduled then
			self:StopBar(CL.count:format(CL.portals, abyssalInfusionCount))
			abyssalInfusionCount = abyssalInfusionCount + 1
			if abyssalInfusionCount < (self:LFR() and 5 or 4) then
				self:Bar(443888, 80, CL.count:format(CL.portals, abyssalInfusionCount))
			end
			scheduled = self:ScheduleTimer("MarkAbyssalInfusionPlayers", 0.5)
		end
		iconList = addPlayerToIconList(iconList, args.destName)
		if #iconList == 2 then
			self:MarkAbyssalInfusionPlayers()
		end
	end
end

function mod:AbyssalReverberationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId) -- XXX Rename shorter / more clear?
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FrothingGluttony(args)
	self:StopBar(CL.count:format(L.frothing_gluttony, frothingGluttonyCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.frothing_gluttony, frothingGluttonyCount)))
	self:PlaySound(args.spellId, "alert")
	frothingGluttonyCount = frothingGluttonyCount + 1
	-- 4th (5th in LFR) cast triggers Cataclysmic Evolution
	local cd = frothingGluttonyCount < (self:LFR() and 5 or 4) and 80 or 25.5
	self:Bar(args.spellId, cd, CL.count:format(L.frothing_gluttony, frothingGluttonyCount))
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
	self:StopBar(CL.count:format(CL.big_adds, queensSummonsCount))
	self:Message(args.spellId, "cyan", CL.incoming:format(CL.count:format(CL.big_adds, queensSummonsCount)))
	self:PlaySound(args.spellId, "info")
	queensSummonsCount = queensSummonsCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][queensSummonsCount], CL.count:format(CL.big_adds, queensSummonsCount))

	queenSummonsCollector, queenSummonsMarks = {}, {}
	if self:GetOption(queensSummonsMarker) then
		self:RegisterTargetEvents("QueensSummonsMarking")
	end
end

function mod:QueensSummonsMarking(_, unit, guid)
	if queenSummonsCollector[guid] then
		self:CustomIcon(queensSummonsMarker, unit, queenSummonsCollector[guid]) -- icon order from Dark Barrioer _APPLIED
		queenSummonsCollector[guid] = nil
	end
end

function mod:DarkBarrierApplied(args)
	if self:GetOption(queensSummonsMarker) then
		for i = 1, #addMarks do
			if not queenSummonsCollector[args.destGUID] and not queenSummonsMarks[i] then
				queenSummonsMarks[i] = args.destGUID
				queenSummonsCollector[args.destGUID] = addMarks[i]
				return
			end
		end
	end
end

function mod:AcolytesEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:NullDetonation(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:UnitBuff(unit, 445013) then -- Dark Barrier
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
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.royal_condemnation, royalCondemnationCount)))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList, iconList = {}, {}
	local scheduled = nil
	local prev = 0
	function mod:MarkRoyalCondemnationPlayers()
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for melee > ranged > healer
		local warned = false
		for i = 1, #iconList do
			local player = iconList[i].name
			local icon = self:GetOption(royalCondemnationMarker) and iconOrder[i] or nil
			if player == self:UnitName("player") then
				local text = icon and CL.rticon:format(L.royal_condemnation, icon) or L.royal_condemnation
				local msg = icon and CL.you_icon:format(L.royal_condemnation, icon) or nil
				self:PlaySound(438976, "warning")
				self:Say(438976, text, nil, icon and CL.rticon:format("Shackles", icon) or "Shackles")
				self:SayCountdown(438976, 6, icon) -- projectile based both ways? z.z
				warned = true
			end
			playerList[#playerList+1] = player
			playerList[player] = icon
			local count = self:Mythic() and 3 or self:LFR() and 1 or 2
			self:TargetsMessage(438976, "yellow", playerList, count, CL.count:format(L.royal_condemnation, royalCondemnationCount - 1), 2)
			self:CustomIcon(royalCondemnationMarker, player, icon)
		end
		if not warned then -- Sound for others
			self:PlaySound(438976, "alert")
		end
	end

	function mod:RoyalCondemnationApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(L.royal_condemnation, royalCondemnationCount))
			if self:Easy() then
				self:Bar(438976, 6.2, CL.explosion) -- 6~6.5
			else
				self:Bar(438976, 8.3, CL.on_group:format(L.royal_condemnation))
			end
			royalCondemnationCount = royalCondemnationCount + 1
			self:CDBar(438976, timers[3][438976][royalCondemnationCount], CL.count:format(L.royal_condemnation, royalCondemnationCount))
			playerList, iconList = {}, {}
			if not scheduled then
				scheduled = self:ScheduleTimer("MarkRoyalCondemnationPlayers", 0.5)
			end
		end
		iconList = addPlayerToIconList(iconList, args.destName)
		local count = self:Mythic() and 3 or self:LFR() and 1 or 2
		if #iconList == count then
			self:MarkRoyalCondemnationPlayers()
		end
	end
end

function mod:RoyalShacklesApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "link_with", L.royal_condemnation) -- Linked with Shackles
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:Infest(args)
	self:StopBar(CL.count:format(CL.small_adds, infestCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(CL.small_adds, infestCount)))
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	infestCount = infestCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][infestCount], CL.count:format(CL.small_adds, infestCount))
end

function mod:InfestApplied(args)
	self:TargetMessage(443325, "purple", args.destName)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then
		self:PlaySound(443325, "warning") -- tauntswap
	end
	self:TargetBar(443325, 5, args.destName)
	if self:Me(args.destGUID) then
		self:Say(443325, CL.small_adds, nil, "Small Adds")
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
	self:StopBar(CL.count:format(CL.pools, gorgeCount))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(CL.pools, gorgeCount)))
	self:PlaySound(args.spellId, "alert")
	gorgeCount = gorgeCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][gorgeCount], CL.count:format(CL.pools, gorgeCount))
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
