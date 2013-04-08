
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Dark Animus", 930, 824)
if not mod then return end
mod:RegisterEnableMob(69701, 69700, 69699, 69427) -- Anima Golem, Large Anima Golem, Massive Anima Golem, Dark Animus

--------------------------------------------------------------------------------
-- Locals
--

local nextPower = 15
local joltCounter = 0
local matterSwapTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "The orb explodes!"

	L.matterswap = GetSpellInfo(139919)
	L.matterswap_desc = "A player with Matter Swap is far away from you. You will swap places with them if they are dispelled."
	L.matterswap_message = "You are furthest for Matter Swap!"
	L.matterswap_icon = 138618

	L.siphon_power = "Siphon Anima (%d%%)"
	L.siphon_power_soon = "Siphon Anima (%d%%) %s soon!"
	L.slam_message = "Slam"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{138485, "FLASH", "SAY"},
		{138609, "FLASH", "ICON", "DISPEL"}, {"matterswap", "FLASH", "ICON"}, {-7770, "TANK"},
		138644, 136954, 138691, 138780, {138763, "FLASH"}, {138729, "FLASH"},
		"berserk", "bosskill",
	}, {
		[138485] = -7759, -- Large Anima Golem
		[138609] = -7760, -- Massive Anima Golem
		[138644] = -7762, -- Dark Animus
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "BossEngage") -- use it to detect when the actual boss enters the fight
	self:Emote("Engage", L["engage_trigger"])

	-- Dark Animus
	self:Log("SPELL_CAST_START", "FullPower", 138729)
	self:Log("SPELL_CAST_START", "InterruptingJolt", 138763, 139867, 139869)
	self:Log("SPELL_CAST_SUCCESS", "EmpowerGolem", 138780)
	self:Log("SPELL_AURA_APPLIED", "AnimaFontApplied", 138691)
	self:Log("SPELL_AURA_REFRESH", "AnimaFontRefresh", 138691)
	self:Log("SPELL_AURA_REMOVED", "AnimaFontRemoved", 138691)
	self:Log("SPELL_CAST_START", "AnimaRing", 136954) -- this is 1 sec faster than SUCCESS but has no destName
	self:Log("SPELL_CAST_SUCCESS", "SiphonAnima", 138644)
	-- Massive Anima Golem
	self:Log("SPELL_AURA_APPLIED_DOSE", "ExplosiveSlam", 138569)
	self:Log("SPELL_AURA_APPLIED", "ExplosiveSlam", 138569)
	self:Log("SPELL_AURA_REMOVED", "MatterSwapRemoved", 138609)
	self:Log("SPELL_AURA_APPLIED", "MatterSwapApplied", 138609)
	-- Large Anima Golem
	self:Log("SPELL_DAMAGE", "CrimsonWake", 138485)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER") -- looks like this is forever emote


	self:Death("Win", 69427)
end

function mod:OnEngage()
	if not self:Heroic() then
		-- this is needed mainly for normal, when you wipe before boss is engaged
		self:StopWipeCheck()
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "StartWipeCheck")
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "StopWipeCheck")
	end
	--self:Berserk(600)
	nextPower = 15
	joltCounter = 0
	wipe(matterSwapTargets)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

----------------------------------------
-- Dark Animus
--

function mod:FullPower(args)
	self:Message(args.spellId, "Important", "Long")
	self:Flash(args.spellId)
end

function mod:InterruptingJolt(args)
	local caster = UnitPowerType("player") == 0 or self:Healer()
	if caster then self:Flash(args.spellId) end

	joltCounter = joltCounter + 1
	self:StopBar(CL["count"]:format(args.spellName, joltCounter))
	self:Message(args.spellId, caster and "Personal" or "Attention", caster and "Long", CL["count"]:format(args.spellName, joltCounter))
	self:Bar(args.spellId, 22, CL["count"]:format(args.spellName, joltCounter+1))
end

function mod:EmpowerGolem(args)
	self:Message(138780, "Attention")
	self:Bar(138780, 15.5)
end

function mod:AnimaFontApplied(args)
	-- cooldown seems to be 20-30ish
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	self:TargetBar(args.spellId, 30, args.destName)
end

function mod:AnimaFontRefresh(args)
	local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
	local duration = expires - GetTime()
	self:TargetBar(args.spellId, duration, args.destName)
end

function mod:AnimaFontRemoved(args)
	self:StopBar(args.spellId, args.destName)
end

function mod:AnimaRing(args)
	self:Message(args.spellId, "Important", "Alert")
	self:CDBar(args.spellId, 22)
end

