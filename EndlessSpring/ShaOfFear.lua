
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Fear", 886, 709)
if not mod then return end
mod:RegisterEnableMob(60999, 61003) -- Sha of Fear, Dread Spawn

--------------------------------------------------------------------------------
-- Locals
--

local swingCounter, thrashCounter, thrashNext = 0, 0, nil
local atSha = true
local nextFear = 0
local submergeCounter = 0
local cackleCounter = 1
local phase = 1
local dreadSpawns = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the swings preceeding Thrash."

	L.throw = "Throw!"
	L.ball_dropped = "Ball dropped!"
	L.ball_you = "You have the ball!"
	L.ball = "Ball"

	L.cooldown_reset = "Your cooldowns have been reset!"

	L.ability_cd = "Ability cooldown bar"
	L.ability_cd_desc = "Show the next possible ability or abilities."
	L.ability_cd_icon = 120458

	L.strike_or_spout = "Strike or Spout"
	L.huddle_or_spout_or_strike = "Huddle or Spout or Strike"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-6699, "TANK_HEALER"}, 119414, 129147, {119519, "FLASH", "SAY"},
		{ 119888, "FLASH" }, 118977,
		129378, {-6700, "TANK_HEALER"}, {120669, "TANK"}, "ability_cd", {120629, "SAY"}, {120519, "FLASH"}, 120672, 120455, {120268, "FLASH", "PROXIMITY"}, {-6109, "FLASH"}, -6107,
		{"swing", "TANK"}, "berserk", "proximity", "bosskill",
	}, {
		[-6699] = -6086,
		[119888] = -6089,
		[129378] = ("%s (%s)"):format(self:SpellName(120289), CL["heroic"]),
		swing = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "BreathOfFear", 119414)
	self:Log("SPELL_CAST_START", "OminousCackle", 119692, 119693, 119593)
	self:Log("SPELL_AURA_APPLIED", "OminousCackleApplied", 129147)
	self:Log("SPELL_AURA_REMOVED", "OminousCackleRemoved", 129147)
	self:Log("SPELL_AURA_APPLIED", "Thrash", 131996)
	self:Log("SPELL_AURA_APPLIED", "DreadThrash", 132007)
	self:Log("SPELL_AURA_APPLIED", "Fearless", 118977)
	self:Log("SPELL_AURA_REMOVED", "FearlessRemoved", 118977)
	self:Log("SPELL_CAST_START", "DeathBlossom", 119888)
	self:Log("SPELL_CAST_SUCCESS", "EerieSkull", 119519)
	-- Heroic
	self:Log("SPELL_CAST_START", "Waterspout", 120519)
	self:Log("SPELL_AURA_APPLIED", "WaterspoutApplied", 120519)
	self:Log("SPELL_AURA_APPLIED", "HuddleInTerror", 120629)
	self:Log("SPELL_CAST_SUCCESS", "NakedAndAfraid", 120669)
	self:Log("SPELL_AURA_APPLIED", "ChampionOfTheLight", 120268)
	self:Log("SPELL_AURA_REMOVED", "ChampionOfTheLightRemoved", 120268)
	self:Log("SPELL_CAST_START", "Submerge", 120455)
	self:Log("SPELL_CAST_START", "Emerge", 120458)
	self:Log("SPELL_CAST_START", "ImplacableStrike", 120672)
	self:Log("SPELL_CAST_START", "EternalDarkness", 120394)
	self:Log("SPELL_CAST_SUCCESS", "DreadSpawnSingleCast", 120388)
	self:Log("SPELL_AURA_APPLIED", "FadingLight", 129378)

	self:Log("SWING_DAMAGE", "Swing", "*")
	self:Log("SWING_MISSED", "Swing", "*")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Transitions", "boss1")

	self:Death("Win", 60999)
	self:Death("DreadSpawnDeath", 61003)
end


