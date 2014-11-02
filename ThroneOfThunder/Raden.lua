--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ra-den", 930, 831)
if not mod then return end
mod:RegisterEnableMob(69473)

--------------------------------------------------------------------------------
-- Locals
--

local animaCounter = 1
local ballCounter = 1
--local cooldownCounter = 1
local lastPower = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.vita_abilities = "Vita abilities"
	L.anima_abilities = "Anima abilities"
	L.worm = "Worm"
	L.worm_desc = "Summon worm"
	L.worm_icon = 138338
	L.balls = "Balls"
	L.balls_desc = "Anima (red) and Vita (blue) balls, that determine which abilities will Ra-den gain"
	L.balls_icon = 138321
	L.corruptedballs = "Corrupted balls"
	L.corruptedballs_desc = "Corrupted Vita and Anima balls, that either increases damage dealt (Vita) or maximum hp (Anima)"
	L.corruptedballs_icon = 139071
	L.unstablevitajumptarget = "Unstable vita jump target"
	L.unstablevitajumptarget_desc = "Tell you when you are the furthest from a player with Unstable Vita. If you emphasize this, you'll also get a countdown for when Unstable Vita is about to jump FROM you."
	L.unstablevitajumptarget_icon = 138297
	L.unstablevitajumptarget_message = "You're furthest from Unstable Vita"
	L.sensitivityfurthestbad = "Vita Sensitivity + Furthest = |cffff0000BAD|r!"
	L.kill_trigger = "Wait!" -- Wait! I am... I am not your enemy. You are powerful. More powerful than he was, even.... Perhaps you are right. Perhaps there is still hope.

	L.assistPrint = "A plugin called 'BigWigs_Ra-denAssist' has now been released for assistance during the Ra-den encounter that your guild may be interested in trying."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"worm", {138333, "TANK_HEALER"}, {138288, "FLASH", "ICON", "PROXIMITY"},
		138339, {138334, "TANK_HEALER"}, {138297, "FLASH", "ICON"}, "unstablevitajumptarget", {138372, "FLASH"},
		"corruptedballs",
		"balls", "stages", "berserk", "bosskill",
		-- XXX 139040 fix desc last phase balls
	}, {
		["worm"] = L.anima_abilities,
		[138339] = L.vita_abilities,
		["corruptedballs"] = CL.phase:format(2),
		["balls"] = "general",
	}
end

function mod:OnBossEnable()
	if not self.assistWarned then
		if not IsAddOnLoaded("BigWigs_Ra-denAssist") then
			BigWigs:Print(L.assistPrint)
		end
		self.assistWarned = true
	end

	-- Anima abilities
	self:Log("SPELL_CAST_START", "Worm", 138338)
	self:Log("SPELL_CAST_SUCCESS", "MurderousStrike", 138333)
	self:Log("SPELL_AURA_APPLIED", "UnstableAnimaApplied", 138288)
	self:Log("SPELL_AURA_REMOVED", "UnstableAnimaRemoved", 138288)
	self:Log("SPELL_DAMAGE", "UnstableAnimaRepeatedDamage", 138295)
	self:Log("SPELL_AURA_APPLIED", "AnimaSensitivityApplied", 139318)
	self:Log("SPELL_AURA_APPLIED", "AnimaSensitivityRemoved", 139318)
	-- Vita abilities
	self:Log("SPELL_CAST_START", "CracklingStalker", 138339)
	self:Log("SPELL_CAST_SUCCESS", "FatalStrike", 138334)
	self:Log("SPELL_AURA_APPLIED", "UnstableVitaApplied", 138297, 138308) -- initial cast, jumps
	self:Log("SPELL_AURA_REMOVED", "UnstableVitaRemoved", 138297, 138308) -- initial cast, jumps
	self:Log("SPELL_AURA_APPLIED", "VitaSensitivity", 138372)
	-- General
	self:Yell("Win", L["kill_trigger"])
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Boss1Succeeded", "boss1")
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "TankAbilityUpdate", "boss1")
	self:Log("SPELL_AURA_APPLIED", "Anima", 138331) -- on boss to start/stop timers
	self:Log("SPELL_AURA_APPLIED", "Vita", 138332) -- on boss to start/stop timers
	self:Log("SPELL_CAST_START", "Balls", 138321)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	self:Bar("balls", 11, L["balls"], 138321)
	self:Berserk(600) -- XXX assumed
	animaCounter = 1
	ballCounter = 1
	--cooldownCounter = 1
	lastPower = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

----------------------------------------
-- Anima Abilities
--

function mod:Anima(args)
	lastPower = "Anima"
	self:StopBar(138339) -- Crackling Stalker
	self:StopBar(138334) -- Fatal Strike
	self:StopBar(138297) -- Unstable Vita
	self:Bar("worm", 8, L["worm"], 138338)
	self:Bar(138333, 35) -- Murderous Strike
end

