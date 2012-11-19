
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Amber-Shaper Un'sok", 897, 737)
if not mod then return end
mod:RegisterEnableMob(62511)

--------------------------------------------------------------------------------
-- Locales
--

local reshapeLife, explosion = mod:SpellName(122784), mod:SpellName(122398) --106966
local phase, phase2warned, primaryIcon = 1, nil, nil

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

	L.boss_is_casting = "BOSS is casting!"
	L.you_are_casting = "YOU are casting!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"ej:6548", "FLASHSHAKE", "ICON"},
		122784, 123059, { "explosion_by_you" }, { "explosion_casting_by_you", "FLASHSHAKE" }, 123060, "willpower",
		"monstrosity", "explosion_by_other", { "explosion_casting_by_other", "FLASHSHAKE" }, 122413, 122408,
		122556,
		{121995, "FLASHSHAKE", "SAY"}, 123020, {121949, "FLASHSHAKE"},
		"berserk", "bosskill", --"proximity", 
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
	self:Log("SPELL_DAMAGE", "BurningAmber", 122504)
	self:Log("SPELL_CAST_SUCCESS", "AmberGlobule", 125502)
	self:Log("SPELL_CAST_REMOVED", "AmberGlobuleRemoved", 125502)
	self:Log("SPELL_CAST_SUCCESS", "Fling", 122415) --122415 is actually Grab, the precursor to Fling
	self:Log("SPELL_CAST_START", "MassiveStomp", 122408)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 62511)
end

function mod:OnEngage(diff)
	self:Bar(122784, 122784, 20, 122784) --Reshape Life
	self:Bar(121949, 121949, 24, 121949) --Parasitic Growth
	self:Berserk(540) -- assume

	phase = 1
	phase2warned = nil
	primaryIcon = nil

	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
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
		self:TargetBar(spellId, spellName, player, 30, spellId)
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
				mod:Say(spellId, CL["say"]:format(mod:SpellName(spellId)))
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
	self:TargetMessage(spellId, spellName, player, "Urgent", spellId, "Alarm")
	if phase < 3 then
		self:Bar(spellId, spellName, 50, spellId)
	else
		self:Bar(spellId, spellName, 15, spellId) -- might be too short for a bar
	end

	if UnitIsUnit("player", player) then
		self:Bar("explosion_by_you", CL["you"]:format(explosion), 15, 122398)
		self:RegisterEvent("UNIT_POWER_FREQUENT")
	elseif UnitIsUnit("focus", player) then
		self:Bar("explosion_by_other", CL["other"]:format(player, explosion), 15, 122398)
	end
end

function mod:BreakFree(_, _, source)
	if UnitIsUnit("player", source) then
		self:UnregisterEvent("UNIT_POWER_FREQUENT")
		self:StopBar(CL["cast"]:format(CL["you"]:format(explosion)))
		self:StopBar(CL["you"]:format(explosion))
	elseif UnitIsUnit("focus", source) then
		self:StopBar(CL["cast"]:format(CL["other"]:format(source, explosion)))
		self:StopBar(CL["other"]:format(source, explosion))
	end
end

function mod:Destabilize(player, spellId, _, _, spellName)
	self:Bar(spellId, CL["other"]:format(spellName, player), self:LFR() and 60 or 15, spellId)
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
			self:Bar("explosion_casting_by_you", CL["cast"]:format(CL["you"]:format(spellName)), 2.5, spellId)
			self:Bar("explosion_by_you", CL["you"]:format(spellName), 13, spellId) -- cooldown
			warningSpam(spellName)
		elseif UnitIsUnit("focus", player) then
			self:FlashShake("explosion_casting_by_other")
			self:Bar("explosion_by_other", CL["other"]:format(player, spellName), 13, spellId) -- cooldown
			self:Bar("explosion_casting_by_other", CL["cast"]:format(CL["other"]:format(player, spellName)), 2.5, spellId)
			self:LocalMessage("explosion_casting_by_other", CL["other"]:format(player, spellName), "Important", spellId, "Alert") -- associate the message with the casting toggle option
		end
	end
