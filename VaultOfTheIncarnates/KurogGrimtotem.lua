
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kurog Grimtotem", 2522, 2491)
if not mod then return end
mod:RegisterEnableMob(184986) -- Kurog Grimtotem
mod:SetEncounterID(2605)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local currentAltar = "?"
local nextAvoidSpell = 0
local nextDamageSpell = 0
local nextUltimateSpell = 0
local nextAddSpell = 0
local avoidCount = 1
local damageCount = 1
local ultimateCount = 1
local barrierRemovedCount = 0
local avoidCD = mod:Mythic() and 45 or 60.5
local damageCD = mod:Mythic() and 25.5 or 30.5
local ultimateCD = mod:Mythic() and 45 or 62

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- Types
	L.damage = "Damage Skills"
	L.damage_desc = "Display timers for Damage abilities (Magma Burst, Biting Chill, Enveloping Earth, Lightning Crash) when we don't know what alter the boss is at."
	L.damage_bartext = "%s [Dmg]" -- {Spell} [Dmg]

	L.avoid = "Avoid Skills"
	L.avoid_desc = "Display timers for Avoid abilities (Molten Rupture, Frigid Torrent, Erupting Bedrock, Shocking Burst) when we don't know what alter the boss is at."
	L.avoid_bartext = "%s [Avoid]" -- {Spell} [Avoid]

	L.ultimate = "Ultimate Skills"
	L.ultimate_desc = "Display timers for Ultimate abilities (Searing Carnage, Absolute Zero, Seismic Rupture, Thundering Strike) when we don't know what alter the boss is at."
	L.ultimate_bartext = "%s [Ult]" -- {Spell} [Ult]

	-- Fire
	L.magma_burst = "Pools"
	L.molten_rupture = "Waves"
	L.searing_carnage = "Dance"

	-- Frost
	L.biting_chill = "Chill DoT"
	L.frigid_torrent = "Orbs"
	L.absolute_zero = "Soaks"
	L.absolute_zero_melee = "Melee Soak"
	L.absolute_zero_ranged = "Ranged Soak"

	-- Earth
	L.enveloping_earth = "Heal Absorb"
	L.erupting_bedrock = "Quakes"

	-- Storm
	L.lightning_crash = "Zaps"
	L.thundering_strike = "Soaks"

	-- General
	L.primal_attunement = "Soft Enrage"

	-- Stage 2
	L.violent_upheaval = "Pillars"
end

--------------------------------------------------------------------------------
-- Altar Mapping
--

local alterSpellNameMap = {
	["?"] = {
		["damage"] = "?",
		["avoid"] = "?",
		["ultimate"] = "?",
	},
	["Fire"] = {
		["damage"] = L.magma_burst,
		["avoid"] = L.molten_rupture,
		["ultimate"] = L.searing_carnage,
	},
	["Frost"] = {
		["damage"] = L.biting_chill,
		["avoid"] = L.frigid_torrent,
		["ultimate"] = L.absolute_zero,
	},
	["Earth"] = {
		["damage"] = L.enveloping_earth,
		["avoid"] = L.erupting_bedrock,
		["ultimate"] = CL.adds,
	},
	["Storm"] = {
		["damage"] = L.lightning_crash,
		["avoid"] = CL.bombs,
		["ultimate"] = L.thundering_strike,
	}
}

local alterSpellIdMap = {
	["?"] = {
		["damage"] = "damage",
		["avoid"] = "avoid",
		["ultimate"] = "ultimate",
	},
	["Fire"] = {
		["damage"] = 382563, -- Magma Burst
		["avoid"] = 373329, -- Molten Rupture
		["ultimate"] = 374023, -- Searing Carnage
	},
	["Frost"] = {
		["damage"] = 373678, -- Biting Chill
		["avoid"] = 391019, -- Frigid Torrent
		["ultimate"] = 372458, -- Absolute Zero
	},
	["Earth"] = {
		["damage"] = 391056, -- Enveloping Earth
		["avoid"] = 395893, -- Erupting Bedrock
		["ultimate"] = 374691, -- Seismic Rupture
	},
	["Storm"] = {
		["damage"] = 373487, -- Lightning Crash
		["avoid"] = 390920, -- Shocking Burst
		["ultimate"] = 374215, -- Thunder Strike
	}
}

