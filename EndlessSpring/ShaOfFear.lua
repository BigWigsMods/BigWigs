
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Fear", 886, 709)
if not mod then return end
mod:RegisterEnableMob(60999, 61003) -- Sha of Fear, Dread Spawn

--------------------------------------------------------------------------------
-- Locals
--

local swingCounter, thrashCounter, resetNext = 0, 0, nil
local atSha = true
local nextFear = 0
local submergeCounter = 0
local cackleCounter = 1
local phase = 1
local dreadSpawns = {}

local function is25man() -- having to test two values is annoying
	local diff = mod:Difficulty()
	return diff == 4 or diff == 6
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the number of swings before Thrash"

	L.damage = "Damage"
	L.miss = "Miss"

	L.throw = "Throw!"
	L.ball_dropped = "Ball dropped!"
	L.ball_you = "You have the ball!"
	L.ball = "Ball"

	L.cooldown_reset = "Your cooldowns reset!"

	L.ability_cd = "Ability cooldown"
	L.ability_cd_desc = "Try and guess in which order abilities will be used after an Emerge"
	L.ability_cd_icon = 120458

	L.huddle_or_spout = "Huddle or Spout"
	L.huddle_or_strike = "Huddle or Strike"
	L.strike_or_spout = "Strike or Spout"
	L.huddle_or_spout_or_strike =  "Huddle or Spout or Strike"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{120519, "FLASHSHAKE"}, {120629, "SAY"}, 120669, {120268, "FLASHSHAKE", "PROXIMITY"}, 120455, 120672, {"ej:6109", "FLASHSHAKE"}, "ej:6107", 129378, "ability_cd",
		"ej:6699", 119414, 129147, {119519, "FLASHSHAKE", "SAY"},
		{ 119888, "FLASHSHAKE" }, 118977,
		"berserk", "proximity", "bosskill",
	}, {
		[120519] = "heroic",
		["ej:6699"] = "ej:6086",
		[119888] = "ej:6089",
		berserk = "general",
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
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Death("Deaths", 60999, 61003)
end


function mod:OnEngage(diff)
	cackleCounter = 1
	self:Bar(119414, 119414, 33, 119414) -- Breath of Fear
	self:Bar(129147, ("%s (%d)"):format(self:SpellName(129147), cackleCounter), is25man() and 25 or 41, 129147) -- Ominous Cackle
	self:Bar("ej:6699", 131996, 10, 131996) -- Thrash
	--self:Berserk(900) -- we start in UNIT_SPELLCAST_SUCCEEDED need to check if commenting it out here does not brake non heroic
	swingCounter, thrashCounter, resetNext = 0, 0, nil
	self:OpenProximity(5) -- might be less
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
	local huddleList, scheduled, huddleTimer = mod:NewTargetList(), nil, nil
	local function warnNext()
		if huddleUsed and spoutUsed and not strikeUsed then
			mod:Bar(120672, 120672, 10, 120672) -- strike
		elseif strikeUsed and spoutUsed and not huddleUsed then
			mod:Bar(120629, 120629, 10, 120629) -- huddle
		elseif huddleUsed and strikeUsed and not spoutUsed then
			mod:Bar(120519, 120519, 10, 120519) -- spout
		elseif huddleUsed and not strikeUsed and not spoutUsed then
			mod:Bar("ability_cd", L["strike_or_spout"], 10, 120458)
		elseif strikeUsed and not huddleUsed and not spoutUsed then
			mod:Bar("ability_cd", L["huddle_or_spout"], 10, 120458)
		elseif spoutUsed and not huddleUsed and not strikeUsed then
			mod:Bar("ability_cd", L["huddle_or_strike"], 10, 120458)
		end
	end
	local function warnhuddle(spellName)
		mod:TargetMessage(120629, spellName, huddleList, "Important", 120629, "Alert")
		scheduled = nil
	end
	function mod:HuddleInTerror(player, spellId, _, _, spellName)
		huddleUsed = true
		warnNext()
		huddleList[#huddleList + 1] = player
		if UnitIsUnit(player, "player") then
			self:Say(spellId, CL["say"]:format(spellName))
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnhuddle, 0.1, spellName)
		end
	end
	function mod:Waterspout(_, spellId, _, _, spellName)
		spoutUsed = true
		warnNext()
		self:Message(spellId, spellName, "Urgent", spellId)
	end
	function mod:ImplacableStrike(_, spellId, _, _, spellName)
		strikeUsed = true
		warnNext()
		self:Message(spellId, spellName, "Attention", spellId, "Alarm")
	end
	function mod:Emerge(_, spellId)
		huddleUsed, strikeUsed, spoutUsed = nil, nil, nil
		self:Bar("ability_cd", L["huddle_or_spout_or_strike"], 10, spellId)
	end
end

function mod:Submerge(_, spellId, _, _, spellName)
	submergeCounter = submergeCounter + 1
	self:Message(spellId, ("%s (%d)"):format(spellName, submergeCounter), "Attention", spellId)
	self:Bar(spellId, ("%s (%d)"):format(spellName, submergeCounter+1), 52, spellId)
end

function mod:FadingLight(player, spellId)
	if UnitIsUnit("player", player) then
		self:LocalMessage(129378, L["cooldown_reset"], "Positive", spellId, "Long")
	end
end

do
	local scheduled = nil
	local function anndounceDreadSpawnCount(source)
		local dreadpSpawnCounter = 0
		for k, v in pairs(dreadSpawns) do
			if v then
				dreadpSpawnCounter = dreadpSpawnCounter + 1
			end
		end
		mod:Message("ej:6107", ("%s (%d)"):format(source, dreadpSpawnCounter), "Positive", 128419) -- positive, tho we are not really happy about it (gathering speed the adds ability icon)
		scheduled = nil
	end
	function mod:DreadSpawnSingleCast(_, _, source, _, _, _, _, _, _, _, sGUID)
		if not dreadSpawns[sGUID] then
			dreadSpawns[sGUID] = true
			if not scheduled then
				scheduled = self:ScheduleTimer(anndounceDreadSpawnCount, 0.2, source)
			end
		end
	end
	function mod:Deaths(mobId, guid, player)
		if mobId == 60999 then -- boss
			self:Win()
		elseif mobId == 61003 then -- dread spawn
			dreadSpawns[guid] = nil -- is this even needed?
			if not scheduled then
				scheduled = self:ScheduleTimer(anndounceDreadSpawnCount, 0.2, player)
			end
		end
	end
end

do
	local prev = 0
	function mod:EternalDarkness(_, spellId, _, _, spellName)
		if UnitBuff("player", self:SpellName(120268)) then -- champion of the light
			local t = GetTime()
			if t-prev > 1 then
				self:Message("ej:6109", L["throw"], "Personal", spellId, "Long")
				self:FlashShake("ej:6109")
				prev = t
			end
		end
	end
end

function mod:ChampionOfTheLight(player, spellId, _, _, spellName)
	self:TargetMessage(spellId, L["ball"], player, "Positive", spellId, "Long")
	--self:CloseProximity(spellId) -- uncomment when mapdata becomes available for last phase
	if UnitIsUnit("player", player) then
		--self:LocalMessage(spellId, L["ball_you"], "Personal", spellId, "Long") -- should maybe have a name like "Ball on you PASS IT!"
		self:FlashShake(spellId)
	end
end

do
	local function checkForDead(player)
		if UnitIsDead(player) then
			mod:Message(120669, L["ball_dropped"], "Important", 120669)
		end
	end
	function mod:ChampionOfTheLightRemoved(player, spellId)
		self:ScheduleTimer(checkForDead, 0.1, player)
		--self:OpenProximity(40, spellId, player, true) -- does not really work due to some map data issues in last phase -- uncomment when mapdata becomes available
	end
end

function mod:NakedAndAfraid(player, spellId, _, _, spellName)
	if self:Tank() then
		self:TargetMessage(spellId, spellName, player, "Urgent", spellId)
		self:Bar(spellId, spellName, 31, spellId)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if unit ~= "boss1" then return end
	if spellId == 114936 then -- Heroic Transition
		phase = 2
		self:CloseProximity()
		self:StopBar(self:SpellName(119414)) -- breath of fear
		self:StopBar(("%s (%d)"):format(self:SpellName(129147), cackleCounter)) -- ominous cackle
	elseif spellId == 120638 then -- Waterspout and Huddle Timing
		--self:Bar(120629, 120629, 10, 120629) -- Huddle in terror
		--self:StopBar("~"..self:SpellName(120519)) -- waterspout
		--self:Bar(120519, 120519, 30, 120519) -- waterspout
	elseif spellId == 62535 then -- 2nd phase Berserk for that 1 sec accuraccy
		self:Berserk(900)
	end
end


function mod:WaterspoutApplied(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
		self:FlashShake(spellId)
	end
end

do -- COPY PASTE ACTION FROM COBALT MINE! see if this works
	local timer, fired = nil, 0
	local eerieSkull = mod:SpellName(119519)
	local function skullWarn(unitId)
		fired = fired + 1
		local unitIdTarget = unitId.."target"
		local player = UnitName(unitIdTarget)
		if player and (not UnitDetailedThreatSituation(unitIdTarget, unitId) or fired > 13) then
			-- If we've done 14 (0.7s) checks and still not passing the threat check, it's probably being cast on the tank
			if UnitIsUnit("player", player) then
				mod:LocalMessage(119519, CL["you"]:format(eerieSkull), "Urgent", 119519, "Alarm")
				mod:Say(119519, CL["say"]:format(eerieSkull))
				mod:FlashShake(119519)
			end
			mod:CancelTimer(timer, true)
			timer = nil
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
		end
	end
	function mod:EerieSkull()
		fired = 0
		if not timer and not self:LFR() then
			timer = self:ScheduleRepeatingTimer(skullWarn, 0.05, "boss1")
		end
	end
end

function mod:Thrash(_, spellId, _, _, spellName)
	resetNext = 2
	if atSha and (self:Healer() or self:Tank()) then
		--[[ don't really need a counter until Dread Expanse (120289) I'll fancy this up after I get some logs
		if phase2 then
			thrashCounter = thrashCounter + 1
			if thrashCounter == 3 then
				self:DelayedMessage("ej:6699", 4, CL["custom_sec"]:format(self:SpellName(132007), 6), "Attention", 132007, self:Tank() or self:Healer() and "Info" or nil) -- Dread Thrash
				self:Bar("ej:6699", 132007, 10, 132007)
			else
				self:Bar("ej:6699", ("%s (%d)"):format(spellName, thrashCounter + 1), 10, spellId)
			end
			self:Message("ej:6699", ("%s (%d)"):format(spellName, thrashCounter), "Important", spellId)
		else
		end
		--]]
		self:Message("ej:6699", spellName, "Important", spellId)
		self:Bar("ej:6699", spellName, 10, spellId)
	end
end

function mod:DreadThrash(_, spellId, _, _, spellName)
	thrashCounter = 0
	resetNext = 5
	if self:Healer() or self:Tank() then
		self:Message("ej:6699", spellName, "Important", spellId, "Alarm")
		--self:Bar("ej:6699", ("%s (%d)"):format(self:SpellName(131996), thrashCounter + 1), 10, 131996) -- Thrash
		self:Bar("ej:6699", 131996, 10, 131996) -- Thrash
	end
end

function mod:Swing(player, damage, _, _, _, _, _, _, _, _, sGUID)
	if self:GetCID(sGUID) == 60999 then
		swingCounter = swingCounter + 1
		if swingCounter > 0 and UnitIsUnit("player", player) then --just the current tank
			self:Message("ej:6699", ("%s (%d){%s}"):format(L["swing"], swingCounter, tonumber(damage) and L["damage"] or L["miss"]), "Positive", 5547)
		end
		if resetNext then
			swingCounter = -resetNext -- ignore the thrash hits
			resetNext = nil
		end
	end
end

function mod:DeathBlossom(_, spellId, _, _, spellName)
	if not atSha then
		self:FlashShake(spellId)
		self:Bar(spellId, CL["cast"]:format(spellName), 2.25, spellId) -- so it can be emphasized for countdown
		self:Message(spellId, spellName, "Important", spellId, "Alert")
	end
end

function mod:Fearless(player, spellId, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT") -- just have it here for now
		self:Bar(119414, self:SpellName(119414), nextFear - GetTime(), 119414)
		self:OpenProximity(5) -- might be less
		atSha = true
		self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(119888))) -- Death Blossom
		self:Bar(spellId, spellName, 30, spellId)
		self:DelayedMessage(spellId, 22, L["fading_soon"]:format(spellName), "Attention", spellId)
	end
end

function mod:FearlessRemoved(player, spellId, _, _, spellName)
	self:StopBar(spellName) -- this is needed so combat ressed people don't get confused because debuff gets removed if you get CR
end

function mod:BreathOfFear(_, spellId, _, _, spellName)
	nextFear = GetTime() + 33.3
	if atSha then -- Don't care about Sha while at a shrine and you have Fearless when you come back
		self:Bar(spellId, spellName, 33.3, spellId)
		self:DelayedMessage(spellId, 25, CL["soon"]:format(spellName), "Attention", spellId)
	end
end

function mod:OminousCackle(_, spellId, _, _, spellName)
	cackleCounter = cackleCounter + 1
	self:Bar(spellId, ("%s (%d)"):format(spellName, cackleCounter), is25man() and 45 or 90, spellId)
end

function mod:OminousCackleRemoved(player) -- set it here, because at this point we are surely out of range of the other platforms
	if UnitIsUnit("player", player) then
		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
		atSha = nil
	end
end

do
	local cackleTargets, scheduled = mod:NewTargetList(), nil
	local function warnCackle(spellId)
		mod:TargetMessage(spellId, spellId, cackleTargets, "Urgent", spellId)
		scheduled = nil
	end
	function mod:OminousCackleApplied(player, spellId)
		cackleTargets[#cackleTargets + 1] = player
		if UnitIsUnit("player", player) then
			self:CloseProximity()
			self:StopBar(119414) -- Breath of Fear
			self:CancelDelayedMessage(CL["soon"]:format(self:SpellName(119414)))
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnCackle, 0.1, spellId)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if not atSha then -- just to be safe
		local mobId = self:GetCID(UnitGUID(unitId))
		if mobId == 61046 or mobId == 61038 or mobId == 61042 then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < 30 then
				self:Message(119888, CL["soon"]:format(self:SpellName(119888)), "Attention", 119888) -- Death Blossom
				-- lets assume for now if the mob gets healed up by the orbs from below 20% then it can not cast death blossom again, if that is not the case
				-- then comment out this UnregisterEvent and uncomment the UnregisterEvent from :Fearless
				self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
			end
		end
	end
end
