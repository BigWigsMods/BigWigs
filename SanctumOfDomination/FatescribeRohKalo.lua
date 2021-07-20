--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fatescribe Roh-Kalo", 2450, 2447)
if not mod then return end
mod:RegisterEnableMob(175730)
mod:SetEncounterID(2431)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 73
local realignFateCount = 1
local callOfEternityCount = 1
local invokeDestinyCount = 1
local fatedConjunctionCount = 1
local twistFateCount = 1
local extemporaneousFateCount = 1
local grimPortentCount = 1

local twistFateTimersHeroic = {
	{6.3, 49.7, 52},
	{11.3, 49.8, 74.9, 26.8},
	{52.8, 48.6, 39.7, 30.3},
}
local twistFateTimersMythic = {
	{6.1, 32.8, 20.7, 37.7, 28},
	{11.2, 32.8, 20.6, 37.7, 28},
	{42, 15.7, 27.9, 46.2, 16.9},
}
local twistFateTimers = mod:Mythic() and twistFateTimersMythic or twistFateTimersHeroic

local timersStageOneMythic = {
	[350568] = {18.2, 57.9, 37.7}, -- Call of Eternity
	-- [351680] = 45, -- Invoke Destiny
	[350421] = {31.6, 47.4, 6.1, 8.4}, -- Fated Conjunction
}

local timersStageThreeHeroic = {
	[350568] = {13, 74.5, 38, 96.5}, -- Call of Eternity
	[351680] = {24, 44.5, 90}, -- Invoke Destiny
	[350421] = {11.2, 51.0, 51.0, 32, 39.2, 27.4}, -- Fated Conjunction
}
local timersStageThreeMythic = {
	[350568] = {14.1, 54.6, 30.4}, -- Call of Eternity
	[351680] = {26.2, 45, 45, 35}, -- Invoke Destiny
	[350421] = {18.9, 75.7, 7.3}, -- Fated Conjunction
}
local timersStageThree = mod:Mythic() and timersStageThreeMythic or timersStageThreeHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rings = "Rings"
	L.rings_active = "Rings Active" -- for when they activate/are movable
	L.runes = "Runes" -- Grim Portent

	L.grimportent_countdown = "Countdown"
	L.grimportent_countdown_icon = 354367 -- Grim Portent
	L.grimportent_countdown_desc = "Countdown for the players who are Affected by Grim Portent"
	L.grimportent_countdown_bartext = "Go to rune!"
end

--------------------------------------------------------------------------------
-- Initialization
--

