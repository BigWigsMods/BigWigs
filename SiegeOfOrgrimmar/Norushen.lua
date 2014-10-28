
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Norushen", 953, 866)
if not mod then return end
mod:RegisterEnableMob(72276, 71977, 71976, 71967) -- Amalgam of Corruption, Manifestation of Corruption, Essence of Corruption, Norushen
mod.engageId = 1624

--------------------------------------------------------------------------------
-- Locals
--

local bigAddSpawnCounter, bigAddKillCounter = 0, 0
local bigAddKills = {}
local percent = 50

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.warmup_trigger = "Very well, I will create a field to keep your corruption quarantined."

	L.big_adds = "Big adds"
	L.big_adds_desc = "Warnings for big adds spawning and being killed."
	L.big_adds_icon = 147082
	L.big_add = "Big add (%d)"
	L.big_add_killed = "Big add killed (%d)"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-8218, "TANK_HEALER"}, {146124, "TANK"}, 145226, 145132,-- Amalgam of Corruption
		"big_adds",
		-8220, 144482, 144514, 144649, 144628,
		"stages", {"warmup", "EMPHASIZE"}, "altpower", "berserk", "bosskill",
	}, {
		[-8218] = -8216, -- Amalgam of Corruption
		["big_adds"] = L.big_adds, -- Big add
		[-8220] = -8220, -- Look Within
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	if IsEncounterInProgress() then
		self:OpenAltPower("altpower", 147800, "AZ", true) -- Corruption
	end

	self:Yell("Warmup", L.warmup_trigger)
	-- Look Within
	self:Log("SPELL_CAST_START", "TitanicSmash", 144628)
	self:Log("SPELL_CAST_START", "HurlCorruption", 144649)
	self:Log("SPELL_CAST_SUCCESS", "LingeringCorruption", 144514)
	self:Log("SPELL_CAST_START", "TearReality", 144482)
	self:Log("SPELL_AURA_REMOVED", "LookWithinRemoved", 144849, 144850, 144851) -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
	self:Log("SPELL_AURA_APPLIED", "LookWithinApplied", 144849, 144850, 144851) -- Test of Serenity (DPS), Test of Reliance (HEALER), Test of Confidence (TANK)
	-- Amalgam of Corruption
	self:Log("SPELL_AURA_APPLIED_DOSE", "Fusion", 145132)
	self:Log("SPELL_AURA_APPLIED", "Fusion", 145132)
	self:Log("SPELL_AURA_APPLIED", "BlindHatred", 145226)
	self:Log("SPELL_CAST_START", "UnleashedAnger", 145216)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SelfDoubt", 146124)
	self:Log("SPELL_AURA_APPLIED", "SelfDoubt", 146124)
	self:Log("SPELL_CAST_SUCCESS", "UnleashCorruption", 145769) -- Spawns big adds in phase 2
	self:Log("SPELL_AURA_APPLIED", "Phase2", 146179) -- Phase 2, "Frayed"
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")

	self:AddSyncListener("BlindHatred")
	self:AddSyncListener("InsideBigAddDeath", 0)
	self:AddSyncListener("OutsideBigAddDeath", 0)
	self:AddSyncListener("Phase2BigAddSpawn")
	self:AddSyncListener("Phase2")

	self:RegisterMessage("DBM_AddonMessage", "OnDBMSync") -- Catch DBM users killing big adds

	self:Death("Deaths", 71977, 72264) -- Manifestation of Corruption, Unleashed Manifestation of Corruption
end

function mod:Warmup()
	self:Bar("warmup", 26, COMBAT, "ability_titankeeper_quarantine")
end

function mod:OnEngage()
	bigAddSpawnCounter, bigAddKillCounter = 0, 0
	self:Berserk(self:LFR() and 600 or 418)
	self:Bar(145226, 25) -- Blind Hatred
	wipe(bigAddKills)
	percent = 50
	self:OpenAltPower("altpower", 147800, "AZ", true) -- Corruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Look Within
-- TANK
function mod:TitanicSmash(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 15)
end

function mod:HurlCorruption(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 20)
end

-- HEALER
function mod:LingeringCorruption(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 15)
end

-- DPS
function mod:TearReality(args)
	self:Message(args.spellId, "Attention", "Info")
	self:CDBar(args.spellId, 8) -- any point for this?
end

do
	local scheduled, lookWithinList = nil, mod:NewTargetList()
	local function warnLookWithinRemoved()
		mod:TargetMessage(-8220, lookWithinList, "Neutral", nil, CL.over:format(mod:SpellName(-8220)))
		scheduled = nil
	end
	function mod:LookWithinRemoved(args)
		lookWithinList[#lookWithinList+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnLookWithinRemoved, 1) -- we care about people coming out, not so much going in
		end
		self:StopBar(-8220, args.destName) -- other tank bar

		if self:Me(args.destGUID) then
			self:StopBar(-8220) -- personal bar
			-- tank
			self:StopBar(144628) -- Titanic Smash
			self:StopBar(144649) -- Hurl Corruption
			-- healer
			self:StopBar(144514) -- Lingering Corruption
			-- dps
			self:StopBar(144482) -- Tear Reality
		end
	end
end

function mod:LookWithinApplied(args)
	if self:Me(args.destGUID) then
		self:Bar(-8220, 60, nil, args.spellId)
	elseif args.spellId == 144851 and self:Tank() then -- Test of Confidence (TANK) mainly for the other tank
		if self:LFR() then -- message for LFR since it happens automatically
			self:TargetMessage(-8220, args.destName, "Neutral", "Warning", args.spellId)
		end
		self:TargetBar(-8220, 60, args.destName, nil, args.spellId)
	end
end

function mod:Phase2()
	self:Sync("Phase2")
end

function mod:UnleashCorruption()
	self:Sync("Phase2BigAddSpawn") -- Big adds spawning outside in p2
end

function mod:OnSync(sync, rest)
	if sync == "BlindHatred" then
		self:Message(145226, "Important", "Long")
		self:Bar(145226, 60)
	elseif sync == "Phase2" then
		self:Message("stages", "Neutral", "Warning", CL.phase:format(2), 146179)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	elseif sync == "InsideBigAddDeath" and rest then
		-- Custom throttle to work around a really rare bug in the encounter where the normal phase will sometimes merge with the "inside" phase and everyone sees the death event of the add, rather than the 1 person.
		if bigAddKills[rest] then return else bigAddKills[rest] = true end

		bigAddSpawnCounter = bigAddSpawnCounter + 1
		if self:LFR() then
			self:Message("big_adds", "Urgent", nil, CL.soon:format(L.big_add:format(bigAddSpawnCounter)), 147082)
		else
			self:Message("big_adds", "Urgent", "Alarm", CL.custom_sec:format(L.big_add:format(bigAddSpawnCounter), 5), 147082)
			self:CDBar("big_adds", 5, L.big_add:format(bigAddSpawnCounter), 147082)
		end
	elseif sync == "Phase2BigAddSpawn" then
		bigAddSpawnCounter = bigAddSpawnCounter + 1
		if self:LFR() then
			self:Message("big_adds", "Urgent", nil, ("%d%% - "):format(percent) .. CL.soon:format(L.big_add:format(bigAddSpawnCounter)), 147082)
		else
			self:Message("big_adds", "Urgent", "Alarm", ("%d%% - "):format(percent) .. CL.custom_sec:format(L.big_add:format(bigAddSpawnCounter), 5), 147082)
			self:CDBar("big_adds", 5, L.big_add:format(bigAddSpawnCounter), 147082)
		end
		percent = percent - 10
	elseif sync == "OutsideBigAddDeath" and rest then
		if bigAddKills[rest] then return else bigAddKills[rest] = true end -- Custom throttle to catch 2 big adds dieing outside at the same time

		bigAddKillCounter = bigAddKillCounter + 1
		if bigAddKillCounter > bigAddSpawnCounter then
			bigAddSpawnCounter = bigAddKillCounter -- Compensate for no boss mod players (LFR) :[
		end
		self:Message("big_adds", "Attention", "Alert", L.big_add_killed:format(bigAddKillCounter), 147082) -- this could probably live wouthout sound but this way people know for sure that they need to check if it is their turn to soak
	end
end

function mod:OnDBMSync(_, _, prefix, _, _, event, guid)
	if prefix == "M" and event == "ManifestationDied" and guid ~= "" then
		self:OnSync("InsideBigAddDeath", guid)
	end
end

function mod:Deaths(args)
	if args.mobId == 71977 then -- Big add inside (Manifestation of Corruption)
		self:Sync("InsideBigAddDeath", args.destGUID)
	elseif args.mobId == 72264 then -- Big add outside (Unleashed Manifestation of Corruption)
		self:Sync("OutsideBigAddDeath", args.destGUID)
	end
end

-- Amalgam of Corruption
function mod:Fusion(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "Attention", nil, CL.count:format(args.spellName, amount))
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 56 and self:MobId(UnitGUID(unitId)) == 72276 then -- 50%, don't trigger a p2 soon message for healers going into the other realm.
		self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(2)), 146179)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:BlindHatred()
	self:Sync("BlindHatred")
end

function mod:UnleashedAnger(args)
	self:Message(-8218, "Attention")
	self:CDBar(-8218, 10)
end

function mod:SelfDoubt(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Info")
	self:CDBar(args.spellId, 16)
end

