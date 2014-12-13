
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
local volatilityCount = 1
local volatilityOnMe = nil
local volatilityTargets = {}

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
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		163297,
		{163372, "PROXIMITY"}, -- Arcane Volatility
		{"volatility_self", "FLASH", "SAY", "EMPHASIZE"},
		"custom_off_volatility_marker",
		--[[ Pol ]]--
		{143834, "TANK"}, -- Shield Bash
		158134, -- Shield Charge
		158093, -- Interrupting Shout
		{158385, "PROXIMITY"}, -- Pulverize
		--[[ Phemos ]]--
		{158521, "TANK"}, -- Double Slash
		{167200, "TANK"}, -- Arcane Wound
		157943, -- Whirlwind
		158057, -- Enfeebling Roar
		158200, -- Quake
		{158241, "FLASH"}, -- Blaze
		--[[ General ]]--
		"berserk",
		"bosskill"
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
	self:Log("SPELL_CAST_START", "ArcaneCharge", 163336) -- Mythic
	self:Log("SPELL_CAST_START", "InterruptingShout", 158093)
	self:Log("SPELL_CAST_SUCCESS", "Pulverize", 158385)
	self:Log("SPELL_CAST_START", "PulverizeCast", 157952, 158415, 158419) -- 1.58s cast
	-- Phemos
	self:Log("SPELL_CAST_START", "DoubleSlash", 158521)
	self:Log("SPELL_AURA_APPLIED", "ArcaneWound", 167200) -- Mythic
	self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneWound", 167200) -- Mythic
	self:Log("SPELL_CAST_START", "Whirlwind", 157943)
	self:Log("SPELL_CAST_START", "EnfeeblingRoar", 158057)
	self:Log("SPELL_CAST_START", "Quake", 158200)
	self:Log("SPELL_CAST_SUCCESS", "QuakeChannel", 158200)
	self:Log("SPELL_AURA_APPLIED", "BlazeDamage", 158241)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazeDamage", 158241)
	self:Emote("ArcaneVolatility", "163372") -- Mythic
	self:Log("SPELL_AURA_APPLIED", "ArcaneVolatilityApplied", 163372) -- Mythic
	self:Log("SPELL_AURA_REMOVED", "ArcaneVolatilityRemoved", 163372) -- Mythic
	self:Log("SPELL_AURA_APPLIED", "ArcaneTwisted", 163297) -- Mythic
end

function mod:OnEngage()
	quakeCount = 0
	pulverizeProximity = nil
	volatilityCount = 1
	volatilityOnMe = nil
	wipe(volatilityTargets)
	self:CDBar(158200, 12) -- Quake
	self:CDBar(143834, 22) -- Shield Bash
	--self:CDBar(158521, 26) -- Double Slash
	self:CDBar(158134, 34) -- Shield Charge
	self:CDBar(157943, 42) -- Whirlwind
	if self:Mythic() then
		self:Bar(163297, 23) -- Arcane Twisted
		self:Bar(163372, 65) -- Arcane Volatility
		self:Berserk(420)
	else
		self:Berserk(480)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity()
	-- pulverize > arcane volatility
	-- open in reverse order so if you disable one it doesn't block others from showing
	if mod:Mythic() then
		if volatilityOnMe then
			mod:OpenProximity(163372, 8)
		elseif #volatilityTargets > 0 then
			mod:OpenProximity(163372, 8, volatilityTargets)
		end
	end
	if pulverizeProximity then
		mod:OpenProximity(158385, 4)
	end
end

local function openPulverizeProximity()
	mod:Message(158385, "Urgent", "Info", CL.soon:format(mod:SpellName(158385)))
	pulverizeProximity = true
	updateProximity()
end

-- Pol

function mod:ShieldBash(args)
	if UnitDetailedThreatSituation("player", self:GetUnitIdByGUID(args.sourceGUID)) or not self:Tank() then
		self:Message(args.spellId, "Urgent")
		self:CDBar(args.spellId, 23)
	end
end