--------------------------------------------------------------------------------
-- Initialization
--

local aboluteZeroMarker = mod:AddMarkerOption(false, "player", 1, 372458, 1, 2)
local envelopingEarthMarker = mod:AddMarkerOption(false, "player", 1, 391056, 1, 2, 3)
local shockingBurstMarker = mod:AddMarkerOption(false, "player", 4, 390920, 4, 5)
function mod:GetOptions()
	return {
		"stages",
		371981, -- Elemental Surge
		374861, -- Elemental Shift
		{372158, "TANK"}, -- Sundering Strike
		"avoid",
		"damage",
		"ultimate",
		-- Fire Altar
		{382563, "SAY", "SAY_COUNTDOWN"}, -- Magma Burst
		373329, -- Molten Rupture
		{374023, "SAY_COUNTDOWN"}, -- Searing Carnage
		-- Frost Altar
		373678, -- Biting Chill
		391019, -- Frigid Torrent
		{372458, "SAY", "SAY_COUNTDOWN"}, -- Absolute Zero
		aboluteZeroMarker,
		-- Earthen Altar
		391056, -- Enveloping Earth
		envelopingEarthMarker,
		395893, -- Erupting Bedrock
		374691, -- Seismic Rupture
		-- Storm Altar
		{373487, "SAY", "SAY_COUNTDOWN"}, -- Lightning Crash
		{390920, "SAY", "SAY_COUNTDOWN"}, -- Shocking Burst
		shockingBurstMarker,
		374215, -- Thunder Strike
		-- Stage 2
		{374321, "TANK"}, -- Breaking Gravel
		{374427, "SAY", "SAY_COUNTDOWN"}, -- Ground Shatter
		374430, -- Violent Upheaval
		374623, -- Frost Binds
		374624, -- Freezing Tempest
		{391696, "SAY"}, -- Lethal Current
		-- Stage 3
		396241, -- Primal Attunement
	}, {
		["stages"] = "general",
		[382563] = -25040, -- Fire Altar
		[373678] = -25061, -- Frost Altar
		[391056] = -25064, -- Earthen Altar
		[373487] = -25068, -- Storm Altar
		[374321] = -25071, -- Stage 2
		[396241] = -26000, -- Stage 3
	},{
		-- Fire
		[382563] = L.magma_burst, -- Magma Burst (Pools)
		[373329] = L.molten_rupture, -- Magma Rupture (Waves)
		[374023] = L.searing_carnage, -- Searing Carnage (Dance)
		-- Frost
		[373678] = L.biting_chill, -- Biting Chill (Chill DoT)
		[391019] = L.frigid_torrent, -- Frigid Torrent (Orbs / Frost Orbs)
		[372458] = L.absolute_zero, -- Absolute Zero (Soaks)
		-- Earth
		[391056] = L.enveloping_earth, -- Enveloping Earth (Healing Absorb)
		[395893] = L.erupting_bedrock, -- Erupting Bedrock (Dance)
		[374691] = CL.adds, -- Seismic Rupture (Adds)
		-- Storm
		[373487] = L.lightning_crash, -- Lightning Crash (Zaps)
		[390920] = CL.bombs, -- Shocking Burst (Bombs)
		[374215] = L.thundering_strike, -- Thundering Strike (Soaks)
		-- Stage 2
		[374427] = CL.bombs, -- Ground Shatter (Bombs)
		-- Stage 3
		[396241] = L.primal_attunement, -- Primal Attunement (Soft Enrage)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "Dominance", 396106, 396109, 396085, 396113) -- Flaming, Earthen, Freezing, Thundering
	self:Log("SPELL_PERIODIC_DAMAGE", "ElementalSurge", 371981)
	self:Log("SPELL_DAMAGE", "ElementalShiftDamage", 374861)
	self:Log("SPELL_AURA_APPLIED", "PrimalBarrierApplied", 374779)
	self:Log("SPELL_AURA_REMOVED", "PrimalBarrierRemoved", 374779)
	self:Log("SPELL_AURA_APPLIED", "SunderingStrikeApplied", 372158)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingStrikeApplied", 372158)
	-- Fire
	self:Log("SPELL_CAST_SUCCESS", "MagmaBurst", 382563)
	self:Log("SPELL_CAST_START", "MoltenRupture", 373329)
	self:Log("SPELL_CAST_START", "SearingCarnage", 374022)
	self:Log("SPELL_AURA_APPLIED", "SearingCarnageApplied", 374023)
	self:Log("SPELL_AURA_REMOVED", "SearingCarnageRemoved", 374023)
	-- Frost
	self:Log("SPELL_CAST_START", "BitingChill", 373678)
	self:Log("SPELL_CAST_START", "FrigidTorrent", 391019)
	self:Log("SPELL_CAST_START", "AbsoluteZero", 372456)
	self:Log("SPELL_AURA_APPLIED", "AbsoluteZeroApplied", 372458)
	self:Log("SPELL_AURA_REMOVED", "AbsoluteZeroRemoved", 372458)
	-- Earthen
	self:Log("SPELL_CAST_START", "EnvelopingEarth", 391055)
	self:Log("SPELL_AURA_APPLIED", "EnvelopingEarthApplied", 391056)
	self:Log("SPELL_AURA_REMOVED", "EnvelopingEarthRemoved", 391056)
	self:Log("SPELL_CAST_START", "EruptingBedrock", 395893)
	self:Log("SPELL_CAST_START", "SeismicRupture", 374691)
	-- Storm
	self:Log("SPELL_CAST_START", "LightningCrash", 373487)
	self:Log("SPELL_AURA_APPLIED", "LightningCrashApplied", 373487)
	self:Log("SPELL_AURA_REMOVED", "LightningCrashRemoved", 373487)
	--self:Log("SPELL_CAST_START", "ShockingBurst", 390920) -- XXX Enable when event is back
	self:Log("SPELL_AURA_APPLIED", "ShockingBurstApplied", 390920)
	self:Log("SPELL_AURA_REMOVED", "ShockingBurstRemoved", 390920)
	self:Log("SPELL_CAST_START", "ThunderStrike", 374215)

	-- Stage 2
	-- Tectonic Crusher
	self:Log("SPELL_AURA_APPLIED_DOSE", "BreakingGravelApplied", 374321)
	self:Log("SPELL_CAST_SUCCESS", "GroundShatter", 374427)
	self:Log("SPELL_AURA_APPLIED", "GroundShatterApplied", 374427)
	self:Log("SPELL_AURA_REMOVED", "GroundShatterRemoved", 374427)
	self:Log("SPELL_CAST_START", "ViolentUpheaval", 374430)
	-- Frozen Destroyer
	self:Log("SPELL_CAST_START", "FrostBinds", 374623)
	self:Log("SPELL_AURA_APPLIED", "FrostBindsApplied", 374623)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FrostBindsApplied", 374623)
	self:Log("SPELL_CAST_START", "FreezingTempest", 374624)
	-- Thundering Ravager
	self:Log("SPELL_CAST_START", "StormBreak", 374622)
	self:Log("SPELL_AURA_APPLIED", "LethalCurrentApplied", 391696)
	self:Death("IntermissionAddDeath", 190690, 190686, 190588, 190688) -- Thundering Ravager, Frozen Destroyer, Tectonic Crusher, Blazing Fiend

	-- Stage 3
	self:Log("SPELL_AURA_APPLIED", "PrimalAttunement", 396241)
