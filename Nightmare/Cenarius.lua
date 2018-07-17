
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

local mod, CL = BigWigs:NewBoss("Cenarius", 1520, 1750)
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
local wispMarks = { [8] = true, [7] = true, [6] = true, [5] = true, [4] = true }
local wispMarked = {}
local nightmareStacks = {}
local mobTable = {
	[105468] = {}, -- Nightmare Ancient
	[105494] = {}, -- Rotten Drake
	[105495] = {}, -- Twisted Sister
}
local mobCount = {
	[105468] = 0, -- Nightmare Ancient
	[105494] = 0, -- Rotten Drake
	[105495] = 0, -- Twisted Sister
}
local drakeDeaths = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.forces = "Forces"
	L.bramblesSay = "Brambles near %s"

	L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

--------------------------------------------------------------------------------
-- Initialization
--

local wispMarker = mod:AddMarkerOption(false, "npc", 8, -13348, 8, 7, 6, 5, 4) -- Corrupted Wisp
function mod:GetOptions()
	return {
		--[[ Cenarius ]]--
		"stages",
		{210279, "INFOBOX"}, -- Creeping Nightmares
		{210290, "SAY", "FLASH"}, -- Nightmare Brambles
		212726, -- Forces of Nightmare
		210346, -- Dread Thorns
		-- P2
		214505, -- Entangling Nightmares
		214529, -- Spear of Nightmares
		{213162, "TANK"}, -- Nightmare Blast

		--[[ Malfurion Stormrage ]]--
		212681, -- Cleansed Ground

		--[[ Corrupted Wisp ]]--
		wispMarker,

		--[[ Nightmare Treant ]]--
		226821, -- Desiccating Stomp

		--[[ Rotten Drake ]]--
		{211192, "SAY"}, -- Rotten Breath
		"custom_off_multiple_breath_bar",

		--[[ Twisted Sister ]]--
		211368, -- Twisted Touch of Life
		{211471, "SAY", "FLASH", "PROXIMITY"}, -- Scorned Touch
		{211989, "SAY"}, -- Unbound Touch

		--[[ Mythic ]]--
		214876, -- Beasts of Nightmare
		214884, -- Corrupt Allies of Nature
	},{
		["stages"] = -13339, -- Cenarius
		[212681] = -13344, -- Malfurion Stormrage
		[wispMarker] = -13348, -- Corrupted Wisp
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
	self:Death("MobDeath", 105468, 105494, 105495) -- Nightmare Ancient, Rotten Drake, Twisted Sister
	self:Log("SPELL_AURA_APPLIED_DOSE", "CreepingNightmares", 210279)
	self:Log("SPELL_AURA_REMOVED", "CreepingNightmaresRemoved", 210279)
	self:Log("SPELL_AURA_APPLIED", "DreadThorns", 210346)
	self:Log("SPELL_AURA_REMOVED", "DreadThornsRemoved", 210346)

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
	self:Log("SPELL_CAST_START", "DesiccatingStomp", 226821, 211073) -- mythic, normal/heroic
	self:Log("SPELL_CAST_START", "NightmareBlast", 213162)

	--[[ Rotten Drake ]]--
	self:Log("SPELL_CAST_START", "RottenBreath", 211192)

	--[[ Twisted Sister ]]--
	self:Log("SPELL_CAST_START", "TwistedTouchOfLife", 211368)
	self:Log("SPELL_AURA_APPLIED", "TwistedTouchOfLifeApplied", 211368)
	self:Log("SPELL_AURA_APPLIED", "ScornedTouch", 211471)
	self:Log("SPELL_AURA_REMOVED", "ScornedTouchRemoved", 211471)
	self:Log("SPELL_AURA_APPLIED", "UnboundTouch", 211989)

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "CorruptAlliesOfNature", 214884)
end

function mod:OnEngage()
	forcesOfNightmareCount = 1
	phase = 1
	self:CDBar(212726, 10, CL.count:format(self:SpellName(212726), forcesOfNightmareCount)) -- Forces of Nightmare
	self:Bar(210290, 28) -- Nightmare Brambles
	if self:Mythic() then
		self:CDBar(213162, 30) -- Nightmare Blast
	end
	wipe(mobCollector)
	wipe(nightmareStacks)
	mobTable = {
		[105468] = {}, -- Nightmare Ancient
		[105494] = {}, -- Rotten Drake
		[105495] = {}, -- Twisted Sister
	}
	mobCount = {
		[105468] = 0, -- Nightmare Ancient
		[105494] = 0, -- Rotten Drake
		[105495] = 0, -- Twisted Sister
	}
	drakeDeaths = 0

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	wipe(wispMarked)
	wispMarks = { [8] = true, [7] = true, [6] = true, [5] = true, [4] = true }
	self:OpenInfo(210279, self:SpellName(210279)) -- Creeping Nightmares