function mod:OnEngage(diff)
	cackleCounter = 1
	self:Bar(119414, 33) -- Breath of Fear
	self:Bar(129147, (diff == 4 or diff == 6) and 25 or 41, CL["count"]:format(self:SpellName(129147), cackleCounter)) -- Ominous Cackle
	swingCounter, thrashCounter, thrashNext = 0, 0, nil
	self:OpenProximity("proximity", 4) -- for Penetrating Bolt
	atSha = true
	nextFear = 0
	submergeCounter = 0
	wipe(dreadSpawns)
	phase = 1
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- intelligent ability warning for last phase
	local huddleUsed, strikeUsed, spoutUsed = nil, nil, nil
	local huddleList, scheduled = mod:NewTargetList(), nil
	local function warnNext()
		if not huddleUsed then -- huddle is always first or second
			mod:Bar("ability_cd", 10, 120629) -- huddle
		elseif not strikeUsed and not spoutUsed then -- huddle was first
			mod:Bar("ability_cd", 10, L["strike_or_spout"], L.ability_cd_icon)
		elseif spoutUsed then
			mod:Bar("ability_cd", 10, 120672) -- strike
		elseif strikeUsed then
			mod:Bar("ability_cd", 10, 120519) -- spout
		end
	end
	local function warnHuddle(spellId)
		mod:TargetMessage(spellId, huddleList, "Important", "Alert")
		scheduled = nil
	end
	function mod:HuddleInTerror(args)
		huddleUsed = true
		warnNext()
		huddleList[#huddleList + 1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnHuddle, 0.3, args.spellId)
		end
	end
	function mod:Waterspout(args)
		spoutUsed = true
		warnNext()
		self:Message(args.spellId, "Urgent")
	end
	function mod:ImplacableStrike(args)
		strikeUsed = true
		warnNext()
		self:Message(args.spellId, "Attention", "Alarm")
	end
	function mod:Emerge(args)
		huddleUsed, strikeUsed, spoutUsed = nil, nil, nil
		self:Bar("ability_cd", 10, L["huddle_or_spout_or_strike"], L.ability_cd_icon)
	end
end

function mod:Submerge(args)
	submergeCounter = submergeCounter + 1
	self:Message(args.spellId, "Attention", nil, CL["count"]:format(args.spellName, submergeCounter))
	self:Bar(args.spellId, 52, CL["count"]:format(args.spellName, submergeCounter+1))
end

function mod:FadingLight(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Positive", "Long", L["cooldown_reset"])
	end
end

do
	local scheduled = nil
	local function announceDreadSpawnCount(source)
		local dreadSpawnCounter = 0
		for guid in next, dreadSpawns do
			dreadSpawnCounter = dreadSpawnCounter + 1
		end
		mod:Message(-6107, "Positive", nil, CL["count"]:format(source, dreadSpawnCounter), 128419)
		scheduled = nil
	end
	function mod:DreadSpawnSingleCast(args)
		if not dreadSpawns[args.sourceGUID] then
			dreadSpawns[args.sourceGUID] = true
			if not scheduled then
				scheduled = self:ScheduleTimer(announceDreadSpawnCount, 0.2, args.sourceName)
			end
		end
	end
	function mod:DreadSpawnDeath(args)
		dreadSpawns[args.destGUID] = nil
		if not scheduled then
			scheduled = self:ScheduleTimer(announceDreadSpawnCount, 0.2, args.destName)
		end
	end
end

do
	local prev = 0
	local champion = mod:SpellName(120268) -- Champion of the Light
	function mod:EternalDarkness(args)
		if UnitBuff("player", champion) then
			local t = GetTime()
			if t-prev > 1 then
				self:Message(-6109, "Personal", "Long", L["throw"])
				self:Flash(-6109)
				prev = t
			end
		end
	end
end

function mod:ChampionOfTheLight(args)
	self:TargetMessage(args.spellId, args.destName, "Positive", "Long", L["ball"])
	--self:CloseProximity(args.spellId) -- uncomment when mapdata becomes available for last phase
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
end

do
	local function checkForDead(player)
		if UnitIsDead(player) then
			mod:Message(120669, "Important", nil, L["ball_dropped"])
		end
	end
	function mod:ChampionOfTheLightRemoved(args)
		self:ScheduleTimer(checkForDead, 0.1, args.destName)
		--self:OpenProximity(args.spellId, 40, args.destName, true) -- does not really work due to some map data issues in last phase -- uncomment when mapdata becomes available
	end
end

function mod:NakedAndAfraid(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Info", nil, nil, true)
	self:Bar(args.spellId, 31)
end

function mod:Transitions(unit, spellName, _, _, spellId)
	if spellId == 114936 then -- Heroic Transition
		phase = 2
		self:CloseProximity()
		self:StopBar(119414) -- Breath of Fear
		self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(119414))) -- Breath of Fear
		self:StopBar(CL["count"]:format(self:SpellName(129147), cackleCounter)) -- Ominous Cackle
		self:StopBar(131996) -- Thrash
		swingCounter = 0
	elseif spellId == 62535 then -- Berserk for that 1 sec accuracy
		self:Berserk(900, phase == 2)
		if phase == 2 then
			-- Phase 2 - Berserk in 15 min!
			self:Message("berserk", "Attention", nil, CL["phase"]:format(2).." - "..CL["custom_min"]:format(spellName, 15), 26662)
			-- start Submerge timer using the current power and the new regen rate
			local left = 1 - (UnitPower("boss1") / UnitPowerMax("boss1")) * 52
			self:Bar(120455, left, CL["count"]:format(self:SpellName(120455), 1))
		end
	end
end

do
	local prev = 0
	function mod:WaterspoutApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		elseif self:Range(args.destName) < 3 then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:RangeMessage(args.spellId)
				self:Flash(args.spellId)
			end
		end
	end
end

do
	local timer, fired = nil, 0
	local eerieSkull = mod:SpellName(119519)
	local function skullWarn(unitId)
		fired = fired + 1
		local player = UnitName("boss1target")
		if player and ((not UnitDetailedThreatSituation("boss1target", "boss1") and not mod:Tank("boss1target")) or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			if UnitIsUnit("player", player) then
				mod:Message(119519, "Urgent", "Alarm", CL["you"]:format(eerieSkull))
				mod:Say(119519, eerieSkull)
				mod:Flash(119519)
			end
			mod:CancelTimer(timer)
			timer = nil
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:EerieSkull()
		fired = 0
		if not timer and not self:LFR() then
			timer = self:ScheduleRepeatingTimer(skullWarn, 0.05)
		end
	end
end

function mod:Thrash(args)
	thrashNext = 2
	if phase == 2 then
		thrashCounter = thrashCounter + 1
		self:Message(-6699, "Urgent", nil, CL["count"]:format(args.spellName, thrashCounter))
		if thrashCounter == 3 then
			self:Bar(-6700, 10) -- Dread Thrash
		else
			self:Bar(-6699, 10, CL["count"]:format(args.spellName, thrashCounter + 1))
		end
	elseif atSha then
		self:Message(-6699, "Important")
		self:Bar(-6699, 10)
	end
end

function mod:DreadThrash(args)
	thrashCounter = 0
	thrashNext = 5
	self:Message(-6700, "Important", "Alarm")
	self:Bar(-6699, 10, CL["count"]:format(self:SpellName(131996), thrashCounter + 1)) -- Thrash
end

do
	local thrashSwing
	function mod:Swing(args)
		if self:MobId(args.sourceGUID) ~= 60999 then return end

		swingCounter = swingCounter + 1
		if thrashNext then -- thrash triggering swing
			thrashSwing = swingCounter
			swingCounter = -thrashNext
			thrashNext = nil
		elseif self:Me(args.destGUID) then --just the current tank
			if swingCounter > 0 then -- normal swing
				self:Message("swing", "Positive", nil, CL["count"]:format(L["swing"], swingCounter), 5547) -- hammer icon (meeeeh)
			elseif swingCounter == 0 then -- last extra swing
				self:Message("swing", "Positive", nil, CL["other"]:format(CL["count"]:format(L["swing"], thrashSwing), self:SpellName(131996)), 12972) -- Swing (4): Thrash (thrashy icon)
			end
		end
	end
end

function mod:DeathBlossom(args)
	if not atSha then
		self:Flash(args.spellId)
		self:Bar(args.spellId, 2.25, CL["cast"]:format(args.spellName)) -- so it can be emphasized for countdown
		self:Message(args.spellId, "Important", "Alert")
	end
end

function mod:Fearless(args)
	if self:Me(args.destGUID) then
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus") -- backup
		self:OpenProximity("proximity", 4) -- Penetrating Bolt
		atSha = true
		self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(119888))) -- Death Blossom
		self:Bar(args.spellId, 30)
		self:DelayedMessage(args.spellId, 22, "Attention", L["fading_soon"]:format(args.spellName))

		-- resume Breath of Fear bar/message
		local left = nextFear - GetTime()
		self:Bar(119414, left)
		if left > 10 then
			self:DelayedMessage(119414, left-8, "Attention", CL["soon"]:format(self:SpellName(119414)), false, "Long")
		end
	end
