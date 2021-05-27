--------------------------------------------------------------------------------
-- Module Declaration
--

if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("Kel'Thuzad", 2450, 2440)
if not mod then return end
mod:RegisterEnableMob(175559, 176703, 176973, 176974, 176929) -- Kel'Thuzad, Frostbound Devoted, Unstoppable Abomination, Soul Reaver, Remnant of Kel'Thuzad
mod:SetEncounterID(2422)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}
local mobCollector = {}
local glacialSpikeMarks = {}
local mindControlled = false
local stage = 1

local darkEvocationCount = 1
local blizzardCount = 1
local soulFractureCount = 1
local oblivionsEchoCount = 1
local frostBlastCount = 1
local glacialWrathCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.spikes = "Spikes" -- Short for Glacial Spikes
	L.spike = "Spike"
	L.silence = mod:SpellName(226452) -- Silence
	L.miasma = "Miasma" -- Short for Necrotic Miasma
end

--------------------------------------------------------------------------------
-- Initialization
--

local glacialWrathMarker = mod:AddMarkerOption(false, "player", 1, 346459, 1, 2, 3, 4, 5) -- Glacial Wrath
local soulReaverMarker = mod:AddMarkerOption(false, "npc", 8, -23435, 8, 7, 6) -- Soul Reaver
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Chains and Ice
		354198, -- Howling Blizzard
		352530, -- Dark Evocation
		{355389, "SAY"}, -- Corpse Detonation
		348071, -- Soul Fracture // Tank hit but spawns Soul Shards for DPS
		{348978, "TANK"}, -- Soul Exhaustion
		{346459, "SAY", "SAY_COUNTDOWN"}, -- Glacial Wrath
		glacialWrathMarker,
		{346530, "ME_ONLY"}, -- Shatter
		{347292, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Oblivion's Echo
		{348760, "SAY", "SAY_COUNTDOWN", "FLASH", "ME_ONLY_EMPHASIZE"}, -- Frost Blast
		-- Stage Two: The Phylactery Opens
		354289, -- Necrotic Miasma
		352051, -- Necrotic Surge
		352293, -- Necrotic Destruction
		352379, -- Freezing Blast
		355055, -- Glacial Winds
		352355, -- Necrotic Obliteration
		352141, -- Banshee's Cry (Soul Reaver)
		soulReaverMarker,
		-- Stage Three: The Final Stand
		354639, -- Deep Freeze
		352348, -- Onslaught of the Damned
	},{
		["stages"] = "general",
		[354198] = mod:SpellName(-22884), -- Stage One: Chains and Ice
		[354289] = mod:SpellName(-22885), -- Stage Two: The Phylactery Opens
		[354639] = mod:SpellName(-23201) -- Stage Three: The Final Stand
	},{
		[355389] = CL.fixate, -- Corpse Detonation (Fixate)
		[346459] = L.spikes, -- Glacial Wrath (Spikes)
		[347292] = L.silence, -- Oblivion's Echo (Silence)
		[348760] = CL.meteor, -- Frost Blast (Meteor)
		[354289] = L.miasma, -- Necrotic Miasma (Miasma)
	}
end

