
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
local barrierRemovedCount = 0
local avoidCount = 1
local damageCount = 1
local ultimateCount = 1
local addCount = {} -- count init on spawn (MythicAddSpawn/IntermissionAddSpawn)
local strikeCount = 1

local avoidCD = 46
local damageCD = 20.7
local ultimateCD = 46

-- Cooldowns of the spells to re-create bars
local nextAvoidSpell = 0
local nextDamageSpell = 0
local nextUltimateSpell = 0
local nextAddSpell = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	-- Types
	L.damage = "Damage Skills"
	L.damage_desc = "Display timers for Damage abilities (Magma Burst, Biting Chill, Enveloping Earth, Lightning Crash) when we don't know what alter the boss is at."
	L.damage_icon = "spell_ice_magicdamage"
	L.damage_bartext = "%s [Dmg]" -- {Spell} [Dmg]

	L.avoid = "Avoid Skills"
	L.avoid_desc = "Display timers for Avoid abilities (Molten Rupture, Frigid Torrent, Erupting Bedrock, Shocking Burst) when we don't know what alter the boss is at."
	L.avoid_icon = "ability_kick"
	L.avoid_bartext = "%s [Avoid]" -- {Spell} [Avoid]

	L.ultimate = "Ultimate Skills"
	L.ultimate_desc = "Display timers for Ultimate abilities (Searing Carnage, Absolute Zero, Seismic Rupture, Thundering Strike) when we don't know what alter the boss is at."
	L.ultimate_icon = "achievement_bg_most_damage_killingblow_dieleast"
	L.ultimate_bartext = "%s [Ult]" -- {Spell} [Ult]

	L.add_bartext = "%s [Add]" -- "{Spell} [Add]"
	L.enrage_other = mod:SpellName(184361)..": %s" -- Enrage

	L.Fire = "Fire"
	L.Frost = "Frost"
	L.Earth = "Earth"
	L.Storm = "Storm"

	-- Fire
	L.magma_burst = "Pools"
	L.molten_rupture = "Waves"
	L.searing_carnage = "Dance"
	L.raging_inferno = "Soak Pools"

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
	L.orb_lightning = mod:SpellName(394719) -- Orb Lightning

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
		["add"] = "?",
	},
	["Fire"] = {
		["stage"] = -25040, -- Fire Altar
		["damage"] = L.magma_burst,
		["avoid"] = L.molten_rupture,
		["ultimate"] = L.searing_carnage,
		["add"] = L.raging_inferno,
	},
	["Frost"] = {
		["stage"] = -25061, -- Frost Altar
		["damage"] = L.biting_chill,
		["avoid"] = L.frigid_torrent,
		["ultimate"] = L.absolute_zero,
		["add"] = L.frigid_torrent,
	},
	["Earth"] = {
		["stage"] = -25064, -- Earthen Altar
		["damage"] = L.enveloping_earth,
		["avoid"] = L.erupting_bedrock,
		["ultimate"] = CL.adds,
		["add"] = L.erupting_bedrock,
	},
	["Storm"] = {
		["stage"] = -25068, -- Storm Altar
		["damage"] = L.lightning_crash,
		["avoid"] = CL.bombs,
		["ultimate"] = L.thundering_strike,
		["add"] = L.orb_lightning,
	}
}

