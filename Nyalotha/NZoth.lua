--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("N'Zoth, the Corruptor", 2217, 2375)
if not mod then return end
mod:RegisterEnableMob(158041) -- N'Zoth, the Corruptor
mod.engageId = 2344
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local stage = 1
local shatteredEgoCount = 1
local psychusName = nil
local mindwrackCount = 0
local synapticShockCount = 0
local creepingAnguishCount = 1
local mindgateCount = 1
local paranoiaCount = 1
local paranoiaTimers = {
	{51.1, 56.8, 48.7}, -- After first Shattered Ego
	{47.3, 56.0, 63.6}, -- After second Shattered Ego
}
local eternalTormentCount = 1
local eternalTormentTimers = {35.5, 56.5, 30, 20}
local corruptedMindCount = {}
local glareCount = 1
local glareTimers = {40.7, 67.2, 35.4}
local anguishCount = 1
local evokeAnguishTimers = {13, 46.2, 32.0, 30.4, 35.3, 35.3}
local harvesterCount = 1
local harvesterTimers = {15.5, 25, 45, 31, 4, 31.8, 4, 30, 4}
local mindgraspCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.realm_switch = "Realm Switched" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Repeating Paranoia Say"
	L.custom_on_repeating_paranoia_say_desc = "Spam a say message in chat to be avoided while you have paranoia."
	L.custom_on_repeating_paranoia_say_icon = 315927
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- General
		"stages",
		"altpower",
		{313609, "SAY_COUNTDOWN"}, -- Gift of N'zoth
		-- Stage 1
		316711, -- Mindwrack
		310184, -- Creeping Anquish
		309991, -- Anguish
		313184, -- Synaptic Shock
		312155, -- Shattered Ego
		-- Stage 2
		315772, -- Mindgrasp
		{315927, "SAY"}, -- Paranoia
		"custom_on_repeating_paranoia_say",
		318449, -- Eternal Torment
		316463, -- Mindgate
		312866, -- Cataclysmic Flames
		{309698, "TANK"}, -- Void Lash
		310042, -- Tumultuous Burst
		313400, -- Corrupted Mind
		-- Stage 3
		318976, -- Stupefying Glare
		317102, -- Evoke Anguish
		-21491, -- Thought Harvester
		317066, -- Harvest Thoughts
	}, {
		["stages"] = CL.general,
		[313609] = -20936, -- Sanity
		[316711] = -21273, -- Psychus
		[315772] = -21485, -- N'Zoth
		[312866] = 315772, -- Mindgate
		[309698] = -21286, -- Basher Tentacle
		[313400] = -21441, -- Corruptor Tentacle
		[318976] = -20767, -- Stage Three: Convergence
		[-21491] = -21491, -- Thought Harvester
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	-- General
	self:Log("SPELL_AURA_APPLIED", "GiftofNzothApplied", 313609)
	self:Log("SPELL_AURA_REMOVED", "GiftofNzothRemoved", 313609)

	-- Stage 1
	self:Log("SPELL_CAST_START", "Mindwrack", 316711)
	self:Log("SPELL_AURA_APPLIED", "MindWrackApplied", 316711)
	self:Log("SPELL_CAST_START", "CreepingAnquish", 310184)
	self:Log("SPELL_AURA_APPLIED", "SynapticShockApplied", 313184)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SynapticShockApplied", 313184)
	self:Log("SPELL_AURA_REMOVED", "SynapticShockRemoved", 313184)
	self:Log("SPELL_AURA_APPLIED", "ShatteredEgo", 312155)
	self:Log("SPELL_AURA_APPLIED", "InfinitysToll", 319346)


	-- Stage 2
	self:Log("SPELL_AURA_REMOVED", "ShatteredEgoRemoved", 312155)
	self:Log("SPELL_CAST_START", "Mindgrasp", 315772)
	self:Log("SPELL_CAST_START", "Paranoia", 315927)
	self:Log("SPELL_AURA_APPLIED", "ParanoiaApplied", 316541, 316542) -- Applied in order of pairs 1, 1, 2, 2, 3, 3
	self:Log("SPELL_AURA_REMOVED", "ParanoiaRemoved", 316541, 316542)
	self:Log("SPELL_CAST_START", "EternalTorment", 318449)
	self:Log("SPELL_CAST_START", "Mindgate", 316463)
	self:Log("SPELL_CAST_SUCCESS", "CataclysmicFlames", 312866)

	-- Basher
	self:Log("SPELL_CAST_START", "VoidLash", 309698)
	self:Log("SPELL_CAST_SUCCESS", "TumultuousBurst", 310042)

	-- Corruptor
	self:Log("SPELL_CAST_START", "CorruptedMind", 313400)
	self:Log("SPELL_AURA_APPLIED", "CorruptedMindApplied", 313400)

	-- Stage 3
	self:Log("SPELL_CAST_START", "Convergence", 312782)
	self:Log("SPELL_CAST_START", "EvokeAnguish", 317102)
	self:Log("SPELL_CAST_START", "HarvestThoughts", 317066)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 309991) -- Anguish
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 309991)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 309991)
end