end

function mod:OnEngage()
	-- Cooldowns of the spells to re-create bars
	avoidCD = self:Mythic() and 45 or 60.5
	damageCD = self:Mythic() and 25.5 or 30.5
	ultimateCD = self:Mythic() and 45 or 62

	self:SetStage(1)
	currentAltar = "?"
	barrierRemovedCount = 0
	avoidCount = 1
	damageCount = 1
	ultimateCount = 1

	local avoidPullCD = self:Mythic() and 23 or 30
	local damagePullCD = self:Mythic() and 14.5 or 20
	local ultimatePullCD = self:Mythic() and 45 or 62

	nextAvoidSpell = avoidPullCD + GetTime()
	nextDamageSpell = damagePullCD + GetTime()
	nextUltimateSpell = ultimatePullCD + GetTime()

	self:Bar("avoid", avoidPullCD, CL.count:format(L.avoid_bartext:format(currentAltar), avoidCount), "ability_kick")
	self:Bar("damage", damagePullCD, CL.count:format(L.damage_bartext:format(currentAltar), damageCount), "spell_ice_magicdamage")
	self:Bar("ultimate", ultimatePullCD, CL.count:format(L.ultimate_bartext:format(currentAltar), ultimateCount), "achievement_bg_most_damage_killingblow_dieleast")
	self:Bar("stages", 125, CL.stage:format(2), 374779)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 391096 then -- Damage Selection
		self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
		damageCount = damageCount + 1
		if self:Mythic() then -- Adjust CD
			damageCD = damageCount % 2 == 0 and 25.5 or 19.5
		end
		nextDamageSpell = damageCD + GetTime()
		self:CDBar(alterSpellIdMap[currentAltar]["damage"], damageCD, CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount)) -- SetOption:374023,372458,374691,374215:::
	elseif spellId == 391100 then -- Avoid Selection
		self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
		avoidCount = avoidCount + 1
		nextAvoidSpell = avoidCD + GetTime()
		self:CDBar(alterSpellIdMap[currentAltar]["avoid"], avoidCD, CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount)) -- SetOption:374023,372458,374691,374215:::
	elseif spellId == 374680 then -- Ultimate Selection
		self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
		ultimateCount = ultimateCount + 1
		nextUltimateSpell = ultimateCD + GetTime()
		self:CDBar(alterSpellIdMap[currentAltar]["ultimate"], ultimateCD, CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount)) -- SetOption:374023,372458,374691,374215:::
	elseif spellId == 390920 then -- XXX Temp Shocking Burst
		self:ShockingBurst()
	end