local alterSpellIdMap = {
	["?"] = {
		["damage"] = "damage",
		["avoid"] = "avoid",
		["ultimate"] = "ultimate",
		["add"] = "add",
	},
	["Fire"] = {
		["damage"] = 382563, -- Magma Burst
		["avoid"] = 373329, -- Molten Rupture
		["ultimate"] = 374023, -- Searing Carnage
		["add"] = 394416, -- Raging Inferno
		["tank"] = 393309, -- Flame Smite
	},
	["Frost"] = {
		["damage"] = 373678, -- Biting Chill
		["avoid"] = 391019, -- Frigid Torrent
		["ultimate"] = 372458, -- Absolute Zero
		["add"] = 391019, -- Frigid Torrent
		["tank"] = 393296, -- Frost Smite
	},
	["Earth"] = {
		["damage"] = 391056, -- Enveloping Earth
		["avoid"] = 395893, -- Erupting Bedrock
		["ultimate"] = 374691, -- Seismic Rupture
		["add"] = 395893, -- Erupting Bedrock
		["tank"] = 391268, -- Earth Smite
	},
	["Storm"] = {
		["damage"] = 373487, -- Lightning Crash
		["avoid"] = 390920, -- Shocking Burst
		["ultimate"] = 374215, -- Thunder Strike
		["add"] = 394719, -- Orb Lightning
		["tank"] = 393429, -- Storm Smite
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
		"berserk",
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
		{374622, "SAY"}, -- Storm Break
		{391696, "SAY", "SAY_COUNTDOWN"}, -- Lethal Current
		-- Stage 3
		396241, -- Primal Attunement
		-- Mythic
		400473, -- Elemental Rage
		{393309, "TANK"}, -- Flame Smite
		394416, -- Raging Inferno
		{393296, "TANK"}, -- Frost Smite
		391425, -- Icy Tempest
		{391268, "TANK"}, -- Earth Smite
		{393429, "TANK", "SAY"}, -- Storm Smite
		394719, -- Orb Lightning
	}, {
		["stages"] = "general",
		[382563] = -25040, -- Fire Altar
		[373678] = -25061, -- Frost Altar
		[391056] = -25064, -- Earthen Altar
		[373487] = -25068, -- Storm Altar
		[374321] = -25071, -- Stage 2
		[396241] = -26000, -- Stage 3
		[400473] = "mythic", -- Mythic
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
		[395893] = L.erupting_bedrock, -- Erupting Bedrock (Quakes)
		[374691] = CL.adds, -- Seismic Rupture (Adds)
		-- Storm
		[373487] = L.lightning_crash, -- Lightning Crash (Zaps)
		[390920] = CL.bombs, -- Shocking Burst (Bombs)
		[374215] = L.thundering_strike, -- Thundering Strike (Soaks)
		-- Stage 2
		[374427] = CL.bombs, -- Ground Shatter (Bombs)
		-- Stage 3
		[396241] = L.primal_attunement, -- Primal Attunement (Soft Enrage)
		-- Mythic
		[394416] = L.raging_inferno, -- Raging Inferno (Soak Pools)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "Dominance", 396106, 396109, 396085, 396113) -- Flaming, Earthen, Freezing, Thundering
	self:Log("SPELL_PERIODIC_DAMAGE", "ElementalSurge", 371981)
	self:Log("SPELL_AURA_APPLIED", "ElementalRage", 400473)
	-- self:Log("SPELL_DAMAGE", "ElementalShiftDamage", 374861)
	self:Log("SPELL_AURA_APPLIED", "PrimalBarrierApplied", 374779)
	self:Log("SPELL_AURA_REMOVED", "PrimalBarrierRemoved", 374779)

	self:Log("SPELL_CAST_START", "SunderingStrike", 390548) -- Sundering Strike
	self:Log("SPELL_AURA_APPLIED", "SunderingStrikeApplied", 372158)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingStrikeApplied", 372158)
	self:Log("SPELL_CAST_START", "SmiteCast", 393309, 393296, 391268, 393429) -- Flame, Frost, Earth, Storm
	self:Log("SPELL_AURA_APPLIED", "FrostSmiteApplied", 393297)
	self:Log("SPELL_AURA_APPLIED", "EarthSmiteApplied", 376430) -- (actually Enveloping Earth)
	self:Log("SPELL_AURA_APPLIED", "StormSmiteApplied", 393431)
	-- Fire
	self:Log("SPELL_CAST_SUCCESS", "MagmaBurst", 382563)
	self:Log("SPELL_CAST_START", "MoltenRupture", 373329)
	self:Log("SPELL_CAST_START", "SearingCarnage", 374022, 392192) -- (also Mythic add cast)
	self:Log("SPELL_AURA_APPLIED", "SearingCarnageApplied", 374023)
	self:Log("SPELL_AURA_REMOVED", "SearingCarnageRemoved", 374023)
	self:Log("SPELL_CAST_START", "RagingInferno", 394416) -- Mythic add cast
	-- Frost
	self:Log("SPELL_CAST_START", "BitingChill", 373678)
	self:Log("SPELL_CAST_START", "FrigidTorrent", 391019) -- (also Mythic add cast)
	self:Log("SPELL_CAST_START", "AbsoluteZero", 372456)
	self:Log("SPELL_AURA_APPLIED", "AbsoluteZeroApplied", 372458)
	self:Log("SPELL_AURA_REMOVED", "AbsoluteZeroRemoved", 372458)
	self:Log("SPELL_CAST_START", "IcyTempest", 391425) -- Mythic add cast
	-- Earthen
	self:Log("SPELL_CAST_START", "EnvelopingEarth", 391055) -- (also Mythic add cast)
	self:Log("SPELL_AURA_APPLIED", "EnvelopingEarthApplied", 391056)
	self:Log("SPELL_AURA_REMOVED", "EnvelopingEarthRemoved", 391056)
	self:Log("SPELL_CAST_START", "EruptingBedrock", 395893)
	self:Log("SPELL_CAST_START", "SeismicRupture", 374691)
	-- Storm
	self:Log("SPELL_CAST_START", "LightningCrash", 397358)
	self:Log("SPELL_AURA_APPLIED", "LightningCrashApplied", 373494)
	self:Log("SPELL_AURA_REMOVED", "LightningCrashRemoved", 373494)
	self:Log("SPELL_CAST_START", "ShockingBurst", 397341)
	self:Log("SPELL_AURA_APPLIED", "ShockingBurstApplied", 390920)
	self:Log("SPELL_AURA_REMOVED", "ShockingBurstRemoved", 390920)
	self:Log("SPELL_CAST_START", "ThunderStrike", 374215)
	self:Log("SPELL_CAST_START", "OrbLightning", 394719) -- Mythic add cast
	self:Log("SPELL_SUMMON", "OrbLightningSummon", 394726)

	-- Stage 2
	self:Log("SPELL_CAST_SUCCESS", "IntermissionAddSpawn", 375828, 375825, 375824, 375792) -- Fire, Frost, Earth, Storm
	self:Death("IntermissionAddDeath", 190588, 190686, 190688, 190690) -- Blazing Fiend, Frozen Destroyer, Tectonic Crusher, Thundering Ravager
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
	self:Log("SPELL_AURA_REMOVED", "LethalCurrentRemoved", 391696)

	-- Stage 3
	self:Log("SPELL_AURA_APPLIED", "PrimalAttunement", 396241)
end

function mod:OnEngage()
	self:SetStage(1)
	currentAltar = "?"
	barrierRemovedCount = 0
	avoidCount = 1
	damageCount = 1
	ultimateCount = 1
	addCount = {}
	strikeCount = 1

	avoidCD = 46
	damageCD = 20.7
	ultimateCD = 46

	local avoidPullCD = self:Easy() and 14.5 or 23
	local damagePullCD = 14.5
	local ultimatePullCD = 46

	nextAvoidSpell = avoidPullCD + GetTime()
	nextDamageSpell = damagePullCD + GetTime()
	nextUltimateSpell = ultimatePullCD + GetTime()

	self:Bar("avoid", avoidPullCD, CL.count:format(L.avoid_bartext:format(currentAltar), avoidCount), L.avoid_icon)
	self:Bar("damage", damagePullCD, CL.count:format(L.damage_bartext:format(currentAltar), damageCount), L.damage_icon)
	self:Bar("ultimate", ultimatePullCD, CL.count:format(L.ultimate_bartext:format(currentAltar), ultimateCount), L.ultimate_icon)

	self:Bar(372158, 10.2) -- Sundering Strike
	self:Bar("stages", 125, CL.stage:format(2), 374779) -- Primal Barrier

	if not self:Easy() then
		self:Berserk(self:Mythic() and 600 or 540, true)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 391096 then -- Damage Selection
		if not self:Easy() then
			self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
			damageCount = damageCount + 1
			damageCD = damageCount % 2 == 0 and 25.6 or 20.7
			nextDamageSpell = damageCD + GetTime()
			self:CDBar(alterSpellIdMap[currentAltar]["damage"], damageCD, CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount)) -- SetOption:382563,373678,391056,373487:::
		end
	elseif spellId == 391100 then -- Avoid Selection
		if not self:Easy() then
			self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
			avoidCount = avoidCount + 1
			nextAvoidSpell = avoidCD + GetTime()
			self:CDBar(alterSpellIdMap[currentAltar]["avoid"], avoidCD, CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount)) -- SetOption:373329,391019,395893,390920:::
		end
	elseif spellId == 374680 then -- Ultimate Selection
		self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
		ultimateCount = ultimateCount + 1
		nextUltimateSpell = ultimateCD + GetTime()
		self:CDBar(alterSpellIdMap[currentAltar]["ultimate"], ultimateCD, CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount)) -- SetOption:374023,372458,374691,374215:::
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
	local newAltar = nil
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
		if newAltar == currentAltar then return end

		self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
		self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
		self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
		currentAltar = newAltar

		self:Message("stages", "cyan", alterSpellNameMap[currentAltar]["stage"])
		self:PlaySound("stages", "long")

		local t = GetTime()
		local avoidRemainingCD = nextAvoidSpell - t
		local damageRemainingCD = nextDamageSpell - t
		local ultimateRemainingCD = nextUltimateSpell - t

		if not self:Easy() or currentAltar == "Earth" or currentAltar == "Storm" then
			self:Bar(alterSpellIdMap[currentAltar]["avoid"], {avoidRemainingCD, avoidCD}, CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount), alterSpellIdMap[currentAltar]["avoid"]) -- SetOption:373329,391019,395893,390920:::
		end
		if not self:Easy() or currentAltar == "Fire" or currentAltar == "Frost" then
			self:Bar(alterSpellIdMap[currentAltar]["damage"], {damageRemainingCD, damageCD}, CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount), alterSpellIdMap[currentAltar]["damage"]) -- SetOption:382563,373678,391056,373487:::
		end
		self:Bar(alterSpellIdMap[currentAltar]["ultimate"], {ultimateRemainingCD, ultimateCD}, CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount), alterSpellIdMap[currentAltar]["ultimate"]) -- SetOption:374023,372458,374691,374215:::
	end