end

function mod:OnBossDisable()
	wipe(wispMarked)
	wipe(mobCollector)
end

--------------------------------------------------------------------------------
-- Local Functions
--

local function getMobNumber(mobId, guid)
	if mobTable[mobId][guid] then return mobTable[mobId][guid] end
	mobCount[mobId] = mobCount[mobId] + 1
	mobTable[mobId][guid] = mobCount[mobId]
	return mobCount[mobId]
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MobDeath(args)
	local mobId = self:MobId(args.destGUID)
	local mobText = getMobNumber(mobId, args.destGUID)
	if mobId == 105468 then -- Nightmare Ancient
		self:StopBar(CL.count:format(self:SpellName(226821), mobText)) -- Desiccating Stomp
	elseif mobId == 105494 then  -- Rotten Drake
		self:StopBar(CL.count:format(self:SpellName(211192), mobText)) -- Rotten Breath
		self:StopBar(CL.cast:format(CL.count:format(self:SpellName(211192), mobText))) -- <Cast: Rotten Breath>
		drakeDeaths = drakeDeaths + 1
		self:UnregisterUnitEvent("UNIT_TARGET", mobCollector[args.destGUID])
	elseif mobId == 105495 then -- Twisted Sister
		self:StopBar(CL.count:format(self:SpellName(211471), mobText)) -- Scorned Touch
		self:StopBar(CL.count:format(self:SpellName(211368), mobText)) -- Twisted Touch of Life
	end
end

function mod:WispMark(event, unit, guid)
	if self:MobId(guid) == 106659 and UnitIsEnemy("player", unit) and not wispMarked[guid] then
		local icon = next(wispMarks)
		if icon then -- At least one icon unused
			SetRaidTarget(unit, icon)
			wispMarks[icon] = nil -- Mark is no longer available
			wispMarked[guid] = icon -- Save the wisp we marked and the icon we marked it with
		end
	end
end

function mod:WispDeath(args)
	if wispMarked[args.destGUID] then -- Did we mark the wisp?
		wispMarks[wispMarked[args.destGUID]] = true -- Mark used is available again
	end
end

