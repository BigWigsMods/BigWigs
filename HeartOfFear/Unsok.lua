
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.explosion_by_other = "Amber Explosion on others"
	L.explosion_by_other_desc = "Cooldown warning for Amber Explosions cast by Amber Monstrosity or your focus target."
	L.explosion_by_other_icon = 122398

	L.explosion_casting_by_other = "Amber Explosion cast by others"
	L.explosion_casting_by_other_desc = "Casting warnings for Amber Explosions started by Amber Monstrosity or your focus target. Emphasizing this is highly recommended!"
	L.explosion_casting_by_other_icon = 122398

	L.explosion_by_you = "Amber Explosion on you"
	L.explosion_by_you_desc = "Cooldown warning for your Amber Explosions."
	L.explosion_by_you_bar = "You start casting..."
	L.explosion_by_you_icon = 122398

	L.explosion_casting_by_you = "Amber Explosion cast by you"
	L.explosion_casting_by_you_desc = "Casting warnings for Amber Explosions started by you. Emphasizing this is highly recommended!"
	L.explosion_casting_by_you_icon = 122398

	L.monstrosity, L.monstrosity_desc = EJ_GetSectionInfo(6254)
	L.monstrosity_icon = 122540 -- somewhat relevant icon

	L.willpower = "Willpower"
	L.willpower_desc = select(2, EJ_GetSectionInfo(6249)) --"When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
	L.willpower_icon = 124824
	L.willpower_message = "Willpower at %d!"

	L.break_free_message = "Health at %d%%!"
	L.fling_message = "Getting tossed!"
	L.parasite = "Parasite"

	L.monstrosity_is_casting = "Monstrosity: Explosion"
	L.you_are_casting = "YOU are casting!"

	L.unsok_short = "|cFFF20056Boss|r" -- Light Red
	L.monstrosity_short = "|cFFFFBE00Add|r" -- Amber
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"ej:6548", "FLASHSHAKE", "ICON", "SAY"},
		122784, 123059, { "explosion_by_you" }, { "explosion_casting_by_you", "FLASHSHAKE" }, 123060, "willpower",
		"monstrosity", "explosion_by_other", { "explosion_casting_by_other", "FLASHSHAKE" }, 122413, 122408,
		122556,
		{121995, "FLASHSHAKE", "SAY"}, 123020, {121949, "FLASHSHAKE"},
		"berserk", "bosskill",
	}, {
		["ej:6548"] = "heroic",
		[122784] = "ej:6249",
		monstrosity = "ej:6246",
		[122556] = "ej:6247",
		[121995] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ReshapeLife", 122784)
	self:Log("SPELL_CAST_SUCCESS", "BreakFree", 123060)
	self:Log("SPELL_CAST_SUCCESS", "Beam", 121994)
	self:Log("SPELL_AURA_APPLIED", "Destabilize", 123059)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Destabilize", 123059)
	self:Log("SPELL_CAST_START", "AmberExplosion", 122398)
	self:Log("SPELL_CAST_START", "AmberExplosionMonstrosity", 122402)
	self:Log("SPELL_CAST_SUCCESS", "AmberCarapace", 122540)
	self:Log("SPELL_AURA_APPLIED", "ConcentratedMutation", 122556)
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
end

function mod:OnEngage(diff)
	reshapeLifeCounter = 1
	self:Bar(122784, ("%s (%d)"):format(self:SpellName(122784), reshapeLifeCounter), 20, 122784) --Reshape Life
	self:Bar(121949, 121949, 24, 121949) --Parasitic Growth
	self:Berserk(540) -- assume

	phase = 1
	primaryIcon = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ParasiticGrowth(player, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 50, spellId)
	self:TargetMessage(spellId, L["parasite"], player, "Urgent", spellId, "Long")
	if UnitIsUnit("player", player) then
		self:FlashShake(spellId)
	end
	if self:Healer() then
		self:TargetBar(spellId, L["parasite"], player, 30, spellId)
	end
end

function mod:ParasiticGrowthRemoved(player, _, _, _, spellName)
	--for bubble/ice block/cloak/etc
	self:StopBar(spellName, player)
end

do
	local prev = 0
	function mod:BurningAmber(player, _, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(123020, CL["underyou"]:format(spellName), "Personal", 123020, "Alarm")
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
			mod:CancelTimer(timer, true)
			timer = nil
			if UnitIsUnit("boss1targettarget", "player") then
				mod:FlashShake(spellId)
				mod:SaySelf(spellId)
			end
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist or boss never targets anything but himself
		if fired > 18 then
			mod:CancelTimer(timer, true)
			timer = nil
			mod:Message(spellId, spellId, "Attention", spellId) -- Give generic warning as a backup
		end
	end
	function mod:Beam(_, spellId)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(beamWarn, 0.05, spellId)
		end
	end
end


--------------
-- Construct

function mod:ReshapeLife(player, spellId, _, _, spellName)
	if phase < 2 then
		self:TargetMessage(spellId, ("%s (%d)"):format(spellName, reshapeLifeCounter), player, "Urgent", spellId, "Alarm")
		reshapeLifeCounter = reshapeLifeCounter + 1
		self:Bar(spellId, ("%s (%d)"):format(spellName, reshapeLifeCounter), 50, spellId)
	elseif phase < 3 then
		self:TargetMessage(spellId, spellName, player, "Urgent", spellId, "Alarm")
		self:Bar(spellId, spellName, 50, spellId)
	else
		self:TargetMessage(spellId, spellName, player, "Urgent", spellId, "Alarm")
		self:Bar(spellId, spellName, 15, spellId) -- might be too short for a bar
	end

	if UnitIsUnit("player", player) then
		self:Bar("explosion_by_you", L["explosion_by_you_bar"], 15, 122398)
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "MyWillpower", "player")
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "BreakFreeHP", "player")
	elseif UnitIsUnit("focus", player) then
		self:Bar("explosion_by_other", CL["other"]:format(player, explosion), 15, 122398)
	end