end

function mod:MythicAddSpawn(args)
	self:Bar(400473, 91, L.enrage_other:format(L[currentAltar])) -- Elemental Rage

	local tankSpellId = alterSpellIdMap[currentAltar]["tank"] -- Smite
	self:Bar(tankSpellId, 10.8) -- SetOption:393309,393296,391268,393429:::

	local addSpellId = alterSpellIdMap[currentAltar]["add"]
	addCount[addSpellId] = 1
	self:CDBar(addSpellId, currentAltar == "Storm" and 15.7 or 25.5, CL.count:format(L.add_bartext:format(alterSpellNameMap[currentAltar]["add"]), 1)) -- SetOption:394416,391019,395893,394719:::
end

function mod:MythicAddDeaths(args)
	if args.mobId == 198311 then -- Flamewrought Eradicator
		self:StopBar(393309) -- Flame Smite
		self:StopBar(CL.count:format(L.add_bartext:format(L.raging_inferno), addCount[394416] or 1)) -- Raging Inferno
		self:StopBar(L.enrage_other:format(L["Fire"]))
	elseif args.mobId == 198308 then -- Icewrought Dominator
		self:StopBar(393296) -- Frost Smite
		self:StopBar(CL.count:format(L.add_bartext:format(L.frigid_torrent), addCount[391019] or 1)) -- Frigid Torrent
		self:StopBar(L.enrage_other:format(L["Frost"]))
	elseif args.mobId == 197595 then -- Ironwrought Smasher
		self:StopBar(391268) -- Earth Smite
		self:StopBar(CL.count:format(L.add_bartext:format(L.erupting_bedrock), addCount[395893] or 1)) -- Erupting Bedrock
		self:StopBar(L.enrage_other:format(L["Earth"]))
	elseif args.mobId == 198326 then -- Stormwrought Despoiler
		self:StopBar(393429) -- Storm Smite
		self:StopBar(CL.count:format(L.add_bartext:format(L.orb_lightning), addCount[394719] or 1)) -- Orb Lightning
		self:StopBar(L.enrage_other:format(L["Storm"]))
	end
