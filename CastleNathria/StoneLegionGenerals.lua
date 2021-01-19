--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stone Legion Generals", 2296, 2425)
if not mod then return end
mod:RegisterEnableMob(
	168112, -- General Kaal
	168113) -- General Grashaal
mod.engageId = 2417
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local intermission = false
local wickedBladeCount = 1
local heartRendCount = 1
local serratedSwipeCount = 1
local crystalizeCount = 1
local pulverizingMeteorCount = 1
local reverberatingLeapCount = 1
local seismicUphealvalCount = 1
local shadowForcesCount = 1

local mobCollector = {}
local mobCollectorGoliath = {}
local skirmisherCount = 0
local skirmisherTracker = {}
local commandoesKilled = 0
local commandoesNeeded = 7
local commandoAddMarks = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.first_blade = "First Blade" -- Wicked Blade
	L.second_blade = "Second Blade"

	L.skirmishers = "Skirmishers" -- Short for Stone Legion Skirmishers

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Just for testing right now"
end

--------------------------------------------------------------------------------
-- Initialization
--

local wickedBladeMarker = mod:AddMarkerOption(false, "player", 2, 333387, 2, 3) -- Wicked Blade
local heartRendMarker = mod:AddMarkerOption(false, "player", 1, 334765, 1, 2, 3, 4) -- Heart Rend
local crystalizeMarker = mod:AddMarkerOption(false, "player", 1, 339690, 1) -- Crystalize
local skirmisherMarker = mod:AddMarkerOption(false, "npc", 8, -22761, 8, 7, 6) -- Stone Legion Skirmisher
local commandoMarker = mod:AddMarkerOption(false, "npc", 8, -22772, 8, 7, 6, 5) -- Stone Legion Commando
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		"custom_on_stop_timers",
			--[[ Stage One: Kaal's Assault ]]--
		329636, -- Hardened Stone Form
		{333387, "SAY"}, -- Wicked Blade
		wickedBladeMarker,
		334765, -- Heart Rend
		heartRendMarker,
		{334929, "TANK"}, -- Serrated Swipe
		{339690, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Crystalize
		crystalizeMarker,
		{342544, "SAY"}, -- Pulverizing Meteor
		343063, -- Stone Spike
		{342733, "FLASH"}, -- Ravenous Feast
		342985, -- Stonegale Effigy

		--[[ Intermission ]]--
		332406, -- Anima Infusion
		339885, -- Anima Infection
		342722, -- Stonewrath Exhaust
		332683, -- Shattering Blast

		--[[ Stage Two: Grashaal's Blitz ]]--
		329808, -- Hardened Stone Form
		{342425, "TANK"}, -- Stone Fist
		{344496, "SAY", "ME_ONLY_EMPHASIZE"}, -- Reverberating Eruption
		334498, -- Seismic Upheaval

		--[[ Mythic ]]--
		342256, -- Call Shadow Forces
		skirmisherMarker,
		342655, -- Volatile Anima Infusion
		340037, -- Volatile Stone Shell
		342698, -- Volatile Anima Injection
		commandoMarker,
	}, {
		["stages"] = "general",
		[329636] = -22681, -- Stage One: Kaal's Assault
		[332406] = "intermission",
		[329808] = -22718, -- Stage Two: Grashaal's Blitz
		[342256] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")

	--[[ Stage One: Kaal's Assault ]]--
	self:Log("SPELL_AURA_APPLIED", "HardenedStoneFormApplied", 329636)
	self:Log("SPELL_AURA_REMOVED", "HardenedStoneFormRemoved", 329636)
	self:Log("SPELL_CAST_START", "WickedBlade", 344230, 333387) -- Normal, Heroic
	self:Log("SPELL_AURA_APPLIED", "WickedBladeApplied", 333377) -- Wicked Mark
	self:Log("SPELL_AURA_REMOVED", "WickedBladeRemoved", 333377)
	self:Log("SPELL_CAST_START", "HeartRend", 334765)
	self:Log("SPELL_AURA_APPLIED", "HeartRendApplied", 334765)
	self:Log("SPELL_AURA_REMOVED", "HeartRendRemoved", 334765)
	self:Log("SPELL_CAST_START", "SerratedSwipe", 334929)
	self:Log("SPELL_CAST_SUCCESS", "SerratedSwipeSuccess", 334929)
	self:Log("SPELL_CAST_SUCCESS", "Crystalize", 339690)
	self:Log("SPELL_AURA_APPLIED", "CrystalizeApplied", 339690)
	self:Log("SPELL_AURA_REMOVED", "CrystalizeRemoved", 339690)
	self:Log("SPELL_CAST_START", "PulverizingMeteor", 342544)
	self:Log("SPELL_AURA_APPLIED", "StoneSpikeApplied", 343063)
	self:Log("SPELL_AURA_APPLIED", "AnimaApplied", 332406, 339885) -- Anima Infusion, Anima Infection
	self:Log("SPELL_CAST_START", "StonewrathExhaust", 342722)
	self:Log("SPELL_CAST_START", "ShatteringBlast", 332683)
	self:Log("SPELL_CAST_SUCCESS", "RavenousFeast", 342732) -- Faster than 342733
	self:Log("SPELL_AURA_APPLIED", "StonegaleEffigy", 343898)

	--[[ Stage Two: Grashaal's Blitz ]]--
	self:Log("SPELL_AURA_APPLIED", "GraniteFormApplied", 329808)
	self:Log("SPELL_AURA_REMOVED", "GraniteFormRemoved", 329808)
	self:Log("SPELL_CAST_START", "StoneFist", 342425)
	self:Log("SPELL_AURA_APPLIED", "StoneFistApplied", 342425)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StoneFistApplied", 342425)
	self:Log("SPELL_CAST_START", "ReverberatingEruption", 344496)
	self:Log("SPELL_CAST_START", "SeismicUpheaval", 334498)

	--[[ Mythic ]]--
	self:Log("SPELL_CAST_START", "CallShadowForces", 342256)
	self:Log("SPELL_SUMMON", "SummonSkirmisher", 342259, 342257, 342258)
	self:Log("SPELL_AURA_APPLIED", "VolatileAnimaAppliedInfusion", 342655)
	self:Log("SPELL_AURA_APPLIED", "VolatileAnimaAppliedInfection", 342698)
	self:Log("SPELL_AURA_APPLIED", "VolatileStoneShell", 340037)
	self:Death("CommandoDeath", 169601) -- Stone Legion Commando
end

function mod:OnEngage()
	stage = 1
	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	crystalizeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1
	shadowForcesCount = 1
	intermission = false

	self:Bar(334929, 8.3, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	self:Bar(333387, 19, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:Bar(334765, self:Mythic() and 35.8 or 28.8, CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:Bar(339690, self:Mythic() and 32.5 or 25, CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize

	if self:Mythic() then
		self:Bar(342256, 10.7, CL.count:format(L.skirmishers, shadowForcesCount)) -- Call Shadow Forces
		self:Berserk(720)
	end

	-- Marking stuff
	mobCollector = {}
	skirmisherCount = 0
	skirmisherTracker = {}
	commandoesKilled = 0
	commandoesNeeded = 7
	commandoAddMarks = {}

	if self:GetOption(skirmisherMarker) or self:GetOption(commandoMarker) then
		self:RegisterTargetEvents("AddMarkTracker")
	end

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unit = ("boss%d"):format(i)
		local guid = self:UnitGUID(unit)
		if guid and not mobCollectorGoliath[guid] then
			mobCollectorGoliath[guid] = true
			local id = self:MobId(guid)
			if id == 172858 then -- Stone Legion Goliath
				self:Message("stages", "cyan", CL.spawned:format(self:UnitName(unit)), false)
				self:Bar(342733, 18) -- Ravenous Feast
			end
		end
	end
end

do
	local abilitysToPause = {
		[333387] = true, -- Wicked Blade
		[334765] = true, -- Heart Rend
		[339690] = true, -- Crystallize
		[344496] = true, -- Reverberating Eruption
		[334498] = true, -- Seismic Upheaval

	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

do
	local throttle = false
	local function Message()
		throttle = false
		mod:Message("stages", "cyan", CL.mob_killed:format(mod:SpellName(-22791), commandoesKilled, commandoesNeeded), false) -- Stone Legion Commando
	end
	function mod:CommandoDeath(args)
		if intermission then
			commandoesKilled = commandoesKilled + 1
			if not throttle then
				throttle = true
				self:SimpleTimer(Message, 1.5)
			end
		end
		if self:GetOption(commandoMarker) then
			for i = 8, 5, -1 do -- 8, 7, 6, 5
				if commandoAddMarks[i] == args.destGUID then
					commandoAddMarks[i] = nil
					return
				end
			end
		end
	end
end

function mod:SummonSkirmisher(args)
	skirmisherCount = skirmisherCount + 1
	local icon = 9-skirmisherCount
	skirmisherTracker[args.destGUID] =  icon
end

function mod:AddMarkTracker(event, unit, guid)
	if guid and not mobCollector[guid] then
		local mobId = self:MobId(guid)
		if self:GetOption(skirmisherMarker) and skirmisherTracker[guid] then --  Stone Legion Skirmisher
			self:CustomIcon(skirmisherMarker, unit, skirmisherTracker[guid])
			mobCollector[guid] = true
		elseif self:GetOption(commandoMarker) and mobId == 169601 then -- Stone Legion Commando
			if self:GetHealth(unit) < 75 then -- They are 72% when they are on the floor, 100% when flying around
				for i = 8, 5, -1 do -- 8, 7, 6, 5
					if not commandoAddMarks[i] then
						mobCollector[guid] = true
						commandoAddMarks[i] = guid
						self:CustomIcon(commandoMarker, unit, i)
						return
					end
				end
			end
		end
	end
end

--[[ Stage One: Kaal's Assault ]]--
function mod:HardenedStoneFormApplied(args)
	self:Message(args.spellId, "green", CL.intermission)
	self:PlaySound(args.spellId, "long")

	intermission = true
	commandoAddMarks = {}
	commandoesKilled = 0

	self:StopBar(CL.count:format(self:SpellName(342256), shadowForcesCount)) -- Call Shadow Forces
	shadowForcesCount = 1
end

function mod:HardenedStoneFormRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:StopBar(CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe

	stage = 2
	self:Message(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	heartRendCount = 1
	serratedSwipeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1

	self:Bar(342425, 14.2) -- Stone Fist
	self:Bar(344496, 10, CL.count:format(self:SpellName(344496), reverberatingLeapCount)) -- Reverberating Eruption
	self:Bar(334498, 17, CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval
end

do
	local playerList, onMe, firstGUID = {}, false, nil
	local function printTarget(self, target, guid)
		if #playerList ~= 0 then -- Compensate for sometimes taking a very long time (0.5s+) to pick a target by using this fallback
			if not self:Me(guid) and onMe then
				self:Say(333387, L.second_blade)
				self:PlaySound(333387, "warning")
			end
			if self:GetOption(wickedBladeMarker) then
				for i = 1, #playerList do
					local name = playerList[i]
					self:CustomIcon(wickedBladeMarker, name, name == target and 2 or 3)
				end
			end
		else
			firstGUID = guid
			playerList[1] = target
		end

		if self:Me(guid) then
			self:Say(333387, L.first_blade)
			self:PlaySound(333387, "warning")
		end
	end

	function mod:WickedBlade(args)
		playerList = {}
		firstGUID = nil
		self:StopBar(CL.count:format(args.spellName, wickedBladeCount))
		self:GetNextBossTarget(printTarget, args.sourceGUID, 1)
		wickedBladeCount = wickedBladeCount + 1
		self:Bar(333387, 30.5, CL.count:format(args.spellName, wickedBladeCount))
	end

	function mod:WickedBladeApplied(args)
		if not firstGUID then -- Compensate for sometimes taking a very long time (0.5s+) to pick a target by using this fallback
			playerList[#playerList+1] = args.destName
			if self:Me(args.destGUID) then
				onMe = true
				self:Say(333387)
				self:PlaySound(333387, "warning")
			end
			if #playerList == 2 then
				--if self:GetOption(wickedBladeMarker) then -- Are potentially wrong marks better than potentially no marks?
				--	self:CustomIcon(wickedBladeMarker, playerList[1], 2)
				--	self:CustomIcon(wickedBladeMarker, playerList[2], 3)
				--end
				self:TargetsMessage(333387, "orange", self:ColorName(playerList), 2, CL.count:format(self:SpellName(333387), wickedBladeCount-1))
			end
		elseif firstGUID and firstGUID ~= args.destGUID then
			if self:Me(args.destGUID) then
				self:Say(333387, L.second_blade)
				self:PlaySound(333387, "warning")
			end
			playerList[2] = args.destName
			self:CustomIcon(wickedBladeMarker, playerList[1], 2)
			self:CustomIcon(wickedBladeMarker, playerList[2], 3)
			self:TargetsMessage(333387, "orange", self:ColorName(playerList), 2, CL.count:format(self:SpellName(333387), wickedBladeCount-1))
		end
	end

	function mod:WickedBladeRemoved(args)
		if self:Me(args.destGUID) then
			onMe = false
		end
		self:CustomIcon(wickedBladeMarker, args.destName)
	end
end

function mod:HeartRend(args)
	self:StopBar(CL.count:format(args.spellName, heartRendCount))
	heartRendCount = heartRendCount + 1
	self:Bar(args.spellId, self:Mythic() and 42.1 or 45, CL.count:format(args.spellName, heartRendCount))
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:HeartRendApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Dispeller("magic") and count == 1 then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) and not self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm")
		end

		self:CustomIcon(heartRendMarker, args.destName, count)

		self:TargetsMessage(args.spellId, "orange", playerList, 4, CL.count:format(args.spellName, heartRendCount-1), nil, nil, playerIcons)
	end

	function mod:HeartRendRemoved(args)
		self:CustomIcon(heartRendMarker, args.destName)
	end
end

function mod:SerratedSwipe(args)
	self:StopBar(CL.count:format(args.spellName, serratedSwipeCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, serratedSwipeCount))
	self:PlaySound(args.spellId, "info")
end

function mod:SerratedSwipeSuccess(args)
	serratedSwipeCount = serratedSwipeCount + 1
	self:CDBar(args.spellId, self:Mythic() and 21.9 or 20, CL.count:format(args.spellName, serratedSwipeCount)) -- to _start
end

function mod:Crystalize(args)
	self:StopBar(CL.count:format(args.spellName, crystalizeCount))
	crystalizeCount = crystalizeCount + 1
	self:CDBar(args.spellId, self:Mythic() and 55 or 50, CL.count:format(args.spellName, crystalizeCount))
end

do
	local prevGUID = nil
	function mod:CrystalizeApplied(args)
		prevGUID = args.destGUID
		self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, crystalizeCount-1))
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
		self:CustomIcon(crystalizeMarker, args.destName, 1)
	end

	function mod:CrystalizeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end

		self:CustomIcon(crystalizeMarker, args.destName)
	end

	function mod:PulverizingMeteor(args)
		if self:Me(prevGUID) then
			self:Yell(args.spellId, 28884) -- Meteor
		end
		self:StopBar(CL.count:format(args.spellName, pulverizingMeteorCount))
		self:Message(args.spellId, "orange", CL.count:format(args.spellName, pulverizingMeteorCount))
		self:PlaySound(args.spellId, "alert")
		pulverizingMeteorCount = pulverizingMeteorCount + 1
	end
end

function mod:StoneSpikeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AnimaApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:StonewrathExhaust(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShatteringBlast(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5)
	intermission = false
end

--[[ Stage Two: Grashaal's Blitz ]]--
function mod:GraniteFormApplied(args)
	self:Message(args.spellId, "green", CL.intermission)
	self:PlaySound(args.spellId, "long")

	commandoAddMarks = {}
	commandoesKilled = 0
	intermission = true

	self:StopBar(CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval
	self:StopBar(CL.count:format(self:SpellName(342256), shadowForcesCount)) -- Call Shadow Forces

	shadowForcesCount = 1
end

function mod:GraniteFormRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:StopBar(CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:StopBar(343086) -- Ricocheting Shuriken

	stage = 3
	self:Message(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	heartRendCount = 1
	serratedSwipeCount = 1

	self:Bar(334929, 4.4, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	self:Bar(334765, 8.8, CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:Bar(334498, 17, CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval
end

function mod:StoneFist(args)
	self:Bar(args.spellId, stage == 2 and 20 or 35)
end

function mod:StoneFistApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount > 1 then
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(344496, 324010) -- Eruption
			self:PlaySound(344496, "warning")
		end
		self:TargetMessage(344496, "red", player, CL.count:format(self:SpellName(324010), reverberatingLeapCount-1))
	end

	function mod:ReverberatingEruption(args)
		self:StopBar(CL.count:format(args.spellName, reverberatingLeapCount))
		self:GetNextBossTarget(printTarget, args.sourceGUID)
		reverberatingLeapCount = reverberatingLeapCount + 1
		self:CDBar(args.spellId, 30, CL.count:format(args.spellName, reverberatingLeapCount))
	end
end

function mod:SeismicUpheaval(args)
	self:StopBar(CL.count:format(args.spellName, seismicUphealvalCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, seismicUphealvalCount))
	self:PlaySound(args.spellId, "long")
	seismicUphealvalCount = seismicUphealvalCount + 1
	self:CDBar(args.spellId, 29, CL.count:format(args.spellName, seismicUphealvalCount))
end

--[[ Mythic ]]--
function mod:CallShadowForces(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.skirmishers, shadowForcesCount))
	self:PlaySound(args.spellId, "long")
	skirmisherCount = 0 -- Reset for a new wave
	shadowForcesCount = shadowForcesCount + 1
	self:CDBar(args.spellId, 52, CL.count:format(L.skirmishers, shadowForcesCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:VolatileAnimaAppliedInfusion(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alert")
		end
		self:TargetsMessage(args.spellId, "cyan", playerList, nil, nil, nil, 2) -- Throttle to 2s
	end
end

function mod:VolatileAnimaAppliedInfection(args)
	self:TargetMessage(args.spellId, "cyan", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert")
	end
end

do
	local prev = 0
	function mod:VolatileStoneShell(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:RavenousFeast(args)
	self:TargetMessage(342733, "red", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(342733, "warning")
		self:Flash(342733)
	end
	self:Bar(342733, 18.2) -- Ravenous Feast
end

function mod:StonegaleEffigy(args)
	self:Message(342985, "cyan")
	self:PlaySound(342985, "alert")
	self:StopBar(342733) -- Ravenous Feast
end
