
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Twin Ogron", 994, 1148)
if not mod then return end
mod:RegisterEnableMob(78238, 78237) -- Pol, Phemos
mod.engageId = 1719

--------------------------------------------------------------------------------
-- Locals
--

local quakeCount = 0
local pulverizeProximity = nil
local arcaneTwisted, arcaneTwistedTime = nil, nil
local volatilityCount = 1
local volatilityOnMe = nil
local volatilityTargets = {}
local polInterval = 26
local phemosInterval = 31

local STRING_SCHOOL_ARCANE = STRING_SCHOOL_ARCANE

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.volatility_self = CL.you:format(mod:SpellName(163372))
	L.volatility_self_desc = "Options for when the Arcane Volatility debuff is on you."
	L.volatility_self_icon = 163372

	L.custom_off_volatility_marker = "Arcane Volatility marker"
	L.custom_off_volatility_marker_desc = "Marks targets of Arcane Volatility with {rt1}{rt2}{rt3}{rt4}, requires promoted or leader."
	L.custom_off_volatility_marker_icon = 1
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		163297, -- Arcane Twisted
		{163372, "PROXIMITY"}, -- Arcane Volatility
		{"volatility_self", "FLASH", "SAY", "EMPHASIZE", "COUNTDOWN"},
		"custom_off_volatility_marker",
		--[[ Pol ]]--
		{143834, "TANK"}, -- Shield Bash
		158134, -- Shield Charge
		158093, -- Interrupting Shout
		{158385, "PROXIMITY"}, -- Pulverize
		--[[ Phemos ]]--
		{158521, "TANK"}, -- Double Slash
		{167200, "TANK_HEALER"}, -- Arcane Wound
		157943, -- Whirlwind
		158057, -- Enfeebling Roar
		158200, -- Quake
		{158241, "FLASH"}, -- Blaze
		--[[ General ]]--
		"berserk",
	}, {
		[163297] = "mythic",
		[143834] = -9595, -- Pol
		[158521] = -9590, -- Phemos
		berserk = "general"
	}
end

function mod:OnBossEnable()
	-- Pol
	self:Log("SPELL_CAST_START", "ShieldBash", 143834)
	self:Log("SPELL_CAST_START", "ShieldCharge", 158134)
	self:Log("SPELL_CAST_START", "InterruptingShout", 158093)
	self:Log("SPELL_CAST_SUCCESS", "Pulverize", 158385)
	self:Log("SPELL_CAST_START", "PulverizeCast", 158415, 158419)
	-- Phemos
	self:Log("SPELL_CAST_START", "DoubleSlash", 158521)
	self:Log("SPELL_AURA_APPLIED", "ArcaneWound", 167200) -- Mythic
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneWound", 167200) -- Mythic
	self:Log("SPELL_CAST_START", "Whirlwind", 157943)
	self:Log("SPELL_CAST_START", "EnfeeblingRoar", 158057)
	self:Log("SPELL_AURA_APPLIED", "EnfeeblingRoarApplied", 158026)
	self:Log("SPELL_CAST_START", "Quake", 158200)
	self:Log("SPELL_CAST_SUCCESS", "QuakeChannel", 158200)
	self:Log("SPELL_AURA_APPLIED", "BlazeApplied", 158241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazeApplied", 158241)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ArcaneTwisted", 163297)
	self:Log("SPELL_CAST_SUCCESS", "ArcaneVolatility", 163372)
	self:Log("SPELL_AURA_APPLIED", "ArcaneVolatilityApplied", 163372)
	self:Log("SPELL_AURA_REFRESH", "ArcaneVolatilityApplied", 163372)
	self:Log("SPELL_AURA_REMOVED", "ArcaneVolatilityRemoved", 163372)
end

function mod:OnEngage()
	polInterval = self:Mythic() and 23 or self:Heroic() and 26 or 28
	phemosInterval = self:Mythic() and 28 or self:Heroic() and 31 or 33
	quakeCount = 0
	pulverizeProximity = nil
	self:CDBar(158200, 12) -- Quake
	self:CDBar(143834, 22) -- Shield Bash
	self:CDBar(158521, 26) -- Double Slash
	self:CDBar(158134, polInterval + 10) -- Shield Charge
	if self:Mythic() then
		wipe(volatilityTargets)
		volatilityCount, volatilityOnMe = 1, nil
		arcaneTwisted, arcaneTwistedTime = nil, GetTime() + 33
		self:Bar(163372, 62) -- Arcane Volatility
		self:Berserk(420)
	else
		self:Berserk(self:LFR() and 600 or 480)
	end
