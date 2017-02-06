
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn timer
-- - Localization for the yells, maybe another way to do it?
-- - Fix any errors/missing timers after merge

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Magistrix Elisande", 1088, 1743)
if not mod then return end
mod:RegisterEnableMob(106643)
mod.engageId = 1872
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--
local phase = 1

local slowElementalCounter = 0
local slowElementalTimers = {49,52,60} -- No idea how it continues
local slowAddTimerMythic = {
		[1] = {5.0, 39.0, 75.0, 0},
		[2] = {5.0, 39, 45, 30, 30, 0},
		[3] = {5.0, 54, 55, 30, 0}
	}

local fastElementalCounter = 0
local fastElementalTimers = {88,95,20} -- No idea how it continues
local fastAddTimerMythic = {
		[1] = {8.0, 81.0, 0},
		[2] = {8.0, 51, 0},
		[3] = {8.0, 36, 45, 0}
	}

local ringCounter = 0
local savedRingCount = 0
local ringTimers = {40,10,63,10} -- No idea how it continues
local ringTimersMythic = {30, 39, 15, 31, 19, 10, 26, 9, 10}

local lookingForMsg = false
local orbMsg = ''
local orbCounter = 0

local singularityCount = 1
local savedSingularityCount = 0
local singularityScheduleTime = 0
local singularityTimers = {25, 36.0, 57.0, 65.0}
local singularityTimersMythic = {56.0, 50.0, 45.0, 0}

-- P2 stuff
local orbCount = 1
local savedOrbCount = 0
local orbTimers = {18, 76.0, 37.0, 70.0, 15.0, 15.0, 30.0, 15.0, 0}
local orbTimersMythic = {14, 85, 60, 20, 10, 0}

local beamCount = 1
local savedBeamCount = 0
local beamTimers = {59, 57.0, 60.0, 70.0}
local beamTimersMythic = {57.8, 50, 65, 0}

local ablatingCount = 1
local ablatingTimers = {15.8, 20.7, 20.6, 21.9, 20.7, 25.5, 20.6, 21.9}
local ablatingTimersMythic = {12.2, 20.6, 20.6, 20.6, 20.6, 20.7, 21.8, 20.6, 20.6, 20.7, 0}

-- Phase 3 Stuff
local tormentCount = 1
local tormentTimers = {23, 61.0, 37.0, 60.0}
local tormentTimersMythic = {63.7, 75, 25, 20, 0}

local conflexiveBurstCount = 1
local conflexiveBurstTimers = {48, 52.0, 56.0, 65.0, 10.0}
local conflexiveBurstTimersMythic = {38.7, 90, 45, 30, 0}
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.ring_msg = "Let the waves of time crash over you!"
	L.singularity_msg = "I control the battlefield, not you!"
	L.orb_msg = "You'll find time can be quite volatile."
	L.beam_msg = "The threads of time answer to me!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ General ]]--
		208887, -- Summon Time Elementals
		211616, -- Summon Time Elemental - Fast
		211614, -- Summon Time Elemental - Slow
		"stages",
		"berserk",

		--[[ Recursive Elemental ]]--
		221864, -- Blast
		209165, -- Slow Time

		--[[ Expedient Elemental ]]--
		209568, -- Exothermic Release
		209166, -- Fast Time

		--[[ Time Layer 1 ]]--
		208807, -- Arcanetic Ring
		209170, -- Spanning Singularity
		{209615, "TANK"}, -- Ablation

		--[[ Time Layer 2 ]]--
		{209244, "SAY", "FLASH"}, -- Delphuric Beam
		210022, -- Epocheric Orb
		{209973, "FLASH", "SAY"}, -- Ablating Explosion

		--[[ Time Layer 3 ]]--
		{211261, "SAY", "FLASH"}, -- Permeliative Torment
		{209597, "SAY", "FLASH"}, -- Conflexive Burst
		209971, -- Ablative Pulse
		{211887, "TANK"}, -- Ablated
	},{
		[208887] = "general",
		[221863] = -13226, -- Recursive Elemental
		[209568] = -13229, -- Expedient Elemental
		[208807] = -13222, -- Time Layer 1
		[209244] = -13235, -- Time Layer 2
		[211261] = -13232, -- Time Layer 3
	}
