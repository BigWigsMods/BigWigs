
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Amber-Shaper Un'sok", 897, 737)
if not mod then return end
mod:RegisterEnableMob(62511, 62711) -- Un'sok, Monstrosity

--------------------------------------------------------------------------------
-- Locals
--

local explosion = mod:SpellName(106966)
local phase, primaryIcon = 1, nil
local reshapeLifeCounter = 1
local monsterDestabilizeStacks = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.explosion_by_other = "Amber Explosion cooldown bar by Monstrosity/Focus"
	L.explosion_by_other_desc = "Cooldown warnings and bar for Amber Explosions cast by the Amber Monstrosity or your focus target."
	L.explosion_by_other_icon = 122398

	L.explosion_casting_by_other = "Amber Explosion cast bar by Monstrosity/Focus"
	L.explosion_casting_by_other_desc = "Cast warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"
	L.explosion_casting_by_other_icon = 122398

	L.explosion_by_you = "Your Amber Explosion cooldown"
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."
	L.explosion_by_you_bar = "You start casting..."
	L.explosion_by_you_icon = 122398

	L.explosion_casting_by_you = "Your Amber Explosion cast bar"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"
	L.explosion_casting_by_you_icon = 122398

	L.willpower = "Willpower"
	L.willpower_desc = select(2, EJ_GetSectionInfo(6249))
	L.willpower_icon = 124824
	L.willpower_message = "Willpower at %d!"

	L.break_free_message = "Health at %d%%!"
	L.fling_message = "Getting tossed!"
	L.parasite = "Parasite"

	L.monstrosity_is_casting = "Monster: Explosion"
	L.you_are_casting = "YOU are casting!"

	L.unsok_short = "Boss"
	L.monstrosity_short = "Monster"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{-6548, "FLASH", "ICON", "SAY"},
		122784, 123059, "explosion_by_you", {"explosion_casting_by_you", "FLASH"}, 123060, "willpower",
		"explosion_by_other", {"explosion_casting_by_other", "FLASH"}, 122413, 122408,
		121995, 123020, {121949, "FLASH"},
		"stages", "berserk", "bosskill",
	}, {
		[-6548] = "heroic",
		[122784] = -6249,
		explosion_by_other = -6246,
		[121995] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ReshapeLife", 122784)
	self:Log("SPELL_AURA_REMOVED", "ReshapeLifeRemoved", 122370)
	self:Log("SPELL_CAST_SUCCESS", "AmberScalpel", 121994)
	self:Log("SPELL_AURA_APPLIED", "Destabilize", 123059)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Destabilize", 123059)
	self:Log("SPELL_CAST_START", "AmberExplosion", 122398)
	self:Log("SPELL_CAST_FAILED", "AmberExplosionPrevented", 122398)
	self:Log("SPELL_CAST_START", "AmberExplosionMonstrosity", 122402)
	self:Log("SPELL_CAST_SUCCESS", "AmberCarapace", 122540)
	self:Log("SPELL_AURA_APPLIED", "ParasiticGrowth", 121949)
	self:Log("SPELL_AURA_REMOVED", "ParasiticGrowthRemoved", 121949)
	self:Log("SPELL_CAST_SUCCESS", "AmberGlobule", 125502)
	self:Log("SPELL_CAST_REMOVED", "AmberGlobuleRemoved", 125502)
	self:Log("SPELL_CAST_SUCCESS", "Fling", 122415) --122415 is actually Grab, the precursor to Fling
	self:Log("SPELL_CAST_START", "MassiveStomp", 122408)

	self:Log("SPELL_DAMAGE", "BurningAmber", 122504)
	self:Log("SPELL_MISSED", "BurningAmber", 122504)

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "MonstrosityInc", "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "Interrupt", "player", "focus")
	self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "MonstrosityStopCast", "boss1", "boss2")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62511)
	self:Death("MonsterDies", 62711)
end

function mod:OnEngage(diff)
	reshapeLifeCounter = 1
	monsterDestabilizeStacks = 1
	self:Bar(122784, 20, CL["count"]:format(self:SpellName(122784), reshapeLifeCounter)) -- Reshape Life
	self:Bar(121949, 24) -- Parasitic Growth
	self:Bar(121995, 10) -- Amber Scalpel
	self:Berserk(600)

	phase = 1
	primaryIcon = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ParasiticGrowth(args)
	self:Bar(args.spellId, 50)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Long", L["parasite"])
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
	end
	if self:Healer() then
		self:TargetBar(args.spellId, 30, args.destName, L["parasite"])
	end
end

function mod:ParasiticGrowthRemoved(args)
	--for bubble/ice block/cloak/etc
	self:StopBar(L["parasite"], args.destName)