end

function mod:BreakFree(_, _, source)
	if UnitIsUnit("player", source) then
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
		self:StopBar(CL["cast"]:format(explosion))
		self:StopBar(L["explosion_by_you_bar"])
	elseif UnitIsUnit("focus", source) then
		source = source:gsub("%-.+", "*")
		self:StopBar(CL["cast"]:format(CL["other"]:format(source, explosion)))
		self:StopBar(CL["other"]:format(source, explosion))
	end
end

function mod:Destabilize(player, spellId, _, _, spellName, buffStack, _, _, _, dGUID)
	local id = self:GetCID(dGUID)
	if id == 62511 or id == 62711 then
		self:StopBar(("%s: [%d]%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], (buffStack or 1)-1, spellName))
		self:Bar(spellId, ("%s: [%d]%s"):format(id == 62511 and L["unsok_short"] or L["monstrosity_short"], buffStack or 1, spellName), self:LFR() and 60 or 15, spellId)
	end
end

do
	local function warningSpam(spellName)
		if UnitCastingInfo("player") == spellName then
			mod:LocalMessage("explosion_casting_by_you", L["you_are_casting"], "Personal", 122398, "Info")
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosion(_, spellId, player, _, spellName)
		if UnitIsUnit("player", player) then
			self:FlashShake("explosion_casting_by_you")
			self:Bar("explosion_casting_by_you", CL["cast"]:format(explosion), 2.5, spellId)
			self:Bar("explosion_by_you", L["explosion_by_you_bar"], 13, spellId) -- cooldown
			warningSpam(spellName)
		elseif UnitIsUnit("focus", player) then
			self:FlashShake("explosion_casting_by_other")
			player = player:gsub("%-.+", "*")
			self:Bar("explosion_by_other", CL["other"]:format(player, explosion), 13, spellId) -- cooldown
			self:Bar("explosion_casting_by_other", CL["cast"]:format(CL["other"]:format(player, explosion)), 2.5, spellId)
			self:LocalMessage("explosion_casting_by_other", CL["other"]:format(player, explosion), "Important", spellId, "Alert") -- associate the message with the casting toggle option
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
		self:Message("monstrosity", CL["soon"]:format(L["monstrosity"]), "Positive", 122540, "Long")
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

function mod:AmberCarapace(_, spellId)
	phase = 2
	self:Message("monstrosity", L["monstrosity"], "Attention", spellId)
	self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(explosion, 20), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 40, CL["custom_sec"]:format(explosion, 15), "Attention", 122402)
	self:DelayedMessage("explosion_by_other", 45, CL["custom_sec"]:format(explosion, 10), "Attention", 122402)
	self:Bar("explosion_by_other", "~"..L["monstrosity_is_casting"], 55, 122402) -- Monstrosity Explosion

	self:Bar(122408, "~"..mod:SpellName(122408), 22, 122408) --Massive Stomp
	self:Bar(122413, "~"..mod:SpellName(122413), 30, 122413) --Fling
end

do
	local function warningSpam(spellName)
		if UnitCastingInfo("boss1") == spellName or UnitCastingInfo("boss2") == spellName then
			mod:LocalMessage("explosion_casting_by_other", L["monstrosity_is_casting"], "Important", 122398, "Alert")
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionMonstrosity(_, spellId, _, _, spellName)
		self:DelayedMessage("explosion_by_other", 25, CL["custom_sec"]:format(spellName, 20), "Attention", spellId)
		self:DelayedMessage("explosion_by_other", 30, CL["custom_sec"]:format(spellName, 15), "Attention", spellId)
		self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(spellName, 10), "Attention", spellId)
		self:Bar("explosion_casting_by_other", L["monstrosity_is_casting"], 2.5, 122398)
		self:Bar("explosion_by_other", "~"..L["monstrosity_is_casting"], 45, spellId) -- cooldown, don't move this
		if UnitDebuff("player", self:SpellName(122784)) then -- Reshape Life
			self:FlashShake("explosion_casting_by_other")
			warningSpam(spellName)
		end
	end