--[[ Cenarius ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 210290 then -- Nightmare Brambles
		self:Bar(spellId, phase == 2 and 20 or 30) -- at some point starts casting with 15sec-20sec cd
		local targetGUID = UnitGUID("boss1target") -- selects target 2sec prior to the cast
		if targetGUID then
			if self:Me(targetGUID) then
				self:Flash(spellId)
				self:Say(spellId, L.bramblesSay:format(self:UnitName("player")), true)
				self:Message(spellId, "Urgent", "Alarm", CL.near:format(self:SpellName(spellId)))
			else
				self:Message(spellId, "Urgent", "Alarm")
			end
		end
	elseif spellId == 217368 then -- Phase 2
		phase = 2
		self:StopBar(213162) -- Nightmare Blast
		self:StopBar(CL.count:format(self:SpellName(212726), forcesOfNightmareCount)) -- Forces of Nightmare
		self:StopBar(210346) -- Dread Thorns
		self:Bar(210290, 13) -- Nightmare Brambles
		self:Bar(214529, 23) -- Spear Of Nightmares
		self:Bar(214505, 35) -- Entangling Nightmares
		self:Message("stages", "Neutral", "Long", CL.stage:format(2), false)
	elseif spellId == 214876 then -- Beasts of Nightmare
		self:Message(spellId, "Important", "Alert", CL.incoming:format(self:SpellName(spellId)))
		self:Bar(spellId, 30.3)
	end
end

do
	local prev = 0
	function mod:CreepingNightmares(args)
		nightmareStacks[args.destName] = args.amount
		if self:Me(args.destGUID) then
			local amount = args.amount or 1
			if amount > 15 and amount % 4 == 0 then
				self:StackMessage(args.spellId, args.destName, amount, "Urgent", "Warning")
			end
		end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:SetInfoByTable(args.spellId, nightmareStacks)
		end
	end
end

function mod:CreepingNightmaresRemoved(args)
	nightmareStacks[args.destName] = nil
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Info", CL.removed:format(args.spellName))
	end
end

function mod:NightmareBlast(args)
	self:Message(args.spellId, "Urgent", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 32)
end

function mod:ForcesOfNightmare(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	forcesOfNightmareCount = forcesOfNightmareCount + 1
	self:Bar(210346, 6) -- Dread Thorns
	self:Bar(212681, 11) -- Cleansed Ground
	self:Bar(args.spellId, 77.7, CL.count:format(args.spellName, forcesOfNightmareCount))

	if self:GetOption(wispMarker) then
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
			local unit = ("boss%d"):format(i)
			local guid = UnitGUID(unit)
			if guid and not mobCollector[guid] and UnitIsEnemy("player", unit) then
				mobCollector[guid] = true
				local mobId = self:MobId(guid)
				local id = adds[mobId]
				if id then
					self:Message(212726, "Neutral", "Info", CL.count:format(self:SpellName(id), getMobNumber(mobId, guid)), false)
				end
				if mobId == 105468 then -- Nightmare Ancient
					self:Bar(226821, 20, CL.count:format(self:SpellName(226821), getMobNumber(mobId, guid))) -- Desiccating Stomp
				elseif mobId == 105494 then -- Rotten Drake
					mobCollector[guid] = unit
					if self:GetOption("custom_off_multiple_breath_bar") or (mobCount[105494]-drakeDeaths == 1) or (drakeDeaths+1 == getMobNumber(105494, guid)) then
						self:Bar(211192, 20, CL.count:format(self:SpellName(211192), getMobNumber(mobId, guid))) -- Rotten Breath
					end
					self:ScheduleTimer("RegisterUnitEvent", 15, "UNIT_TARGET", "BreathTarget", unit)
				elseif mobId == 105495 then -- Twisted Sister
					self:CDBar(211471, 5, CL.count:format(self:SpellName(211471), getMobNumber(mobId, guid))) -- Scorned Touch
					self:CDBar(211368, 6, CL.count:format(self:SpellName(211368), getMobNumber(mobId, guid))) -- Twisted Touch of Life
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
	if phase == 1 then
		self:CDBar(args.spellId, 32.7)
	end
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
		if self:UnitDebuff("player", spellName) then
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

--[[ Nightmare Treant ]]--
do
	local prev = 0
	function mod:DesiccatingStomp(args)
		self:StopBar(CL.count:format(args.spellName, getMobNumber(105468, args.sourceGUID))) -- Desiccating Stomp
		self:Message(226821, "Urgent", "Long", CL.casting:format(args.spellName))
		local t = GetTime()
		if t-prev > 4 then
			prev = t
			local spellText = CL.count:format(args.spellName, getMobNumber(105468, args.sourceGUID))
			self:CastBar(226821, self:Mythic() and 6.1 or 3, spellText)
			self:ScheduleTimer("Bar", 6.1, 226821, 27, spellText)
		end
	end
end

--[[ Rotten Drake ]]--
function mod:RottenBreath(args)
	if self:GetOption("custom_off_multiple_breath_bar") or (mobCount[105494]-drakeDeaths == 1) or (drakeDeaths+1 == getMobNumber(105494, args.sourceGUID)) then
		local spellText = CL.count:format(args.spellName, getMobNumber(105494, args.sourceGUID))
		self:CastBar(args.spellId, 5.5, spellText)
		self:CDBar(args.spellId, 25, spellText)
	end
end

function mod:BreathTarget(event, unit) -- They love to drop their target after casting
	local target = unit.."target"
	local guid = UnitGUID(target)
	if not guid or UnitDetailedThreatSituation(target, unit) ~= false or self:MobId(guid) ~= 1 then return end

	if self:Me(guid) then
		self:Say(211192)
	end
	self:TargetMessage(211192, self:UnitName(target), "Attention", "Alert", nil, nil, true)
end

--[[ Twisted Sister ]]--
function mod:TwistedTouchOfLife(args)
	local spellText = CL.count:format(args.spellName, getMobNumber(105495, args.sourceGUID))
	self:Message(args.spellId, "Important", self:Interrupter() and "Alarm", CL.casting:format(spellText))
	self:Bar(args.spellId, self:Mythic() and 11 or 15.5, spellText)
end

function mod:TwistedTouchOfLifeApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", nil, nil, self:Dispeller("magic", true, args.spellId))
end

do
	local proxList, isOnMe, scheduled = {}, nil, nil
	local prev = 0

	local function warn(self, spellId, spellName, guid)
		if not isOnMe then
			self:Message(spellId, "Important", "Alert", CL.count:format(spellName, getMobNumber(105495, guid)))
		end
		scheduled = nil
	end

	function mod:ScornedTouch(args)
		if self:Me(args.destGUID) then
			self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
			isOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
			local _, _, _, expires = self:UnitDebuff("player", args.spellName)
			local t = expires - GetTime()
			self:TargetBar(args.spellId, t, args.destName)
			self:OpenProximity(args.spellId, 8)
		end

		proxList[#proxList+1] = args.destName
		if not isOnMe then
			self:OpenProximity(args.spellId, 8, proxList)
		end

		local t = GetTime()
		if t-prev > 19 and (not scheduled) then -- prevent debuff spread to reset timer
			prev = t
			scheduled = self:ScheduleTimer(warn, 0.1, self, args.spellId, args.spellName, args.sourceGUID)
			self:Bar(args.spellId, 20.6, CL.count:format(args.spellName, getMobNumber(105495, args.sourceGUID)))
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

function mod:UnboundTouch(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alert")
		self:Say(args.spellId)
	end
end