end

function mod:OnBossDisable()
	if self:Mythic() then
		if self.db.profile.custom_off_volatility_marker then
			for _, player in next, volatilityTargets do
				SetRaidTarget(player, 0)
			end
		end
		wipe(volatilityTargets)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function isNextEmpowered(guid, nextCast)
	if not arcaneTwisted then
		return mod:MobId(guid) == 78237 -- Phemos is first (cheating, but works)
	end
	local t = GetTime() + nextCast
	return (arcaneTwisted ~= guid and arcaneTwistedTime < t) or (arcaneTwisted == guid and arcaneTwistedTime > t)
end

local function updateProximity()
	-- arcane volatility on you > pulverize > arcane volatility
	-- open in reverse order so if you disable one it doesn't block others from showing
	if #volatilityTargets > 0 then
		mod:OpenProximity(163372, 8, volatilityTargets)
	end
	if pulverizeProximity then
		mod:OpenProximity(158385, 4)
	end
	if volatilityOnMe then
		mod:OpenProximity(163372, 8)
	end
end

local function openPulverizeProximity()
	mod:Message(158385, "Urgent", "Alarm", CL.incoming:format(mod:SpellName(158385)))
	pulverizeProximity = true
	updateProximity()
end

-- Pol

function mod:ShieldBash(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and UnitDetailedThreatSituation("player", unit)) or not self:Tank() then -- Exclude the tank tanking Phemos
		self:Message(args.spellId, "Urgent")
		if self:Mythic() and isNextEmpowered(args.sourceGUID, 23) then
			self:CDBar(args.spellId, 23, ("%s (%s)"):format(args.spellName, STRING_SCHOOL_ARCANE))
		else
			self:CDBar(args.spellId, 23)
		end
	end
end

function mod:ShieldCharge(args)
	self:Bar(args.spellId, 3)
	if arcaneTwisted == args.sourceGUID then
		self:Message(args.spellId, "Urgent", "Alarm", ("%s (%s)"):format(args.spellName, STRING_SCHOOL_ARCANE)) -- Shield Charge (Arcane)
		self:Bar(args.spellId, 4, 163336) -- Arcane Charge
	else
		self:Message(args.spellId, "Urgent", "Alarm")
	end
	self:CDBar(158093, polInterval) -- Interrupting Shout
end

function mod:InterruptingShout(args)
	local _, _, _, _, _, endTime = UnitCastingInfo(self:GetUnitIdByGUID(args.sourceGUID))
	local cast = endTime and (endTime / 1000 - GetTime()) or 0
	if cast > 1.5 then
		self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
	end

	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	if self:Ranged() then
		self:PlaySound(args.spellId, "Long")
		self:Flash(args.spellId)
	end
	self:CDBar(158385, polInterval) -- Pulverize
	self:ScheduleTimer(openPulverizeProximity, polInterval-2) -- gives you ~5s to spread out
end

do
	local count = 0
	function mod:Pulverize(args)
		count = 1
		-- skip the first actual cast (157952) in favor of announcing it at the start of the sequence to give people more time to spread out
		self:Message(158385, "Urgent", "Info", CL.count:format(args.spellName, count))
		self:Bar(158385, 3.1, ("<%s>"):format(CL.count:format(args.spellName, count)))
		if self:Mythic() and isNextEmpowered(args.sourceGUID, polInterval) then
			self:CDBar(158134, polInterval, ("%s (%s)"):format(self:SpellName(158134), STRING_SCHOOL_ARCANE)) -- Shield Charge (Arcane)
		else
			self:CDBar(158134, polInterval) -- Shield Charge
		end
	end
	function mod:PulverizeCast(args)
		count = count + 1
		self:Message(158385, "Urgent", "Info", CL.count:format(args.spellName, count))
		self:CDBar(158385, count == 2 and 3.3 or 6.6, ("<%s>"):format(CL.count:format(args.spellName, count))) -- these can vary by 1s or so
		pulverizeProximity = nil
		self:CloseProximity(158385)
		updateProximity()
	end
end

-- Phemos

function mod:DoubleSlash(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and UnitDetailedThreatSituation("player", unit)) or not self:Tank() then -- Exclude the tank tanking Pol
		self:Message(args.spellId, "Attention")
		if self:Mythic() and isNextEmpowered(args.sourceGUID, 27) then
			self:CDBar(args.spellId, 27, ("%s (%s)"):format(args.spellName, STRING_SCHOOL_ARCANE))
		else
			self:CDBar(args.spellId, 27) -- XXX all over the place, due to channeling?
		end
	end