end

function mod:FearlessRemoved(args)
	self:StopBar(args.spellName) -- this is needed so combat ressed people don't get confused because debuff gets removed if you get CR
end

function mod:BreathOfFear(args)
	nextFear = GetTime() + 33.3
	if atSha then -- Don't care about Sha while at a shrine and you have Fearless when you come back
		self:Bar(args.spellId, 33.3)
		self:DelayedMessage(args.spellId, 25, "Attention", CL["soon"]:format(args.spellName), false, "Long")
	end
end

function mod:OminousCackle(args)
	cackleCounter = cackleCounter + 1
	local diff = self:Difficulty()
	self:Bar(args.spellId, (diff == 4 or diff == 6) and 45 or 90, CL["count"]:format(args.spellName, cackleCounter))
end

function mod:OminousCackleRemoved(args) -- set it here, because at this point we are surely out of range of the other platforms
	if self:Me(args.destGUID) then
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "BlossomPreWarn", "target", "focus")
	end
end

do
	local cackleTargets, scheduled = mod:NewTargetList(), nil
	local function warnCackle(spellId)
		mod:TargetMessage(spellId, cackleTargets, "Urgent")
		scheduled = nil
	end
	function mod:OminousCackleApplied(args)
		cackleTargets[#cackleTargets + 1] = args.destName
		if self:Me(args.destGUID) then
			atSha = nil
			self:CloseProximity()
			self:StopBar(131996) -- Thrash
			self:StopBar(119414) -- Breath of Fear
			self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(119414))) -- Breath of Fear
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnCackle, 0.1, args.spellId)
		end
	end
end

function mod:BlossomPreWarn(unitId)
	local mobId = self:MobId(UnitGUID(unitId))
	if mobId == 61046 or mobId == 61038 or mobId == 61042 then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 30 then
			self:Message(119888, "Attention", nil, CL["soon"]:format(self:SpellName(119888))) -- Death Blossom
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "target", "focus")
		end
	end
end

