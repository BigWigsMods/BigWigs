
--------------------------------------------------------------------------------
-- TODO List:
-- - WaveSpawn got broken, figure out a new way to do this
--     Wave 1:	Wisp, Drake, Treant
--     Wave 2:	Wisp, Drake, Sister
--     Wave 3:	2x Sister, Treant
--     Wave 4:	2x Drake, Wisp
--     Wave 5:	2x Treant, Sister
--     Wave 6:	2x Wisp, Sister

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cenarius", 1094, 1750)
if not mod then return end
mod:RegisterEnableMob(104636)
mod.engageId = 1877
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local forcesOfNightmareCount = 1
local phase = 1
local whispMarks = { [8] = true, [7] = true, [6] = true, [5] = true, [4] = true }
local whispMarked = {}
local stompCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.forces = "Forces"
	L.bramblesSay = "Brambles near %s"

	L.custom_off_wisp_marker = "Corrupted Wisp marker"
	L.custom_off_wisp_marker_desc = "Mark Corrupted Wisps with {rt8}{rt7}{rt6}{rt5}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, having nameplates enabled or quickly mousing over the wisps is the fastest way to mark them.|r"
	L.custom_off_wisp_marker_icon = 8
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Cenarius ]]--
		"stages",
		210279, -- Creeping Nightmares
		{210290, "SAY", "FLASH"}, -- Nightmare Brambles
		212726, -- Forces of Nightmare
		210346, -- Dread Thorns
		214884, -- Corrupt Allies of Nature
		-- P2
		214505, -- Entangling Nightmares
		214529, -- Spear of Nightmares
		{213162, "TANK"}, -- Nightmare Blast

		--[[ Malfurion Stormrage ]]--
		212681, -- Cleansed Ground

		--[[ Corrupted Wisp ]]--
		"custom_off_wisp_marker",

		--[[ Nightmare Treant ]]--
		226821, -- Desiccating Stomp

		--[[ Rotten Drake ]]--
		211192, -- Rotten Breath

		--[[ Twisted Sister ]]--
		211368, -- Twisted Touch of Life
		{211471, "SAY", "FLASH", "PROXIMITY"}, -- Scorned Touch

		--[[ Mythic ]]--
		214876, -- Beasts of Nightmare
	},{
		["stages"] = -13339, -- Cenarius
		[212681] = -13344, -- Malfurion Stormrage
		["custom_off_wisp_marker"] = -13348, -- Corrupted Wisp
		[226821] = -13350, -- Nightmare Treant
		[211192] = -13354, -- Rotten Drake
		[211368] = -13357, -- Twisted Sister
		[214876] = "mythic",
	}
end

function mod:OnBossEnable()
	--[[ Cenarius ]]--
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_CAST_START", "ForcesOfNightmare", 212726)
	self:Log("SPELL_AURA_APPLIED", "CreepingNightmares", 210279)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CreepingNightmares", 210279)
	self:Log("SPELL_AURA_REMOVED", "CreepingNightmaresRemoved", 210279)
	self:Log("SPELL_AURA_APPLIED", "DreadThorns", 210346)
	self:Log("SPELL_AURA_REMOVED", "DreadThornsRemoved", 210346)
	self:Log("SPELL_AURA_APPLIED", "CorruptAlliesOfNature", 214884)

	self:Log("SPELL_AURA_APPLIED", "EntanglingNightmares", 214505)
	self:Log("SPELL_CAST_START", "SpearOfNightmaresCast", 214529)
	self:Log("SPELL_AURA_APPLIED", "SpearOfNightmares", 214529)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SpearOfNightmares", 214529)

	--[[ Malfurion Stormrage ]]--
	self:Log("SPELL_AURA_APPLIED", "CleansedGround", 212681)
	self:Log("SPELL_AURA_REMOVED", "CleansedGroundRemoved", 212681)

	--[[ Corrupted Wisp ]]--
	self:Death("WispDeath", 106659)

	--[[ Nightmare Treant ]]--
	self:Log("SPELL_CAST_START", "DesiccatingStomp", 226821)
	self:Log("SPELL_CAST_SUCCESS", "DesiccatingStompSuccess", 226821)
	self:Log("SPELL_CAST_START", "NightmareBlast", 213162)

	--[[ Rotten Drake ]]--
	self:Log("SPELL_CAST_START", "RottenBreath", 211192)

	--[[ Twisted Sister ]]--
	self:Log("SPELL_CAST_START", "TwistedTouchOfLife", 211368)
	self:Log("SPELL_AURA_APPLIED", "TwistedTouchOfLifeApplied", 211368)
	self:Log("SPELL_AURA_APPLIED", "ScornedTouch", 211471)
	self:Log("SPELL_AURA_REMOVED", "ScornedTouchRemoved", 211471)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_SUCCESS", "BeastsOfNightmare", 214876) -- untested
