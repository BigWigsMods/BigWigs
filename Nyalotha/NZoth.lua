--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("N'Zoth, the Corruptor", 2217, 2375)
if not mod then return end
mod:RegisterEnableMob(158041, 158376) -- N'Zoth, the Corruptor
mod.engageId = 2344
mod.respawnTime = 49

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local stage = 1
local outside = true
local shatteredEgoCount = 1
local shatteredEgo = nil
local basherCount = 1
local basherTentacleTimers = {25.5, 55.5, 50, 50}
local basherTentacleTimersMythic = {1.5, 35, 35, 55, 32}
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
local eternalTormentTimers = {35.5, 56.5, 29.5, 19.5, 28.5} -- 9.7 repeatedly after
local corruptedMindCount = {}
local glareCount = 1
local glareTimers = {40.7, 67.2, 35.4}
local glareTimersMythic = {36, 69, 23}
local anguishCount = 1
local evokeAnguishTimers = {13, 46.2, 32.0, 30.4, 35.3, 35.3}
local evokeAnguishTimersMythic = {23.1, 20.7, 34.1, 20.7}
local evokeAnguishTimersMythicTwo = {26, 20.7, 34.1, 20.7, 41}
local harvesterCount = 1
local harvesterTimers = {15.5, 25, 45, 31, 4, 31.8, 4, 30, 4}
local mindgraspCount = 1
local paranoiaTimersMythic = {12.2, 86.2}
local paranoiaTimersMythicStageTwo = {53.5, 66}
local harvesterTimersMythic = {9.5, 77.5, 25.5}
local cleansingProtocolTimers = {27, 16, 12, 26}
local annihilateCount = 1
local eventHorizonCount = 1
local protocolCount = 1
local darkMatterCount = 1
local voidspawnKilled = nil
local harversterIconCount = 1
local harvesterList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.realm_switch = "Realm Switched" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Repeating Paranoia Say"
	L.custom_on_repeating_paranoia_say_desc = "Spam a say message in chat to be avoided while you have paranoia."
	L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "Warning: Chamber of Heart compromised. Hostile forces inbound."
	L.gateway_open = "Gateway Open!"

	L.laser_left = "Lasers (Left)"
	L.laser_right = "Lasers (Right)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local harvesterMarker = mod:AddMarkerOption(false, "npc", 3, -21491, 3, 7) -- Thought Harvester
