--------------------------------------------------------------------------------
-- Module Declaration
--
if not IsTestBuild() then return end
local mod, CL = BigWigs:NewBoss("The Tarragrue", 2450, 2435)
if not mod then return end
mod:RegisterEnableMob(175611) -- The Tarragrue
mod:SetEncounterID(2423)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local tankList = {}
local chainsCount = 1
local howlCount = 1
local mistCount = 1
local remnantCount = 1
local graspCount = 1
local nextMist = 0
local mistCastCount = 1
local remnantType = {
	[352382] = "physical_remnant",
	[352389] = "magic_remnant",
	[352398] = "fire_remnant",
}

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

	L.physical_remnant = "Physical Remnant"
	L.magic_remnant = "Magic Remnant"
	L.fire_remnant = "Fire Remnant"
	L.fire = "Fire"
	L.magic = "Magic"
	L.physical = "Physical"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{346985, "TANK"}, -- Overpower
		{346986, "TANK"}, -- Crushed Armor
		{347269, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE", "ICON"}, -- Chains of Eternity
		347274, -- Annihilating Smash
		{347283, "SAY", "ME_ONLY", "ME_ONLY_EMPHASIZE"}, -- Predator's Howl
		347286, -- Unshakeable Dread
		347679, -- Hungering Mist
		352368, -- Remnant of Forgotten Torments
		352382, -- Remnant: Upper Reaches' Might
		352389, -- Remnant: Mort'regar's Echoes
		352398, -- Remnant: Soulforge Heat
		347668, -- Grasp of Death
		{347490, "DISPEL"}, -- Fury of the Ages
		347369, -- The Jailer's Gaze
		"berserk",
	},{
		[346985] = "general",
	},{
		[347269] = L.chains, -- Chains of Eternity (Chains)
		[347283] = L.howl, -- Predator's Howl (Howl)
		[352368] = L.remnants, -- Remnant of Forgotten Torments (Remnants)
		[347679] = L.mist, -- Hungering Mist (Mist)
		[352382] = L.physical_remnant, -- Remnant: Upper Reaches' Might (Physical Remnant)
		[352389] = L.magic_remnant, -- Remnant: Mort'regar's Echoes (Magic Remnant)
		[352398] = L.fire_remnant, -- Remnant: Soulforge Heat (Fire Remnant)
		[347668] = L.grasp, -- Grasp of Death (Grasp)
		[347490] = L.enrage, -- Fury of the Ages (Enrage)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Overpower", 346985)
	self:Log("SPELL_AURA_APPLIED", "CrushedArmorApplied", 346986)
	self:Log("SPELL_AURA_APPLIED", "ChainsOfEternityApplied", 347269)
	self:Log("SPELL_AURA_REMOVED", "ChainsOfEternityRemoved", 347269)
	self:Log("SPELL_AURA_APPLIED", "AnnihilatingSmashApplied", 347274)
	self:Log("SPELL_AURA_REMOVED", "AnnihilatingSmashRemoved", 347274)
	self:Log("SPELL_CAST_START", "PredatorsHowl", 347283)
	self:Log("SPELL_AURA_APPLIED", "PredatorsHowlApplied", 347283)
	self:Log("SPELL_AURA_REMOVED", "PredatorsHowlRemoved", 347283)
	self:Log("SPELL_AURA_APPLIED", "UnshakeableDreadApplied", 347286)
	self:Log("SPELL_CAST_START", "HungeringMist", 347679)
	self:Log("SPELL_CAST_START", "HungeringMistCast", 354080)
	self:Log("SPELL_CAST_SUCCESS", "RemnantOfForgottenTorments", 352368)
	self:Log("SPELL_CAST_SUCCESS", "RemnantSpawn", 352382, 352389, 352398) -- Upper Reaches' Might, Mort'regar's Echoes, Soulforge Heat
	self:Log("SPELL_AURA_APPLIED", "RemnantStacks", 352384, 352392, 352387) -- Physical, Fire, Magic
	self:Log("SPELL_AURA_APPLIED_DOSE", "RemnantStacks", 352384, 352392, 352387)
	self:Log("SPELL_CAST_SUCCESS", "GraspOfDeath", 347668)
	self:Log("SPELL_AURA_APPLIED", "GraspOfDeathApplied", 347668)
	self:Log("SPELL_CAST_START", "FuryOfTheAgesStart", 347490)
	self:Log("SPELL_AURA_APPLIED", "FuryOfTheAgesApplied", 347490)
	self:Log("SPELL_DISPEL", "FuryOfTheAgesDispel", "*")
	self:Log("SPELL_AURA_APPLIED", "TheJailersGazeApplied", 347369)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:GROUP_ROSTER_UPDATE()
end

function mod:OnEngage()
	chainsCount = 1
	howlCount = 1
	remnantCount = 1
	graspCount = 1
	mistCount = 1

	self:Bar(347283, self:Mythic() and 5 or 3.6, CL.count:format(L.howl, howlCount)) -- Predator's Howl
	self:Bar(347668, self:Mythic() and 8 or 6.23, CL.count:format(L.grasp, graspCount)) -- Grasp of Death
	self:Bar(346985, self:Mythic() and 10 or 12.3) -- Overpower
	self:Bar(347269, self:Mythic() and 13 or 17.1, CL.count:format(L.chains, chainsCount)) -- Chains of Eternity
	self:Bar(347679, 24.7, CL.count:format(L.mist, mistCount)) -- Hungering Mist
	nextMist = GetTime() + 24.7

	if not self:Mythic() then -- XXX unknown
		self:Berserk(420) -- Heroic
	end

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
	if nextMist - GetTime() > 28 then
		self:Bar(args.spellId, 28)
	end
end

function mod:CrushedArmorApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local bossUnit = self:GetBossId(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Not taunted? Play again.
	end
end

function mod:ChainsOfEternityApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(L.chains, chainsCount))
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.count:format(L.chains, chainsCount))
		self:SayCountdown(args.spellId, 8)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetBar(args.spellId, 8, args.destName, CL.count:format(L.chains, chainsCount))
	chainsCount = chainsCount + 1
	if nextMist - GetTime() > 28 then
		self:Bar(args.spellId, 27.9, CL.count:format(L.chains, chainsCount))
	end
