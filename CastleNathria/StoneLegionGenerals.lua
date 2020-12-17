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

local mobCollector = {}
local stage = 1
local wickedBladeCount = 1
local heartRendCount = 1
local serratedSwipeCount = 1
local crystalizeCount = 1
local pulverizingMeteorCount = 1
local reverberatingLeapCount = 1
local seismicUphealvalCount = 1
local shadowForcesCount = 1

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

local wickedBladeMarker = mod:AddMarkerOption(false, "player", 6, 333387, 6, 7) -- Wicked Blade
local heartRendMarker = mod:AddMarkerOption(false, "player", 1, 334765, 1, 2, 3, 4) -- Heart Rend
local crystalizeMarker = mod:AddMarkerOption(false, "player", 5, 339690, 5) -- Crystalize
local skirmisherMarker = mod:AddMarkerOption(false, "target", 1, -22761, 1, 2, 3) -- Stone Legion Skirmisher
function mod:GetOptions()
	return {
		"stages",
		"custom_on_stop_timers",
			--[[ Stage One: Kaal's Assault ]]--
		329636, -- Hardened Stone Form
		{333387, "SAY"}, -- Wicked Blade
		wickedBladeMarker,
		334765, -- Heart Rend
		heartRendMarker,
		{334929, "TANK"}, -- Serrated Swipe
		{339690, "SAY", "SAY_COUNTDOWN"}, -- Crystalize
		crystalizeMarker,
		342544, -- Pulverizing Meteor
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
		{344496, "SAY"}, -- Reverberating Eruption
		334498, -- Seismic Upheaval

		--[[ Mythic ]]--
		342256, -- Call Shadow Forces
		skirmisherMarker,
		342655, -- Volatile Anima Infusion
		340037, -- Volatile Stone Shell
		342698, -- Volatile Anima Injection
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
	self:Log("SPELL_CAST_SUCCESS", "HeartRend", 334765)
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
	self:Log("SPELL_AURA_APPLIED", "StonegaleEffigy", 342985)

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
	self:Log("SPELL_AURA_APPLIED", "VolatileAnimaApplied", 342655, 342698) -- Volatile Anima Infusion, Volatile Anima Injection
	self:Log("SPELL_AURA_APPLIED", "VolatileStoneShell", 340037)
end

function mod:OnEngage()
	mobCollector = {}
	stage = 1
	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	crystalizeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1
	shadowForcesCount = 1

	self:Bar(334929, 9.3, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	self:Bar(333387, 19, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:Bar(334765, 28.8, CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:Bar(339690, 25, CL.count:format(self:SpellName(339690), crystalizeCount)) -- Crystalize
	-- Ravenous Feast XXX

	if self:Mythic() then
		self:Bar(342256, 12, CL.count:format(L.skirmishers, shadowForcesCount)) -- Call Shadow Forces
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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

--[[ Stage One: Kaal's Assault ]]--
function mod:HardenedStoneFormApplied(args)
	self:Message(args.spellId, "green", CL.intermission)
	self:PlaySound(args.spellId, "long")
end

function mod:HardenedStoneFormRemoved(args)
	self:StopBar(342256) -- Call Shadow Forces
	self:StopBar(CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:StopBar(CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:StopBar(CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe

	stage = 2
	self:Message(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	pulverizingMeteorCount = 1
	reverberatingLeapCount = 1
	seismicUphealvalCount = 1
	shadowForcesCount = 1

	self:Bar(342425, 34.9) -- Stone Fist
	self:Bar(344496, 7.8, CL.count:format(self:SpellName(344496), reverberatingLeapCount)) -- Reverberating Eruption
	self:Bar(334498, 33.8, CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval

	self:CDBar(333387, 26, CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade

	if self:Mythic() then
		self:Bar(342256, 60, CL.count:format(L.skirmishers, shadowForcesCount)) -- Call Shadow Forces
	end
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
					SetRaidTarget(name, name == target and 6 or 7)
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
				--	SetRaidTarget(playerList[1], 6)
				--	SetRaidTarget(playerList[2], 7)
				--end
				self:TargetsMessage(333387, "orange", self:ColorName(playerList), 2, CL.count:format(self:SpellName(333387), wickedBladeCount-1))
			end
		elseif firstGUID and firstGUID ~= args.destGUID then
			if self:Me(args.destGUID) then
				self:Say(333387, L.second_blade)
				self:PlaySound(333387, "warning")
			end
			playerList[2] = args.destName
			if self:GetOption(wickedBladeMarker) then
				SetRaidTarget(playerList[1], 6)
				SetRaidTarget(playerList[2], 7)
			end
			self:TargetsMessage(333387, "orange", self:ColorName(playerList), 2, CL.count:format(self:SpellName(333387), wickedBladeCount-1))
		end
	end

	function mod:WickedBladeRemoved(args)
		if self:Me(args.destGUID) then
			onMe = false
		end
		if self:GetOption(wickedBladeMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:HeartRend(args)
	self:StopBar(CL.count:format(args.spellName, heartRendCount))
	heartRendCount = heartRendCount + 1
	self:Bar(args.spellId, 45, CL.count:format(args.spellName, heartRendCount))
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

		if self:GetOption(heartRendMarker) then
			SetRaidTarget(args.destName, count)
		end

		self:TargetsMessage(args.spellId, "orange", playerList, 4, CL.count:format(args.spellName, heartRendCount-1), nil, nil, playerIcons)
	end

	function mod:HeartRendRemoved(args)
		if self:GetOption(heartRendMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SerratedSwipe(args)
	self:StopBar(CL.count:format(args.spellName, serratedSwipeCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, serratedSwipeCount))
	self:PlaySound(args.spellId, "info")
end

function mod:SerratedSwipeSuccess(args)
	serratedSwipeCount = serratedSwipeCount + 1
	self:CDBar(args.spellId, 20, CL.count:format(args.spellName, serratedSwipeCount)) -- to _start
end

function mod:Crystalize(args)
	self:StopBar(CL.count:format(args.spellName, crystalizeCount))
	crystalizeCount = crystalizeCount + 1
	self:CDBar(args.spellId, 60, CL.count:format(args.spellName, crystalizeCount))
end

function mod:CrystalizeApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(args.spellName, crystalizeCount-1))
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
		self:PlaySound(args.spellId, "warning")
	end
	if self:GetOption(crystalizeMarker) then
		SetRaidTarget(args.destName, 5)
	end
end

function mod:CrystalizeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end

	if self:GetOption(crystalizeMarker) then
		SetRaidTarget(args.destName, 0)
	end
end

function mod:PulverizingMeteor(args)
	self:StopBar(CL.count:format(args.spellName, pulverizingMeteorCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, pulverizingMeteorCount))
	self:PlaySound(args.spellId, "alert")
	pulverizingMeteorCount = pulverizingMeteorCount + 1
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
end

--[[ Stage Two: Grashaal's Blitz ]]--
function mod:GraniteFormApplied(args)
	self:Message(args.spellId, "green", CL.intermission)
	self:PlaySound(args.spellId, "long")

	self:StopBar(CL.count:format(self:SpellName(334498), seismicUphealvalCount)) -- Seismic Upheaval
end

function mod:GraniteFormRemoved(args)
	self:StopBar(CL.count:format(self:SpellName(333387), wickedBladeCount)) -- Wicked Blade
	self:StopBar(CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend
	self:StopBar(343086) -- Ricocheting Shuriken

	stage = 3
	self:Message(args.spellId, "green", CL.stage:format(stage))
	self:PlaySound(args.spellId, "long")

	wickedBladeCount = 1
	heartRendCount = 1
	serratedSwipeCount = 1
	shadowForcesCount = 1

	self:Bar(334929, 4.4, CL.count:format(self:SpellName(334929), serratedSwipeCount)) -- Serrated Swipe
	self:Bar(334765, 8.8, CL.count:format(self:SpellName(334765), heartRendCount)) -- Heart Rend

	if self:Mythic() then
		self:Bar(342256, 60, CL.count:format(L.skirmishers, shadowForcesCount)) -- Call Shadow Forces
	end
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
		self:TargetMessage(344496, "red", player, CL.count:format(self:SpellName(344496), reverberatingLeapCount-1))
	end

	function mod:ReverberatingEruption(args)
		self:StopBar(CL.count:format(args.spellName, reverberatingLeapCount))
		self:GetNextBossTarget(printTarget, args.sourceGUID)
		reverberatingLeapCount = reverberatingLeapCount + 1
		self:CDBar(args.spellId, 32, CL.count:format(args.spellName, reverberatingLeapCount))
	end
end

function mod:SeismicUpheaval(args)
	self:StopBar(CL.count:format(args.spellName, seismicUphealvalCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, seismicUphealvalCount))
	self:PlaySound(args.spellId, "long")
	seismicUphealvalCount = seismicUphealvalCount + 1
	self:CDBar(args.spellId, 32, CL.count:format(args.spellName, seismicUphealvalCount))
end

--[[ Mythic ]]--
do
	local skirmisherMarks = {}
	function mod:SkirmisherAddMark(event, unit, guid)
		if self:MobId(guid) == 174335 and not mobCollector[guid] then
			for i = 1, 3 do
				if not skirmisherMarks[i] then
					SetRaidTarget(unit, i)
					skirmisherMarks[i] = guid
					mobCollector[guid] = true
					if i == 3 then
						self:UnregisterTargetEvents()
					end
					return
				end
			end
		end
	end

	function mod:CallShadowForces(args)
		self:Message(args.spellId, "cyan", CL.count:format(L.skirmishers, shadowForcesCount))
		self:PlaySound(args.spellId, "long")
		shadowForcesCount = shadowForcesCount + 1
		self:CDBar(args.spellId, 52, CL.count:format(L.skirmishers, shadowForcesCount))

		if self:GetOption(skirmisherMarker) then
			skirmisherMarks = {}
			self:RegisterTargetEvents("SkirmisherAddMark")
			self:ScheduleTimer("UnregisterTargetEvents", 10)
		end
	end
end

function mod:VolatileAnimaApplied(args)
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
end

do
	local prev = 0
	function mod:StonegaleEffigy(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "cyan")
			self:PlaySound(args.spellId, "alert")
		end
	end
end