end

do
	local prev = 0
	function mod:ElementalRage(args)
		if args.time-prev < 3 then return end
		prev = args.time

		-- atlar adds
		local altar = nil
		local mobId = self:MobId(args.destGUID)
		if mobId == 198311 then
			altar = "Fire"
		elseif mobId == 198308 then
			altar = "Frost"
		elseif mobId == 197595 then
			altar = "Earth"
		elseif mobId == 198326 then
			altar = "Storm"
		end

		self:Message(args.spellId, "red", altar and L.enrage_other:format(L[altar]) or nil)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:PrimalBarrierApplied(args)
	self:StopBar(CL.count:format(L.avoid_bartext:format(alterSpellNameMap[currentAltar]["avoid"]), avoidCount))
	self:StopBar(CL.count:format(L.damage_bartext:format(alterSpellNameMap[currentAltar]["damage"]), damageCount))
	self:StopBar(CL.count:format(L.ultimate_bartext:format(alterSpellNameMap[currentAltar]["ultimate"]), ultimateCount))
	self:StopBar(372158) -- Sundering Strike
	self:StopBar(CL.stage:format(2))

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long") -- phase
end

function mod:PrimalBarrierRemoved(args)
	self:StopBar(400473) -- Elemental Rage

	barrierRemovedCount = barrierRemovedCount + 1
	self:SetStage(1)
	self:Message("stages", "cyan", CL.stage:format(1), false)
	self:PlaySound("stages", "long") -- phase

	currentAltar = "?"
	avoidCount = 1
	damageCount = 1
	ultimateCount = 1
	strikeCount = 1

	local avoidIntermissionCD = self:Easy() and 14.5 or 22.5
	local damageIntermissionCD = 14.5
	local ultimateIntermissionCD = 45.5

	local t = GetTime()
	nextAvoidSpell = avoidIntermissionCD + t
	nextDamageSpell = damageIntermissionCD + t
	nextUltimateSpell = ultimateIntermissionCD + t

	self:Bar("avoid", avoidIntermissionCD, CL.count:format(L.avoid_bartext:format(currentAltar), avoidCount), L.avoid_icon)
	self:Bar("damage", damageIntermissionCD, CL.count:format(L.damage_bartext:format(currentAltar), damageCount), L.damage_icon)
	self:Bar("ultimate", ultimateIntermissionCD, CL.count:format(L.ultimate_bartext:format(currentAltar), ultimateCount), L.ultimate_icon)

	self:Bar(372158, 10.2) -- Sundering Strike
	if barrierRemovedCount < 2 then
		self:Bar("stages", 125, CL.stage:format(2), 374779) -- Primal Barrier
	else
		self:Bar(396241, self:Easy() and 96 or 94, L.primal_attunement) -- Primal Attunement
	end