end

function mod:ChainsOfEternityRemoved(args)
	self:PrimaryIcon(args.spellId)
	self:StopBar(CL.count:format(L.chains, chainsCount), args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:AnnihilatingSmashApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
		self:TargetBar(args.spellId, self:LFR() and 10 or self:Normal() and 15 or 30, args.destName)
	end
end

function mod:AnnihilatingSmashRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellName, args.destName)
	end
end

do
	local playerList = {}
	local soundPlayed = false

	function mod:PredatorsHowl(args)
		playerList = {}
		soundPlayed = false
		self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.howl, howlCount)))
		howlCount = howlCount + 1
		if nextMist - GetTime() > 25 then
			self:Bar(args.spellId, 25.6, CL.count:format(L.howl, howlCount))
		end
		self:PlaySound(args.spellId, "alert")
	end

	function mod:PredatorsHowlApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Dispeller("magic") and not soundPlayed then
			self:PlaySound(args.spellId, "alarm")
			soundPlayed = true
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.howl)
			if not soundPlayed then
				self:PlaySound(args.spellId, "alarm")
				soundPlayed = true
			end
		end
		self:NewTargetsMessage(args.spellId, "red", playerList, nil, CL.count:format(L.howl, howlCount-1))
	end
end

function mod:PredatorsHowlRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(L.howl))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:UnshakeableDreadApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:HungeringMist(args)
	mistCastCount = 1
	self:Message(args.spellId, "cyan", CL.count:format(L.mist, mistCount))
	self:PlaySound(args.spellId, "long")
	mistCount = mistCount + 1
	nextMist = 96.3 + GetTime()
	self:ScheduleTimer("Bar", 19.9, args.spellId, 76.4, CL.count:format(L.mist, mistCount)) -- Hungering Mist

	self:Bar(347283, 22, CL.count:format(L.howl, howlCount)) -- Predator's Howl
	self:Bar(346985, 25.7) -- Overpower
	self:Bar(347668, 28.1, CL.count:format(L.grasp, graspCount)) -- Grasp of Death
	self:Bar(352368, 24.3, CL.count:format(L.remnants, remnantCount)) -- Remnants
	self:Bar(347490, 32.9, L.enrage)
	self:Bar(347269, 58.3, CL.count:format(L.chains, chainsCount)) -- Chains of Eternity