end

do
	local prev = 0
	function mod:BurningAmber(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(123020, "Personal", "Alarm", CL["underyou"]:format(args.spellName))
		end
	end
end

function mod:AmberScalpel()
	self:Bar(121995, 50)
	self:Message(121995, "Attention")
end

--------------
-- Construct

function mod:ReshapeLife(args)
	if phase < 2 then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm", CL["count"]:format(args.spellName, reshapeLifeCounter))
		reshapeLifeCounter = reshapeLifeCounter + 1
		self:Bar(args.spellId, 50, CL["count"]:format(args.spellName, reshapeLifeCounter))
	elseif phase < 3 then
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
		self:Bar(args.spellId, 50)
	else
		self:TargetMessage(args.spellId, args.destName, "Urgent", "Alarm")
	end

	if self:Me(args.destGUID) then
		self:Bar("explosion_by_you", 15, L["explosion_by_you_bar"], 122398)
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "MyWillpower", "player")
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "BreakFreeHP", "player")
	elseif UnitIsUnit("focus", args.destName) then
		self:TargetBar("explosion_by_other", 15, args.destName, explosion, 122398)
	end
end

function mod:ReshapeLifeRemoved(args)
	if self:Me(args.destGUID) then
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
		self:StopBar(CL["cast"]:format(explosion))
		self:StopBar(L["explosion_by_you_bar"])
	elseif UnitIsUnit("focus", args.destName) then
		self:StopBar(CL["cast"]:format(CL["other"]:format(args.sourceName:gsub("%-.+", "*"), explosion)))
		self:StopBar(args.destName, explosion)
	end
end