end

do
	local prev = 0
	function mod:ElementalSurge(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prevAltar, newAltar = nil, nil
	function mod:Dominance(args)
		if args.spellId ==  396085 then -- Earth
			newAltar = "Earth"
		elseif args.spellId ==  396106 then -- Fire
			newAltar = "Fire"
		elseif args.spellId ==  396109 then -- Frost
			newAltar = "Frost"
		elseif args.spellId ==  396113 then -- Storm
			newAltar = "Storm"
		end

		if newAltar ~= currentAltar then
			self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
			self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
			self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
			currentAltar = newAltar
			prevAltar = newAltar

			local avoidRemainingCD = nextAvoidSpell - GetTime()
			local damageRemainingCD = nextDamageSpell - GetTime()
			local ultimateRemainingCD = nextUltimateSpell - GetTime()
			self:Bar(alterSpellIdMap[currentAltar]["avoid"], {avoidRemainingCD, avoidCD}, CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount), alterSpellIdMap[currentAltar]["avoid"]) -- SetOption:374023,372458,374691,374215:::
			self:Bar(alterSpellIdMap[currentAltar]["damage"], {damageRemainingCD, damageCD}, CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount), alterSpellIdMap[currentAltar]["damage"]) -- SetOption:374023,372458,374691,374215:::
			self:Bar(alterSpellIdMap[currentAltar]["ultimate"], {ultimateRemainingCD, ultimateCD}, CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount), alterSpellIdMap[currentAltar]["ultimate"]) -- SetOption:374023,372458,374691,374215:::
		end
	end
end

do
	local prev = 0
	function mod:ElementalShiftDamage(args)
		if args.time - prev > 1 then
			prev = args.time
			self:Message(args.spellId, "cyan")
			self:PlaySound(args.spellId, "long")
		end
	end
end

function mod:PrimalBarrierApplied()
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long") -- phase
	self:SetStage(2)

	self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
	self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
	self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
	self:StopBar(372158) -- Sundering Strike
	self:StopBar(CL.stage:format(2)) -- Stage 2
end