local callOfEternityMarker = mod:AddMarkerOption(false, "player", 1, 350568, 1, 2, 3, 4, 5) -- Call of Eternity
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: Scrying Fate
		{351680, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Invoke Destiny
		353432, -- Burden of Destiny (Fixate)
		353398, -- Anomalous Blast
		{353603, "TANK"}, -- Diviner's Probe
		353931, -- Twist Fate
		350421, -- Fated Conjunction (Beams)
		{350568, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Call of Eternity (Bombs)
		callOfEternityMarker,
		-- Stage Two: Defying Destiny
		357739, -- Realign Fate
		357144, -- Despair
		353122, -- Darkest Destiny
		-- Stage Three: Fated Terminus
		353195, -- Extemporaneous Fate
		354367, -- Grim Portent
		{"grimportent_countdown", "COUNTDOWN"},
		354964, -- Runic Affinity
	},{
		[351680] = mod:SpellName(-22926), -- Stage One: Scrying Fate
		[357739] = mod:SpellName(-22927), -- Stage Two: Defying Destiny
		[353195] = mod:SpellName(-23486), -- Stage Three: Fated Terminus
	},{
		[351680] = CL.add, -- Invoke Destiny (Add)
		[353432] = CL.fixate, -- Burden of Destiny (Fixate)
		[350421] = CL.beams, -- Fated Conjunction (Beams)
		[350568] = CL.bombs, -- Call of Eternity (Bombs)
		[357739] = L.rings, -- Realign Fate (Rings)
		[353195] = L.rings, -- Extemporaneous Fate (Rings)
		[354367] = L.runes, -- Grim Portent (Runes)
	}
end

function mod:OnBossEnable()
	-- Stage One: Scrying Fate
	self:Log("SPELL_CAST_START", "InvokeDestiny", 351680)
	self:Log("SPELL_AURA_APPLIED", "InvokeDestinyApplied", 351680)
	self:Log("SPELL_AURA_REMOVED", "InvokeDestinyRemoved", 351680)
	self:Log("SPELL_AURA_APPLIED", "BurdenOfDestinyApplied", 353432)
	self:Log("SPELL_AURA_APPLIED", "AnomalousBlastApplied", 353398)
	self:Log("SPELL_CAST_START", "DivinersProbe", 353603)
	self:Log("SPELL_CAST_SUCCESS", "TwistFate", 354265)
	self:Log("SPELL_AURA_APPLIED", "TwistFateApplied", 353931)
	self:Log("SPELL_CAST_START", "FatedConjunction", 350421)
	self:Log("SPELL_CAST_SUCCESS", "FatedConjunctionSuccess", 350421)
	self:Log("SPELL_CAST_START", "CallOfEternity", 350554)
	self:Log("SPELL_AURA_APPLIED", "CallOfEternityApplied", 350568, 356065) -- Heroic, Normal
	self:Log("SPELL_AURA_REMOVED", "CallOfEternityRemoved", 350568, 356065)

	-- Stage Two: Defying Destiny
	self:Log("SPELL_AURA_APPLIED", "RealignFateApplied", 357739)
	self:Log("SPELL_CAST_START", "Despair", 357144)
	self:Death("MonstrosityDeath", 180323) -- Fatespawn Monstrosity

	self:Log("SPELL_AURA_APPLIED", "UnstableAccretionApplied", 353693)
	self:Log("SPELL_AURA_REMOVED", "RealignFateRemoved", 357739)

	-- Stage Three: Fated Terminus
	self:Log("SPELL_AURA_APPLIED", "ExtemporaneousFateApplied", 353195)
	self:Log("SPELL_AURA_REMOVED", "ExtemporaneousFateRemoved", 353195)

	-- Mythic
	self:Log("SPELL_CAST_START", "GrimPortent", 354367)
	self:Log("SPELL_AURA_APPLIED", "GrimPortentApplied", 354365)
	self:Log("SPELL_AURA_REMOVED", "GrimPortentRemoved", 354365)
	self:Log("SPELL_AURA_APPLIED", "RunicAffinityApplied", 354964)

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

function mod:OnEngage()
	self:SetStage(1)
	nextStageWarning = 73
	stage = 1
	realignFateCount = 1
	callOfEternityCount = 1
	invokeDestinyCount = 1
	fatedConjunctionCount = 1
	twistFateCount = 1
	extemporaneousFateCount = 1
	grimPortentCount = 1
	twistFateTimers = self:Mythic() and twistFateTimersMythic or twistFateTimersHeroic
	timersStageThree = self:Mythic() and timersStageThreeMythic or timersStageThreeHeroic

	-- these all can vary by 2s
	self:CDBar(353931, 6, CL.count:format(self:SpellName(353931), twistFateCount)) -- Twist Fate
	self:CDBar(350421, self:Mythic() and 30.6 or 13.4, CL.count:format(CL.beams, fatedConjunctionCount)) -- Fated Conjunction (Beams)
	self:CDBar(350568, self:Mythic() and 18.2 or 24.3, CL.count:format(CL.bombs, callOfEternityCount)) -- Call of Eternity (Bombs)
	self:CDBar(351680, self:Mythic() and 20.6 or 35.3, CL.count:format(CL.add, invokeDestinyCount)) -- Invoke Destiny (Add)

	if self:Mythic() then
		self:CDBar(354367, 43.8, CL.count:format(L.runes, grimPortentCount)) -- Grim Portent (Runes)
	end

	self:Berserk(600) -- Heroic PTR
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < nextStageWarning then -- 70% and 40%
		self:Message("stages", "green", CL.soon:format(self:SpellName(357739)), false) -- Realign Fate
		self:PlaySound("stages", "info")
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 20 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

-- Stage One: Scrying Fate
function mod:InvokeDestiny(args)
	if self:Tank() then
		self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(CL.add, invokeDestinyCount)))
		self:PlaySound(args.spellId, "alert")
	end
	self:StopBar(CL.count:format(CL.add, invokeDestinyCount))
	invokeDestinyCount = invokeDestinyCount + 1
	self:CDBar(args.spellId, stage == 3 and timersStageThree[args.spellId][invokeDestinyCount] or 45, CL.count:format(CL.add, invokeDestinyCount))
end