function mod:OnBossEnable()
	-- Stage One - Thirst for Blood
	self:Log("SPELL_CAST_START", "HowlingBlizzardStart", 354198)
	self:Log("SPELL_CAST_SUCCESS", "HowlingBlizzard", 354198)
	self:Log("SPELL_AURA_APPLIED", "DarkEvocation", 352530) -- No _SUCCESS on the channel
	self:Log("SPELL_AURA_APPLIED", "CorpseDetonationFixateApplied", 355389)
	self:Log("SPELL_CAST_START", "SoulFractureStart", 348071)
	self:Log("SPELL_CAST_SUCCESS", "SoulFractureSuccess", 348071)
	self:Log("SPELL_AURA_APPLIED", "SoulExhaustionApplied", 348978)
	self:Log("SPELL_AURA_REMOVED", "SoulExhaustionRemoved", 348978)
	self:Log("SPELL_CAST_START", "GlacialWrath", 346459)
	self:Log("SPELL_SUMMON", "GlacialWrathSummon", 346459)
	self:Log("SPELL_AURA_APPLIED", "GlacialWrathApplied", 353808)
	self:Log("SPELL_AURA_REMOVED", "GlacialWrathRemoved", 353808)
	self:Log("SPELL_AURA_APPLIED", "ShatterApplied", 346530)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShatterApplied", 346530)
	self:Log("SPELL_AURA_APPLIED", "OblivionsEcho", 347291, 352997) -- Stage 1, Stage 3
	self:Log("SPELL_AURA_APPLIED", "OblivionsEchoApplied", 347292)
	self:Log("SPELL_AURA_REMOVED", "OblivionsEchoRemoved", 347292)
	self:Log("SPELL_AURA_APPLIED", "FrostBlastApplied", 348760)

	-- Stage Two: The Phylactery Opens
	self:Log("SPELL_AURA_APPLIED", "NecroticMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticMiasmaApplied", 354289)
	self:Log("SPELL_AURA_APPLIED", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_AURA_APPLIED_DOSE", "NecroticSurgeApplied", 352051)
	self:Log("SPELL_CAST_START", "NecroticDestruction", 352293)
	self:Log("SPELL_CAST_START", "FreezingBlast", 352379)
	self:Log("SPELL_CAST_START", "GlacialWinds", 355055)
	self:Log("SPELL_CAST_START", "NecroticObliteration", 352355)
	self:Death("RemnantDeath", 176929) -- Remnant of Kel'Thuzad

	self:Log("SPELL_CAST_START", "BansheesCry", 352141)
	self:Log("SPELL_SUMMON", "MarchOfTheForsakenSummon", 352094)

	-- Stage Three: The Final Stand
	self:Log("SPELL_CAST_START", "OnslaughtOfTheDamned", 352348)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 354198, 354639) -- Howling Blizzard, Deep Freeze
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 354198, 354639)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 354198, 354639)

	self:Log("SPELL_AURA_APPLIED", "ReturnOfTheDamned", 348638)
	self:Log("SPELL_AURA_REMOVED", "ReturnOfTheDamnedRemoved", 348638)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	self:SetStage(1)
	stage = 1
	mobCollector = {}
	glacialSpikeMarks = {}
	mindControlled = false

	darkEvocationCount = 1
	blizzardCount = 1
	soulFractureCount = 1
	oblivionsEchoCount = 1
	frostBlastCount = 1
	glacialWrathCount = 1


	self:CDBar(348071, 7.5, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
	self:CDBar(347292, 10, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
	self:CDBar(346459, 19, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
	self:CDBar(348760, 43.5, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
	self:CDBar(352530, 44.5, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
	--self:CDBar(354198, 112, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

-- Stage One: Chains and Ice
function mod:HowlingBlizzardStart(args)
	self:Message(args.spellId, "cyan", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end


function mod:HowlingBlizzard(args)
	self:CastBar(args.spellId, 20, CL.count:format(args.spellName, blizzardCount))
	blizzardCount = blizzardCount + 1
	self:CDBar(args.spellId, 111.2, CL.count:format(args.spellName, blizzardCount))
end

function mod:DarkEvocation(args)
	self:Message(args.spellId, "cyan", CL.casting:format(CL.count:format(args.spellName, darkEvocationCount)))
	self:PlaySound(args.spellId, "long")
	darkEvocationCount = darkEvocationCount + 1
	self:CDBar(args.spellId, 47.8, CL.count:format(args.spellName, darkEvocationCount))
end

function mod:CorpseDetonationFixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		--self:Say(args.spellId, CL.fixate) -- Kinda spammy
	end
end

function mod:SoulFractureStart(args)
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(args.spellName, soulFractureCount)))
	self:PlaySound(args.spellId, "alarm")
end

function mod:SoulFractureSuccess(args)
	soulFractureCount = soulFractureCount + 1
	self:CDBar(args.spellId, 33.2, CL.count:format(args.spellName, soulFractureCount)) -- 33~ or 40.3+ (delayed by a blizzard/dark evocation?)
end

function mod:SoulExhaustionApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		local unit = self:GetBossId(args.sourceGUID) -- Check if its always boss1, then we dont have to GetBossId
		if not self:Me(args.destGUID) and not self:Tanking(unit) then
			self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(args.spellName, soulFractureCount-1))
			self:PlaySound(args.spellId, "warning", "taunt", args.destName) -- Not taunted? Play warning sound.
		elseif self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end
	self:TargetBar(args.spellId, 60, args.destName, CL.count:format(args.spellName, soulFractureCount-1))
end

function mod:SoulExhaustionRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
	self:StopBar(args.spellId, args.destName)
end

function mod:GlacialWrath(args)
	self:Message(args.spellId, "orange", CL.casting:format(L.spikes))
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 44.1, L.spikes)

	mobCollector = {}
	glacialSpikeMarks = {}
	if self:GetOption(glacialWrathMarker) then
		self:RegisterTargetEvents("GlacialSpikeMarker")
		self:ScheduleTimer("UnregisterTargetEvents", 10)
	end
end

function mod:GlacialWrathSummon(args)
	mobCollector[args.destGUID] = tremove(glacialSpikeMarks, 1)
end

function mod:GlacialSpikeMarker(event, unit, guid)
	if self:MobId(guid) == 175861 and mobCollector[guid] then
		self:CustomIcon(glacialWrathMarker, unit, mobCollector[guid])
		mobCollector[guid] = nil
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:GlacialWrathApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(346459, CL.count_rticon:format(L.spike, count, count))
			self:SayCountdown(346459, 6, count)
			self:PlaySound(346459, "warning")
		end
		self:NewTargetsMessage(346459, "orange", playerList, nil, L.spike)
		self:CustomIcon(glacialWrathMarker, args.destName, icon)
	end

	function mod:GlacialWrathRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(346459)
		end
		self:CustomIcon(glacialWrathMarker, args.destName)
		glacialSpikeMarks[#glacialSpikeMarks+1] = playerList[args.destName] -- _REMOVED is more reliable for spike order
	end
end


do
	local playerName = mod:UnitName("player")
	local stacks = 1
	local scheduled = nil

	local function ShatterStackMessage()
		mod:NewStackMessage(346530, "blue", playerName, stacks)
		mod:PlaySound(346530, stacks > 4 and "warning" or "info") -- How many stacks is too much?
		scheduled = nil
	end

	function mod:ShatterApplied(args) -- Throttle incase several die at the same time
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer(ShatterStackMessage, 0.1)
			end
		end
	end
end

do
	local playerList = {}
	function mod:OblivionsEcho(args)
		playerList = {}
		oblivionsEchoCount = oblivionsEchoCount + 1
		if stage == 3 then
			self:CDBar(347292, oblivionsEchoCount % 2 == 0 and 17.1 or 23.3, CL.count:format(L.silence, oblivionsEchoCount))
		else
			self:CDBar(347292, 39.1, CL.count:format(L.silence, oblivionsEchoCount)) -- 38-44?
		end
	end

	function mod:OblivionsEchoApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.silence)
			self:SayCountdown(args.spellId, 6)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.silence, oblivionsEchoCount-1))
	end
end

function mod:OblivionsEchoRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:FrostBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, CL.meteor)
		self:Flash(args.spellId)
		self:YellCountdown(args.spellId, 6)
	else
		self:PlaySound(args.spellId, "alert")
	end
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(CL.meteor, frostBlastCount))
	frostBlastCount = frostBlastCount + 1
	self:CDBar(args.spellId, stage == 3 and 40.2 or 42.5, CL.count:format(CL.meteor, frostBlastCount))
