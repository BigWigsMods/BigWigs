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

local firstShadowgate = false
local gloomTouchCount = 1
local platformAddsKilled = 0
local worshippersKilled = 0
local acolytesKilled = 0

local abyssalInfusionCount = 1
local frothingGluttonyCount = 1
local queensSummonsCount = 1
local royalCondemnationCount = 1
local infestCount = 1
local gorgeCount = 1

local iconOrder = {6, 3, 7, 1, 2} -- blue, diamond, red, circle, star, skipping green due to the encounter being green tinted
local addMarks = {8, 5, 4}
local mobCollector, mobMarks = {}, {}

local timersNormal = { -- 11:32
	[1] = {
		[437592] = { 19.3, 56.0, 56.0, 0 }, -- Reactive Toxin
		[439814] = { 57.5, 54.0, 0 }, -- Silken Tomb
		[440899] = { 8.5, 40.0, 55.0, 0 }, -- Liquefy
		[437093] = { 12.5, 40.0, 55.0, 0 }, -- Feast
		[439299] = { 76.4, 48.0, 0 }, -- Web Blades
	},
	[3] = {
		[444829] = { 113.7, 82.0, 0 }, -- Queen's Summons
		[438976] = { 43.2, 141.6, 0 }, -- Royal Condemnation
		[443325] = { 29.2, 66.0, 80.0, 0 }, -- Infest
		[443336] = { 35.2, 66.0, 80.0, 0 }, -- Gorge
		[439299] = { 201.2, 0 }, -- Web Blades
	},
}

local timersHeroic = { -- 10:09 (enrage)
	[1] = {
		[437592] = { 19.3, 56.0, 56.0, 0 }, -- Reactive Toxin
		[439814] = { 57.4, 64.0, 0 }, -- Silken Tomb
		[440899] = { 8.5, 40.0, 51.0, 0 }, -- Liquefy
		[437093] = { 11.4, 40.0, 51.0, 0 }, -- Feast
		[439299] = { 20.5, 47.0, 43.0, 29.0, 0 }, -- Web Blades
	},
	[3] = {
		[444829] = { 119.0, 75.0, 0 }, -- Queen's Summons
		[438976] = { 43.2, 58.5, 99.5, 0 }, -- Royal Condemnation
		[443325] = { 29.7, 66.0, 82.0, 0 }, -- Infest
		[443336] = { 32.7, 66.0, 82.0, 0 }, -- Gorge
		[439299] = { 85.0, 39.0, 41.0, 18.5, 49.5, 0 }, -- Web Blades
	},
}

local timersMythic = { -- 10:10 (enrage)
	[1] = {
		[437592] = { 21.1, 56.0, 56.0, 0 }, -- Reactive Toxin
		[439814] = { 12.3, 40.0, 57.0, 0 }, -- Silken Tomb
		[440899] = { 6.4, 40.0, 54.0, 0 }, -- Liquefy
		[437093] = { 8.4, 40.0, 54.0, 0 }, -- Feast
		[439299] = { 20.3, 40.0, 13.0, 25.0, 19.0, 23.0, 0 }, -- Web Blades
	},
	[3] = {
		[444829] = { 43.3, 64.0, 83.0, 0 }, -- Queen's Summons
		[438976] = { 111.4, 86.0, 0 }, -- Royal Condemnation
		[443325] = { 30.0, 66.0, 80.0, 0 }, -- Infest
		[443336] = { 32.0, 66.0, 80.0, 0 }, -- Gorge
		[439299] = { 48.3, 37.0, 21.0, 17.0, 42.0, 21.0, 19.0, 36.0, 0 }, -- Web Blades
		[445422] = { 45.0, 80.0, 88.0, 35.5 }, -- Frothing Gluttony
	},
}

local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

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
	L.royal_condemnation = "Shackles"
	L.frothing_gluttony = "Ring"

	L.stage_two_end_message_storymode = "Run into the portal"
end

--------------------------------------------------------------------------------
-- Initialization
--

