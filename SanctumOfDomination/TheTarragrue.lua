--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Tarragrue", 2450, 2435)
if not mod then return end
mod:RegisterEnableMob(163538, 152253, 157098) -- The Tarragrue
mod:SetEncounterID(2423)
--mod:SetRespawnTime(30)
--mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}
local chainsCount = 1
local howlCount = 1
local mistCount = 1
local remnantCount = 1
local graspCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.chains = "Chains" -- Chains of Eternity (Chains)
	L.howl = mod:SpellName(135241) -- Predator's Howl (Howl)
	L.remnants = "Remnants" -- Remnant of Forgotten Torments (Remnants)
	L.mist = mod:SpellName(126435) -- Hungering Mist (Mist)
	L.grasp = mod:SpellName(188080) -- Grasp of Death (Grasp)
	L.enrage = mod:SpellName(184361) -- Fury of the Ages (Enrage)
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{346985, "TANK"}, -- Overpower
		{346986, "TANK"}, -- Crushed Armor
		{347269, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Chains of Eternity
		347274, -- Eternal Ruin
		{347283, "SAY", "SAY_COUNTDOWN"}, -- Predator's Howl
		347286, -- Unshakeable Dread
		347671, -- Hungering Mist
		352368, -- Remnant of Forgotten Torments
		352382, -- Remnant: Upper Reaches' Might
		352389, -- Remnant: Mort'regar's Echoes
		352398, -- Remnant: Soulforge Heat
		347668, -- Grasp of Death
		347490, -- Fury of the Ages
		347369, -- The Jailer's Gaze
	},{
		[346985] = "general",
	},{
		[347269] = L.chains, -- Chains of Eternity (Chains)
		[347283] = L.howl, -- Predator's Howl (Howl)
		[352368] = L.remnants, -- Remnant of Forgotten Torments (Remnants)
		[347671] = L.mist, -- Hungering Mist (Mist)
		[347668] = L.grasp, -- Grasp of Death (Grasp)
		[347490] = L.enrage, -- Fury of the Ages (Enrage)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Overpower", 346985)
	self:Log("SPELL_AURA_APPLIED", "CrushedArmorApplied", 346986)
	self:Log("SPELL_AURA_APPLIED", "ChainsOfEternityApplied", 347269)
	self:Log("SPELL_AURA_REMOVED", "ChainsOfEternityRemoved", 347269)
	self:Log("SPELL_AURA_APPLIED", "EternalRuinApplied", 347274)
	self:Log("SPELL_AURA_REMOVED", "EternalRuinRemoved", 347274)
	self:Log("SPELL_AURA_APPLIED", "PredatorsHowlApplied", 347283)
	self:Log("SPELL_AURA_REMOVED", "PredatorsHowlRemoved", 347283)
	self:Log("SPELL_AURA_APPLIED", "UnshakeableDreadApplied", 347286)
	self:Log("SPELL_CAST_SUCCESS", "HungeringMist", 347671)
	self:Log("SPELL_CAST_SUCCESS", "RemnantOfForgottenTorments", 352368)
	self:Log("SPELL_CAST_SUCCESS", "Remnants", 352382, 352389, 352398) -- Upper Reaches' Might, Mort'regar's Echoes, Soulforge Heat
	self:Log("SPELL_CAST_START", "GraspOfDeath", 347668)
	self:Log("SPELL_AURA_APPLIED", "GraspOfDeathApplied", 347668)
	self:Log("SPELL_CAST_START", "FuryOfTheAgesStart", 347490)
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheAgesApplied", 347490)
	self:Log("SPELL_AURA_REMOVED", "FuryOfTheAgesRemoved", 347490)
	self:Log("SPELL_AURA_APPLIED", "TheJailersGazeApplied", 347369)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	chainsCount = 1
	howlCount = 1
	mistCount = 1
	remnantCount = 1
	graspCount = 1

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 13 then -- The Jailer's Gaze at 10%
		self:Message(347369, "green", CL.soon:format(self:SpellName(347369))) -- The Jailer's Gaze
		self:UnregisterUnitEvent(event, unit)
	end
end

function mod:GROUP_ROSTER_UPDATE() -- Compensate for quitters (LFR)
	tankList = {}
	for unit in self:IterateGroup() do
		if self:Tank(unit) then
			tankList[#tankList+1] = unit
		end
	end
end

function mod:Overpower(args)
	local bossUnit = self:GetBossId(args.sourceGUID)
	for i = 1, #tankList do
		local unit = tankList[i]
		if bossUnit and self:Tanking(bossUnit, unit) then
			self:TargetMessage(args.spellId, "purple", self:UnitName(unit), CL.casting:format(args.spellName))
			break
		elseif i == #tankList then
			self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		end
	end
	self:PlaySound(args.spellId, "warning")
	--self:Bar(args.spellId, 17)
end

function mod:CrushedArmorApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local bossUnit = self:GetBossId(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Not taunted? Play again.
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:ChainsOfEternityApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			chainsCount = chainsCount + 1
			--self:Bar(args.spellId, 23, CL.count:format(L.chains, chainsCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(L.chains, chainsCount-1))
			self:SayCountdown(args.spellId, 8)
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.chains, chainsCount-1))
	end
end

function mod:ChainsOfEternityRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

-- XXX Temp incase it only hits 1 target, easy to adjust
-- function mod:ChainsOfEternityApplied(args)
-- 	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(L.chains, chainsCount))
-- 	self:PrimaryIcon(args.spellId, args.destName)
-- 	if self:Me(args.destGUID) then
-- 		self:Say(args.spellId, CL.count:format(L.chains, chainsCount))
-- 		self:SayCountdown(args.spellId, 8)
-- 		self:PlaySound(args.spellId, "warning")
-- 	end
-- 	self:TargetBar(args.spellId, 8, args.destName, CL.count:format(L.chains, chainsCount))
--	chainsCount = chainsCount + 1
-- 	--self:Bar(args.spellId, 69, CL.count:format(L.chains, chainsCount))
-- end

-- function mod:ChainsOfEternityRemoved(args)
-- 	self:PrimaryIcon(args.spellId)
-- 	self:StopBar(CL.count:format(L.chains, chainsCount), args.destName)
-- 	if self:Me(args.destGUID) then
-- 		self:CancelSayCountdown(args.spellId)
-- 	end
-- end

function mod:EternalRuinApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:TargetBar(args.spellId, self:Easy() and 12 or 30, args.destName)
	end
end

function mod:EternalRuinRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
	end
end

do
	local playerList = {}
	local prev = 0
	local soundPlayed = false
	function mod:PredatorsHowlApplied(args) -- XXX on all players?
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			soundPlayed = false
			howlCount = howlCount + 1
			if self:Dispeller("magic") then
				soundPlayed = true
				self:PlaySound(args.spellId, "alarm")
			end
			--self:Bar(args.spellId, 23, CL.count:format(L.howl, howlCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count:format(L.howl, howlCount-1))
			self:SayCountdown(args.spellId, 21)
			if soundPlayed == false then -- Only play if we havn't warned yet
				self:PlaySound(args.spellId, "alarm")
			end
		end
		self:NewTargetsMessage(args.spellId, "red", playerList, self:Mythic() and 10 or self:Heroic() and 5 or self:Normal() and 3 or self:LFR() and 1, CL.count:format(L.howl, howlCount-1))
	end
end

function mod:PredatorsHowlRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(L.howl))
		self:PlaySound(args.spellId, "info")
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:UnshakeableDreadApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:HungeringMist(args) -- XXX Adds?
	self:Message(args.spellId, "orange", CL.count:format(L.mist, mistCount))
	self:PlaySound(args.spellId, "alert")
	--self:CastBar(args.spellId, 5, CL.count:format(L.mist, mistCount))
	mistCount = mistCount + 1
	--self:Bar(args.spellId, 33, CL.count:format(L.mist, mistCount))
end

function mod:RemnantOfForgottenTorments(args) -- XXX Adds?
	self:Message(args.spellId, "yellow", CL.count:format(L.remnants, remnantCount))
	self:PlaySound(args.spellId, "long")
	remnantCount = remnantCount + 1
	--self:Bar(args.spellId, 33, CL.count:format(L.remnants, remnantCount))
end

function mod:Remnants(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 33)
end

function mod:GraspOfDeath(args)
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.grasp, graspCount)))
	self:PlaySound(args.spellId, "alert")
	graspCount = graspCount + 1
	--self:Bar(args.spellId, 33, CL.count:format(L.grasp, graspCount))