end

function mod:SunderingStrike(args)
	self:Message(372158, "purple", CL.casting:format(args.spellName))
	self:PlaySound(372158, "alert") -- frontal
	strikeCount = strikeCount + 1
	local cd = strikeCount % 2 == 0 and 25.6 or 20 -- XXX can be 28/17, should probably handle that
	self:CDBar(372158, cd)
end

function mod:SunderingStrikeApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:SmiteCast(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alert") -- frontal
	self:Bar(args.spellId, 30.5)
end

function mod:FrostSmiteApplied(args)
	self:TargetMessage(393296, "purple", args.destName)
end

function mod:EarthSmiteApplied(args)
	self:TargetMessage(391268, "purple", args.destName)
end

function mod:StormSmiteApplied(args)
	self:TargetMessage(393429, "purple", args.destName)
	if self:Me(args.destGUID) then
		self:Say(393429, CL.bomb)
	end
end

-- Fire
function mod:MagmaBurst(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.damage_bartext:format(L.magma_burst), damageCount))
	self:PlaySound(args.spellId, "info")
	if self:Easy() then
		self:StopBar(CL.count:format(L.damage_bartext:format(L.magma_burst), damageCount))
		damageCount = damageCount + 1
		local cd = damageCount % 3 == 1 and 20.7 or damageCount % 3 == 2 and 8.5 or 17.0
		nextDamageSpell = cd + GetTime()
		self:Bar(args.spellId, cd, CL.count:format(L.damage_bartext:format(L.magma_burst), damageCount))
		-- shared cd
		avoidCount = damageCount
		nextAvoidSpell = nextDamageSpell
	end
end

function mod:MoltenRupture(args)
	self:Message(args.spellId, "orange", CL.count:format(L.avoid_bartext:format(L.molten_rupture), avoidCount))
	self:PlaySound(args.spellId, "alert")
end

function mod:SearingCarnage(args)
	if self:MobId(args.sourceGUID) == 184986 then -- Kurog
		self:Message(374023, "yellow", CL.casting:format(CL.count:format(L.ultimate_bartext:format(L.searing_carnage), ultimateCount)))
	else --if self:MobId(args.sourceGUID) == 190688 then -- Blazing Fiend (Intermission add)
		local count = addCount[374023] or 1
		self:StopBar(CL.count:format(L.searing_carnage, count))
		self:Message(374023, "yellow", CL.casting:format(CL.count:format(L.searing_carnage, count)))
		count = count + 1
		self:Bar(374023, 23.1, CL.count:format(L.searing_carnage, count))
		addCount[374023] = count
	end
	self:PlaySound(374023, "info")
