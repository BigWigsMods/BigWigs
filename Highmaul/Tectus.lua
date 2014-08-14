
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Tectus", 994, 1195)
if not mod then return end
mod:RegisterEnableMob(78948)
--mod.engageId = 1722

--------------------------------------------------------------------------------
-- Locals
--

local split = nil
local shardsOfTectus = {}

-- a better tContains with blackjack and the index found returned
local function tContains(table, item)
	local index = 1
	while table[index] do
		if item == table[index] then
			return index
		end
		index = index + 1
	end
	return nil
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.earthwarper_trigger = "MASTER!" -- MASTER! I COME FOR YOU!
	L.berserker_trigger = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.adds = CL.adds
	L.adds_desc = "Timers for when new adds enter the fight."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		162287, {162288, "TANK"}, 162346, 163208, 162475,
		{162894, "TANK"}, {162892, "TANK"}, 162968,
		163318,
		"adds", "bosskill",
	}, {
		[162287] = -10060,
		[162894] = -10061,
		[163318] = -10062,
		["adds"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Tectus
	self:Log("SPELL_AURA_REMOVED", "TheLivingMountainApplied", 162287, 162658) -- The Living Mountain, Shard of the Mountain
	self:Log("SPELL_AURA_REMOVED", "TheLivingMountainRemoved", 162287, 162658)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Accretion", 162288)
	self:Log("SPELL_AURA_APPLIED", "CrystallineBarrage", 162346)
	self:Log("SPELL_AURA_APPLIED", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_PERIODIC_DAMAGE", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_CAST_SUCCESS", "Fracture", 163208)
	self:Log("SPELL_CAST_START", "TectonicUpheaval", 162475)
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "TectonicUpheavalStop", "boss1", "boss2", "boss3")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Split", "boss1", "boss2", "boss3")
	-- Earthwarper
	self:Yell("Earthwarper", L.earthwarper_trigger)
	self:Log("SPELL_CAST_START", "GiftOfEarth", 162894)
	self:Log("SPELL_AURA_APPLIED", "Petrification", 162892)
	self:Log("SPELL_CAST_START", "EarthenFlechettes", 162968)
	self:Log("SPELL_DAMAGE", "EarthenFlechettesDamage", 162968)
	self:Log("SPELL_ABSORBED", "EarthenFlechettesDamage", 162968)
	-- Berserker
	self:Yell("Berserker", L.berserker_trigger)
	self:Log("SPELL_CAST_SUCCESS", "RavingAssault", 163318) -- 3s cast, can we get target earlier/on SPELL_CAST_START?

	self:Death("Win", 78948)
end

function mod:OnEngage()
	split = nil
	wipe(shardsOfTectus)
	self:CDBar(162346, 6) -- Crystalline Barrage
	self:CDBar("adds", 10, -10061) -- Earthwarper
	self:CDBar("adds", 20, -10062) -- Berserker
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:TheLivingMountainApplied(args)
	-- should probably just do this IEEU
	local guid = args.sourceGUID
	if self:MobId(guid) == 80551 and not tContains(shardsOfTectus, guid) then -- Shard of Tectus
		shardsOfTectus[#shardsOfTectus+1] = guid
	end
end

function mod:TheLivingMountainRemoved(args)
	if self:MobId(args.sourceGUID) ~= 80557 then -- Mote of Tectus
		local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags) -- Raid icon string
		self:Message(162287, "Positive", not split and "Long", CL.other:format(raidIcon .. args.sourceName, CL.removed:format(args.spellName)))
	end
end

do
	local prev = 0
	function mod:Accretion(args)
		local t = GetTime()
		if self:MobId(args.sourceGUID) ~= 80557 and args.amount > 3 and t-prev > 5 then
			self:Message(args.spellId, "Attention", nil, CL.count:format(args.spellName, args.amount))
		end
	end
end

do
	local prev = 0
	function mod:CrystallineBarrage(args)
		-- stop announcing barrage from Motes to the raid
		if self:MobId(args.sourceGUID) ~= 80557 or self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
		end
		local t = GetTime()
		if t-prev > 10 then -- not sure how out of sync they get
			self:CDBar(args.spellId, 20)
			prev = t
		end
	end
end

do
	local prev = 0
	function mod:CrystallineBarrageDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 3 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

function mod:Fracture(args)
	if not split then
		self:Bar(args.spellId, 6)
	end
end

function mod:TectonicUpheaval(args)
	if self:MobId(args.sourceGUID) ~= 80557 then -- Mote of Tectus
		-- try and differentiate the bars
		local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		if raidIcon == "" and split then
			local index = tContains(shardsOfTectus, args.sourceGUID)
			raidIcon = index and ("[%d] "):format(index) or ""
		end
		self:Bar(args.spellId, 12, raidIcon..CL.cast:format(args.spellName))
	end
end

function mod:TectonicUpheavalStop(unit, spellName, _, _, spellId)
	if spellId == 162475 then -- Tectonic Upheaval
		local raidIcon
		local index = GetRaidTargetIndex(unit)
		if index then
			raidIcon = _G["COMBATLOG_ICON_RAIDTARGET"..index]
		else
			index = tContains(shardsOfTectus, UnitGUID(unit))
			raidIcon = index and ("[%d] "):format(index) or ""
		end
		self:StopBar(raidIcon..CL.cast:format(spellName))
		-- yup. all that to stop a bar.
	end
end

function mod:Split(unit, spellName, _, _, spellId)
	if spellId == 140562 then -- Break Player Targetting (cast when Tectus/Shards die)
		split = true
		self:StopBar(-10061) -- Earthwarper
		self:StopBar(-10062) -- Berserker
		self:CDBar(162346, 8) -- Crystalline Barrage 7-12s, then every ~20s, 2-5s staggered
	end
end

-- Adds

function mod:Earthwarper(args)
	self:Message("adds", "Attention", "Info", -10062, false)
	self:CDBar("adds", 40, -10061) -- 40-44
	self:CDBar(162894, 10) -- Gift of Earth
	self:CDBar(162968, 15) -- Earthen Flechettes
end

function mod:GiftOfEarth(args)
	self:Message(args.spellId, "Urgent", "Alert")
	self:CDBar(args.spellId, 11)
end

function mod:Petrification(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning")
end

function mod:EarthenFlechettes(args)
	self:Message(args.spellId, "Attention", self:Tank() and "Alert")
	self:CDBar(args.spellId, 15)
end

do
	local prev = 0
	function mod:EarthenFlechettesDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and not self:Tank() and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end


function mod:Berserker(args)
	self:Message("adds", "Attention", "Info", -10062, false)
	self:CDBar("adds", 41, -10062)
	self:CDBar(163312, 13) -- Raving Assault (~10s + 3s cast)
end

function mod:RavingAssault(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
end