do
	local function warnPower(spellId)
		local power = UnitPower("boss1")
		if power > nextPower then
			if nextPower == 15 then
				mod:Message(spellId, "Attention", "Info", L["siphon_power_soon"]:format(power, mod:SpellName(136954))) -- Anima Ring (25)
			elseif nextPower == 45 then
				mod:Message(spellId, "Attention", "Info", L["siphon_power_soon"]:format(power, mod:SpellName(138691))) -- Anima Font (50)
			elseif nextPower == 70 then
				mod:Message(spellId, "Attention", "Info", L["siphon_power_soon"]:format(power, mod:SpellName(138763))) -- Interrupting Jolt (75)
			elseif nextPower == 95 then
				mod:Message(spellId, "Attention", "Warning", L["siphon_power_soon"]:format(power, mod:SpellName(138729))) -- Full Power (100)
			end
			nextPower = nextPower + 30
		else
			mod:Message(spellId, "Neutral", nil, L["siphon_power"]:format(power))
		end
	end
	function mod:SiphonAnima(args)
		self:Bar(args.spellId, self:Heroic() and 20 or 6)
		self:ScheduleTimer(warnPower, 0.1, args.spellId) -- the power update happens after the cast
	end
end

function mod:BossEngage()
	self:CheckBossStatus()
	if self:MobId(UnitGUID("boss1")) == 69427 then
		self:Bar(138644, self:Heroic() and 120 or 30) -- Siphon Anima
		if self:Heroic() then
			self:Bar(138780, 7) -- Empower Golem
		end
	end
end

----------------------------------------
-- Massive Anima Golem
--

function mod:ExplosiveSlam(args)
	local golem = self:GetUnitIdByGUID(args.sourceGUID)
	if (golem and UnitIsUnit(args.destName, golem.."target")) or self:Tank(args.destName) then -- don't care about non-tanks gaining stacks
		self:StackMessage(-7770, args.destName, args.amount, "Urgent", "Info", L["slam_message"])
	end
end

-- Matter Swap fun!
do
	local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone
	local function getDistance(unit1, unit2)
		local tx, ty = GetPlayerMapPosition(unit1)
		local px, py = GetPlayerMapPosition(unit2)

		local dx, dy = (tx - px), (ty - py)
		local distance = (dx * dx + dy * dy) ^ 0.5

		return distance
	end

	local timer, last = nil, nil
	local function warnSwapTarget()
		local player = matterSwapTargets[1]
		if not player then
			mod:CancelTimer(timer)
			timer = nil
			return
		end

		SetMapToCurrentZone()
		local furthest, highestDistance = nil, 0
		for i=1, GetNumGroupMembers() do
			local unit = ("raid%d"):format(i)
			if UnitAffectingCombat(unit) and not UnitIsUnit(unit, player) then -- filter dead people and outside groups
				local distance = getDistance(unit, player)
				if distance > highestDistance then
					highestDistance = distance
					furthest = unit
				end
			end
		end

		if furthest and furthest ~= last then
			local name, server = UnitName(furthest)
			if server then name = name.."-"..server end
			if not name then return end

			mod:SecondaryIcon("matterswap", name)
			if UnitIsUnit(furthest, "player") then
				mod:Message("matterswap", "Personal", "Info", L["matterswap_message"], L.matterswap_icon)
				mod:Flash("matterswap")
			end
			last = furthest
		end
	end

	function mod:MatterSwapApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
			self:TargetBar(args.spellId, 12, args.destName)
			self:Flash(args.spellId)
		elseif self:Dispeller("magic", nil, 138609) then
			self:TargetMessage(args.spellId, args.destName, "Important", "Alarm", nil, nil, true)
			self:TargetBar(args.spellId, 12, args.destName)
		end

		matterSwapTargets[#matterSwapTargets+1] = args.destName
		self:PrimaryIcon(args.spellId, matterSwapTargets[1])

		last = nil
		if not timer and self.db.profile.matterswap > 0 then -- pretty wasteful to do the scanning if the option isn't on
			warnSwapTarget()
			timer = self:ScheduleRepeatingTimer(warnSwapTarget, 0.5)
		end
	end

	function mod:MatterSwapRemoved(args)
		self:StopBar(args.spellId, args.destName)
		if args.destName == matterSwapTargets[1] then
			tremove(matterSwapTargets, 1)
			self:PrimaryIcon(args.spellId, matterSwapTargets[1]) -- mark next (if set)
		else -- dispeller ignored marks! (should only be two)
			tremove(matterSwapTargets, 2)
		end
	end
end

----------------------------------------
-- Large Anima Golem
--

do
	local prev = 0
	function mod:CrimsonWake(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(_, msg, sender)
	if sender == self:SpellName(138485) then -- Crimson Wake
		self:Say(138485)
		self:Bar(138485, 30, CL["you"]:format(sender))
		self:DelayedMessage(138485, 30, "Positive", CL["over"]:format(sender))
		self:Message(138485, "Urgent", "Alarm", CL["you"]:format(sender))
		self:Flash(138485)
	end
end