end

function mod:SearingCarnageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.searing_carnage)
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning") -- debuffmove
	end
end

function mod:SearingCarnageRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:RagingInferno(args)
	-- (Mythic altar add)
	local count = addCount[args.spellId] or 1
	self:StopBar(CL.count:format(L.add_bartext:format(L.raging_inferno), count))
	self:Message(args.spellId, "cyan", CL.count:format(L.add_bartext:format(L.raging_inferno), count))
	count = count + 1
	self:CDBar(args.spellId, 30, CL.count:format(L.add_bartext:format(L.raging_inferno), count))
	addCount[args.spellId] = count
end

-- Frost Altar
function mod:BitingChill(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.damage_bartext:format(L.biting_chill), damageCount))
	self:PlaySound(args.spellId, "info")
	if self:Easy() then
		self:StopBar(CL.count:format(L.damage_bartext:format(L.biting_chill), damageCount))
		damageCount = damageCount + 1
		local cd = damageCount % 3 == 1 and 20.7 or damageCount % 3 == 2 and 8.5 or 17.0
		nextDamageSpell = cd + GetTime()
		self:Bar(args.spellId, cd, CL.count:format(L.damage_bartext:format(L.biting_chill), damageCount))
		-- shared cd
		avoidCount = damageCount
		nextAvoidSpell = nextDamageSpell
	end
end

function mod:FrigidTorrent(args)
	if self:MobId(args.sourceGUID) == 184986 then -- Kurog
		self:Message(args.spellId, "orange", CL.count:format(L.avoid_bartext:format(L.frigid_torrent), avoidCount))
	else --if self:MobId(args.sourceGUID) == 198308 then -- Frostwrought Dominator (Mythic altar add)
		local count = addCount[args.spellId] or 1
		self:StopBar(CL.count:format(L.add_bartext:format(L.frigid_torrent), count))
		self:Message(args.spellId, "cyan", CL.count:format(L.add_bartext:format(L.frigid_torrent), count))
		count = count + 1
		self:CDBar(args.spellId, 33, CL.count:format(L.add_bartext:format(L.frigid_torrent), count))
		addCount[args.spellId] = count
	end
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
		if self:MobId(args.sourceGUID) == 184986 then -- Kurog
			self:Message(372458, "orange", CL.casting:format(CL.count:format(L.ultimate_bartext:format(L.absolute_zero), ultimateCount)))
		else --if self:MobId(args.sourceGUID) == 190686 then -- Frozen Destroyer (Intermission add)
			self:StopBar(CL.count:format(L.absolute_zero, ultimateCount))
			self:Message(372458, "orange", CL.casting:format(CL.count:format(L.absolute_zero, ultimateCount)))
			ultimateCount = ultimateCount + 1 -- reusing this because it's also the same _APPLIED
			self:Bar(372458, 23, CL.count:format(L.absolute_zero, ultimateCount))
		end
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
			self:TargetsMessage(372458, "yellow", playerList, 2, CL.count:format(L.absolute_zero, ultimateCount-1))
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

function mod:IcyTempest(args)
	self:Message(args.spellId, "cyan", L.add_bartext:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

-- Earth Altar
do
	local count = 1
	function mod:EnvelopingEarth(args)
		self:Message(391056, "yellow", CL.casting:format(CL.count:format(L.damage_bartext:format(L.enveloping_earth), damageCount)))
		self:PlaySound(391056, "info")
		count = 1
	end

	function mod:EnvelopingEarthApplied(args)
		count = count + 1
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.enveloping_earth)
			self:PlaySound(args.spellId, "alarm") -- debuffdamage
		end
		if count < 9 then -- flex scaling, yikes
			self:CustomIcon(envelopingEarthMarker, args.destName, count)
		end
	end

	function mod:EnvelopingEarthRemoved(args)
		self:CustomIcon(envelopingEarthMarker, args.destName)
	end
end