end

function mod:HungeringMistCast()
	self:Message(347679, "yellow", CL.casting:format(CL.count:format(L.mist, mistCastCount)))
	self:PlaySound(347679, "info")
	self:CastBar(347679, 4.8, CL.count:format(L.mist, mistCastCount)) -- Hungering Mist
	mistCount = mistCount + 1
end

function mod:RemnantOfForgottenTorments(args)
	self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(L.remnants, remnantCount)))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, self:Mythic() and 4 or 6, CL.spawning:format(CL.count:format(L.remnants, remnantCount))) -- Remnants Spawning
	remnantCount = remnantCount + 1
	if nextMist - GetTime() > 30 then
		self:Bar(args.spellId, 31, CL.count:format(L.remnants, remnantCount)) -- 30.5 ~ 31.67
	end
end

function mod:RemnantSpawn(args)
	local remnant = L[remnantType[args.spellId]]
	self:Message(args.spellId, "cyan", remnant)
	self:PlaySound(args.spellId, "info")
end

function mod:RemnantStacks(args)
	if self:Me(args.destGUID) then
		local key = 352382 -- Physical
		local text = L.physical
		if args.spellId == 352392 then -- Fire
			key = 352398
			text = L.fire
		elseif args.spellId == 352387 then -- Magic
			key = 352389
			text = L.magic
		end
		self:NewStackMessage(key, "blue", args.destName, args.amount, nil, text)
		self:PlaySound(key, "alarm")
	end
end

do
	local playerList = {}
	local soundPlayed = false

	function mod:GraspOfDeath(args)
		playerList = {}
		if self:Healer() then
			soundPlayed = true
			self:PlaySound(args.spellId, "alert")
		else
			soundPlayed = false
		end

		self:Message(args.spellId, "red", CL.count:format(L.grasp, graspCount))

		graspCount = graspCount + 1
		if nextMist - GetTime() > 30 then
			self:CDBar(args.spellId, 26.7, CL.count:format(L.grasp, graspCount)) -- queues
		elseif mistCount == 1 then -- The second cast is quick (starts at 80 energy)
			self:Bar(args.spellId, 13.5, CL.count:format(L.grasp, graspCount))
		end
	end

	function mod:GraspOfDeathApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			if not soundPlayed then
				soundPlayed = true
				self:PlaySound(args.spellId, "alarm")
			end
			self:PersonalMessage(args.spellId)
		end
	end
end

function mod:FuryOfTheAgesStart(args)
	self:Message(args.spellId, "yellow", CL.casting:format(L.enrage))
	if self:Dispeller("enrage", true, args.spellId) then
		self:PlaySound(args.spellId, "info")
	end
	if nextMist - GetTime() > 46 then
		self:Bar(args.spellId, 46, L.enrage)
	end
end

function mod:FuryOfTheAgesApplied(args)
	if bit.band(args.destFlags, 0x400) == 0 and self:Dispeller("enrage", true, args.spellId) then -- COMBATLOG_OBJECT_TYPE_PLAYER
		self:Message(args.spellId, "orange", CL.buff_boss:format(L.enrage))
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:FuryOfTheAgesDispel(args)
	if args.extraSpellId == 347490 then -- Fury of the Ages
		self:Message(347490, "green", CL.removed_by:format(L.enrage, args.sourceName))
	end
end

function mod:TheJailersGazeApplied(args)
	self:Message(args.spellId, "red", CL.percent:format(10, args.spellName))
	self:PlaySound(args.spellId, "long")
end