end

do
	local playerList = {}
	local prev = 0
	local soundPlayed = false
	function mod:GraspOfDeathApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			soundPlayed = false
			if self:Healer() then
				soundPlayed = true
				self:PlaySound(args.spellId, "alert")
			end
		end
		playerList[#playerList+1] = args.destName
		if soundPlayed == false and self:Me(args.destGUID) then -- Only play if we havn't warned yet
			self:PlaySound(args.spellId, "alarm")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.grasp, graspCount-1))
	end
end

function mod:FuryOfTheAgesStart(args)
	self:Message(args.spellId, "cyan", CL.casting:format(L.enrage))
	if self:Dispeller("enrage", true) then
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FuryOfTheAgesApplied(args)
	if self:Dispeller("enrage", true) then
		self:Message(args.spellId, "orange", CL.buff_boss:format(L.enrage))
		self:PlaySound(args.spellId, "warning")
	end
	--self:Bar(args.spellId, 20, L.enrage)
end

function mod:FuryOfTheAgesRemoved(args)
	self:Message(args.spellId, "green", CL.removed_by:format(L.enrage, args.sourceName))
	if self:Dispeller("enrage", true) then
		self:PlaySound(args.spellId, "info")
	end
end

function mod:TheJailersGazeApplied(args)
	self:Message(args.spellId, "orange", CL.percent:format(10, args.spellName))
	self:PlaySound(args.spellId, "long")
end