function mod:OnEngage()
	self:OpenAltPower("altpower", -21056) -- Sanity
	wipe(mobCollector)
	wipe(corruptedMindCount)

	stage = 1
	creepingAnguishCount = 1
	synapticShockCount = 0
	shatteredEgoCount = 1
	mindwrackCount = 1
	mindgateCount = 1
	mindgraspCount = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local prevBasher, prevHarvester = 0, 0
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unit = ("boss%d"):format(i)
		local guid = UnitGUID(unit)
		local mobId = self:MobId(guid)
		if mobId == 158376 and not mobCollector[guid] then -- Psychus
			mobCollector[guid] = true
			mindwrackCount = 0

			self:CDBar(316711, 7.3, CL.count:format(self:SpellName(316711), (mindwrackCount%3)+1)) -- Mindwrack
			self:Bar(310184, 12.1, CL.count:format(self:SpellName(310184), creepingAnguishCount)) -- Creeping Anquish
		elseif mobId == 162933 and not mobCollector[guid] then -- Thought Harvester
			mobCollector[guid] = true
			self:NameplateBar(317066, 8.5, guid) -- Harvest Thoughts
			if self:Tank() then
				self:NameplateBar(316711, 3, guid) -- Mindwrack
			end
			self:Message2(-21491, "yellow", CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth")
			self:PlaySound(-21491, "info")
			harvesterCount = harvesterCount + 1
			self:Bar(-21491, harvesterTimers[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
		end
	end
end

-- General
do
	local playerList = mod:NewTargetList()
	function mod:GiftofNzothApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:SayCountdown(args.spellId, 20)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:GiftofNzothRemoved(args)
		if self:Me(args.spellId) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

-- Stage 1
function mod:Mindwrack(args)
	if stage < 3 then -- Cannot interrupt in stage 3
		local canDo, ready = self:Interrupter(args.sourceGUID)
		if canDo then
			self:Message2(args.spellId, "red", CL.count:format(args.spellName, mindwrackCount))
			if ready then
				self:PlaySound(args.spellId, "alarm")
			end
		end
		mindwrackCount = mindwrackCount + 1
		self:CDBar(args.spellId, 6, CL.count:format(args.spellName, (mindwrackCount%3)+1)) -- Only show 1-3 for interrupts
	elseif self:Tank() then -- Warn tanks about casts in stage 3 with nameplate bars
		self:Message2(args.spellId, "red")
		self:PlaySound(args.spellId, "alarm")
		self:NameplateBar(args.spellId, 8.5, args.sourceGUID)
	end
end

function mod:MindWrackApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 2 and amount % 2 == 0 then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CreepingAnquish(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, creepingAnguishCount))
	self:PlaySound(args.spellId, "alarm")
	creepingAnguishCount = creepingAnguishCount + 1
	self:CDBar(args.spellId, 26.8, CL.count:format(args.spellName, creepingAnguishCount))
end

function mod:SynapticShockApplied(args)
	local amount = args.amount or 1
	psychusName = args.destName
	self:StopBar(CL.count:format(args.spellName, synapticShockCount), psychusName)
	self:StackMessage(args.spellId, args.destName, amount, "green")
	self:PlaySound(args.spellId, "info")
	synapticShockCount = amount
	self:TargetBar(args.spellId, 20, psychusName, CL.count:format(args.spellName, synapticShockCount))
end

function mod:SynapticShockRemoved(args)
	self:StopBar(CL.count:format(args.spellName, synapticShockCount), psychusName)
	synapticShockCount = 0
end

do
	local prev = 0
	function mod:ShatteredEgo(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(self:SpellName(310184), creepingAnguishCount)) -- Creeping Anguish
			self:StopBar(CL.count:format(self:SpellName(313184), synapticShockCount), psychusName) -- Synaptic Shock
			self:StopBar(CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia

			self:Message2(args.spellId, "green", CL.count:format(args.spellName, shatteredEgoCount))
			self:PlaySound(args.spellId, "long")
			self:CastBar(args.spellId, 30, CL.count:format(args.spellName, shatteredEgoCount))
			shatteredEgoCount = shatteredEgoCount + 1

			creepingAnguishCount = 0
			synapticShockCount = 0
		end
	end
end

function mod:InfinitysToll(args)
	if self:Me(args.destGUID) then
		self:Message2("stages", "green", L.realm_switch, false)
		self:PlaySound("stages", "info")
	end
end

-- Stage 2
function mod:ShatteredEgoRemoved()
	if stage == 1 then -- Stage 2 Starting
		stage = 2
		self:Message2("stages", "cyan", CL.stage:format(stage), false)
		self:PlaySound("stages", "long")

		mindgateCount = 1
		paranoiaCount = 1
		eternalTormentCount = 1

		-- XXX Add Timer Bar
		self:Bar(315772, 7.1) -- Mindgrasp
		self:Bar(318449, 35.5, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
		self:Bar(315927, paranoiaTimers[mindgateCount][paranoiaCount], CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
		self:Bar(316463, 68, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
	elseif stage == 2 and mindgateCount == 2 then -- Stun restart bars only the first time, second time starts stage 3
		paranoiaCount = 1
		eternalTormentCount = 1

		-- XXX Add Timer Bar
		self:Bar(315772, 7.1) -- Mindgrasp
		self:Bar(318449, 35.5, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
		self:Bar(315927, 47.3, CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
		self:Bar(316463, 68, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
	end
end

function mod:Mindgrasp(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, mindgraspCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 12, CL.count:format(args.spellName, mindgraspCount))
end

do
	local firstParanoiaTargetGUID, lastParanoiaName = nil, nil
	function mod:Paranoia(args)
		firstParanoiaTargetGUID = nil
		paranoiaCount = paranoiaCount + 1
		self:Bar(args.spellId, paranoiaTimers[mindgateCount][paranoiaCount], CL.count:format(args.spellName, paranoiaCount))
	end

	local sayTimer, paranoiaFallbackTimer = nil, nil
	function mod:ParanoiaApplied(args)
		if self:Me(args.destGUID) then
			self:Say(315927, args.spellName, true)
			self:PlaySound(315927, "warning")
			if self:GetOption("custom_on_repeating_paranoia_say") then
				sayTimer = self:ScheduleRepeatingTimer(SendChatMessage, 1.5, args.spellName, "SAY")
			end
		end

		if args.spellId == 316542 then -- 1st paranoia - save data, print on 2nd
			firstParanoiaTargetGUID = args.destGUID
			lastParanoiaName = args.destName
			if self:Me(args.destGUID) then -- fallback if the last event is missing
				paranoiaFallbackTimer = self:ScheduleTimer("Message2", 0.1, 315927, "blue", CL.link:format("|cffff0000???"))
			end
		elseif args.spellId == 316541 and firstParanoiaTargetGUID then -- Paranoia 2
			if self:Me(args.destGUID) then -- We got 2nd debuff, so print last name
				self:Message2(315927, "blue", CL.link:format(self:ColorName(lastParanoiaName)))
			elseif self:Me(firstParanoiaTargetGUID) then -- We got 1st debuff so this is our mate
				self:Message2(315927, "blue", CL.link:format(self:ColorName(args.destName)))
			end
			firstParanoiaTargetGUID = nil
			if paranoiaFallbackTimer then -- We printed above, so cancel this
				self:CancelTimer(paranoiaFallbackTimer)
				paranoiaFallbackTimer = nil
			end
		else -- One of them immuned, so no proper linked message
			if self:Me(args.destGUID) or self:Me(firstParanoiaTargetGUID) then
				self:Message2(315927, "blue", CL.link:format("|cffff00ff???"))
				if paranoiaFallbackTimer then -- We printed above, so cancel this
					self:CancelTimer(paranoiaFallbackTimer)
					paranoiaFallbackTimer = nil
				end
			end
			firstParanoiaTargetGUID = nil
		end
	end

	function mod:ParanoiaRemoved(args)
		if self:Me(args.destGUID) then
			self:Message2(315927, "green", CL.removed:format(args.spellName))
			self:PlaySound(315927, "info")
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end
end

function mod:EternalTorment(args)
	self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, eternalTormentCount))
	self:PlaySound(args.spellId, "alert")
	eternalTormentCount = eternalTormentCount + 1
	self:Bar(args.spellId, stage == 3 and (eternalTormentCount == 2 and (72.5 or eternalTormentCount % 2 == 1 and 11 or 24)) or eternalTormentTimers[eternalTormentCount], CL.count:format(args.spellName, eternalTormentCount))
end

function mod:Mindgate(args)
	self:Message2(args.spellId, "green", CL.count:format(args.spellName, mindgateCount))
	self:PlaySound(args.spellId, "long")
	if mindgateCount == 1 then
		self:Bar(312866, 31.5) -- Cataclysmic Flames
	end
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, mindgateCount))
	mindgateCount = mindgateCount + 1
end

function mod:CataclysmicFlames(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 24.3)
end

do
	local prev = 0
	function mod:VoidLash(args)
		local t = args.time
		if t-prev > 2 then -- 2 Tentacles are up in the same wave, cast within 1s
			prev = t
			self:Message2(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert")
			self:CDBar(args.spellId, 23)
		end
	end
end

function mod:TumultuousBurst(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CorruptedMind(args)
	if not corruptedMindCount[args.sourceGUID] then
		corruptedMindCount[args.sourceGUID] = 1
	end
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "red", CL.count:format(args.spellName, corruptedMindCount[args.sourceGUID]))
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
	corruptedMindCount[args.sourceGUID] = corruptedMindCount[args.sourceGUID] + 1
	self:NameplateBar(args.spellId, 5, args.sourceGUID)
end

function mod:CorruptedMindApplied(args)
	if self:Me(args.destGUID) or self:Dispeller("magic") then
		self:TargetMessage(args.spellId, args.destName, "orange")
		self:PlaySound(args.spellId, "alert", args.destName)
	end
end

function mod:Convergence()
	stage = 3
	self:Message2("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	anguishCount = 1
	mindgraspCount = 1
	harvesterCount = 1
	glareCount = 1
	eternalTormentCount = 1

	self:Bar(318449, 32.8, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
	self:Bar(317102, 13, CL.count:format(self:SpellName(317102), anguishCount)) -- Evoke Anguish
	self:StartStupifyingGlareTimer(glareTimers[glareCount])
	self:Bar(-21491, harvesterTimers[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
	self:Bar(315772, 71.5, CL.count:format(self:SpellName(315772), mindgraspCount)) -- Mindgrasp
end

function mod:EvokeAnguish(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, anguishCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10, CL.count:format(args.spellName, anguishCount))
	anguishCount = anguishCount + 1
	self:Bar(317102, evokeAnguishTimers[anguishCount], CL.count:format(args.spellName, anguishCount))
end

function mod:StartStupifyingGlareTimer(t)
	self:Bar(318976, t, CL.count:format(self:SpellName(318976), glareCount))
	self:ScheduleTimer("Message2", t, 318976, "yellow", CL.count:format(self:SpellName(318976), glareCount))
	self:ScheduleTimer("PlaySound", t, 318976, "long")
	glareCount = glareCount + 1
	if glareTimers[glareCount] then
		self:ScheduleTimer("StartStupifyingGlareTimer", t, glareTimers[glareCount])
	end
end

function mod:HarvestThoughts(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:NameplateBar(args.spellId, 23, args.sourceGUID)
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