function mod:InvokeDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.count:format(CL.add, invokeDestinyCount-1))
		self:SayCountdown(args.spellId, 8)
		self:PlaySound(args.spellId, "warning")
	end
	self:Bar(args.spellId, 8, CL.incoming:format(CL.add))
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(CL.add, invokeDestinyCount-1))
end

function mod:InvokeDestinyRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(CL.count:format(CL.add, invokeDestinyCount-1), args.destName)
end

function mod:BurdenOfDestinyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:AnomalousBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:DivinersProbe(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	if bossUnit and self:Tanking(bossUnit) then
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:TwistFate(args)
	self:Message(353931, "orange", CL.count:format(args.spellName, twistFateCount))
	self:StopBar(CL.count:format(args.spellName, twistFateCount))
	twistFateCount = twistFateCount + 1
	self:CDBar(353931, twistFateTimers[realignFateCount][twistFateCount], CL.count:format(args.spellName, twistFateCount))
end

function mod:TwistFateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FatedConjunction(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(CL.beams, fatedConjunctionCount)))
	-- self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6.8, CL.count:format(CL.beams, fatedConjunctionCount))
	self:StopBar(CL.count:format(CL.beams, fatedConjunctionCount))
	fatedConjunctionCount = fatedConjunctionCount + 1
	if self:Mythic() then
		local timers = stage == 3 and timersStageThree[args.spellId] or timersStageOneMythic[args.spellId]
		self:CDBar(args.spellId, timers[fatedConjunctionCount], CL.count:format(CL.beams, fatedConjunctionCount))
	else
		if stage == 3 then
			self:CDBar(args.spellId, timersStageThree[args.spellId][fatedConjunctionCount], CL.count:format(CL.beams, fatedConjunctionCount))
		else
			self:CDBar(args.spellId, fatedConjunctionCount % 2 == 0 and 60.3 or 47.4, CL.count:format(CL.beams, fatedConjunctionCount)) -- 60.4 26.7 26.7
		end
	end
end

function mod:FatedConjunctionSuccess(args)
	self:Message(args.spellId, "yellow", CL.count:format(CL.beams, fatedConjunctionCount))
	self:PlaySound(args.spellId, "alert")
end

do
	local playerList = {}
	function mod:CallOfEternity(args)
		playerList = {}
		self:CastBar(350568, 10, CL.count:format(CL.bombs, callOfEternityCount))
		self:StopBar(CL.count:format(CL.bombs, callOfEternityCount))
		callOfEternityCount = callOfEternityCount + 1
		if stage == 3 then
			self:CDBar(350568, timersStageThree[350568][callOfEternityCount], CL.count:format(CL.bombs, callOfEternityCount)) -- 38-40
		else
			self:CDBar(350568, mod:Mythic() and timersStageOneMythic[350568][callOfEternityCount] or 38, CL.count:format(CL.bombs, callOfEternityCount)) -- 38-40
		end
	end

	function mod:CallOfEternityApplied(args)
		local count = #playerList+1
		local icon = count
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:TargetBar(350568, 8, args.destName, CL.count:format(CL.bomb, callOfEternityCount-1))
			self:Say(350568, CL.count_rticon:format(CL.bomb, count, icon))
			self:SayCountdown(350568, 8)
			self:PlaySound(350568, "warning")
		end
		self:NewTargetsMessage(350568, "orange", playerList, nil, CL.count:format(CL.bomb, callOfEternityCount-1))
		self:CustomIcon(callOfEternityMarker, args.destName, icon)
	end

	function mod:CallOfEternityRemoved(args)
		if self:Me(args.destGUID) then
			self:StopBar(CL.count:format(CL.bomb, callOfEternityCount-1), args.destName)
			self:CancelSayCountdown(350568)
		end
		self:CustomIcon(callOfEternityMarker, args.destName)
	end
end

-- Stage Two: Defying Destiny
function mod:RealignFateApplied(args)
	self:StopBar(CL.count:format(CL.bombs, callOfEternityCount))
	self:StopBar(CL.count:format(CL.beams, fatedConjunctionCount))
	self:StopBar(CL.count:format(CL.add, invokeDestinyCount))
	self:StopBar(CL.count:format(L.runes, grimPortentCount))
	self:StopBar(CL.count:format(self:SpellName(353931), twistFateCount))

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
	self:CDBar(args.spellId, 17.5, L.rings_active, args.spellId) -- 16-18s
	realignFateCount = realignFateCount + 1
end