end

function mod:UNIT_SPELLCAST_INTERRUPTED(_, unitId, spellName, _, _, spellId)
	--Mutated Construct's Struggle for Control doesn't fire a SPELL_INTERRUPT
	if spellId == 122398 then
		if unitId == "player" then
			self:StopBar(CL["cast"]:format(CL["you"]:format(spellName)))
		elseif unitId == "focus" then
			local player = UnitName(unitId)
			self:StopBar(CL["cast"]:format(CL["other"]:format(player, spellName)))
		end
	end
end

--Willpower
do
	local prev = 0
	function mod:UNIT_POWER_FREQUENT(_, unitId, powerType)
		if unitId == "player" and powerType == "ALTERNATE" then
			local t = GetTime()
			if t-prev > 1 then
				local willpower = UnitPower("player", 10)
				if willpower < 20 and willpower > 0 then
					prev = t
					self:LocalMessage("willpower", L["willpower_message"]:format(willpower), "Personal", 124824)
				end
			end
		end
	end
end

do
	local prev = 0
	function mod:UNIT_HEALTH_FREQUENT(_, unitId)
		if unitId == "boss1" and not phase2warned then
			local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
			if hp < 75 then -- phase starts at 70
				phase2warned = true
				self:Message("monstrosity", CL["soon"]:format(L["monstrosity"]), "Positive", 122540, "Long")
			end
		elseif unitId == "player" and UnitDebuff("player", reshapeLife) then --Break Free Warning
			local t = GetTime()
			if t-prev > 1 then
				local hp = UnitHealth("player") / UnitHealthMax("player") * 100
				if hp < 21 then
					prev = t
					self:LocalMessage(123060, L["break_free_message"]:format(hp), "Personal", 123060)
				end
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
	self:Bar("explosion_by_other", "~"..CL["onboss"]:format(explosion), 55, 122402) -- Monstrosity Explosion

	--TIL you can dodge fling! is like rotface's explosion, you have ~3s to move after it picks a player
	--self:OpenProximity(8) --8yds for Fling
	self:Bar(122408, "~"..mod:SpellName(122408), 22, 122408) --Massive Stomp
	self:Bar(122413, "~"..mod:SpellName(122413), 30, 122413) --Fling
end

do
	local function warningSpam(spellName)
		if UnitCastingInfo("boss2") == spellName then
			mod:LocalMessage("explosion_casting_by_other", L["boss_is_casting"], "Important", 122398, "Alert")
			mod:ScheduleTimer(warningSpam, 0.5, spellName)
		end
	end
	function mod:AmberExplosionMonstrosity(_, spellId, _, _, spellName)
		self:DelayedMessage("explosion_by_other", 25, CL["custom_sec"]:format(spellName, 20), "Attention", spellId)
		self:DelayedMessage("explosion_by_other", 30, CL["custom_sec"]:format(spellName, 15), "Attention", spellId)
		self:DelayedMessage("explosion_by_other", 35, CL["custom_sec"]:format(spellName, 10), "Attention", spellId)
		self:Bar("explosion_casting_by_other", L["boss_is_casting"], 2.5, 122398)
		self:Bar("explosion_by_other", "~"..CL["onboss"]:format(spellName), 45, spellId) -- cooldown, don't move this
		if UnitDebuff("player", reshapeLife) then
			self:FlashShake("explosion_casting_by_other")
			warningSpam(spellName)
		end
	end
end

--Monstrosity's Amber Explosion
function mod:UNIT_SPELLCAST_STOP(_, _, _, _, _, spellId)
	if spellId == 122402 then
		self:StopBar(L["boss_is_casting"])
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
	self:StopBar("~"..CL["onboss"]:format(explosion))
	--self:CloseProximity()
	phase = 3
	self:Message(spellId, spellName, "Attention", spellId)
end

function mod:AmberGlobule(player, spellId, _, _, spellName)
	self:TargetMessage("ej:6548", spellName, player, "Important", spellId, "Alert")
	if UnitIsUnit(player, "player") then
		self:FlashShake("ej:6548")
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