do
	-- XXX this proximity management might need some more testing ( our tactics ignore this phase )
	local prev, sensitiveToAnima = 0, {}
	local function proximityAfterUnstableAnimaDamage()
		local targets = {}
		for k, v in next, sensitiveToAnima do
			if v then
				targets[#targets+1] = k
			end
		end
		if UnitDebuff("player", mod:SpellName(138288)) then -- Unstable Anima
			mod:OpenProximity(138288, 8, targets)
		end
	end
	function mod:UnstableAnimaRepeatedDamage(args)
		local t = GetTime()
		if t-prev > 1 then
			prev = t
			self:Message(138288, "Attention", nil, CL["count"]:format(args.spellName, animaCounter))
			animaCounter = animaCounter + 1
			self:Bar(138288, 15, CL["count"]:format(args.spellName, animaCounter))
			self:ScheduleTimer(proximityAfterUnstableAnimaDamage, 0.2)
		end
	end

	function mod:AnimaSensitivityApplied(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(138288)
			self:OpenProximity(138288, 8, args.sourceName)
		end
		sensitiveToAnima[args.destName] = true
	end
	function mod:AnimaSensitivityRemoved(args)
		sensitiveToAnima[args.destName] = false
		if self:Me(args.destGUID) then
			self:CloseProximity(138288)
		end
	end
end

function mod:UnstableAnimaApplied(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	else
		self:OpenProximity(args.spellId, 8, args.destName, true)
	end
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Attention")
	animaCounter = animaCounter + 1
	self:Bar(args.spellId, 15, CL["count"]:format(args.spellName, animaCounter))
end

function mod:UnstableAnimaRemoved(args)
	self:CloseProximity(args.spellId)
end

function mod:Worm(args)
	self:Message("worm", "Urgent", nil, L["worm"], args.spellId)
end

function mod:MurderousStrike(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 35)
end

----------------------------------------
-- Vita abilities
--

function mod:Vita(args)
	lastPower = "Vita"
	self:StopBar(CL["count"]:format(self:SpellName(138288), animaCounter)) -- Unstable Anima
	self:StopBar(L["worm"]) -- Worm
	self:StopBar(138333) -- Murderous Strike
	self:Bar(138339, 8) -- Summon Craclking Stalker -- XXX shorten maybe?
	self:CDBar(138334, 10) -- Fatal Strike
end

function mod:CracklingStalker(args)
	self:Message(args.spellId, "Attention")
	self:Bar(args.spellId, 42)
end

function mod:VitaSensitivity(args)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Personal", "Info")
	end
end

do
	local timer, last, player = nil, nil, nil
	local function warnJumpTarget()
		if not player then
			mod:CancelTimer(timer)
			timer = nil
			return
		end

		local furthest, highestDistance = nil, 0
		for unit in mod:IterateGroup() do
			if UnitAffectingCombat(unit) and not UnitIsUnit(unit, player) then
				local distance = mod:Range(unit, player)
				if distance > highestDistance then
					highestDistance = distance
					furthest = unit
				end
			end
		end

		if furthest and furthest ~= last then
			mod:SecondaryIcon("unstablevitajumptarget", furthest)
			if UnitIsUnit(furthest, "player") then

				if UnitDebuff("player", mod:SpellName(138372)) then -- Vita Sensitivity
					mod:Flash(138372) -- Vita Sensitivity
					mod:Message("unstablevitajumptarget", "Personal", "Long", L["sensitivityfurthestbad"], 138372)
				else
					mod:Message("unstablevitajumptarget", "Personal", "Info", L["unstablevitajumptarget_message"], L.unstablevitajumptarget_icon)
				end
			end
			last = furthest
		end
	end

	function mod:UnstableVitaApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(138297)
			self:Bar("unstablevitajumptarget", 5, CL["you"]:format(args.spellName), args.spellId)
		else
			self:TargetBar(138297, 5, args.destName)
		end
		self:TargetMessage(138297, args.destName, "Personal", "Info")
		self:PrimaryIcon(138297, args.destName)

		last = nil
		player = args.destName
		if not timer and self.db.profile.unstablevitajumptarget > 0 then -- pretty wasteful to do the scanning if the option isn't on
			timer = self:ScheduleRepeatingTimer(warnJumpTarget, 0.5)
		end
	end
	function mod:UnstableVitaRemoved(args)
		self:StopBar(args.spellId)
		self:SecondaryIcon("unstablevitajumptarget")
		self:PrimaryIcon(args.spellId)
		player = nil
	end
end

function mod:FatalStrike(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
	self:CDBar(args.spellId, 10)
end

----------------------------------------
-- General
--

function mod:Boss1Succeeded(unitId, spellName, _, _, spellId)
	if spellId == 139040 then
		self:CDBar("corruptedballs", 16, L["corruptedballs"], 139071)
		self:Message("corruptedballs", "Important", "Alarm", L["corruptedballs"], 139071)
	end
end

function mod:UNIT_HEALTH_FREQUENT(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 43 then
		self:Message("stages", "Neutral", "Info", CL["soon"]:format(CL["phase"]:format(2)), false)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:TankAbilityUpdate(unit)
	local power = UnitPower(unit)
	if UnitBuff(unit, self:SpellName(138331)) then -- Anima - Murderous Strike
		if power == 30 then
			self:Bar(138333, 25)
		elseif power == 60 then
			self:Bar(138333, 15)
		elseif power == 90 then
			self:Bar(138333, 5)
		end
	elseif UnitBuff(unit, self:SpellName(138332)) then -- Vita - Fatal Strike
		if power == 20 then
			self:Bar(138334, 8)
		elseif power == 40 then
			self:Bar(138334, 6)
		elseif power == 50 then
			self:Bar(138334, 5)
		-- don't know if there is much point starting a bar shorter than 5 sec
		end
	end
end

function mod:Balls(args)
	self:Message("balls", "Urgent", "Warning", CL["count"]:format(L["balls"], ballCounter), args.spellId)
	ballCounter = ballCounter + 1
	self:Bar("balls", 33, CL["count"]:format(L["balls"], ballCounter), args.spellId)
end

