
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tectus", 994, 1195)
if not mod then return end
mod:RegisterEnableMob(78948)
mod.engageId = 1722

--------------------------------------------------------------------------------
-- Locals
--

local marked = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	--L.pillar_trigger = "RISE, MOUNTAINS!"
	L.earthwarper_trigger1 = "Yjj'rmr" -- Yjj'rmr... Xzzolos...
	L.earthwarper_trigger2 = "Yes, Tectus" -- Yes, Tectus. Bend to... our master's... will....
	L.earthwarper_trigger3 = "You do not understand!" -- You do not understand! This one must not....
	L.berserker_trigger1 = "MASTER!" -- MASTER! I COME FOR YOU!
	L.berserker_trigger2 = "Kral'ach" --Kral'ach.... The darkness speaks.... A VOICE!
	L.berserker_trigger3 = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.adds = CL.adds
	L.adds_desc = "Timers for when new adds enter the fight."

	L.custom_off_barrage_marker = "Crystalline Barrage marker"
	L.custom_off_barrage_marker_desc = "Marks targets of Crystalline Barrage with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader."
	L.custom_off_barrage_marker_icon = 1

	L.tectus = "Tectus"
	L.shard = "Shard"
	L.motes = "Motes"

	L.earthwarper_icon = "spell_shadow_raisedead" -- there's no pale orcish spell icons :(
	L.berserker_icon = "ability_warrior_endlessrage" -- angry orc
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{162894, "TANK"}, {162892, "TANK"}, 162968,
		163312,
		{162288, "TANK"}, {162346, "FLASH"}, "custom_off_barrage_marker", 162475, "adds", "berserk", "bosskill",
	}, {
		[162894] = -10061, -- Earthwarper
		[163312] = -10062, -- Berserker
		[162288] = "general",
	}
end

function mod:OnBossEnable()
	-- Tectus
	self:Log("SPELL_AURA_APPLIED_DOSE", "Accretion", 162288)
	self:Log("SPELL_AURA_APPLIED", "CrystallineBarrage", 162346)
	self:Log("SPELL_AURA_REMOVED", "CrystallineBarrageRemoved", 162346)
	self:Log("SPELL_PERIODIC_DAMAGE", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_PERIODIC_MISSED", "CrystallineBarrageDamage", 162370)
	self:Log("SPELL_CAST_START", "TectonicUpheaval", 162475)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Split", "boss1", "boss2", "boss3")
	-- Earthwarper
	self:Yell("Earthwarper", L.earthwarper_trigger1, L.earthwarper_trigger2, L.earthwarper_trigger3)
	self:Log("SPELL_CAST_START", "GiftOfEarth", 162894)
	self:Log("SPELL_AURA_APPLIED", "Petrification", 162892)
	self:Log("SPELL_CAST_START", "EarthenFlechettes", 162968)
	self:Log("SPELL_DAMAGE", "EarthenFlechettesDamage", 162968)
	self:Log("SPELL_MISSED", "EarthenFlechettesDamage", 162968)
	-- Berserker
	self:Yell("Berserker", L.berserker_trigger1, L.berserker_trigger2, L.berserker_trigger3)
	self:Log("SPELL_CAST_START", "RavingAssault", 163312)
end

function mod:OnEngage()
	wipe(marked)
	--self:CDBar(162346, 6) -- Crystalline Barrage
	self:CDBar("adds", 11, -10061, L.earthwarper_icon) -- Earthwarper
	self:CDBar("adds", 21, -10062, L.berserker_icon) -- Berserker

	if not self:LFR() then
		self:Berserk(self:Mythic() and 480 or 600)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Accretion(args)
	if self:MobId(args.sourceGUID) ~= 80557 and UnitGUID("target") == args.sourceGUID and args.amount > 3 then
		local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
		self:Message(args.spellId, "Attention", nil, raidIcon..CL.count:format(args.spellName, args.amount))
	end
end

function mod:CrystallineBarrage(args)
	--self:CDBar(args.spellId, 30.5)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:Flash(args.spellId)
	end
	if self.db.profile.custom_off_barrage_marker then
		for i=1, 5 do
			if not marked[i] then
				SetRaidTarget(args.destName, i)
				marked[i] = args.destName
				break
			end
		end
	end
end

function mod:CrystallineBarrageRemoved(args)
	if self.db.profile.custom_off_barrage_marker then
		SetRaidTarget(args.destName, 0)
		for i=1, 5 do
			if marked[i] == args.destName then
				marked[i] = nil
			end
		end
	end
end

do
	local prev = 0
	function mod:CrystallineBarrageDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

do
	local prev = 0
	local names = { [78948] = L.tectus, [80551] = L.shard, [80557] = L.motes }
	function mod:TectonicUpheaval(args)
		local t = GetTime()
		local id = self:MobId(args.sourceGUID)
		if id ~= 80557 or t-prev > 5 then -- not Mote or first Mote cast in 5s
			local raidIcon = CombatLog_String_GetIcon(args.sourceRaidFlags)
			self:Message(args.spellId, "Positive", nil, CL.other:format(raidIcon .. names[id], args.spellName))
			if id == 80557 then prev = t end
		end
	end
end

function mod:Split(unit, spellName, _, _, spellId)
	if spellId == 140562 then -- Break Player Targetting (cast when Tectus/Shards die)
		self:StopBar(-10061) -- Earthwarper
		self:StopBar(-10062) -- Berserker
		--self:CDBar(162346, 8) -- Crystalline Barrage 7-12s, then every ~20s, 2-5s staggered
	end
end

-- Adds

function mod:Earthwarper(args)
	self:Message("adds", "Attention", "Info", -10061, false)
	self:CDBar("adds", 41, -10061, L.earthwarper_icon)
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
	self:CDBar("adds", 41, -10062, L.berserker_icon)
	self:CDBar(163312, 13) -- Raving Assault (~10s + 3s cast)
end

function mod:RavingAssault(args)
	self:Message(args.spellId, "Urgent")
end