local reactiveToxinMarker = mod:AddMarkerOption(true, "player", 6, 437592, 6, 3, 7, 1, 2) -- Reactive Toxin
local chamberAcolyteMarker = mod:AddMarkerOption(true, "npc", 1, -29945, 1, 2) -- Chamber Acolyte
local abyssalInfusionMarker = mod:AddMarkerOption(true, "player", 1, 443888, 1, 2) -- Abyssal Infusion
local royalCondemnationMarker = mod:AddMarkerOption(true, "player", 6, 438976, 6, 3, 7) -- Royal Condemnation
local queensSummonsMarker = mod:AddMarkerOption(true, "npc", 8, 444829, 8, 5, 4) -- Queen's Summons (Summoned Acolyte)
function mod:GetOptions()
	return {
		{"stages", "CASTBAR"},
		-- Stage One: A Queen's Venom
		{437592, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Reactive Toxin
			reactiveToxinMarker,
			{451278, "SAY", "SAY_COUNTDOWN"}, -- Concentrated Toxin
			464638, -- Frothy Toxin (Fail)
			438481, -- Toxic Waves (Damage)
			437078, -- Acid (Damage)
		{437417, "CASTBAR"}, -- Venom Nova
			441556, -- Reactive Vapor (Fail)
		439814, -- Silken Tomb
			441958, -- Grasping Silk (Damage)
		440899, -- Liquefy
		{437093, "TANK_HEALER"}, -- Feast
		439299, -- Web Blades

		-- Intermission: The Spider's Web
		447076, -- Predation
		447456, -- Paralyzing Venom
		{447411, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Wrest

		-- Stage Two: Royal Ascension
		443403, -- Gloom (Damage)
		{460369, "CASTBAR"}, -- Shadowgate
		-- Queen Ansurek
		449940, -- Acidic Apocalypse (Fail)
		-- Ascended Voidspeaker
		447950, -- Shadowblast
		{448046, "COUNTDOWN"}, -- Gloom Eruption
		-- Devoted Worshipper
		{447967, "SAY", "ME_ONLY_EMPHASIZE"}, -- Gloom Touch
		448458, -- Cosmic Apocalypse (Fail)
		-- Chamber Guardian
		{448147, "TANK"}, -- Oust
		-- Chamber Expeller
		451600, -- Expulsion Beam
		-- Chamber Acolyte
		{455374, "NAMEPLATE"}, -- Dark Detonation
		chamberAcolyteMarker,
		-- Caustic Skitterer
		449236, -- Caustic Fangs

		-- Stage Three: Paranoia's Feast
		{443888, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Abyssal Infusion
			abyssalInfusionMarker,
			455387, -- Abyssal Reverberation
		445422, -- Frothing Gluttony
			445880, -- Froth Vapor (Fail)
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
		[437417] = L.venom_nova, -- Venom Nova (Nova)
		[439814] = L.silken_tomb, -- Silken Tomb (Roots)
		[440899] = CL.pools, -- Liquefy (Pools)
		[439299] = L.web_blades, -- Web Blades (Blades)
		[447456] = CL.waves, -- Paralyzing Venom (Waves)
		[447411] = L.wrest, -- Wrest (Pull In)
		[449940] = CL.you_die, -- Acidic Apocalypse (You die)
		[448046] = CL.knockback, -- Gloom Eruption (Knockback)
		[448458] = CL.you_die, -- Cosmic Apocalypse (You die)
		[443888] = CL.portals, -- Abyssal Infusion (Portals)
		[445422] = L.frothing_gluttony, -- Frothing Gluttony (Ring)
		[444829] = CL.big_adds, -- Queen's Summons (Big Adds)
		[438976] = L.royal_condemnation, -- Royal Condemnation (Shackles)
		[441865] = CL.link_with:format(L.royal_condemnation), -- Royal Shackles (Linked with Shackles)
		[443325] = CL.small_adds, -- Infest (Small Adds)
		[443336] = CL.pools, -- Gorge (Pools)
	}
end

function mod:OnRegister()
	self:SetSpellRename(439814, L.silken_tomb) -- Silken Tomb (Roots)
	self:SetSpellRename(447456, CL.waves) -- Paralyzing Venom (Waves)
	self:SetSpellRename(447411, L.wrest) -- Wrest (Pull In)
	self:SetSpellRename(449940, CL.you_die) -- Acidic Apocalypse (You die)
	self:SetSpellRename(448458, CL.you_die) -- Cosmic Apocalypse (You die)
	self:SetSpellRename(443888, CL.portals) -- Abyssal Infusion (Portals)
	self:SetSpellRename(445422, L.frothing_gluttony) -- Frothing Gluttony (Ring)
	self:SetSpellRename(444829, CL.big_adds) -- Queen's Summons (Big Adds)
	self:SetSpellRename(438976, L.royal_condemnation) -- Royal Condemnation (Shackles)
end

function mod:OnBossEnable()

	self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", nil, "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: A Queen's Venom
	self:Log("SPELL_CAST_START", "ReactiveToxin", 437592)
	self:Log("SPELL_CAST_SUCCESS", "ReactiveToxinSuccess", 437592) -- LFR
	self:Log("SPELL_AURA_APPLIED", "ReactiveToxinApplied", 437586)
	self:Log("SPELL_AURA_REMOVED", "ReactiveToxinRemoved", 437586)
	self:Log("SPELL_AURA_APPLIED", "ConcentratedToxinApplied", 451278)
	self:Log("SPELL_AURA_APPLIED", "FrothyToxinApplied", 464638)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrothyToxinApplied", 464638)
	self:Log("SPELL_DAMAGE", "ToxicWavesDamage", 438481)
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
	self:Log("SPELL_CAST_SUCCESS", "ParalyzingVenom", 447456)
	self:Log("SPELL_CAST_START", "Wrest", 447411)

	-- Stage Two: Royal Ascension
	self:Log("SPELL_CAST_START", "Shadowgate", 460369)
	self:Log("SPELL_AURA_APPLIED", "ShadowyDistortionApplied", 460218)
	self:Log("SPELL_AURA_APPLIED", "ShadowgateGloomTouchApplied", 464056)
	-- Queen Ansurek
	self:Log("SPELL_AURA_APPLIED", "CosmicProtection", 458247) -- Story Mode Stage 2
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
	-- Chamber Guardian
	self:Log("SPELL_CAST_START", "Oust", 448147)
	self:Death("GuardianDeath", 223204)
	-- Chamber Expeller
	self:Log("SPELL_CAST_START", "ExpulsionBeam", 451600)
	self:Death("ExpellerDeath", 224368)
	-- Chamber Acolyte
	self:Log("SPELL_CAST_START", "DarkDetonation", 455374)
	self:Death("ChamberAcolyteDeath", 226200)
	-- Caustic Skitterer
	-- self:Log("SPELL_AURA_APPLIED", "CausticFangsApplied", 449236)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CausticFangsApplied", 449236)

	-- Stage Three: Paranoia's Feast
	self:Log("SPELL_CAST_START", "AphoticCommunion", 449986)
	self:Log("SPELL_CAST_SUCCESS", "AphoticCommunionSuccess", 449986)
	self:Log("SPELL_CAST_START", "AbyssalInfusion", 443888)
	self:Log("SPELL_CAST_SUCCESS", "AbyssalInfusionSuccess", 443888) -- LFR
	self:Log("SPELL_AURA_APPLIED", "AbyssalInfusionApplied", 443903)
	self:Log("SPELL_AURA_REMOVED", "AbyssalInfusionRemoved", 443903)
	self:Log("SPELL_AURA_APPLIED", "AbyssalReverberationApplied", 455387)
	self:Log("SPELL_CAST_START", "FrothingGluttony", 445422)
	self:Log("SPELL_AURA_APPLIED", "FrothVaporAppliedOnBoss", 445880)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrothVaporAppliedOnBoss", 445880)
	self:Log("SPELL_CAST_START", "QueensSummons", 444829)
	self:Log("SPELL_AURA_APPLIED", "AcolytesEssenceApplied", 445152)
	self:Log("SPELL_CAST_START", "NullDetonation", 445021)
	self:Log("SPELL_AURA_APPLIED", "RoyalCondemnationApplied", 438974)
	self:Log("SPELL_AURA_REMOVED", "RoyalCondemnationRemoved", 438974)
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

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 437078, 443403, 441958) -- Acid, Gloom, Grasping Silk
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 437078, 443403, 441958)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 437078, 443403, 441958)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic

	self:SetStage(1)
	reactiveToxinCount = 1
	venomNovaCount = 1
	silkenTombCount = 1
	liquefyCount = 1
	feastCount = 1
	webBladesCount = 1

	mobCollector = {}
	mobMarks = {}

	if not self:Story() then
		self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
		self:Bar(440899, timers[1][440899][1], CL.count:format(CL.pools, liquefyCount)) -- Liquefy
		self:Bar(437093, timers[1][437093][1], CL.count:format(self:SpellName(437093), feastCount)) -- Feast
		self:Bar(437592, timers[1][437592][1], CL.count:format(L.reactive_toxin, reactiveToxinCount)) -- Reactive Toxin
		self:Bar("stages", 153.9, CL.intermission, 447207) -- Predation
	else
		self:Bar("stages", 100, CL.stage:format(2), 458247) -- Cosmic Protection
	end
	self:Bar(439299, self:Story() and 7.5 or timers[1][439299][1], CL.count:format(L.web_blades, webBladesCount)) -- Web Blades
	self:Bar(437417, self:Story() and 34.5 or 29.5, CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
	self:Bar(439814, self:Story() and 20.5 or timers[1][439814][1], CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 8 do
		local unit = ("boss%d"):format(i)
		local guid = self:UnitGUID(unit)
		if guid then
			local mobId = self:MobId(guid)
			if mobId == 221863 and not mobCollector[guid] then -- Summoned Acolyte
				mobCollector[guid] = true
				local index = mobMarks[mobId] or 1
				local icon = addMarks[index] -- marks first 3 with 8, 5, 4
				if icon then
					self:CustomIcon(queensSummonsMarker, unit, icon)
				end
				mobMarks[mobId] = index + 1
			end
		end
	end
end

function mod:AddMarking(_, unit, guid)
	if self:MobId(guid) == 226200 and not mobCollector[guid] then -- Chamber Acolyte
		mobCollector[guid] = true
		-- use the spawn counter from the mob spawn uid for marking (1/2)
		local uid = select(7, strsplit("-", guid))
		local index = bit.rshift(bit.band(tonumber(string.sub(uid, 1, 5), 16), 0xffff8), 3) + 1
		self:CustomIcon(chamberAcolyteMarker, unit, index)
	end
end

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

function mod:UNIT_SPELLCAST_INTERRUPTED(_, _, _, spellId)
	if spellId == 450191 then -- Wrest
		self:WrestInterrupted()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 450040 then -- Land
		self:Land()
	elseif spellId == 449962 then -- Acidic Apocalypse
		self:AcidicApocalypsePrecast()
	elseif self:Story() and spellId == 438667 then -- Royal Condemnation
		-- No RoyalCondemnationApplied in story mode
		self:StopBar(CL.count:format(L.royal_condemnation, royalCondemnationCount))
		self:Message(438976, "yellow", CL.count:format(L.royal_condemnation, royalCondemnationCount))
		self:Bar(441865, 6.2, CL.explosion)
		royalCondemnationCount = royalCondemnationCount + 1
		self:Bar(438976, 53.0, CL.count:format(L.royal_condemnation, royalCondemnationCount))
	end
end

-- Stage One: A Queen's Venom

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 37 then -- Intermission forced at 35%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

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
				self:PlaySound(437592, "warning") -- position?
				self:Say(437592, text, nil, icon and CL.rticon:format("Toxin", icon) or "Toxin")
				self:SayCountdown(437592, self:Mythic() and 5 or 6, icon)
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

	function mod:ReactiveToxinSuccess()
		if self:LFR() then -- No ReactiveToxinApplied in LFR
			self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount))
			self:Message(437592, "orange", CL.count:format(L.reactive_toxin, reactiveToxinCount))
			reactiveToxinCount = reactiveToxinCount + 1
			self:Bar(437592, timers[1][437592][reactiveToxinCount], CL.count:format(L.reactive_toxin, reactiveToxinCount))
		end
	end

	function mod:ReactiveToxinApplied(args)
		if not scheduled then
			self:StopBar(CL.count:format(L.reactive_toxin, reactiveToxinCount))
			reactiveToxinCount = reactiveToxinCount + 1
			self:Bar(437592, timers[1][437592][reactiveToxinCount], CL.count:format(L.reactive_toxin, reactiveToxinCount))
			scheduled = self:ScheduleTimer("MarkToxinPlayers", 0.5)
		end
		iconList = addPlayerToIconList(iconList, args.destName)
		local requiredPlayers = self:Mythic() and math.min(reactiveToxinCount, 3) or self:Easy() and 1 or 2
		if #iconList == requiredPlayers then
			self:MarkToxinPlayers()
		end
	end

	function mod:ReactiveToxinRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(437592)
		end
		self:CustomIcon(reactiveToxinMarker, args.destName)
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
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 3)
		if args.amount and args.amount > 3 then
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
	local msg = CL.count:format(L.venom_nova, venomNovaCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", CL.casting:format(msg))
	self:CastBar(args.spellId, self:Mythic() and 5 or self:Story() and 4 or 6, msg)
	self:PlaySound(args.spellId, "alert")
	venomNovaCount = venomNovaCount + 1
	if venomNovaCount < (self:Story() and 3 or 4) then
		self:Bar(args.spellId, self:Story() and 38 or 56.0, CL.count:format(L.venom_nova, venomNovaCount))
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
	self:Bar(args.spellId, self:Story() and 38.0 or timers[1][args.spellId][silkenTombCount], CL.count:format(L.silken_tomb, silkenTombCount))
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
			self:Bar(args.spellId, self:Story() and 38.0 or timers[self:GetStage()][args.spellId][webBladesCount], CL.count:format(L.web_blades, webBladesCount))
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
		self:StopCastBar(CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
		self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
		self:StopBar(CL.count:format(L.web_blades, webBladesCount)) -- Web Blades

		self:SetStage(1.5)
		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		paralyzingVenomCount = 1
		wrestCount = 1

		self:Bar(447411, 6.0, CL.count:format(L.wrest, wrestCount)) -- Wrest
		self:Bar(447456, 15.5, CL.count:format(CL.waves, paralyzingVenomCount)) -- Paralyzing Venom
	end

	function mod:PredationApplied(args)
		predationApplied = args.time
	end

	function mod:PredationRemoved(args)
		self:StopBar(CL.count:format(CL.waves, paralyzingVenomCount)) -- Paralyzing Venom
		self:StopBar(CL.count:format(L.wrest, wrestCount)) -- Wrest
		self:StopCastBar(CL.count:format(L.wrest, wrestCount-1))

		self:Message(447076, "green", CL.removed_after:format(args.spellName, args.time - predationApplied))

		self:SetStage(2)
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		wrestCount = 1
		gloomTouchCount = 1
		platformAddsKilled = 0
		worshippersKilled = 0
		acolytesKilled = 0
		firstShadowgate = true

		if self:Mythic() then
			if self:GetOption(chamberAcolyteMarker) then
				self:RegisterTargetEvents("AddMarking")
			end
			self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "ShadowgateNameplateCheck")
			self:RegisterEvent("UNIT_SPELLCAST_START")
			self:RegisterEvent("UNIT_SPELLCAST_STOP")
		end
	end
end

function mod:ParalyzingVenom(args)
	self:Message(args.spellId, "yellow", CL.count:format(CL.waves, paralyzingVenomCount))
	paralyzingVenomCount = paralyzingVenomCount + 1
	self:Bar(args.spellId, paralyzingVenomCount % 3 == 1 and 11.0 or 4.0, CL.count:format(CL.waves, paralyzingVenomCount))
end

function mod:Wrest(args)
	self:Message(args.spellId, "red", CL.count:format(L.wrest, wrestCount))
	self:CastBar(args.spellId, 6, CL.count:format(L.wrest, wrestCount))
	self:PlaySound(args.spellId, "alert")
	wrestCount = wrestCount + 1
	self:Bar(args.spellId, 19.0, CL.count:format(L.wrest, wrestCount))
end

-- Stage Two: Royal Ascension
function mod:CosmicProtection() -- Story Mode
	self:StopBar(CL.stage:format(2))
	self:StopBar(CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
	self:StopCastBar(CL.count:format(L.venom_nova, venomNovaCount)) -- Venom Nova
	self:StopBar(CL.count:format(L.silken_tomb, silkenTombCount)) -- Silken Tomb
	self:StopBar(CL.count:format(L.web_blades, webBladesCount)) -- Web Blades

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
end

do
	-- Shadowgate
	local prev = nil
	local casterGUID = nil

	-- cast events from nameplates, requires looking at the gate D;
	function mod:ShadowgateNameplateCheck(event, unit)
		local guid = self:UnitGUID(unit)
		if self:MobId(guid) == 228617 and casterGUID ~= guid then -- Shadowgate
			casterGUID = guid
			local name, _, _, _, endTime = UnitCastingInfo(unit)
			if name then
				local remaining = endTime / 1000 - GetTime()
				self:CastBar(460369, {remaining, 12})
			end
		end
		if self.targetEventFunc then -- for RegisterTargetEvents
			self:NAME_PLATE_UNIT_ADDED(event, unit)
		end
	end

	function mod:UNIT_SPELLCAST_START(_, unit, castGUID, spellId)
		if spellId == 460369 and prev ~= castGUID then -- Shadowgate
			firstShadowgate = false
			prev = castGUID
			casterGUID = self:UnitGUID(unit)
			self:CastBar(460369, 12)
		end
	end

	function mod:UNIT_SPELLCAST_STOP(_, unit, _, spellId)
		if spellId == 460369 then -- Shadowgate
			casterGUID = self:UnitGUID(unit)
			self:StopCastBar(460369)
		end
	end

	function mod:Shadowgate(args)
		if firstShadowgate then -- get the next cast
			firstShadowgate = false
			self:CastBar(args.spellId, 12)
		elseif casterGUID == args.sourceGUID then
			-- show the cast for the last gate you saw a nameplate for
			self:CastBar(args.spellId, 12)
		end
	end

	function mod:ShadowyDistortionApplied(args)
		if self:Me(args.destGUID) then
			casterGUID = nil
			self:StopCastBar(460369) -- Shadowgate
			-- Wrest swap
			local currentCount = wrestCount - 1
			local nextCount = wrestCount + 1
			self:StopCastBar(CL.count:format(self:SpellName(447411), currentCount)) -- Wrest
			local remaining = self:BarTimeLeft(CL.count:format(self:SpellName(447411), nextCount)) - 8
			self:StopBar(CL.count:format(self:SpellName(447411), nextCount))
			if remaining > 1 then
				self:CDBar(447411, remaining, CL.count:format(self:SpellName(447411), wrestCount))
			end
		elseif args.sourceGUID ~= casterGUID then -- dest portal isn't mine
			self:StopCastBar(460369) -- Shadowgate
		end
	end
end

function mod:ShadowgateGloomTouchApplied(args)
	local touchOnMe = false
	if self:Me(args.destGUID) then
		touchOnMe = true -- make sure there's a message
		self:PlaySound(447967, "alarm") -- spread
		-- self:Say(args.spellId)
	end
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if touchOnMe or (unit and self:UnitWithinRange(unit, 45)) then
		self:TargetMessage(447967, "yellow", args.destName)
	end
end

-- Queen Ansurek

do
	local prev = 0
	local scheduled = nil
	local threadsOnMe = false
	local currentCount, nextCount = nil, nil

	function mod:WrestReset()
		if platformAddsKilled == 2 then -- platform 2->3
			self:StopCastBar(460369) -- Shadowgate

			-- resets when you spawn the bridge? so may vary a bit
			local text = CL.count:format(L.wrest, wrestCount)
			local remaining = self:BarTimeLeft(text)
			if remaining > 1 then
				self:CDBar(447411, 12.0, text)
			end
			text = CL.count:format(L.wrest, wrestCount + 1)
			remaining = self:BarTimeLeft(text)
			if remaining > 1 then
				self:CDBar(447411, 12.0, text)
			end
		end
	end

	function mod:WrestInterrupted()
		if threadsOnMe then -- last cast was on me
			self:StopCastBar(CL.count:format(L.wrest, currentCount))
			self:StopBar(CL.count:format(L.wrest, nextCount))
			-- recasts next one here, messing with the numbering
			self:CDBar(447411, 10.7, CL.count:format(L.wrest, currentCount + 1))
		else
			-- other side, swap order
			self:StopBar(CL.count:format(L.wrest, wrestCount))
			self:CDBar(447411, 18.7, CL.count:format(L.wrest, nextCount))
		end
	end

	function mod:WrestCast()
		self:StopBar(CL.count:format(L.wrest, wrestCount))
		wrestCount = wrestCount + 1
		if threadsOnMe then
			currentCount = wrestCount - 1
			self:Message(447411, "red", CL.count:format(L.wrest, currentCount))
			self:CastBar(447411, 5, CL.count:format(L.wrest, currentCount))
			self:PlaySound(447411, "alert")
			nextCount = wrestCount + 1
			self:CDBar(447411, 16.0, CL.count:format(L.wrest, nextCount))
		else
			self:CDBar(447411, {8.0, 16.0}, CL.count:format(L.wrest, wrestCount))
		end
	end

	function mod:PredationThreadsApplied(args)
		if self:GetStage() == 2 then
			if args.time - prev > 2 then
				prev = args.time
				threadsOnMe = false
				scheduled = self:ScheduleTimer("WrestCast", 0.1)
			end
			if self:Me(args.destGUID) then
				threadsOnMe = true
			end
		end
	end

	function mod:AcidicApocalypsePrecast()
		-- platform 3->4
		self:CancelTimer(scheduled)
		for i = 1, wrestCount + 1 do
			self:StopBar(CL.count:format(L.wrest, i)) -- nuclear cleanup
		end
		self:StopCastBar(460369) -- Shadowgate
		-- firstShadowgate = true -- XXX can still catch desync'd casts here z.z
	end

	function mod:AcidicApocalypse(args)
		self:Bar(args.spellId, self:Easy() and 50 or 35, CL.you_die)
	end
end

function mod:AcidicApocalypseSuccess(args)
	self:Message(args.spellId, "red", CL.you_die)
	self:PlaySound(args.spellId, "alarm")
end

-- Ascended Voidspeaker

function mod:Shadowblast(args)
	local isPossible, isReady = self:Interrupter(args.sourceGUID)
	if isPossible then
		self:Message(args.spellId, "orange")
		if isReady then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:VoidspeakerDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			if self:Story() then
				self:Message("stages", "cyan", L.stage_two_end_message_storymode, false, nil, 5) -- Stay onscreen for 5s
			else
				self:StopCastBar(460369) -- Shadowgate

				self:Message("stages", "cyan", CL.killed:format(args.destName), false)
				self:Bar(448046, self:Mythic() and 5.2 or self:Easy() and 7.1 or 5.9, CL.knockback) -- Gloom Eruption

				if wrestCount == 1 then -- first Voidspeaker set
					firstShadowgate = true
					self:CDBar(447411, self:Easy() and 13.5 or 11.8, CL.count:format(L.wrest, wrestCount)) -- Wrest
					self:Bar(451600, 12.5) -- Expulsion Beam
					self:Bar(448147, 14.2) -- Oust
				end
			end
		end
	end
end

-- Devoted Worshipper
do
	local prev, prevSource = 0, nil
	local touchOnMe = false
	local playerList = {}
	function mod:GloomTouchApplied(args)
		if args.sourceGUID ~= prevSource or args.time - prev > 5 then
			prev = args.time
			prevSource = args.sourceGUID
			playerList = {}
			touchOnMe = false
			gloomTouchCount = gloomTouchCount + 1
		end
		if self:Me(args.destGUID) then
			touchOnMe = true -- make sure there's a message
			self:PlaySound(args.spellId, "alarm") -- spread
			self:Say(args.spellId, nil, nil, "Gloom Touch")
		end

		local unit = self:UnitTokenFromGUID(args.sourceGUID)
		if touchOnMe or (unit and self:UnitWithinRange(unit, 60)) then
			playerList[#playerList + 1] = args.destName
			self:TargetsMessage(args.spellId, "yellow", playerList, self:Mythic() and 1 or 2, CL.count:format(args.spellName, gloomTouchCount-1))
		end
	end
end

do
	local prev = 0
	function mod:CosmicApocalypse(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Bar(args.spellId, self:Mythic() and 80 or self:Easy() and 95 or 85, CL.you_die)
		end
	end
end

do
	local prev = 0
	function mod:CosmicApocalypseSuccess(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red", CL.you_die)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:WorshipperDeath(args)
	worshippersKilled = worshippersKilled + 1
	self:Message("stages", "cyan", CL.mob_killed:format(args.destName, worshippersKilled, 2), false)
	if worshippersKilled == 2 then
		self:StopBar(CL.you_die) -- Cosmic Apocalypse
	end
end

-- Chamber Guardian
function mod:Oust(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 60) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning")
		self:Bar(args.spellId, 10)
	end
end

do
	local prev = 0
	function mod:GuardianDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(448147) -- Oust
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
			platformAddsKilled = platformAddsKilled + 1
			self:WrestReset()
		end
	end
end

-- Chamber Expeller
function mod:ExpulsionBeam(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 60) then
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alert")
		self:Bar(args.spellId, 10)
	end
end

do
	local prev = 0
	function mod:ExpellerDeath(args)
		if args.time - prev > 2 then
			prev = args.time
			self:StopBar(451600) -- Expulsion Beam
			self:Message("stages", "cyan", CL.killed:format(args.destName), false)
			platformAddsKilled = platformAddsKilled + 1
			self:WrestReset()
		end
	end
end

-- Chamber Acolyte
function mod:DarkDetonation(args)
	local isPossible, isReady = self:Interrupter(args.sourceGUID)
	if isPossible then
		self:Message(args.spellId, "yellow")
		if isReady then
			self:PlaySound(args.spellId, "alarm")
		end
	end
	self:Nameplate(args.spellId, 13, args.sourceGUID)
end

function mod:ChamberAcolyteDeath(args)
	acolytesKilled = acolytesKilled + 1
	self:Message("stages", "cyan", CL.mob_killed:format(args.destName, acolytesKilled, 2), false)
	self:ClearNameplate(args.destGUID)
end

-- Caustic Skitterer
function mod:CausticFangsApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 10 == 0 then
			self:StackMessage(args.spellId, "blue", args.destName, amount, 20)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Stage Three: Paranoia's Feast
function mod:AphoticCommunion(args)
	self:StopBar(CL.you_die) -- Acidic Apocalypse
	if self:Mythic() then
		self:UnregisterTargetEvents()
		self:UnregisterEvent("UNIT_SPELLCAST_START")
		self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	end

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long")
	self:CastBar("stages", 20, CL.stage:format(3), args.spellId)

	abyssalInfusionCount = 1
	frothingGluttonyCount = 1
	queensSummonsCount = 1
	royalCondemnationCount = 1
	infestCount = 1
	gorgeCount = 1
	webBladesCount = 1

	if self:GetOption(queensSummonsMarker) then
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	end

	-- if not self:Story() then
	-- 	self:Bar(443325, timers[3][443325][1], CL.count:format(CL.small_adds, infestCount)) -- Infest
	-- 	self:Bar(443336, timers[3][443336][1], CL.count:format(CL.pools, gorgeCount)) -- Gorge
	-- 	self:Bar(443888, 59.1, CL.count:format(CL.portals, abyssalInfusionCount)) -- Abyssal Infusion
	-- 	self:Bar(439299, timers[3][439299][1], CL.count:format(L.web_blades, webBladesCount)) -- Web Blades
	-- end
	-- self:Bar(438976, self:Story() and 31.0 or timers[3][438976][1], CL.count:format(L.royal_condemnation, royalCondemnationCount)) -- Royal Condemnation
	-- self:Bar(445422, self:Story() and 62.0 or 68.8, CL.count:format(L.frothing_gluttony, frothingGluttonyCount)) -- Frothing Gluttony
	-- self:Bar(444829, self:Story() and 42.0 or timers[3][444829][1], CL.count:format(CL.big_adds, queensSummonsCount)) -- Queen's Summons
end

function mod:AphoticCommunionSuccess()
	-- timers from Land UNIT event, roughly 24s shorter than CLEU
	if not self:Story() then
		self:Bar(443325, 5.9, CL.count:format(self:SpellName(443325), infestCount)) -- Infest
		self:Bar(443336, self:Mythic() and 7.9 or self:Easy() and 11.9 or 8.9, CL.count:format(self:SpellName(443336), gorgeCount)) -- Gorge
		self:Bar(443888, 35.7, CL.count:format(self:SpellName(443888), abyssalInfusionCount)) -- Abyssal Infusion
		self:Bar(439299, self:Mythic() and 24.9 or self:Easy() and 177 or 62.0, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades

		self:PauseBar(443325, CL.count:format(self:SpellName(443325), infestCount)) -- Infest
		self:PauseBar(443336, CL.count:format(self:SpellName(443336), gorgeCount)) -- Gorge
		self:PauseBar(443888, CL.count:format(self:SpellName(443888), abyssalInfusionCount)) -- Abyssal Infusion
		self:PauseBar(439299, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades
	end

	self:Bar(444829, self:Mythic() and 19.9 or self:Easy() and 90 or self:Story() and 19.0 or 96.0, CL.count:format(self:SpellName(444829), queensSummonsCount)) -- Queen's Summons
	self:Bar(445422, self:Story() and 39.0 or 45.0, CL.count:format(self:SpellName(445422), frothingGluttonyCount)) -- Frothing Gluttony
	self:Bar(438976, self:Mythic() and 88.0 or self:Story() and 8.0 or 20.0, CL.count:format(self:SpellName(438976), royalCondemnationCount)) -- Royal Condemnation

	self:PauseBar(444829, CL.count:format(self:SpellName(444829), queensSummonsCount)) -- Queen's Summons
	self:PauseBar(445422, CL.count:format(self:SpellName(445422), frothingGluttonyCount)) -- Frothing Gluttony
	self:PauseBar(438976, CL.count:format(self:SpellName(438976), royalCondemnationCount)) -- Royal Condemnation
end

function mod:Land()
	if not self:Story() then
		self:ResumeBar(443325, CL.count:format(self:SpellName(443325), infestCount)) -- Infest
		self:ResumeBar(443336, CL.count:format(self:SpellName(443336), gorgeCount)) -- Gorge
		self:ResumeBar(443888, CL.count:format(self:SpellName(443888), abyssalInfusionCount)) -- Abyssal Infusion
		self:ResumeBar(439299, CL.count:format(self:SpellName(439299), webBladesCount)) -- Web Blades
	end
	self:ResumeBar(444829, CL.count:format(self:SpellName(444829), queensSummonsCount)) -- Queen's Summons
	self:ResumeBar(445422, CL.count:format(self:SpellName(445422), frothingGluttonyCount)) -- Frothing Gluttony
	self:ResumeBar(438976, CL.count:format(self:SpellName(438976), royalCondemnationCount)) -- Royal Condemnation
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
				self:PlaySound(443888, "warning") -- position?
				self:Say(443888, text, nil, icon and CL.rticon:format("Portal", icon) or "Portal")
				self:SayCountdown(443888, 6, icon)
			end
			playerList[#playerList+1] = player
			playerList[player] = icon
			self:TargetsMessage(438976, "orange", playerList, nil, CL.count:format(CL.portals, abyssalInfusionCount - 1), 2)
			self:CustomIcon(abyssalInfusionMarker, player, icon)
		end
	end

	function mod:AbyssalInfusion()
		playerList, iconList = {}, {}
	end

	function mod:AbyssalInfusionSuccess()
		if self:LFR() then -- No AbyssalInfusionApplied in LFR
			self:StopBar(CL.count:format(CL.portals, abyssalInfusionCount))
			self:Message(443888, "orange", CL.count:format(CL.portals, abyssalInfusionCount))
			abyssalInfusionCount = abyssalInfusionCount + 1
			if abyssalInfusionCount < 5 then
				self:Bar(443888, 80, CL.count:format(CL.portals, abyssalInfusionCount))
			end
		end
	end

	function mod:AbyssalInfusionApplied(args)
		if not scheduled then
			self:StopBar(CL.count:format(CL.portals, abyssalInfusionCount))
			abyssalInfusionCount = abyssalInfusionCount + 1
			if abyssalInfusionCount <  4 then
				self:Bar(443888, 80, CL.count:format(CL.portals, abyssalInfusionCount))
			end
			scheduled = self:ScheduleTimer("MarkAbyssalInfusionPlayers", 0.5)
		end
		iconList = addPlayerToIconList(iconList, args.destName)
		if #iconList == 2 then
			self:MarkAbyssalInfusionPlayers()
		end
	end

	function mod:AbyssalInfusionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(443888)
		end
		self:CustomIcon(abyssalInfusionMarker, args.destName)
	end
end

function mod:AbyssalReverberationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb) -- XXX Rename shorter / more clear?
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FrothingGluttony(args)
	self:StopBar(CL.count:format(L.frothing_gluttony, frothingGluttonyCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.frothing_gluttony, frothingGluttonyCount)))
	self:PlaySound(args.spellId, "alert")
	frothingGluttonyCount = frothingGluttonyCount + 1
	local cd
	if self:Mythic() then
		cd = timers[3][args.spellId][frothingGluttonyCount]
	elseif self:Story() then
		cd = 53
	else
		-- 4th (5th in LFR) cast triggers Cataclysmic Evolution
		cd = frothingGluttonyCount < (self:LFR() and 5 or 4) and 80 or 25.5
	end
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
			scheduled = self:ScheduleTimer("FrothVaporStacksMessage", 1)
		end
	end
end

function mod:QueensSummons(args)
	self:StopBar(CL.count:format(CL.big_adds, queensSummonsCount))
	self:Message(args.spellId, "cyan", CL.incoming:format(CL.count:format(CL.big_adds, queensSummonsCount)))
	self:PlaySound(args.spellId, "info")
	queensSummonsCount = queensSummonsCount + 1
	self:Bar(args.spellId, self:Story() and 53 or timers[3][args.spellId][queensSummonsCount], CL.count:format(CL.big_adds, queensSummonsCount))
	mobMarks[221863] = nil
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
		local isPossible, isReady = self:Interrupter(args.sourceGUID)
		if isPossible then
			self:Message(args.spellId, "yellow")
			if isReady then
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
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
				self:Bar(441865, 6.2, CL.explosion) -- 6~6.5
			else
				self:Bar(441865, 8.3, CL.on_group:format(L.royal_condemnation))
			end
			royalCondemnationCount = royalCondemnationCount + 1
			self:Bar(438976, timers[3][438976][royalCondemnationCount], CL.count:format(L.royal_condemnation, royalCondemnationCount))
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

	function mod:RoyalCondemnationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(438976)
		end
		self:CustomIcon(royalCondemnationMarker, args.destName)
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
	self:TargetBar(443325, self:Mythic() and 4 or 5, args.destName)
	if self:Me(args.destGUID) then
		self:Say(443325, CL.small_adds, nil, "Small Adds")
		self:SayCountdown(443325, self:Mythic() and 4 or 5)
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
			scheduled = self:ScheduleTimer("GloomHatchlingStacksMessage", 2)
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