end

--Monstrosity's Amber Explosion
function mod:MonstrosityStopCast(_, _, _, _, spellId)
	if spellId == 122402 then
		self:StopBar(L["monstrosity_is_casting"])
	end
end

function mod:Fling(player)
	--(0) Grab -> (2.4-4.4) Fling -> (5.7) Rough Landing -> (6.1) damage/stun -> (8.7) stun off
	if UnitIsUnit("player", player) then
		self:Bar(122413, L["fling_message"], 6, 68659)
	end
	--cd is usually 35, but can be 27.8 (cast early when explosion is near the same time normally?)
	self:Bar(122413, "~"..mod:SpellName(122413), 35, 122413) --Fling
	self:TargetMessage(122413, mod:SpellName(122413), player, "Urgent", 122413, "Alarm") --Fling
end

function mod:MassiveStomp(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId, "Alarm")
	self:Bar(spellId, "~"..spellName, 18, spellId) -- 18-29, 24.4 average
end


------------
-- Phase 3

function mod:ConcentratedMutation(_, spellId, _, _, spellName)
	self:StopBar("~"..L["monstrosity_is_casting"])
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 20))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 15))
	self:CancelDelayedMessage(CL["custom_sec"]:format(explosion, 10))
	phase = 3
	self:Message(spellId, spellName, "Attention", spellId)
end

function mod:AmberGlobule(player, spellId, _, _, spellName)
	self:TargetMessage("ej:6548", spellName, player, "Important", spellId, "Alert")
	if UnitIsUnit(player, "player") then
		self:FlashShake("ej:6548")
		self:SaySelf("ej:6548", spellName)
	end
	if not primaryIcon then
		self:PrimaryIcon("ej:6548", player)
		primaryIcon = player
	else
		self:SecondaryIcon("ej:6548", player)
	end
end

function mod:AmberGlobuleRemoved(player)
	if primaryIcon == player then
		self:PrimaryIcon("ej:6548")
		primaryIcon = nil
	else
		self:SecondaryIcon("ej:6548")
	end
end