end

function mod:ArcaneWound(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
end

function mod:Whirlwind(args)
	if arcaneTwisted == args.sourceGUID then
		self:Message(args.spellId, "Attention", "Alert", ("%s (%s)"):format(args.spellName, STRING_SCHOOL_ARCANE)) -- Whirlwind (Arcane)
	else
		self:Message(args.spellId, "Attention")
	end
	self:CDBar(158057, phemosInterval) -- Enfeebling Roar
end

function mod:EnfeeblingRoar(args)
	local _, _, _, _, _, endTime = UnitCastingInfo(self:GetUnitIdByGUID(args.sourceGUID))
	local cast = endTime and (endTime / 1000 - GetTime()) or 0
	if cast > 1.5 then
		self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
	end

	self:Message(args.spellId, "Attention", "Alert", CL.casting:format(args.spellName))
	self:CDBar(158200, phemosInterval, CL.count:format(self:SpellName(158200), quakeCount+1)) -- Quake
end

function mod:EnfeeblingRoarApplied(args)
	if self:Me(args.destGUID) then
		local value = select(16, UnitDebuff("player", args.spellName))
		self:Message(158057, "Attention", nil, ("%s: %d%%"):format(args.spellName, value))
	end
end

function mod:Quake(args)
	quakeCount = quakeCount + 1
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(CL.count:format(args.spellName, quakeCount)))
	if self:Mythic() and isNextEmpowered(args.sourceGUID, phemosInterval) then
		self:CDBar(157943, phemosInterval, ("%s (%s)"):format(self:SpellName(157943), STRING_SCHOOL_ARCANE)) -- Whirlwind (Arcane)
	else
		self:CDBar(157943, phemosInterval) -- Whirlwind
	end
end

function mod:QuakeChannel(args)
	self:Bar(args.spellId, 12, CL.cast:format(CL.count:format(args.spellName, quakeCount)))
end

function mod:BlazeApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
	end
end

do
	local prev = 0
	local times = { 8.5, 6, 46, 7, 16, 8.5, 6, 40, 131, 9.5, 56.5, 8.5, 6 }
	function mod:ArcaneVolatility(args)
		local t = GetTime()
		if t-prev > 4 then -- Fired once per player
			prev = t
			self:Message(args.spellId, "Neutral")
			local t = times[volatilityCount]
			if t then
				self:CDBar(args.spellId, t)
			end
			volatilityCount = volatilityCount + 1
		end
	end
end

do
	local timeLeft, timer = 6, nil
	local function sayCountdown(self)
		timeLeft = timeLeft - 1
		if timeLeft < 4 then
			self:Say("volatility_self", timeLeft, true)
			if timeLeft < 2 and timer then
				self:CancelTimer(timer)
				timer = nil
			end
		end
	end

	function mod:ArcaneVolatilityApplied(args)
		if self:Me(args.destGUID) then
			if timer then self:CancelTimer(timer) end
			timeLeft = 6
			timer = self:ScheduleRepeatingTimer(sayCountdown, 1, self)
			self:TargetBar("volatility_self", 6, args.destName, 67735, args.spellId) -- 67735 = "Volatility"
			volatilityOnMe = true
			self:Message("volatility_self", "Personal", "Warning", CL.you:format(args.spellName))
			self:Flash("volatility_self", args.spellId)
			self:Say("volatility_self", args.spellId)
		end
		if not tContains(volatilityTargets, args.destName) then -- SPELL_AURA_REFRESH
			volatilityTargets[#volatilityTargets+1] = args.destName
			if self.db.profile.custom_off_volatility_marker then
				SetRaidTarget(args.destName, #volatilityTargets)
			end
		end
		updateProximity()
	end

	function mod:ArcaneVolatilityRemoved(args)
		tDeleteItem(volatilityTargets, args.destName)
		if self:Me(args.destGUID) then
			self:StopBar(67735, args.destName)
			volatilityOnMe = nil
			self:CloseProximity(args.spellId)
			if timer then
				self:CancelTimer(timer)
				timer = nil
			end
		elseif #volatilityTargets == 0 then
			self:CloseProximity(args.spellId)
		end
		updateProximity()
		if self.db.profile.custom_off_volatility_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ArcaneTwisted(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
	arcaneTwisted = args.destGUID
	arcaneTwistedTime = GetTime() + 55
end