function mod:EruptingBedrock(args)
	if self:MobId(args.sourceGUID) == 184986 then -- Kurog
		self:Message(args.spellId, "orange", CL.count:format(L.avoid_bartext:format(L.erupting_bedrock), avoidCount))
		if self:Easy() then
			self:StopBar(CL.count:format(L.avoid_bartext:format(L.erupting_bedrock), avoidCount))
			avoidCount = avoidCount + 1
			local cd = avoidCount % 3 == 1 and 20.7 or avoidCount % 3 == 2 and 8.5 or 17.0
			nextAvoidSpell = cd + GetTime()
			self:Bar(args.spellId, cd, CL.count:format(L.avoid_bartext:format(L.erupting_bedrock), avoidCount))
			-- shared cd
			damageCount = avoidCount
			nextDamageSpell = nextAvoidSpell
		end
	else --if self:MobId(args.sourceGUID) == 197595 then -- Earthwrought Smasher (Mythic altar add)
		local count = addCount[args.spellId] or 1
		self:StopBar(CL.count:format(L.add_bartext:format(L.erupting_bedrock), count))
		self:Message(args.spellId, "cyan", CL.count:format(L.add_bartext:format(L.erupting_bedrock), count))
		count = count + 1
		self:CDBar(args.spellId, 34, CL.count:format(L.add_bartext:format(L.erupting_bedrock), count))
		addCount[args.spellId] = count
	end
	self:PlaySound(args.spellId, "alert")
end

function mod:SeismicRupture(args)
	if self:MobId(args.sourceGUID) == 184986 then -- Kurog
		self:Message(args.spellId, "orange", CL.count:format(L.ultimate_bartext:format(CL.adds), ultimateCount))
	else --if self:MobId(args.sourceGUID) == 190588 then -- Tectonic Crusher (Mythic intermission add)
		local count = addCount[args.spellId] or 1
		self:StopBar(CL.count:format(CL.adds, count))
		self:Message(args.spellId, "orange", CL.count:format(CL.adds, count))
		count = count + 1
		self:Bar(args.spellId, 45, CL.count:format(CL.adds, count))
		addCount[args.spellId] = count
	end
	self:PlaySound(args.spellId, "warning")
end

-- Storm Altar
do
	local playerList = {}
	function mod:LightningCrash(args)
		self:Message(373487, "yellow", CL.casting:format(CL.count:format(L.damage_bartext:format(L.lightning_crash), damageCount)))
		self:PlaySound(373487, "info")
		playerList = {}
	end

	function mod:LightningCrashApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(373487, L.lightning_crash)
			self:SayCountdown(373487, 4)
			self:PersonalMessage(373487)
			self:PlaySound(373487, "warning") -- debuffmove
		end
		self:TargetsMessage(373487, "orange", playerList, nil, CL.count:format(L.lightning_crash, damageCount-1))
	end

	function mod:LightningCrashRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(373487)
		end
	end
end

do
	local playerList = {}
	function mod:ShockingBurst(args)
		self:Message(390920, "yellow", CL.casting:format(CL.count:format(L.avoid_bartext:format(CL.bombs), avoidCount)))
		self:PlaySound(390920, "info")
		playerList = {}
		if self:Easy() then
			self:StopBar(CL.count:format(L.avoid_bartext:format(CL.bombs), avoidCount))
			avoidCount = avoidCount + 1
			local cd = avoidCount % 3 == 1 and 20.7 or avoidCount % 3 == 2 and 8.5 or 17.0
			nextAvoidSpell = cd + GetTime()
			self:Bar(390920, avoidCD, CL.count:format(L.avoid_bartext:format(CL.bombs), avoidCount))
			-- shared cd
			damageCount = avoidCount
			nextDamageSpell = nextAvoidSpell
		end
	end

	function mod:ShockingBurstApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count + 3 -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 5, count)
			self:PlaySound(args.spellId, "warning") -- debuffmove
		end
		self:TargetsMessage(args.spellId, "orange", playerList, nil, CL.count:format(CL.bombs, avoidCount-1))
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
	if self:MobId(args.sourceGUID) == 184986 then -- Kurog
		self:Message(args.spellId, "orange", CL.count:format(L.ultimate_bartext:format(L.thundering_strike), ultimateCount))
	else --if self:MobId(args.sourceGUID) == 190690 then -- Thunder Ravager (Intermission add)
		local count = addCount[args.spellId] or 1
		self:StopBar(CL.count:format(L.thundering_strike, count))
		self:Message(args.spellId, "orange", CL.count:format(L.thundering_strike, count))
		count = count + 1
		self:Bar(args.spellId, 41, CL.count:format(L.thundering_strike, count))
		addCount[args.spellId] = count
	end
	self:PlaySound(args.spellId, "alert")
end

