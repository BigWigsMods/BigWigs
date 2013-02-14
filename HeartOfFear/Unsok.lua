
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
	L.willpower_desc = select(2, EJ_GetSectionInfo(6249)) --"When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
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
		{"ej:6548", "FLASH", "ICON", "SAY"},
		122784, 123059, "explosion_by_you", {"explosion_casting_by_you", "FLASH"}, 123060, "willpower",
		"explosion_by_other", {"explosion_casting_by_other", "FLASH"}, 122413, 122408,
		{121995, "FLASH", "SAY"}, 123020, {121949, "FLASH"},
		"stages", "berserk", "bosskill",
	}, {
		["ej:6548"] = "heroic",
		[122784] = "ej:6249",
		explosion_by_other = "ej:6246",
		[121995] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ReshapeLife", 122784)
	self:Log("SPELL_CAST_SUCCESS", "BreakFree", 123060)
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
	self:Bar(122784, ("%s (%d)"):format(self:SpellName(122784), reshapeLifeCounter), 20, 122784) --Reshape Life
	self:Bar(121949, 121949, 24, 121949) --Parasitic Growth
	self:Bar(121994, 121994, 10, 121994) -- Amber Scalpel
	self:Berserk(600) -- Does he even have one?

	phase = 1
	primaryIcon = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ParasiticGrowth(args)
	self:Bar(args.spellId, args.spellName, 50, args.spellId)
	self:TargetMessage(args.spellId, L["parasite"], args.destName, "Urgent", args.spellId, "Long")
	if UnitIsUnit("player", args.destName) then
		self:Flash(args.spellId)
	end
	if self:Healer() then
		self:TargetBar(args.spellId, L["parasite"], args.destName, 30, args.spellId)
	end
end

function mod:ParasiticGrowthRemoved(args)
	--for bubble/ice block/cloak/etc
	self:StopBar(L["parasite"], args.destName)
end

do
	local prev = 0
	function mod:BurningAmber(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(123020, CL["underyou"]:format(args.spellName), "Personal", 123020, "Alarm")
		end
	end
end

do
	local timer, fired = nil, 0
	local function beamWarn(spellId)
		fired = fired + 1
		local player = UnitName("boss1targettarget") --Boss targets an invisible mob, which targets player. Calling boss1targettarget allows us to see it anyways
		if player and not UnitIsUnit("boss1targettarget", "boss1") then --target target is himself, so he's not targeting off scalple mob yet
			mod:TargetMessage(spellId, spellId, player, "Attention", spellId, "Long")
			mod:CancelTimer(timer)
			timer = nil
			if UnitIsUnit("boss1targettarget", "player") then
				mod:Flash(spellId)
				mod:Say(spellId)
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist or boss never targets anything but himself
		if fired > 18 then
			mod:CancelTimer(timer)
			timer = nil
			mod:Message(spellId, spellId, "Attention", spellId) -- Give generic warning as a backup
		end
	end
	function mod:AmberScalpel(args)
		self:Bar(args.spellId, args.spellName, 50, args.spellId)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(beamWarn, 0.05, args.spellId)
		end
	end
end


--------------
-- Construct

function mod:ReshapeLife(args)
	if phase < 2 then
		self:TargetMessage(args.spellId, ("%s (%d)"):format(args.spellName, reshapeLifeCounter), args.destName, "Urgent", args.spellId, "Alarm")
		reshapeLifeCounter = reshapeLifeCounter + 1
		self:Bar(args.spellId, ("%s (%d)"):format(args.spellName, reshapeLifeCounter), 50, args.spellId)
	elseif phase < 3 then
		self:TargetMessage(args.spellId, args.spellName, args.destName, "Urgent", args.spellId, "Alarm")
		self:Bar(args.spellId, args.spellName, 50, args.spellId)
	else
		self:TargetMessage(args.spellId, args.spellName, args.destName, "Urgent", args.spellId, "Alarm")
		self:Bar(args.spellId, args.spellName, 15, args.spellId) -- might be too short for a bar
	end

	if UnitIsUnit("player", args.destName) then
		self:Bar("explosion_by_you", L["explosion_by_you_bar"], 15, 122398)
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "MyWillpower", "player")
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "BreakFreeHP", "player")
	elseif UnitIsUnit("focus", args.destName) then
		self:Bar("explosion_by_other", CL["other"]:format(args.destName, explosion), 15, 122398)
	end
end

function mod:BreakFree(args)
	if UnitIsUnit("player", args.sourceName) then
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
		self:StopBar(CL["cast"]:format(explosion))
		self:StopBar(L["explosion_by_you_bar"])
	elseif UnitIsUnit("focus", args.sourceName) then
		local source = args.sourceName:gsub("%-.+", "*")
		self:StopBar(CL["cast"]:format(CL["other"]:format(source, explosion)))
		self:StopBar(CL["other"]:format(source, explosion))
	end
end