function mod:PrimalBarrierRemoved()
	barrierRemovedCount = barrierRemovedCount + 1
	self:Message("stages", "cyan", CL.stage:format(barrierRemovedCount), false)
	self:PlaySound("stages", "long") -- phase
	self:SetStage(barrierRemovedCount)
	currentAltar = "?"

	avoidCount = 1
	damageCount = 1
	ultimateCount = 1

	local avoidIntermissionCD = self:Mythic() and 69 or 30
	local damageIntermissionCD = self:Mythic() and 14.5 or 20
	local ultimateIntermissionCD = self:Mythic() and 45 or 60

	nextAvoidSpell = avoidIntermissionCD + GetTime()
	nextDamageSpell = damageIntermissionCD + GetTime()
	nextUltimateSpell = ultimateIntermissionCD + GetTime()

	self:Bar("avoid", avoidIntermissionCD, CL.count:format(L.avoid_bartext:format(currentAltar), avoidCount), "ability_kick")
	self:Bar("damage", damageIntermissionCD, CL.count:format(L.damage_bartext:format(currentAltar), damageCount), "spell_ice_magicdamage")
	self:Bar("ultimate", ultimateIntermissionCD, CL.count:format(L.ultimate_bartext:format(currentAltar), ultimateCount), "achievement_bg_most_damage_killingblow_dieleast")
	if barrierRemovedCount < 2 then
		self:Bar("stages", 127, CL.stage:format(2), 374779) -- Stage 2
	else
		self:Bar(396241, 94, L.primal_attunement) -- Primal Attunement
	end
end

function mod:SunderingStrikeApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 30.5)
end

-- Fire
function mod:MagmaBurst(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.damage_bartext:format(L.magma_burst), damageCount))
	self:PlaySound(args.spellId, "info")
end

function mod:MoltenRupture(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.avoid_bartext:format(L.molten_rupture), avoidCount)))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	function mod:SearingCarnage(args)
		self:Message(374023, "yellow", CL.casting:format(CL.count:format(L.ultimate_bartext:format(L.searing_carnage), ultimateCount)))
		self:PlaySound(374023, "info")
		playerList = {}
	end

	function mod:SearingCarnageApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.ultimate_bartext:format(L.searing_carnage), ultimateCount-1))
	end

	function mod:SearingCarnageRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

-- Frost Altar
function mod:BitingChill(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.damage_bartext:format(L.biting_chill), damageCount)))
	self:PlaySound(args.spellId, "info")
	self:CastBar(args.spellId, 13) -- 3s cast + 10s duration
end

function mod:FrigidTorrent(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.avoid_bartext:format(L.frigid_torrent), avoidCount)))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList, iconList = {}, {}
	local scheduled = nil
	local function sortPriority(first, second)
		if first and second then
			if first.tank ~= second.tank then
				return first.tank and not second.tank
			end
			if first.melee ~= second.melee then
				return first.melee and not second.melee
			end
			return first.index < second.index
		end
	end

	function mod:AbsoluteZero(args)
		self:Message(372458, "orange", CL.casting:format(CL.count:format(L.ultimate_bartext:format(L.absolute_zero), ultimateCount)))
		playerList = {}
		iconList = {}
	end

	function mod:MarkPlayers()
		local playedSound = false
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		table.sort(iconList, sortPriority) -- Priority for tanks > melee > ranged
		for i = 1, #iconList do
			if iconList[i].player == self:UnitName("player") then
				local text = i == 1 and L.absolute_zero_melee or L.absolute_zero_ranged -- Melee or Ranged Soak
				self:Say(372458, CL.rticon:format(text, i))
				self:PersonalMessage(372458, nil, text)
				self:SayCountdown(372458, 5, i)
				self:PlaySound(372458, "warning") -- debuffmove
				playedSound = true
			end
			playerList[#playerList+1] = iconList[i].player
			playerList[iconList[i].player] = i
			self:CustomIcon(aboluteZeroMarker, iconList[i].player, i)
		end
		if not playedSound then -- play for others
			self:TargetsMessage(372458, "yellow", playerList, 2, CL.count:format(L.ultimate_bartext:format(L.absolute_zero), ultimateCount-1))
			self:PlaySound(372458, "alert") -- stack
		end
	end

	function mod:AbsoluteZeroApplied(args)
		if not scheduled then
			scheduled = self:ScheduleTimer("MarkPlayers", 0.3)
		end
		iconList[#iconList+1] = {player=args.destName, melee=self:Melee(args.destName), index=UnitInRaid(args.destName) or 99, tank=self:Tank(args.destName)} -- 99 for players not in your raid (or if you have no raid)
		if #iconList == 2 then
			self:MarkPlayers()
		end
	end

	function mod:AbsoluteZeroRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(aboluteZeroMarker, args.destName)
	end
end

-- Earth Altar
do
	local playerList = {}
	function mod:EnvelopingEarth(args)
		self:Message(391056, "yellow", CL.casting:format(CL.count:format(L.damage_bartext:format(L.enveloping_earth), damageCount)))
		self:PlaySound(391056, "info")
		playerList = {}
	end

	function mod:EnvelopingEarthApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- debuffdamage
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, L.enveloping_earth)
		self:CustomIcon(envelopingEarthMarker, args.destName, count)
	end

	function mod:EnvelopingEarthRemoved(args)
		self:CustomIcon(envelopingEarthMarker, args.destName)
	end
end

function mod:EruptingBedrock(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.avoid_bartext:format(L.erupting_bedrock), avoidCount)))
	self:PlaySound(args.spellId, "alert")