function mod:OrbLightning(args)
	-- (Mythic altar add)
	local count = addCount[args.spellId] or 1
	self:StopBar(CL.count:format(L.add_bartext:format(L.orb_lightning), count))
	self:Message(args.spellId, "cyan", CL.casting:format(CL.count:format(L.add_bartext:format(L.orb_lightning), count)))
	-- self:CastBar(args.spellId, 5.6, L.orb_lightning) -- orb spawn <Cast: Soak Orbs>
	count = count + 1
	self:Bar(args.spellId, 48.5, CL.count:format(L.add_bartext:format(L.orb_lightning), count))
	addCount[args.spellId] = count
end

do
	local prev = 0
	function mod:OrbLightningSummon(args)
		if args.time-prev > 3 then
			prev = args.time
			local count = addCount[394719]
			if not count then -- awkward
				count = 2
				-- self:CDBar(394719, 42.9, CL.count:format(L.add_bartext:format(L.orb_lightning), count)) -- still alive?
				addCount[394719] = count
			end
			self:Message(394719, "purple", CL.count:format(L.orb_lightning, count - 1))
			self:PlaySound(394719, "alarm")
		end
	end
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
	local function printTarget(self, name, guid)
		self:TargetMessage(374622, "yellow", name) -- Storm Break
		if self:Me(guid) then
			self:PlaySound(391696, "warning") -- debuffmove
			self:Say(391696)
		end
	end

	function mod:StormBreak(args)
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:Bar(391696, 20) -- Lethal Current
	end

	function mod:LethalCurrentApplied(args)
		self:TargetMessage(args.spellId, "orange", args.destName) -- Storm Break
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning") -- debuffmove
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:LethalCurrentRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:IntermissionAddSpawn(args)
	if args.spellId == 375828 then -- Blazing Fiend
		if self:Mythic() then
			addCount[374023] = 1
			self:Bar(374023, 20, CL.count:format(L.searing_carnage, 1)) -- Searing Carnage
			self:Bar(400473, 91) -- Elemental Rage
		end
	elseif args.spellId == 375825 then -- Frozen Destroyer
		self:Bar(374624, self:Mythic() and 33 or 30) -- Freezing Tempest
		if self:Mythic() then
			ultimateCount = 1
			self:Bar(372458, 20, CL.count:format(L.absolute_zero, ultimateCount)) -- Absolute Zero
			self:Bar(400473, 91) -- Elemental Rage
		end
	elseif args.spellId == 375824 then -- Tectonic Crusher
		self:Bar(374427, 5.5, CL.bombs) -- Ground Shatter
		self:Bar(374430, 20, L.violent_upheaval) -- Violent Upheaval
		if self:Mythic() then
			addCount[374691] = 1
			self:Bar(374691, 45, CL.count:format(CL.adds, 1)) -- Seismic Rupture
			self:Bar(400473, 91) -- Elemental Rage
		end
	elseif args.spellId == 375792 then -- Thundering Ravager
		self:Bar(391696, 7.3) -- Lethal Current
		if self:Mythic() then
			addCount[374215] = 1
			self:Bar(374215, 37.7, CL.count:format(L.thundering_strike, 1)) -- Thunder Strike
			self:Bar(400473, 91) -- Elemental Rage
		end
	end
end

function mod:IntermissionAddDeath(args)
	if args.mobId == 190690  then -- Thundering Ravager
		self:StopBar(391696) -- Lethal Current
		self:StopBar(CL.count:format(L.thundering_strike, addCount[374215] or 1)) -- Thunder Strike
	elseif args.mobId == 190588 then -- Tectonic Crusher
		self:StopBar(CL.bombs) -- Ground Shatter
		self:StopBar(L.violent_upheaval) -- Violent Upheaval
		self:StopBar(CL.count:format(CL.adds, addCount[374691] or 1)) -- Seismic Rupture
	elseif args.mobId == 190686 then -- Frozen Destroyer
		self:StopBar(374624) -- Freezing Tempest
		self:StopBar(CL.count:format(L.absolute_zero, ultimateCount)) -- Absolute Zero
	elseif args.mobId == 190688  then -- Blazing Fiend
		self:StopBar(CL.count:format(L.searing_carnage, addCount[374023] or 1)) -- Searing Carnage
	end
end

-- Stage 3
function mod:PrimalAttunement(args)
	self:Message(args.spellId, "red", L.primal_attunement)
	self:PlaySound(args.spellId, "warning") -- danger
	self:StopBar(L.primal_attunement)
end