end

function mod:OnBossEnable()
	--[[ General ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "TimeStop", 208944) -- Phase triggering
	self:Log("SPELL_CAST_SUCCESS", "LeavetheNightwell", 208863) -- New phase starting
	self:RegisterEvent("RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	--[[ Recursive Elemental ]]--
	self:Log("SPELL_CAST_START", "Blast", 221864)
	self:Log("SPELL_AURA_APPLIED", "SlowTime", 209165)

	--[[ Expedient Elemental ]]--
	self:Log("SPELL_CAST_START", "ExothermicRelease", 209568)
	self:Log("SPELL_AURA_APPLIED", "FastTime", 209166)

	--[[ Time Layer 1 ]]--
	self:Log("SPELL_CAST_START", "ArcaneticRing", 208807)
	self:Log("SPELL_AURA_APPLIED", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_DAMAGE", "SingularityDamage", 209433)
	self:Log("SPELL_PERIODIC_MISSED", "SingularityDamage", 209433)
	self:Log("SPELL_AURA_APPLIED", "Ablation", 209615)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablation", 209615)

	--[[ Time Layer 2 ]]--
	self:Log("SPELL_AURA_APPLIED", "DelphuricBeam", 209244)
	self:Log("SPELL_CAST_START", "EpochericOrb", 210022)
	self:Log("SPELL_AURA_APPLIED", "AblatingExplosion", 209973)

	--[[ Time Layer 3 ]]--
	self:Log("SPELL_AURA_APPLIED", "PermeliativeTorment", 211261)
	self:Log("SPELL_CAST_START", "ConflexiveBurst", 209597)
	self:Log("SPELL_AURA_APPLIED", "ConflexiveBurstApplied", 209598)
	self:Log("SPELL_CAST_START", "AblativePulse", 209971)
	self:Log("SPELL_AURA_APPLIED", "Ablated", 211887)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Ablated", 211887)
end

function mod:OnEngage()
	phase = 0 -- Phase 1 starts upon first Leave the Nightwell cast
	fastElementalCounter = 0
	slowElementalCounter = 0
	lookingForMsg = false
	ringCounter = 0
	orbCounter = 0
	savedRingCount = 20
	savedsingularityCount = 20
	savedOrbCount = 20
	savedBeamCount = 20
	singularityCount = 1
	self:Bar(211614, 5) -- Summon Time Elemental - Slow
	self:Bar(211616, 8) -- Summon Time Elemental - Fast
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 211614 then -- Slow
		self:Message(spellId, "Neutral", "Info")
		slowElementalCounter = slowElementalCounter + 1
		self:Bar(spellId, slowElementalTimers[slowElementalCounter] or 60) -- Assuming timers cap at 60, which is probably wrong
	elseif spellId == 211616 then -- Fast
		self:Message(spellId, "Neutral", "Info")
		fastElementalCounter = fastElementalCounter + 1
		self:Bar(spellId, fastElementalTimers[fastElementalCounter] or 20) -- Assuming timers cap at 20, which is probably wrong
	elseif spellId == 209170 or spellId == 209171 then -- SpanningSingularity
		singularityCount=singularityCount+1	
		self:Message(209170, "Attention", "Info", self:SpellName(209170))
		self:Bar(209170,  self:Mythic() and singularityTimersMythic[singularityCount] or singularityTimers[singularityCount] or 0, CL.count:format(self:SpellName(209170), singularityCount))
	end
end

function mod:RAID_BOSS_EMOTE(event, msg, npcname)
	if msg:find("228877") then -- Arcanetic Rings
		ringCounter = ringCounter + 1
		self:Bar(208807, ringTimers[ringCounter] or (ringCounter%2==0 and 10 or 40))
		self:Message(208807, "Attention", "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg, npcname)
	if msg:find(L.ring_msg) then
		ringCount = ringCount+1
		self:Message(208807, "Urgent", "Alert")
		if ringCount < savedRingCount then
			self:Bar(208807, self:Mythic() and ringTimersMythic[ringCount] or ringTimers[ringCount] or 0, CL.count:format(self:SpellName(208807), ringCount))
		end
	elseif msg:find(L.orb_msg) then
		orbCount = orbCount+1
		self:Message(210022, "Urgent", "Alert", CL.casting:format(self:SpellName(210022)))
		if orbCount < savedOrbCount then
			self:Bar(210022, self:Mythic() and orbTimersMythic[orbCount] or orbTimers[orbCount] or 0, CL.count:format(self:SpellName(210022), orbCount))
		end
	elseif msg:find(L.beam_msg) then
		beamCount = beamCount+1
		self:Message(214278, "Urgent", "Alert", CL.casting:format(self:SpellName(214278)))
		if beamCount < savedBeamCount then
			self:Bar(214278, self:Mythic() and  beamTimersMythic[beamCount] or beamTimers[beamCount] or 60, CL.count:format(self:SpellName(214278), beamCount))
		end
	elseif msg:find(L.singularity_msg) and phase == 2 or phase == 3 then -- Mythic only, zones apears 2s after the message. 
		self:ScheduleTimer("Message", 2, 209170, "Attention", "Info", self:SpellName(209170))
	end
end

function mod:TimeStop(args)
	phase = phase + 1
	self:Message("stages", "Neutral", "Info", CL.stage:format(phase), false)
	-- Stop old bars
	self:StopBar(211614)
	self:StopBar(211616)
	self:StopBar(CL.count:format(self:SpellName(208807), ringCount)) -- Arcanetic Ring
	self:StopBar(CL.count:format(self:SpellName(210022), orbCount)) -- Epocheric Orb
	self:StopBar(CL.count:format(self:SpellName(214278), beamCount)) -- Delphuric Beam
	self:StopBar(CL.count:format(self:SpellName(209170), singularityCount)) -- Singularity
	self:StopBar(CL.count:format(self:SpellName(209973), ablatingCount)) -- Ablating
	self:StopBar("Berserk") -- Terminate
	
end

function mod:LeavetheNightwell(args)
	slowElementalCounter = 1
	fastElementalCounter = 1
	phase = phase+1
	fastBubbleCount = 0
	singularityScheduleTime = 0
	conflexiveBurstCount = 1
	
	if self:Mythic() then 
		self:Bar("berserk", phase == 3 and 194 or 199, "Berserk") -- Terminate
	end
	
	if phase == 2 then
		savedRingCount = ringCount
		savedSingularityCount = singularityCount
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
		singularityCount = 1
		
		beamCount = 1
		orbCount = 1
		ablatingCount = 1
		self:Bar(214278, self:Mythic() and beamTimersMythic[beamCount] or beamTimers[beamCount] or 0)
		self:Bar(210022, self:Mythic() and orbTimersMythic[orbCount] or orbTimers[orbCount] or 0)
		self:Bar(209973, self:Mythic() and ablatingTimersMythic[ablatingCount] or ablatingTimers[ablatingCount] or 0)
		if self:Mythic() then 
			for key, value in pairs(singularityTimersMythic) do
				if value == 0 then
					break
				end
				singularityScheduleTime = value + singularityScheduleTime
				singularityCount = singularityCount + 1
				if singularityCount < savedSingularityCount then
					self:ScheduleTimer("Bar", singularityScheduleTime, 209170, singularityTimersMythic[singularityCount], CL.count:format(self:SpellName(209170), singularityCount))	
				end 
			end
		else
			for key, value in pairs(singularityTimers) do
				singularityScheduleTime = value + singularityScheduleTime
				singularityCount = singularityCount + 1
				if singularityCount < savedSingularityCount then
					self:ScheduleTimer("Bar", singularityScheduleTime, 209170, self:Mythic() and singularityTimersMythic[singularityCount] or singularityTimers[singularityCount] or 0, CL.count:format(self:SpellName(209170), singularityCount))	
				else 
					break;
				end 
			end
		end
	end
	if phase == 3 then
		savedOrbCount = orbCount
		savedBeamCount = beamCount
		self:Message("stages", "Neutral", "Long", CL.stage:format(phase), false)
		
		beamCount = 1
		orbCount = 1
		ablatingCount = 1
		conflexiveBurstCount = 1
		singularityCount = 1
		
		self:Bar(214278, self:Mythic() and beamTimersMythic[beamCount] or beamTimers[beamCount] or 0, CL.count:format(self:SpellName(214278), beamCount))
		self:Bar(210022, self:Mythic() and orbTimersMythic[orbCount] or orbTimers[orbCount] or 0, CL.count:format(self:SpellName(210022), orbCount))
		self:Bar(210387, self:Mythic() and tormentTimersMythic[tormentCount] or tormentTimers[tormentCount] or 0)
		self:Bar(209597, self:Mythic() and conflexiveBurstTimersMythic[conflexiveBurstCount] or conflexiveBurstCount[conflexiveBurstCount] or 0, CL.count:format(self:SpellName(209597), conflexiveBurstCount))
		if self:Mythic() then 
			for key, value in pairs(singularityTimersMythic) do
				singularityScheduleTime = value + singularityScheduleTime
				singularityCount = singularityCount + 1
				if singularityCount < savedSingularityCount then
					self:ScheduleTimer("Bar", singularityScheduleTime, 209170, singularityTimersMythic[singularityCount], CL.count:format(self:SpellName(209170), singularityCount))	
				else
					break;
				end
			end
		else
			for key, value in pairs(singularityTimers) do
				singularityScheduleTime = value + singularityScheduleTime
				singularityCount = singularityCount + 1
				if singularityCount < savedSingularityCount then
					self:ScheduleTimer("Bar", singularityScheduleTime, 209170, self:Mythic() and singularityTimersMythic[singularityCount] or singularityTimers[singularityCount] or 0, CL.count:format(self:SpellName(209170), singularityCount))	
				else 
					break;
				end 
			end
		end
	end
	ringCount = 1
	
	singularityCount = 1
	self:Bar(208807, self:Mythic() and ringTimersMythic[ringCount] or ringTimers[ringCount] or 0, CL.count:format(self:SpellName(208807), ringCount)) -- Arcanetic Ring
	self:Bar(209170, self:Mythic() and singularityTimersMythic[singularityCount] or singularityTimers[singularityCount] or 0, CL.count:format(self:SpellName(209170), singularityCount)) -- Spanning Singularity
end

--[[ Recursive Elemental ]]--
function mod:Blast(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Important", "Alert")
	end
end

function mod:SlowTime(args)
	if self:Me(args.destGUID)then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Long")
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Expedient Elemental ]]--
function mod:ExothermicRelease(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:FastTime(args)
	if self:Me(args.destGUID)then
		self:Message(args.spellId, "Positive", "Long", CL.you:format(args.spellName))
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local t = expires - GetTime()
		self:TargetBar(args.spellId, t, args.destName)
	end
end

--[[ Time Layer 1 ]]--
do
	local prev = 0
	function mod:SingularityDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(209170, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:Ablation(args)
	local amount = args.amount or 1
	if amount % 2 == 1 or amount > 3 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 3 and "Warning")
	end
end

--[[ Time Layer 2 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:DelphuricBeam(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end

function mod:AblatingExplosion(args)
	ablatingCount = ablatingCount+1	
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
	self:TargetMessage(args.spellId, args.destName, "Attention", "Long")
	self:Bar(args.spellId, self:Mythic() and ablatingTimersMythic[ablatingCount] or ablatingTimers[ablatingCount] or 0, CL.count:format(self:SpellName(args.spellId), ablatingCount))

end

--[[ Time Layer 3 ]]--
do
	local playerList = mod:NewTargetList()
	function mod:PermeliativeTorment(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Alarm")
		end
	end
end

function mod:ConflexiveBurst(args)
	conflexiveBurstCount = conflexiveBurstCount+1
	self:Bar(209597, self:Mythic() and conflexiveBurstTimersMythic[conflexiveBurstCount] or conflexiveBurstTimers[conflexiveBurstCount] or 0, CL.count:format(self:SpellName(args.spellId), tormentCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:ConflexiveBurstApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(209597)
			self:Say(209597)
			-- Need to constantly update because of fast/slow time
			--local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			--local t = expires - GetTime()
			--self:TargetBar(209597, t, args.destName)
		end

		playerList[#playerList+1] = args.destName

		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 209597, playerList, "Important", "Alarm")
		end
	end
end

function mod:AblativePulse(args)
	self:Message(args.spellId, "Important", "Alert", CL.casting:format(args.spellName))
end

function mod:Ablated(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 4 and "Warning")
end