end

function mod:NecroticMiasmaApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 and amount > 15 then -- 15+ or every 2
			self:NewStackMessage(args.spellId, "blue", args.destName, amount, 10, L.miasma)
			if amount > 15 then
				self:PlaySound(args.spellId, "alert")
			end
		end
	end
end

function mod:NecroticSurgeApplied(args)
	self:NewStackMessage(args.spellId, "cyan", args.destName, args.amount)
	self:PlaySound(args.spellId, "info")

	self:StopBar(CL.cast:format(self:SpellName(352293))) -- Necrotic Destruction
	self:StopBar(352379) -- Freezing Blast
	self:StopBar(355055) -- Glacial Winds

	if stage == 2 then
		self:SetStage(1)
		stage = 1
		self:CDBar(348071, 9.5, CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
		self:CDBar(347292, 10.5, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
		self:CDBar(346459, 20.5, CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
		self:CDBar(348760, 45.3, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast // Sometimes 90s? why?

		-- Standard time if mana is 100
		local evocationTime = 45.4
		local blizzardTime = 86.2

		local currentMana = UnitPower("boss1")
		if currentMana then
			if currentMana == 80 then
				evocationTime = 46.1
				blizzardTime = 86.4
			elseif currentMana == 60 then
				evocationTime = 11.5
				blizzardTime = 46.5
			elseif currentMana == 40 then
				-- XXX 20 uses these times sometimes? seems like the longer at 20
				-- the higher the chance evo is used immediately regardless of energy?
				evocationTime = 3.2
				blizzardTime = 21.5
			elseif currentMana == 20 then
				evocationTime = 46.5
				blizzardTime = 11.5
			end
		end
		self:CDBar(352530, evocationTime, CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
		self:CDBar(354198, blizzardTime, CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard
	else -- Stage 3
		oblivionsEchoCount = 1

		-- oblivion > oblivion > frost blast > onslaught > repeat
		-- always the same order, but seems to either start at oblivion or frost blast based on energy

		-- Standard time if mana is 100
		local frostBlastTime = 30.2
		local onslaughtTime = 33.9
		local oblivionTime = 5.8

		local currentMana = UnitPower("boss1")
		if currentMana == 80 then
			-- XXX Check
			frostBlastTime = 30.2
			onslaughtTime = 33.9
			oblivionTime = 5.8
		elseif currentMana == 60 then
			-- XXX Check
			frostBlastTime = 29.8
			onslaughtTime = 33.97
			oblivionTime = 45.8
		elseif currentMana == 40 then
			-- XXX Check
			frostBlastTime = 29.8
			onslaughtTime = 33.97
			oblivionTime = 45.8
		elseif currentMana == 20 then
			frostBlastTime = 29.8
			onslaughtTime = 33.97
			oblivionTime = 45.8
		end
		self:CDBar(347292, oblivionTime, CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
		self:CDBar(348760, frostBlastTime, CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
		self:CDBar(348760, onslaughtTime, 34.8) -- Onslaught of the Damned
	end
end

function mod:NecroticDestruction(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 45)

	-- UNIT_SPELLCAST_SUCCEEDED Events which are 2.5~s faster to do a stage change on:
	-- ClearAllDebuffs-34098-npc:175559
	-- Cosmetic Death-351625-npc:175559
	-- Teleport to Floor-351418-npc:175559

	self:StopBar(CL.count:format(self:SpellName(348071), soulFractureCount)) -- Soul Fracture
	self:StopBar(CL.count:format(L.silence, oblivionsEchoCount)) -- Oblivion's Echo
	self:StopBar(CL.count:format(L.spikes, glacialWrathCount)) -- Glacial Wrath
	self:StopBar(CL.count:format(CL.meteor, frostBlastCount)) -- Frost Blast
	self:StopBar(CL.count:format(self:SpellName(352530), darkEvocationCount)) -- Dark Evocation
	self:StopBar(CL.count:format(self:SpellName(354198), blizzardCount)) -- Howling Blizzard

	self:SetStage(2)
	stage = 2
	if self:GetHealth("boss2") < 34 then -- final stage 2
		self:CDBar(355055, 3) -- Glacial Winds
		self:CDBar(352379, 11) -- Freezing Blast
	else
		self:CDBar(352379, 7) -- Freezing Blast
	end
end

function mod:RemnantDeath()
	self:SetStage(3)
	stage = 3
end

function mod:FreezingBlast(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CDBar(args.spellId, 4.9)
end

function mod:GlacialWinds(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 13.5)
end

function mod:NecroticObliteration(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10)

	self:StopBar(352379) -- Freezing Blast
	self:StopBar(355055) -- Glacial Winds
end

function mod:OnslaughtOfTheDamned(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 40.2)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and not mindControlled then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

function mod:ReturnOfTheDamned(args)
	if self:Me(args.destGUID) then
		mindControlled = true
	end
end

function mod:ReturnOfTheDamnedRemoved(args)
	if self:Me(args.destGUID) then
		mindControlled = false
	end
end

function mod:BansheesCry(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local scheduled = nil
	local bossUnits = {"boss1", "boss2", "boss3", "boss4", "boss5", "arena1", "arena2", "arena3"}
	function mod:SoulReaverMarker()
		local mark = 8
		for i = 1, #bossUnits do
			local unit = bossUnits[i] -- boss5 arena1 arena2 were used
			if self:MobId(unit) == 176974 then -- Soul Reaver
				self:CustomIcon(soulReaverMarker, unit, mark)
				mark = mark - 1
				if mark < 6 then break end
			end
		end
		scheduled = nil
	end
	function mod:MarchOfTheForsakenSummon(args)
		if not scheduled and self:GetOption(soulReaverMarker) then
			-- Delayed for IEEU
			scheduled = self:ScheduleTimer("SoulReaverMarker", 0.3)
		end
	end
end