end

function mod:SeismicRupture(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.ultimate_bartext:format(CL.adds), ultimateCount)))
	self:PlaySound(args.spellId, "warning")
end

-- Storm Altar
do
	local playerList = {}
	function mod:LightningCrash(args)
		self:Message(391056, "yellow", CL.casting:format(CL.count:format(L.damage_bartext:format(L.lightning_crash), damageCount)))
		self:PlaySound(391056, "info")
		playerList = {}
	end

	function mod:LightningCrashApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.lightning_crash)
			self:SayCountdown(args.spellId, 4)
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "orange", playerList)
	end

	function mod:LightningCrashRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local playerList = {}
	function mod:ShockingBurst()
		self:Message(390920, "yellow", CL.casting:format(CL.count:format(L.avoid_bartext:format(CL.bombs), avoidCount)))
		self:PlaySound(390920, "info")
		playerList = {}
	end

	function mod:ShockingBurstApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count + 3 -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, nil, CL.bomb)
			self:SayCountdown(args.spellId, 5, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 4, CL.bombs)
		self:CustomIcon(shockingBurstMarker, args.destName, count)
	end

	function mod:ShockingBurstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(shockingBurstMarker, args.destName)
	end
end

function mod:ThunderStrike(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.ultimate_bartext:format(L.thundering_strike), ultimateCount)))
	self:PlaySound(args.spellId)
end

-- Stage 2
-- Tectonic Crusher
function mod:BreakingGravelApplied(args)
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 0)
		self:PlaySound(args.spellId, "info")
	end
end

do
	local playerList = {}
	function mod:GroundShatter(args)
		playerList = {}
		self:Bar(args.spellId, 30, CL.bombs)
	end

	function mod:GroundShatterApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 5)
			self:PersonalMessage(args.spellId, nil, CL.bomb)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
	end

	function mod:GroundShatterRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:ViolentUpheaval(args)
	self:Message(args.spellId, "orange", CL.casting:format(L.violent_upheaval))
	self:PlaySound(args.spellId, "alarm") -- castmove
	self:Bar(args.spellId, 34, L.violent_upheaval)
end

-- Frozen Destroyer
function mod:FrostBinds(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:FrostBindsApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 0)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FreezingTempest(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning") -- danger
	self:Bar(args.spellId, 35)
end

-- Thundering Ravager
do
	local warned = false
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			warned = true
			self:PlaySound(391696, "warning") -- debuffmove
			self:Say(391696)
		end
		self:TargetMessage(391696, "yellow", name, self:SpellName(391696))
	end

	function mod:StormBreak(args)
		warned = false
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:Bar(391696, 20)
	end

	function mod:LethalCurrentApplied(args)
		if self:Me(args.destGUID) and not warned then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
	end
end

function mod:IntermissionAddDeath(args)
	if args.mobId == 190690  then -- Thundering Ravager
		self:StopBar(391696) -- Storm Break
	elseif args.mobId == 190588 then -- Tectonic Crusher
		self:StopBar(CL.bombs) -- Ground Shatter
		self:StopBar(L.violent_upheaval) -- Violent Upheaval
	elseif args.mobId == 190686 then -- Frozen Destroyer
		self:StopBar(374624) -- Freezing Tempest
	--elseif args.mobId == 190688  then -- Blazing Fiend
	end
end

-- Stage 3
function mod:PrimalAttunement(args)
	self:Message(args.spellId, "red", L.primal_attunement)
	self:PlaySound(args.spellId, "warning") -- danger
	self:StopBar(L.primal_attunement)
end