function mod:Despair(args)
	local canDo, ready = self:Interrupter()
	if canDo then
		self:Message(args.spellId, "yellow", CL.casting:format(args.spellName))
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
	--self:Bar(args.spellId, 20)
end

function mod:MonstrosityDeath()
	self:StopBar(357144) -- Despair
end

do
	local prev = 0
	function mod:UnstableAccretionApplied(args) -- Best way to track it atm
		local t = args.time
		if t-prev > 40 then
			prev = t
			self:Message("stages", "green", L.rings_active, false)
			self:PlaySound("stages", "info")
			self:StopBar(L.rings_active)
			self:CastBar(353122, 40) -- Darkest Destiny
		end
	end
end

function mod:RealignFateRemoved(args)
	self:StopBar(CL.cast:format(self:SpellName(353122))) -- Darkest Destiny

	if realignFateCount > 2 then -- Stage 3 after 2x Realign Fate
		stage = 3
	else
		stage = 1
	end
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	invokeDestinyCount = 1
	fatedConjunctionCount = 1
	callOfEternityCount = 1
	twistFateCount = 1

	if self:Mythic() then
		self:CDBar(353931, stage == 3 and 42 or 13.1, CL.count:format(self:SpellName(353931), twistFateCount)) -- Twist Fate
		self:CDBar(350421, stage == 3 and 18.7 or 35.5, CL.count:format(CL.beams, fatedConjunctionCount)) -- Fated Conjunction (Beams)
		self:CDBar(350568, stage == 3 and 10.7 or 22.5, CL.count:format(CL.bombs, callOfEternityCount)) -- Call of Eternity (Bombs)
		self:CDBar(351680, stage == 3 and 26.2 or 25.8, CL.count:format(CL.add, invokeDestinyCount)) -- Invoke Destiny (Add)
		if stage == 1 then
			grimPortentCount = 1
			self:CDBar(354367, 48.8, CL.count:format(L.runes, grimPortentCount)) -- Grim Portent (Runes)
		end
	else
		self:CDBar(353931, stage == 3 and 53 or 11.1, CL.count:format(self:SpellName(353931), twistFateCount)) -- Twist Fate
		self:CDBar(350421, stage == 3 and 8.3 or 19, CL.count:format(CL.beams, fatedConjunctionCount)) -- Fated Conjunction (Beams)
		self:CDBar(350568, stage == 3 and 10.7 or 31.6, CL.count:format(CL.bombs, callOfEternityCount)) -- Call of Eternity (Bombs)
		self:CDBar(351680, stage == 3 and 24.2 or 38, CL.count:format(CL.add, invokeDestinyCount)) -- Invoke Destiny (Add)
	end

	if stage == 3 then
		extemporaneousFateCount = 1
		self:Bar(353195, 35.9, CL.count:format(L.rings, extemporaneousFateCount)) -- Extemporaneous Fate (Rings)
	end
end

-- Stage Three: Fated Terminus
function mod:ExtemporaneousFateApplied(args)
	self:Message(args.spellId, "orange", CL.count:format(L.rings, extemporaneousFateCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 30, CL.count:format(L.rings, extemporaneousFateCount))
	extemporaneousFateCount = extemporaneousFateCount + 1
	self:CDBar(args.spellId, 40, CL.count:format(L.rings, extemporaneousFateCount)) -- XXX 35-50s, maybe table? seemed inconsistent between 2 pulls.
end

function mod:ExtemporaneousFateRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(L.rings)) -- Rings Over
	self:StopBar(CL.cast:format(CL.count:format(L.rings, extemporaneousFateCount)))
end

-- Mythic
function mod:GrimPortent(args)
	self:Message(args.spellId, "yellow", CL.count:format(L.runes, grimPortentCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 12.5, CL.count:format(L.runes, grimPortentCount)) -- based on the visual for the explosion
	grimPortentCount = grimPortentCount + 1
	self:CDBar(args.spellId, 75, CL.count:format(L.runes, grimPortentCount))
end

function mod:GrimPortentApplied(args)
	if self:Me(args.destGUID) then
		-- self:StopBar(CL.cast:format(CL.count:format(L.runes, grimPortentCount-1)))
		self:PersonalMessage(354367)
		self:PlaySound(354367, "alarm")
		self:Bar("grimportent_countdown", 9, L.grimportent_countdown_bartext, 354367) -- be there by this time, explosion at cast time
	end
end

function mod:GrimPortentRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(L.grimportent_countdown_bartext)
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:RunicAffinityApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "orange", playerList)
	end
end