function mod:Destabilize(args)
	local id = self:MobId(args.destGUID)
	if id == 62511 or id == 62711 then
		local buffStack = args.amount or 1
		monsterDestabilizeStacks = id == 62711 and buffStack or monsterDestabilizeStacks
		self:StopBar(("%s: (%d)%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], buffStack-1, args.spellName))
		self:Bar(args.spellId, self:LFR() and 60 or 15, ("%s: (%d)%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], buffStack, args.spellName))
	end
end

do
	local last = 0
	local function warningSpam(spellName)
		if UnitCastingInfo("player") == spellName then
			mod:Message("explosion_casting_by_you", "Personal", "Info", L["you_are_casting"], 122398)
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionPrevented(args) -- We stunned ourself before it started casting
		local t = GetTime()
		if t-last > 4 and self:Me(args.sourceGUID) then -- Use a throttle so that we don't confuse interrupting a cast (_FAILED) with preventing a cast (also _FAILED)
			self:Bar("explosion_by_you", 13, L["explosion_by_you_bar"], args.spellId) -- cooldown
			last = t
		end
	end
	function mod:AmberExplosion(args)
		if self:Me(args.sourceGUID) then
			last = GetTime()
			self:Flash("explosion_casting_by_you", args.spellId)
			self:Bar("explosion_casting_by_you", 2.5, CL["cast"]:format(explosion), args.spellId)
			self:Bar("explosion_by_you", 13, L["explosion_by_you_bar"], args.spellId) -- cooldown
			warningSpam(args.spellName)
		elseif UnitIsUnit("focus", args.sourceName) then
			self:Flash("explosion_casting_by_other", args.spellId)
			self:TargetBar("explosion_by_other", 13, args.sourceName, explosion, args.spellId) -- cooldown
			self:Bar("explosion_casting_by_other", 2.5, CL["cast"]:format(CL["other"]:format(args.sourceName:gsub("%-.+", "*"), explosion)), args.spellId)
			self:TargetMessage("explosion_casting_by_other", args.sourceName, "Important", "Alert", explosion, args.spellId, true) -- associate the message with the casting toggle option
		end
	end
end

function mod:Interrupt(unitId, _, _, _, spellId)
	--Mutated Construct's Struggle for Control doesn't fire a SPELL_INTERRUPT
	if spellId == 122398 then
		if unitId == "player" then
			self:StopBar(CL["cast"]:format(explosion))
		elseif unitId == "focus" then
			local player, server = UnitName(unitId)
			if server then player = player.."*" end
			self:StopBar(CL["cast"]:format(CL["other"]:format(player, explosion)))
		end
	end
end

--Willpower
do
	local prev = 0
	function mod:MyWillpower(unitId, powerType)
		if powerType == "ALTERNATE" then
			local t = GetTime()
			if t-prev > 1 then
				local willpower = UnitPower(unitId, 10)
				if willpower < 20 and willpower > 0 then
					prev = t
					self:Message("willpower", "Personal", nil, L["willpower_message"]:format(willpower), 124824)
				end
			end
		end
	end
end

function mod:MonstrosityInc(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 75 then -- phase starts at 70
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		self:Message("stages", "Positive", "Long", CL["soon"]:format(self:SpellName(-6254)), false) -- Monstrosity
	end
end

do
	local prev = 0
	function mod:BreakFreeHP(unitId)
		local t = GetTime()
		if t-prev > 1 then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < 21 then
				prev = t
				self:Message(123060, "Personal", nil, L["break_free_message"]:format(hp))
			end
		end
	end
end

----------------
-- Monstrosity

function mod:AmberCarapace(args)
	phase = 2
	self:Message("stages", "Attention", nil, CL["other"]:format(CL["phase"]:format(2), self:SpellName(-6254)), "spell_nature_shamanrage") -- Monstrosity
	self:DelayedMessage("explosion_by_other", 35, "Attention", CL["custom_sec"]:format(explosion, 20), 122402)
	self:DelayedMessage("explosion_by_other", 40, "Attention", CL["custom_sec"]:format(explosion, 15), 122402)
	self:DelayedMessage("explosion_by_other", 45, "Attention", CL["custom_sec"]:format(explosion, 10), 122402)
	self:DelayedMessage("explosion_by_other", 50, "Attention", CL["custom_sec"]:format(explosion, 5), 122402)
	self:CDBar("explosion_by_other", 55, L["monstrosity_is_casting"], 122402) -- Monstrosity Explosion

	self:CDBar(122408, 22) -- Massive Stomp
	self:CDBar(122413, 30) -- Fling
end

do
	local function warningSpam(spellName)
		if UnitCastingInfo("boss1") == spellName or UnitCastingInfo("boss2") == spellName then
			mod:Message("explosion_casting_by_other", "Important", "Alert", L["monstrosity_is_casting"], 122398)
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionMonstrosity(args)
		self:DelayedMessage("explosion_by_other", 25, "Attention", CL["custom_sec"]:format(explosion, 20), args.spellId)
		self:DelayedMessage("explosion_by_other", 30, "Attention", CL["custom_sec"]:format(explosion, 15), args.spellId)
		self:DelayedMessage("explosion_by_other", 35, "Attention", CL["custom_sec"]:format(explosion, 10), args.spellId)
		self:DelayedMessage("explosion_by_other", 40, "Attention", CL["custom_sec"]:format(explosion, 5), args.spellId)
		self:Bar("explosion_casting_by_other", 2.5, "<".. L["monstrosity_is_casting"] ..">", 122398)
		self:CDBar("explosion_by_other", 45, L["monstrosity_is_casting"], args.spellId) -- cooldown, don't move this
		if UnitDebuff("player", self:SpellName(122784)) then -- Reshape Life
			self:Flash("explosion_casting_by_other", args.spellId)
			warningSpam(args.spellName)
		end
	end
end

--Monstrosity's Amber Explosion
function mod:MonstrosityStopCast(_, _, _, _, spellId)
	if spellId == 122402 then
		self:StopBar("<".. L["monstrosity_is_casting"] ..">")
	end
end

function mod:Fling(args)
	--(0) Grab -> (2.4-4.4) Fling -> (5.7) Rough Landing -> (6.1) damage/stun -> (8.7) stun off
	if self:Me(args.destGUID) then
		self:Bar(122413, 6, L["fling_message"], 68659)
	end
	self:CDBar(122413, 28) --Fling
	self:TargetMessage(122413, args.destName, "Urgent", "Alarm") --Fling
end

function mod:MassiveStomp(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:CDBar(args.spellId, 18)
end

------------
-- Phase 3

function mod:MonsterDies()
	self:StopBar(L["monstrosity_is_casting"])
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 20))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 15))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 10))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 5))
	phase = 3
	self:StopBar(("%s: (%d)%s"):format(L["monstrosity_short"], monsterDestabilizeStacks, self:SpellName(123059)))
	self:Message("stages", "Attention", nil, CL["phase"]:format(3), 122556) -- Concentrated Mutation
end

function mod:AmberGlobule(args)
	self:TargetMessage(-6548, args.destName, "Important", "Alert")
	if self:Me(args.destGUID) then
		self:Flash(-6548)
		self:Say(-6548)
	end
	if not primaryIcon then
		self:PrimaryIcon(-6548, args.destName)
		primaryIcon = args.destName
	else
		self:SecondaryIcon(-6548, args.destName)
	end
end

function mod:AmberGlobuleRemoved(args)
	if primaryIcon == args.destName then
		self:PrimaryIcon(-6548)
		primaryIcon = nil
	else
		self:SecondaryIcon(-6548)
	end
end