function mod:Destabilize(args)
	local id = self:MobId(args.destGUID)
	if id == 62511 or id == 62711 then
		local buffStack = args.amount or 1
		monsterDestabilizeStacks = id == 62711 and buffStack or monsterDestabilizeStacks
		self:StopBar(("%s: (%d)%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], buffStack-1, args.spellName))
		self:Bar(args.spellId, ("%s: (%d)%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], buffStack, args.spellName), self:LFR() and 60 or 15, args.spellId)
	end
end

do
	local last = 0
	local function warningSpam(spellName)
		if UnitCastingInfo("player") == spellName then
			mod:LocalMessage("explosion_casting_by_you", L["you_are_casting"], "Personal", 122398, "Info")
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionPrevented(args) -- We stunned ourself before it started casting
		local t = GetTime()
		if t-last > 4 and UnitIsUnit("player", args.sourceName) then -- Use a throttle so that we don't confuse interrupting a cast (_FAILED) with preventing a cast (also _FAILED)
			self:Bar("explosion_by_you", L["explosion_by_you_bar"], 13, args.spellId) -- cooldown
			last = t
		end
	end
	function mod:AmberExplosion(args)
		if UnitIsUnit("player", args.sourceName) then
			last = GetTime()
			self:Flash("explosion_casting_by_you")
			self:Bar("explosion_casting_by_you", CL["cast"]:format(explosion), 2.5, args.spellId)
			self:Bar("explosion_by_you", L["explosion_by_you_bar"], 13, args.spellId) -- cooldown
			warningSpam(args.spellName)
		elseif UnitIsUnit("focus", args.sourceName) then
			self:Flash("explosion_casting_by_other")
			local player = args.sourceName:gsub("%-.+", "*")
			self:Bar("explosion_by_other", CL["other"]:format(player, explosion), 13, args.spellId) -- cooldown
			self:Bar("explosion_casting_by_other", CL["cast"]:format(CL["other"]:format(player, explosion)), 2.5, args.spellId)
			self:LocalMessage("explosion_casting_by_other", CL["other"]:format(player, explosion), "Important", args.spellId, "Alert") -- associate the message with the casting toggle option
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
					self:LocalMessage("willpower", L["willpower_message"]:format(willpower), "Personal", 124824)
				end
			end
		end
	end
end

function mod:MonstrosityInc(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 75 then -- phase starts at 70
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		self:Message("stages", CL["soon"]:format(EJ_GetSectionInfo(6254)), "Positive", nil, "Long") -- Monstrosity
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
				self:LocalMessage(123060, L["break_free_message"]:format(hp), "Personal", 123060)
			end
		end
	end
end

----------------
-- Monstrosity

function mod:AmberCarapace(args)
	phase = 2
	self:Message("stages", CL["phase"]:format(2)..": "..EJ_GetSectionInfo(6254), "Attention", "spell_nature_shamanrage") -- Monstrosity
	self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 40, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 45, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 50, CL["custom_sec"]:format(explosion, 5), "Attention", 122402)
	self:Bar("explosion_by_other", "~"..L["monstrosity_is_casting"], 55, 122402) -- Monstrosity Explosion

	self:Bar(122408, "~"..mod:SpellName(122408), 22, 122408) -- Massive Stomp
	self:Bar(122413, "~"..mod:SpellName(122413), 30, 122413) -- Fling
end

do
	local function warningSpam(spellName)
		if UnitCastingInfo("boss1") == spellName or UnitCastingInfo("boss2") == spellName then
			mod:LocalMessage("explosion_casting_by_other", L["monstrosity_is_casting"], "Important", 122398, "Alert")
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionMonstrosity(args)
		self:DelayedMessage("explosion_by_other", 25, CL["custom_sec"]:format(explosion, 20), "Attention", args.spellId)
		self:DelayedMessage("explosion_by_other", 30, CL["custom_sec"]:format(explosion, 15), "Attention", args.spellId)
		self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(explosion, 10), "Attention", args.spellId)
		self:DelayedMessage("explosion_by_other", 40, CL["custom_sec"]:format(explosion, 5), "Attention", args.spellId)
		self:Bar("explosion_casting_by_other", "<".. L["monstrosity_is_casting"] ..">", 2.5, 122398)
		self:Bar("explosion_by_other", "~"..L["monstrosity_is_casting"], 45, args.spellId) -- cooldown, don't move this
		if UnitDebuff("player", self:SpellName(122784)) then -- Reshape Life
			self:Flash("explosion_casting_by_other")
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
	if UnitIsUnit("player", args.destName) then
		self:Bar(122413, L["fling_message"], 6, 68659)
	end
	--cd is usually 35, but can be 27.8 (cast early when explosion is near the same time normally?)
	self:Bar(122413, "~"..mod:SpellName(122413), 35, 122413) --Fling
	self:TargetMessage(122413, mod:SpellName(122413), args.destName, "Urgent", 122413, "Alarm") --Fling
end

function mod:MassiveStomp(args)
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId, "Alarm")
	self:Bar(args.spellId, "~"..args.spellName, 18, args.spellId) -- 18-29, 24.4 average
end


------------
-- Phase 3

function mod:MonsterDies()
	self:StopBar("~"..L["monstrosity_is_casting"])
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 20))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 15))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 10))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 5))
	phase = 3
	self:StopBar(("%s: (%d)%s"):format(L["monstrosity_short"], monsterDestabilizeStacks, self:SpellName(123059)))
	self:Message("stages", CL["phase"]:format(3), "Attention", 122556) -- Concentrated Mutation
end

function mod:AmberGlobule(args)
	self:TargetMessage("ej:6548", args.spellName, args.destName, "Important", args.spellId, "Alert")
	if UnitIsUnit(args.destName, "player") then
		self:Flash("ej:6548")
		self:Say("ej:6548", args.spellName)
	end
	if not primaryIcon then
		self:PrimaryIcon("ej:6548", args.destName)
		primaryIcon = args.destName
	else
		self:SecondaryIcon("ej:6548", args.destName)
	end
end

function mod:AmberGlobuleRemoved(args)
	if primaryIcon == args.destName then
		self:PrimaryIcon("ej:6548")
		primaryIcon = nil
	else
		self:SecondaryIcon("ej:6548")
	end
end