function mod:GetOptions()
	return {
		-- General
		"stages",
		"berserk",
		"altpower",
		{313609, "SAY_COUNTDOWN"}, -- Gift of N'zoth
		-- Stage 1
		{316711, "NAMEPLATEBAR"}, -- Mindwrack
		310184, -- Creeping Anquish
		309991, -- Anguish
		313184, -- Synaptic Shock
		312155, -- Shattered Ego
		-- Stage 2
		315772, -- Mindgrasp
		{315927, "SAY", "PROXIMITY"}, -- Paranoia
		"custom_on_repeating_paranoia_say",
		318449, -- Eternal Torment
		316463, -- Mindgate
		312866, -- Cataclysmic Flames
		313960, -- Black Volley
		-21286, -- Basher Tentacle
		{309698, "TANK"}, -- Void Lash
		310042, -- Tumultuous Burst
		313400, -- Corrupted Mind
		-- Stage 3
		318976, -- Stupefying Glare
		317102, -- Evoke Anguish
		-21491, -- Thought Harvester
		harvesterMarker,
		{317066, "NAMEPLATEBAR"}, -- Harvest Thoughts
		318091, -- Summon Gateway
		318196, -- Event Horizon
		316970, -- Cleansing Protocol
		318971, -- Dark Matter
		{318459, "SAY", "SAY_COUNTDOWN"}, -- Annihilate
	}, {
		["stages"] = CL.general,
		[313609] = -20936, -- Sanity
		[316711] = -21273, -- Psychus
		[315772] = -21485, -- N'Zoth
		[312866] = 315772, -- Mindgate
		[-21286] = -21286, -- Basher Tentacle
		[313400] = -21441, -- Corruptor Tentacle
		[318976] = -20767, -- Stage Three: Convergence
		[-21491] = -21491, -- Thought Harvester
		[318091] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	-- General
	self:Log("SPELL_AURA_APPLIED", "GiftofNzothApplied", 313609)
	self:Log("SPELL_AURA_REMOVED", "GiftofNzothRemoved", 313609)

	-- Stage 1
	self:Log("SPELL_CAST_START", "Mindwrack", 316711)
	self:Log("SPELL_AURA_APPLIED", "MindWrackApplied", 316711)
	self:Log("SPELL_CAST_START", "CreepingAnquish", 310184)
	self:Log("SPELL_AURA_APPLIED", "SynapticShockApplied", 313184, 319309)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SynapticShockApplied", 313184, 319309)
	self:Log("SPELL_AURA_REMOVED", "SynapticShockRemoved", 313184, 319309)
	self:Log("SPELL_AURA_APPLIED", "ShatteredEgo", 312155, 319015) -- Heroic, Mythic
	self:Log("SPELL_AURA_APPLIED", "InfinitysToll", 319346)
	self:Log("SPELL_AURA_REMOVED", "InfinitysTollRemoved", 319346)

	-- Stage 2
	self:Log("SPELL_AURA_REMOVED", "ShatteredEgoRemoved", 312155, 319015) -- Heroic, Mythic
	self:Log("SPELL_CAST_START", "Mindgrasp", 315772)
	self:Log("SPELL_CAST_START", "Paranoia", 315927)
	self:Log("SPELL_AURA_APPLIED", "ParanoiaApplied", 316541, 316542) -- Applied in order of pairs 1, 1, 2, 2, 3, 3
	self:Log("SPELL_AURA_REMOVED", "ParanoiaRemoved", 316541, 316542)
	self:Log("SPELL_CAST_SUCCESS", "EternalTorment", 318449)
	self:Log("SPELL_CAST_START", "Mindgate", 316463)
	self:Log("SPELL_CAST_SUCCESS", "CataclysmicFlames", 312866)
	self:Log("SPELL_AURA_APPLIED", "BlackVolley", 313960)

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

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "EventHorizon", 318196)
	self:Log("SPELL_CAST_START", "CleansingProtocol", 316970, 319349)
	self:Log("SPELL_CAST_START", "DarkMatter", 318971)
	self:Log("SPELL_CAST_SUCCESS", "Annihilate", 318460)
	self:Log("SPELL_AURA_APPLIED", "AnnihilateApplied", 318459)
	self:Log("SPELL_AURA_REMOVED", "AnnihilateRemoved", 318459)

	self:Death("VoidspawnDeath", 163612) -- Voidspawn Annihilator
end