end

function mod:OnEngage()
	forcesOfNightmareCount = 1
	stompCount = 1
	phase = 1
	self:CDBar(212726, 10, CL.count:format(self:SpellName(212726), forcesOfNightmareCount)) -- Forces of Nightmare
	self:Bar(210290, 28) -- Nightmare Brambles
	self:CDBar(213162, 30) -- Nightmare Blast
	wipe(mobCollector)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	wipe(whispMarked)
	whispMarks = { [8] = true, [7] = true, [6] = true, [5] = true, [4] = true }
end

function mod:OnBossDisable()
	wipe(whispMarked)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:WispMark(event, unit)
	local guid = UnitGUID(unit)
	if self:MobId(guid) == 106659 and UnitIsEnemy("player", unit) and not whispMarked[guid] then
		local icon = next(whispMarks)
		if icon then -- At least one icon unused
			SetRaidTarget(unit, icon)
			whispMarks[icon] = nil -- Mark is no longer available
			whispMarked[guid] = icon -- Save the tentacle we marked and the icon we marked it with
		end
	end
end

function mod:WispDeath(args)
	if whispMarked[args.destGUID] then -- Did we mark the Tentacle?
		whispMarks[whispMarked[args.destGUID]] = true -- Mark used is available again
	end
end

--[[ Cenarius ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 210290 then -- Nightmare Brambles
		self:Bar(spellId, phase == 2 and 20 or 30) -- at some point starts casting with 15sec-20sec cd
		local targetGUID = UnitGUID("boss1target") -- selects target 2sec prior to the cast
		if targetGUID then
			if self:Me(targetGUID) then
				self:Flash(spellId)
				self:Say(spellId, L.bramblesSay:format(self:UnitName("player")), true)
				self:RangeMessage(spellId, "Urgent", "Alarm")
			else
				self:Message(spellId, "Urgent", "Alarm")
			end
		end
	elseif spellId == 217368 then -- Phase 2
		phase = 2
		self:StopBar(213162)
		self:Bar(210290, 13) -- Nightmare Brambles
		self:Bar(214529, 23) -- Spear Of Nightmares
		self:Bar(214505, 35) -- Entangling Nightmares
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
	end
end

function mod:CreepingNightmares(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount > 15 and amount % 4 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
		end
	end
end

function mod:NightmareBlast(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 32)
end

function mod:CreepingNightmaresRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
	end
end

function mod:ForcesOfNightmare(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	forcesOfNightmareCount = forcesOfNightmareCount + 1
	self:Bar(210346, 6) -- Dread Thorns
	self:Bar(212681, 11) -- Cleansed Ground
	self:Bar(args.spellId, 77.7, CL.count:format(args.spellName, forcesOfNightmareCount))

	if self:GetOption("custom_off_wisp_marker") then
		self:RegisterTargetEvents("WispMark")
		self:ScheduleTimer("UnregisterTargetEvents", 10)
	end
end

do
	local adds = {
		[106304] = -13348, -- Corrupted Wisp
		[105468] = -13350, -- Nightmare Treant
		[105494] = -13354, -- Rotten Drake
		[105495] = -13357, -- Twisted Sister
	}
	function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		for i = 1, 5 do
			local guid = UnitGUID("boss"..i)
			if guid and not mobCollector[guid] then
				mobCollector[guid] = true
				local mobId = self:MobId(guid)
				local id = adds[mobId]
				if id then
					self:Message(212726, "Neutral", "Info", id, false)
				end
				if mobId == 105468 then -- Nightmare Ancient
					stompCount = 1
					self:Bar(226821, 20) -- Desiccating Stomp
				elseif mobId == 105495 then -- Twisted Sister
					self:Bar(211471, 6) -- Scorned Touch
					self:Bar(211368, 7) -- Twisted Touch of Life
				end
			end
		end
	end
end

function mod:DreadThorns(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:Bar(args.spellId, 45, CL.on:format(args.spellName, args.destName))
end

function mod:DreadThornsRemoved(args)
	self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
	self:CDBar(args.spellId, 32.7)
end

function mod:EntanglingNightmares(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:CDBar(args.spellId, 51)
end

-- untested
local prev = 0
function mod:CorruptAlliesOfNature(args)
	local t = GetTime()
	if t-prev > 10 then
		prev = t
		self:Message(args.spellId, "Attention", "Info", CL.other:format(args.spellName, args.destName))
	end
end

function mod:SpearOfNightmaresCast(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
end

function mod:SpearOfNightmares(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Urgent", self:Tank() and "Warning")
	self:Bar(args.spellId, 15.7)
end

--[[ Malfurion Stormrage ]]--
do
	local cleansedGroundCheck = nil

	local function checkForCleansedGround(self, spellId, spellName)
		if UnitDebuff("player", spellName) then
			self:Message(spellId, "Positive", "Alert", CL.underyou:format(spellName))
			cleansedGroundCheck = self:ScheduleTimer(checkForCleansedGround, 1, self, spellId, spellName)
		end
	end

	function mod:CleansedGround(args)
		if self:Me(args.destGUID) then
			if cleansedGroundCheck then self:CancelTimer(cleansedGroundCheck) end
			cleansedGroundCheck = self:ScheduleTimer(checkForCleansedGround, 1, self, args.spellId, args.spellName) -- you shouldn't stand in there for too long
		end
	end

	function mod:CleansedGroundRemoved(args)
		if cleansedGroundCheck and self:Me(args.destGUID) then
			self:CancelTimer(cleansedGroundCheck)
			cleansedGroundCheck = nil
		end
	end
end

--[[ Corrupted Wisp ]]--
-- give fixate debuff pls blizzard

--[[ Nightmare Treant ]]--
function mod:DesiccatingStomp(args)
	self:Message(args.spellId, "Urgent", "Long", CL.casting:format(CL.count:format(args.spellName, stompCount)))
	stompCount = stompCount + 1
end

function mod:DesiccatingStompSuccess(args)
	self:CDBar(args.spellId, stompCount % 2 == 0 and 3 or 27)
end

--[[ Rotten Drake ]]--
function mod:RottenBreath(args)
	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 5.5, CL.cast:format(args.spellName))
	self:CDBar(args.spellId, 25)
end

--[[ Twisted Sister ]]--
function mod:TwistedTouchOfLife(args)
	self:Message(args.spellId, "Important", self:Interrupter() and "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 11)
end

function mod:TwistedTouchOfLifeApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, self:Dispeller("magic", true, args.spellId))
end

do
	local proxList, isOnMe, scheduled = {}, nil, nil

	local function warn(self, spellId)
		if not isOnMe then
			self:Message(spellId, "Important", "Alert")
		end
		scheduled = nil
	end

	function mod:ScornedTouch(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
			self:OpenProximity(args.spellId, 8)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 8, proxList)
		end

		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId)
		end
	end

	function mod:ScornedTouchRemoved(args)
		if self:Me(args.destGUID) then
			isOnMe = nil
			self:StopBar(args.spellName, args.destName)
			self:CloseProximity(args.spellId)
		end

		tDeleteItem(proxList, args.destName)
		if not isOnMe then -- Don't change proximity if it's on you and expired on someone else
			if #proxList == 0 then
				self:CloseProximity(args.spellId)
			else
				self:OpenProximity(args.spellId, 8, proxList)
			end
		end
	end
end

--[[ Mythic ]]--
function mod:BeastsOfNightmare(args)
	self:Message(args.spellId, "Important", "Alert")
end