function mod:ShieldCharge(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(158093, 27) -- Interrupting Shout
end

do
	local prev = 0
	function mod:ArcaneCharge(args)
		local t = GetTime()
		if t-prev > 10 then
			self:Message(158134, "Urgent", nil, 163336)
			self:CDBar(158134, 5, 163336)
			prev = t
		end
	end
end

function mod:InterruptingShout(args)
	local _, _, _, _, _, endTime = UnitCastingInfo(self:GetUnitIdByGUID(args.sourceGUID))
	local cast = endTime and (endTime / 1000 - GetTime()) or 0
	if cast > 1.5 then
		self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
	end

	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	if self:Healer() or self:Damager() == "RANGED" then
		self:PlaySound(args.spellId, "Long")
		self:Flash(args.spellId)
	end
	self:CDBar(158385, 27) -- Pulverize
	self:ScheduleTimer(openPulverizeProximity, 23) -- gives you ~7s to spread out
end

do
	local count = 0
	function mod:Pulverize(args)
		count = 0
		self:Message(158385, "Urgent", "Info", CL.count:format(args.spellName, 1))
		self:CDBar(158134, 27) -- Shield Charge
	end
	function mod:PulverizeCast(args)
		count = count + 1
		if count > 1 then
			self:Message(158385, "Urgent", "Info", CL.count:format(args.spellName, count))
			pulverizeProximity = nil
			self:CloseProximity(158385)
			updateProximity()
		end
	end
end

-- Phemos

function mod:DoubleSlash(args)
	if UnitDetailedThreatSituation("player", self:GetUnitIdByGUID(args.sourceGUID)) or not self:Tank() then
		self:Message(args.spellId, "Attention")
		self:CDBar(args.spellId, 28) -- XXX all over the place
	end
end

function mod:ArcaneWound(args)
	-- XXX this isn't applied terribly often, buggy or just ment to be a minor annoyance?
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
end

function mod:Whirlwind(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(158057, self:Normal() and 33 or 31) -- Enfeebling Roar
end

function mod:EnfeeblingRoar(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(158200, self:Normal() and 33 or 31, CL.count:format(self:SpellName(158200), quakeCount+1)) -- Quake
end

function mod:Quake(args)
	quakeCount = quakeCount + 1
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(CL.count:format(args.spellName, quakeCount)))
	self:CDBar(157943, self:Normal() and 33 or 31) -- Whirlwind
end

function mod:QuakeChannel(args)
	self:Bar(args.spellId, 12, CL.cast:format(CL.count:format(args.spellName, quakeCount)))
end

do
	local prev = 0
	function mod:BlazeDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName))
			prev = t
		end
	end
end

do
	local times = { 60, 22, 45, 50, 89 } -- every 60 energy (either boss)... almost ;[
	function mod:ArcaneVolatility()
		self:Message(163372, "Neutral")
		local t = times[volatilityCount]
		if t then
			self:CDBar(163372, t)
		end
		volatilityCount = volatilityCount + 1
		wipe(volatilityTargets)
		volatilityOnMe = nil
	end

	local timeLeft, timer = 6, nil
	local function sayCountdown()
		timeLeft = timeLeft - 1
		mod:Say("volatility_self", timeLeft, true)
		if timeLeft < 2 then
			mod:CancelTimer(timer)
		end
	end

	local list, scheduled = mod:NewTargetList(), nil
	local function warn(spellId)
		if not volatilityOnMe then
			mod:TargetMessage(spellId, list, "Important")
		end
		wipe(list)
		scheduled = nil
	end
	function mod:ArcaneVolatilityApplied(args)
		list[#list+1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 1, args.spellId)
		end
		if self:Me(args.destGUID) then
			timeLeft = 6
			volatilityOnMe = true
			self:Message("volatility_self", "Personal", "Warning", CL.you:format(args.spellName))
			self:Flash("volatility_self", args.spellId)
			self:Say("volatility_self", args.spellId)
			self:TargetBar("volatility_self", 6, args.destName, args.spellId)
			timer = self:ScheduleRepeatingTimer(sayCountdown, 1)
		else
			self:TargetBar(args.spellId, 6, args.destName)
		end
		updateProximity()
		if self.db.profile.custom_off_volatility_marker then
			volatilityTargets[#volatilityTargets+1] = args.destName
			SetRaidTarget(args.destName, #volatilityTargets)
		end
	end

	function mod:ArcaneVolatilityRemoved(args)
		tDeleteItem(volatilityTargets, args.destName)
		self:StopBar(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			volatilityOnMe = nil
			self:CloseProximity(args.spellId)
			self:CancelTimer(timer)
		end
		updateProximity()
		if self.db.profile.custom_off_volatility_marker then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:ArcaneTwisted(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
	self:Bar(args.spellId, 55)
end