function mod:OnEngage()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:OpenAltPower("altpower", -21056, "ZA") -- Sanity
	wipe(mobCollector)
	wipe(corruptedMindCount)
	wipe(harvesterList)

	stage = 1
	outside = true
	creepingAnguishCount = 1
	synapticShockCount = 0
	eternalTormentCount = 1
	shatteredEgoCount = 1
	shatteredEgo = nil
	mindwrackCount = 1
	mindgateCount = 1
	mindgraspCount = 1
	basherCount = 1
	paranoiaCount = 1
	annihilateCount = 1
	voidspawnKilled = nil
	harversterIconCount = 1
	if self:Mythic() then
		self:Bar(315927, 16.3, CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
		self:Bar(318449, 28.5, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
		self:Bar(316463, 55, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
		self:Bar(315772, 103, CL.count:format(self:SpellName(315772), mindgraspCount)) -- Mindgrasp
		self:Berserk(780)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HarvesterMarker(event, unit, guid)
	if self:MobId(guid) == 162933 and not harvesterList[guid] then -- Eldritch Abomination
		harversterIconCount = harversterIconCount + 1
		harvesterList[guid] = harversterIconCount % 2 == 0 and 3 or 5
		SetRaidTarget(unit, harvesterList[guid])
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L.gateway_yell, nil, true) then
		self:Message(318091, "cyan", self:SpellName(318091))
		self:PlaySound(318091, "long")
		voidspawnKilled = nil
		eternalTormentCount = 1
		eventHorizonCount = 1
		protocolCount = 1
		protocolCount = 1
		annihilateCount = 1
		darkMatterCount = 1
		harversterIconCount = 1

		self:Bar(318449, 22.2) -- Eternal Torment
		self:Bar(318196, 22.3, CL.count:format(self:SpellName(318196), eventHorizonCount)) -- Event Horizon
		self:Bar(316970, cleansingProtocolTimers[protocolCount], CL.count:format(self:SpellName(316970), protocolCount)) -- Cleansing Protocol
		self:Bar(318459, 62, CL.count:format(self:SpellName(318459), annihilateCount)) -- Annihilate
		self:Bar(318971, 41, CL.count:format(self:SpellName(318971), darkMatterCount)) -- Dark Matter
	end
end

do
	local prev = 0 -- can be used for both because different stages
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
				local t = GetTime()
				if t-prev > 2 then -- 2 Spawn at the same in Mythic
					prev = t
					self:Message(-21491, "yellow", CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth")
					self:PlaySound(-21491, "info")
					harvesterCount = harvesterCount + 1
					if self:Mythic() then
						self:Bar(-21491, harvesterTimersMythic[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
					else
						self:Bar(-21491, harvesterTimers[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
					end
				end
			elseif mobId == 158367 and not mobCollector[guid] then -- Basher
				mobCollector[guid] = true
				local t = GetTime()
				if t-prev > 10 then -- 2 Spawn at the same time sometimes
					prev = t
					self:Message(-21286, "yellow", CL.count:format(self:SpellName(-21286), basherCount), "spell_priest_voidtendrils")
					self:PlaySound(-21286, "long")
					basherCount = basherCount + 1
					self:Bar(-21286, self:Mythic() and basherTentacleTimersMythic[basherCount] or basherTentacleTimers[basherCount], CL.count:format(self:SpellName(-21286), basherCount), "spell_priest_voidtendrils")
				end
			end
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
do
	local prev = 0
	function mod:Mindwrack(args)
		if stage < 3 and not outside then -- Cannot interrupt in stage 3 or while outside
			self:StopBar(CL.count:format(args.spellName, (mindwrackCount%3)+1))
			local canDo, ready = self:Interrupter(args.sourceGUID)
			if canDo then
				self:Message(args.spellId, "red", CL.count:format(args.spellName, (mindwrackCount%3)+1))
				if ready then
					self:PlaySound(args.spellId, "alarm")
				end
			end
			mindwrackCount = mindwrackCount + 1
			self:CDBar(args.spellId, 6, CL.count:format(args.spellName, (mindwrackCount%3)+1)) -- Only show 1-3 for interrupts
		elseif self:Tank() and stage > 2 then -- Warn tanks about casts in stage 3 with nameplate bars
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "red")
				self:PlaySound(args.spellId, "alarm")
				self:NameplateBar(args.spellId, 8.5, args.sourceGUID)
			end
		end
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
	if not outside then
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, creepingAnguishCount))
		self:PlaySound(args.spellId, "alarm")
		creepingAnguishCount = creepingAnguishCount + 1
		self:CDBar(args.spellId, 26.8, CL.count:format(args.spellName, creepingAnguishCount))
	end
end

function mod:SynapticShockApplied(args)
	local amount = args.amount or 1
	psychusName = args.destName
	self:StopBar(CL.count:format(args.spellName, synapticShockCount), psychusName)
	self:StackMessage(313184, args.destName, amount, "green")
	self:PlaySound(313184, "info")
	synapticShockCount = amount
	self:TargetBar(313184, 20, psychusName, CL.count:format(args.spellName, synapticShockCount))
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
			self:StopBar(CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
			self:StopBar(CL.count:format(self:SpellName(310184), creepingAnguishCount)) -- Creeping Anguish
			self:StopBar(CL.count:format(self:SpellName(313184), synapticShockCount), psychusName) -- Synaptic Shock
			self:StopBar(CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
			self:StopBar(CL.count:format(self:SpellName(-21286), basherCount))
			self:StopBar(313960) -- Black Volley
			self:StopBar(312866) -- Cataclysmic Flames

			self:Message(312155, "green", CL.count:format(args.spellName, shatteredEgoCount))
			self:PlaySound(312155, "long")
			self:CastBar(312155, 30, CL.count:format(args.spellName, shatteredEgoCount))
			shatteredEgoCount = shatteredEgoCount + 1

			creepingAnguishCount = 1
			synapticShockCount = 0
			shatteredEgo = true
		end
	end
end

function mod:InfinitysToll(args)
	if self:Me(args.destGUID) then
		self:Message("stages", "green", L.realm_switch, false)
		self:PlaySound("stages", "info")
		outside = true
	end
end

function mod:InfinitysTollRemoved(args)
	if self:Me(args.destGUID) then
		outside = nil
	end
end

-- Stage 2
function mod:ShatteredEgoRemoved()
	if self:Mythic() then
		if mindgateCount == 2 then -- First stun
			basherCount = 1
			paranoiaCount = 1
			eternalTormentCount = 1
			mindgraspCount = 1
			shatteredEgo = nil

			self:Bar(315927, 12.22, CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
			self:Bar(318449, 28.7, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
			self:Bar(316463, 55, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
			self:Bar(315772, 103, CL.count:format(self:SpellName(315772), mindgraspCount)) -- Mindgrasp
		end
	else
		if stage == 1 then -- Stage 2 Starting
			stage = 2
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")

			mindgateCount = 1
			paranoiaCount = 1
			eternalTormentCount = 1
			shatteredEgo = nil

			self:Bar(315772, 7.1) -- Mindgrasp
			self:Bar(-21286, basherTentacleTimers[basherCount], CL.count:format(self:SpellName(-21286), basherCount), "spell_priest_voidtendrils")
			self:Bar(318449, 35.5, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
			if paranoiaTimers[shatteredEgoCount-1] then -- XXX fixme
				self:Bar(315927, paranoiaTimers[shatteredEgoCount-1][paranoiaCount], CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
			end
			self:Bar(316463, 68, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
		elseif stage == 2 and mindgateCount == 2 then -- Stun restart bars only the first time, second time starts stage 3
			paranoiaCount = 1
			eternalTormentCount = 1
			basherCount = 1

			self:Bar(315772, 7.1) -- Mindgrasp
			self:Bar(-21286, basherTentacleTimers[basherCount], CL.count:format(self:SpellName(-21286), basherCount), "spell_priest_voidtendrils")
			self:Bar(318449, 35.5, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
			self:Bar(315927, 47.3, CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
			self:Bar(316463, 68, CL.count:format(self:SpellName(316463), mindgateCount)) -- Mindgate
		end
	end
end

function mod:Mindgrasp(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, mindgraspCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 12, CL.count:format(args.spellName, mindgraspCount))
end

do
	local firstParanoiaTargetGUID, lastParanoiaName, mateName = nil, nil, nil
	local proxList, isOnMe, isCasting = {}, nil, nil

	local function updateProximity(self)
		if isCasting then -- spread during cast
			self:OpenProximity(315927, 5)
		elseif isOnMe and mateName then -- stand with mate
			self:OpenProximity(315927, 5, mateName, true)
		elseif #proxList > 0 then -- avoid Paranoias
			self:OpenProximity(315927, 5, proxList)
		else -- no more Paranoias, so we're done
			self:CloseProximity(315927)
		end
	end

	function mod:Paranoia(args)
		self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, paranoiaCount)))
		wipe(proxList)
		isOnMe = nil
		mateName = nil
		isCasting = true
		firstParanoiaTargetGUID = nil
		paranoiaCount = paranoiaCount + 1
		if not shatteredEgo then -- Dont start bars while the boss is stunned
			if self:Mythic() then
				local t = nil
				if stage == 3 then
					t = paranoiaTimersMythicStageTwo[paranoiaCount]
				else
					t = paranoiaTimersMythic[paranoiaCount]
				end
				self:Bar(args.spellId, t, CL.count:format(args.spellName, paranoiaCount))
			else
				self:Bar(args.spellId, paranoiaTimers[shatteredEgoCount-1][paranoiaCount], CL.count:format(args.spellName, paranoiaCount))
			end
		end
		updateProximity(self)
	end

	local sayTimer, paranoiaFallbackTimer = nil, nil
	function mod:ParanoiaApplied(args)
		isCasting = false
		if self:Me(args.destGUID) then
			isOnMe = true
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
				paranoiaFallbackTimer = self:ScheduleTimer("Message", 0.1, 315927, "blue", CL.link:format("|cffff0000???"))
			end
		elseif args.spellId == 316541 and firstParanoiaTargetGUID then -- Paranoia 2
			if self:Me(args.destGUID) then -- We got 2nd debuff, so print last name
				self:Message(315927, "blue", CL.link:format(self:ColorName(lastParanoiaName)))
				mateName = lastParanoiaName
			elseif self:Me(firstParanoiaTargetGUID) then -- We got 1st debuff so this is our mate
				self:Message(315927, "blue", CL.link:format(self:ColorName(args.destName)))
				mateName = args.destName
			end
			firstParanoiaTargetGUID = nil
			if paranoiaFallbackTimer then -- We printed above, so cancel this
				self:CancelTimer(paranoiaFallbackTimer)
				paranoiaFallbackTimer = nil
			end
		else -- One of them immuned, so no proper linked message
			if self:Me(args.destGUID) or self:Me(firstParanoiaTargetGUID) then
				self:Message(315927, "blue", CL.link:format("|cffff00ff???"))
				if paranoiaFallbackTimer then -- We printed above, so cancel this
					self:CancelTimer(paranoiaFallbackTimer)
					paranoiaFallbackTimer = nil
				end
			end
			firstParanoiaTargetGUID = nil
		end

		proxList[#proxList+1] = args.destName

		updateProximity(self)
	end

	function mod:ParanoiaRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:Message(315927, "green", CL.removed:format(args.spellName))
			self:PlaySound(315927, "info")
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end

		tDeleteItem(proxList, args.destName)

		updateProximity(self)
	end
end

function mod:EternalTorment(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, eternalTormentCount))
	self:PlaySound(args.spellId, "alert")
	eternalTormentCount = eternalTormentCount + 1
	if self:Mythic() and not shatteredEgo then
		self:Bar(args.spellId, eternalTormentCount == 4 and 50 or eternalTormentCount == 6 and 50 or 25, CL.count:format(args.spellName, eternalTormentCount)) -- When is it 50?
	elseif not shatteredEgo then
		if stage == 3 then
			if eternalTormentCount % 2 == 1 then -- 3,5,7,etc
				self:Bar(args.spellId, 11, CL.count:format(args.spellName, eternalTormentCount))
			else
				self:Bar(args.spellId, eternalTormentCount == 2 and 72.5 or 24, CL.count:format(args.spellName, eternalTormentCount))
			end
		else
			self:Bar(args.spellId, eternalTormentTimers[eternalTormentCount] or 9.7, CL.count:format(args.spellName, eternalTormentCount))
		end
	end
end

function mod:Mindgate(args)
	self:Message(args.spellId, "green", CL.count:format(args.spellName, mindgateCount))
	self:PlaySound(args.spellId, "long")
	if mindgateCount == 1 then
		self:Bar(312866, 31.5) -- Cataclysmic Flames
	elseif mindgateCount == 2 then
		self:Bar(313960, 34) -- Black Volley
	end
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, mindgateCount))
	mindgateCount = mindgateCount + 1
end

function mod:CataclysmicFlames(args)
	if not outside and not shatteredEgo then -- Reduce spam outside and stop when stunned
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "warning")
		self:Bar(args.spellId, 24.3)
	end
end

function mod:BlackVolley(args)
	if not outside and not shatteredEgo then -- Reduce spam outside and stop when stunned
		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "alert")
		self:Bar(args.spellId, 20)
	end
end

do
	local prev = 0
	function mod:VoidLash(args)
		local t = args.time
		if t-prev > 2 then -- 2 Tentacles are up in the same wave, cast within 1s
			prev = t
			self:Message(args.spellId, "purple")
			self:PlaySound(args.spellId, "alert")
			self:CDBar(args.spellId, 23)
		end
	end
end

function mod:TumultuousBurst(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CorruptedMind(args)
	if not corruptedMindCount[args.sourceGUID] then
		corruptedMindCount[args.sourceGUID] = 1
	end
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "red", CL.count:format(args.spellName, corruptedMindCount[args.sourceGUID]))
		if ready then
			self:PlaySound(args.spellId, "alarm")
		end
	end
	corruptedMindCount[args.sourceGUID] = corruptedMindCount[args.sourceGUID] + 1
end

function mod:CorruptedMindApplied(args)
	if self:Me(args.destGUID) or self:Dispeller("magic") then
		self:TargetMessage(args.spellId, "orange", args.destName)
		self:PlaySound(args.spellId, "alert", args.destName)
	end
end

function mod:Convergence()
	stage = 3
	if self:Mythic() then
		self:Message("stages", "cyan", CL.stage:format(2), false)
	else
		self:Message("stages", "cyan", CL.stage:format(stage), false)
	end
	self:PlaySound("stages", "long")

	anguishCount = 1
	mindgraspCount = 1
	harvesterCount = 1
	glareCount = 1
	eternalTormentCount = 1
	paranoiaCount = 1

	self:Bar(315772, self:Mythic() and 58.4 or 71.5, CL.count:format(self:SpellName(315772), mindgraspCount)) -- Mindgrasp

	if self:Mythic() then
		self:StartStupifyingGlareTimer(glareTimersMythic[glareCount])
		self:Bar(315927, paranoiaTimersMythicStageTwo[paranoiaCount], CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
		self:Bar(317102, evokeAnguishTimersMythic[anguishCount], CL.count:format(self:SpellName(317102), anguishCount)) -- Evoke Anguish
		self:Bar(-21491, harvesterTimersMythic[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
		self:Bar(318091, 153) -- Summon Gateway
	else
		self:Bar(318449, 32.8, CL.count:format(self:SpellName(318449), eternalTormentCount)) -- Eternal Torment
		self:Bar(317102, 13, CL.count:format(self:SpellName(317102), anguishCount)) -- Evoke Anguish
		self:StartStupifyingGlareTimer(glareTimers[glareCount])
		self:Bar(-21491, harvesterTimers[harvesterCount], CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
	end

	if self:GetOption(harvesterMarker) then
		self:RegisterTargetEvents("HarvesterMarker")
	end
end

function mod:EvokeAnguish(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, anguishCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 10, CL.count:format(args.spellName, anguishCount))
	anguishCount = anguishCount + 1
	if self:Mythic() then
		if voidspawnKilled then
			self:Bar(317102, evokeAnguishTimersMythicTwo[anguishCount], CL.count:format(args.spellName, anguishCount))
		else
			self:Bar(317102, evokeAnguishTimersMythic[anguishCount], CL.count:format(args.spellName, anguishCount))
		end
	else
		self:Bar(317102, evokeAnguishTimers[anguishCount], CL.count:format(args.spellName, anguishCount))
	end
end

function mod:StartStupifyingGlareTimer(t)
	if self:Mythic() then
		if voidspawnKilled then -- Reversed Order
			self:Bar(318976, t, CL.count:format(glareCount%2==1 and L.laser_right or L.laser_left, glareCount))
			self:ScheduleTimer("Message", t, 318976, "yellow", CL.count:format(glareCount%2==1 and L.laser_right or L.laser_left, glareCount))
		else
			self:Bar(318976, t, CL.count:format(glareCount%2==0 and L.laser_right or L.laser_left, glareCount))
			self:ScheduleTimer("Message", t, 318976, "yellow", CL.count:format(glareCount%2==0 and L.laser_right or L.laser_left, glareCount))
		end
	else
		self:Bar(318976, t, CL.count:format(self:SpellName(318976), glareCount))
		self:ScheduleTimer("Message", t, 318976, "yellow", CL.count:format(self:SpellName(318976), glareCount))
	end
	self:ScheduleTimer("PlaySound", t, 318976, "long")
	glareCount = glareCount + 1
	if self:Mythic() then
		if glareTimersMythic[glareCount] then
			self:ScheduleTimer("StartStupifyingGlareTimer", t, glareTimersMythic[glareCount])
		end
	else
		if glareTimers[glareCount] then
			self:ScheduleTimer("StartStupifyingGlareTimer", t, glareTimers[glareCount])
		end
	end
end

do
	local prev = 0
	function mod:HarvestThoughts(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
		self:NameplateBar(args.spellId, self:Mythic() and 30 or 23, args.sourceGUID)
	end
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

-- Mythic
function mod:EventHorizon(args)
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(args.spellName, eventHorizonCount))
	if self:Me(args.destGUID) or self:Tank() then
		self:PlaySound(args.spellId, "warning")
	end
	eventHorizonCount = eventHorizonCount + 1
	self:Bar(args.spellId, 30, CL.count:format(args.spellName, eventHorizonCount))
end

function mod:DarkMatter(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, darkMatterCount))
	self:PlaySound(args.spellId, "alarm")
	darkMatterCount = darkMatterCount + 1
	self:Bar(args.spellId, darkMatterCount % 2 == 0 and 60 or 102, CL.count:format(args.spellName, darkMatterCount))
end

do
	local prev = 0
	function mod:CleansingProtocol(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(316970, "yellow", CL.count:format(args.spellName, protocolCount))
			self:PlaySound(316970, "alert")
			if args.spellId == 316970 then
				self:CastBar(316970, 8, CL.count:format(args.spellName, protocolCount))
			else
				self:CastBar(316970, 20, CL.count:format(args.spellName, protocolCount))
			end
			protocolCount = protocolCount + 1
			self:Bar(316970, cleansingProtocolTimers[protocolCount], CL.count:format(args.spellName, protocolCount))
		end
	end
end

function mod:Annihilate(args)
	annihilateCount = annihilateCount + 1
	self:Bar(318459, annihilateCount % 2 == 0 and 4 or 54.5, CL.count:format(args.spellName, annihilateCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:AnnihilateApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 8)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, CL.count:format(args.spellName, annihilateCount-1))
	end

	function mod:AnnihilateRemoved(args)
		if self:Me(args.spellId) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:VoidspawnDeath()
	self:Message(318091, "cyan", L.gateway_open)
	self:PlaySound(318091, "long")

	self:StopBar(CL.count:format(self:SpellName(318196), eventHorizonCount)) -- Event Horizon
	self:StopBar(CL.count:format(self:SpellName(316970), protocolCount)) -- Cleansing Protocol
	self:StopBar(CL.count:format(self:SpellName(318459), annihilateCount)) -- Annihilate
	self:StopBar(CL.count:format(self:SpellName(318971), darkMatterCount)) -- Dark Matter

	voidspawnKilled = true
	anguishCount = 1
	mindgraspCount = 1
	harvesterCount = 1
	glareCount = 1
	eternalTormentCount = 1
	paranoiaCount = 1

	self:Bar(315772, 61.1, CL.count:format(self:SpellName(315772), mindgraspCount)) -- Mindgrasp
	self:Bar(315927, paranoiaTimersMythicStageTwo[paranoiaCount]+2.7, CL.count:format(self:SpellName(315927), paranoiaCount)) -- Paranoia
	self:StartStupifyingGlareTimer(38)
	self:Bar(317102, 26, CL.count:format(self:SpellName(317102), anguishCount)) -- Evoke Anguish
	self:Bar(-21491, 5.5, CL.count:format(self:SpellName(-21491), harvesterCount), "achievement_boss_heraldofnzoth") -- Thought Harvester
end
