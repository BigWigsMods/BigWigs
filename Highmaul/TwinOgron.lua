
--------------------------------------------------------------------------------
-- Module Declaration
--

if not BigWigs.isWOD then return end -- XXX compat
local mod, CL = BigWigs:NewBoss("Twin Ogron", 994, 1148)
if not mod then return end
mod:RegisterEnableMob(78238, 78237) -- Pol, Phemos
--mod.engageId = 1719

--------------------------------------------------------------------------------
-- Locals
--

local bossDeaths = 0
local quakeCount = 0
local volatilityCount = 1
local nextPhemo = 0

local function GetBossUnit(guid)
	for i=1, 3 do
		local unit = ("boss%d"):format(i)
		if UnitGUID(unit) == guid then
			return unit
		end
	end
end

local function GetBossCastTime(guid)
	local unit = GetBossUnit(guid) or ""
	local spell, _, _, _, _, endTime = UnitCastingInfo(unit)
	if spell then
		return endTime / 1000 - GetTime()
	end
	return 0
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
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
		{143834, "TANK_HEALER"}, {158134, "ICON", "SAY", "FLASH"}, {158093, "FLASH"}, 158385,
		{158521, "TANK_HEALER"}, {167200, "TANK"}, 157943, 158057, 158200, {158241, "FLASH"}, {163372, "FLASH", "PROXIMITY"}, "custom_off_volatility_marker",
		"berserk", "bosskill"
	}, {
		[143834] = -9595, -- Pol
		[158521] = -9590, -- Phemos
		["berserk"] = "general"
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

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

	self:Death("Deaths", 78238, 78237) -- Pol, Phemos
end

function mod:OnEngage()
	bossDeaths = 0
	quakeCount = 0
	volatilityCount = 1
	nextPhemo = 158200
	self:CDBar(158200, 12) -- Quake
	self:CDBar(143834, 22) -- Shield Bash
	--self:CDBar(158521, 26) -- Double Slash
	self:CDBar(158134, 34) -- Shield Charge
	if self:Mythic() then
		self:Bar(163372, 65) -- Arcane Volatility
	end
	if not self:LFR() then
		self:Berserk(420) -- Mythic time, normal unconfirmed
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Deaths(args)
	bossDeaths = bossDeaths + 1
	if bossDeaths > 1 then
		self:Win()
	end
end

-- Pol

function mod:ShieldBash(args)
	self:Message(args.spellId, "Urgent")
	self:CDBar(args.spellId, 23)
end

do
	-- XXX target scanning doesn't work /sadface i'll leave it here for now, though
	local timer = nil

	local function warnShieldCharge(self, name, guid)
		self:PrimaryIcon(158134, name)
		if self:Me(guid) then
			self:Say(158134)
			self:Flash(158134)
		elseif self:Range(name) < 11 then
			self:RangeMessage(158134)
			self:Flash(158134)
			return
		end
		self:TargetMessage(158134, name, "Urgent", "Alarm")
	end

	function mod:ShieldCharge(args)
		if timer then
			self:Message(args.spellId, "Urgent", "Alarm")
			self:CancelTimer(timer)
			timer = nil
		end
		self:CDBar(158093, 27) -- Interrupting Shout
	end

	local UnitGUID, UnitDetailedThreatSituation = UnitGUID, UnitDetailedThreatSituation
	local function scanner(self)
		for i=1, 5 do
			local boss = ("boss%d"):format(i)
			if self:MobId(UnitGUID(boss)) == 78238 then
				local bossTarget = boss.."target"
				local guid = UnitGUID(bossTarget)
				if guid and (not UnitDetailedThreatSituation(bossTarget, boss) and not self:Tank(bossTarget)) then
					local name = self:UnitName(bossTarget)
					warnShieldCharge(self, name, guid)
					self:CancelTimer(timer)
					timer = nil
				end
				return
			end
		end
	end
	function mod:ShieldChargeScan()
		timer = self:ScheduleRepeatingTimer(scanner, 0.05, self)
	end
end

do
	local prev = 0
	function mod:ArcaneCharge(args)
		-- XXX doesn't always happen on Shield Charge?
		local t = GetTime()
		if t-prev > 10 then
			self:Message(158134, "Urgent", nil, 163336)
			self:CDBar(158134, 5, 163336)
			prev = t
		end
	end
end

function mod:InterruptingShout(args)
	self:Message(args.spellId, "Urgent", nil, CL.casting:format(args.spellName))
	local cast = GetBossCastTime(args.sourceGUID)
	if cast > 1 then
		self:Bar(args.spellId, cast, CL.cast:format(args.spellName))
	end
	if self:Healer() or self:Damager() == "RANGED" then
		self:PlaySound(args.spellId, "Long")
		self:Flash(args.spellId)
	end
	self:CDBar(158385, 27) -- Pulverize
end

do
	local count = 0
	function mod:Pulverize(args)
		count = 0
		self:Message(args.spellId, "Urgent", nil, CL.incoming:format(args.spellName))
		self:CDBar(158134, 27) -- Shield Charge
		self:ScheduleTimer("ShieldChargeScan", 20)
	end
	function mod:PulverizeCast(args)
		count = count + 1
		self:Message(158385, "Urgent", "Alert", CL.count(args.spellName, count))
	end
end

-- Phemos

function mod:ArcaneWound(args)
	-- XXX this isn't applied terribly often, buggy or just ment to be a minor annoyance?
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
end

function mod:DoubleSlash(args)
	self:Message(args.spellId, "Attention")
	--self:CDBar(args.spellId, 25) -- all over the place 10-34s
end

function mod:Whirlwind(args)
	self:Message(args.spellId, "Attention")
	if nextPhemo == args.spellId then
		self:CDBar(158057, 33) -- Enfeebling Roar
		nextPhemo = 158057
	end
end

function mod:EnfeeblingRoar(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(158200, 33, CL.count:format(self:SpellName(158200), quakeCount+1)) -- Quake
	nextPhemo = 158200
end

function mod:Quake(args)
	quakeCount = quakeCount + 1
	self:Message(args.spellId, "Attention", "Alert", CL.incoming:format(CL.count:format(args.spellName, quakeCount)))
	self:CDBar(157943, 33) -- Whirlwind
	nextPhemo = 157943
end

function mod:QuakeChannel(args)
	self:Bar(args.spellId, 12, CL.cast:format(CL.count:format(args.spellName, quakeCount)))
end

do
	local prev = 0
	function mod:BlazeDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName))
			self:Flash(args.spellId)
			prev = t
		end
	end
end

do
	local times = { 60, 22, 45, 50, 89 } -- every 60 energy (either boss)... almost ;[
	local targets, isOnMe, timer = {}, nil, nil

	function mod:ArcaneVolatility()
		self:Message(163372, "Urgent")
		local t = times[volatilityCount]
		if t then
			self:CDBar(163372, t)
		end
		wipe(targets)
		isOnMe = nil
		timer = self:ScheduleTimer("CloseProximity", 7, 163372)
		self:OpenProximity(163372, 8, targets)
	end

	function mod:ArcaneVolatilityApplied(args)
		self:TargetBar(args.spellId, 6, args.destName)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 8)
			isOnMe = true
			self:CancelTimer(timer)
		elseif not isOnMe then
			self:OpenProximity(args.spellId, 8, targets)
		end
		if self.db.profile.custom_off_volatility_marker and #targets < 5 then
			targets[#targets+1] = args.destName
			SetRaidTarget(args.destName, #targets)
		end
	end

	function mod:ArcaneVolatilityRemoved(args)
		self:StopBar(args.spellId, args.destName)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
		if tContains(targets, args.destName) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

