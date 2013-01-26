
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grand Empress Shek'zeer", 897, 743)
if not mod then return end
mod:RegisterEnableMob(62837)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Death to all who dare challenge my empire!"
	L.phases = "Phases"
	L.phases_desc = "Warning for phase changes."
	L.phases_icon = "achievement_raid_mantidraid07"

	L.eyes = "Eyes of the Empress"
	L.eyes_desc = "Count the stacks and show a duration bar for Eyes of the Empress."
	L.eyes_icon = 123707
	L.eyes_message = "%2$dx Eyes on %1$s"

	L.fumes_bar = "Your fumes buff"
end
L = mod:GetLocale()
L.eyes = L.eyes.." "..INLINE_TANK_ICON
L.eyes_desc = CL.tank..L.eyes_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{123845, "FLASHSHAKE", "ICON", "SAY"},
		"ej:6325", "eyes", {123788, "FLASHSHAKE", "ICON"}, "proximity", 123735,
		{125390, "FLASHSHAKE"}, 124097, 125826, 124827, {124077, "FLASHSHAKE"},
		{124862, "FLASHSHAKE", "SAY", "PROXIMITY"}, { 124849, "FLASHSHAKE" },
		"phases", "berserk", "bosskill",
	}, {
		[123845] = "heroic",
		["ej:6325"] = "ej:6336",
		[125390] = "ej:6340",
		[124862] = "ej:6341",
		phases = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Eyes", 123707)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Eyes", 123707)
	self:Log("SPELL_CAST_SUCCESS", "DreadScreech", 123735)
	self:Log("SPELL_AURA_APPLIED", "CryOfTerror", 123788)
	self:Log("SPELL_AURA_REMOVED", "CryOfTerrorRemoved", 123788)

	self:Log("SPELL_AURA_APPLIED", "Poison", 124827)
	self:Log("SPELL_AURA_REFRESH", "Poison", 124827)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 125390)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 125390)
	self:Log("SPELL_AURA_APPLIED", "Dispatch", 124077)
	self:Log("SPELL_AURA_APPLIED", "Resin", 124097)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AmberTrap", 124748)

	self:Log("SPELL_AURA_APPLIED", "UltimateCorruption", 125451)
	self:Log("SPELL_AURA_REMOVED", "VisionsRemoved", 124862)
	self:Log("SPELL_AURA_APPLIED", "VisionsDispel", 124868)
	self:Log("SPELL_AURA_APPLIED", "Visions", 124862)
	self:Log("SPELL_CAST_START", "ConsumingTerror", 124849)

	self:Log("SPELL_AURA_APPLIED", "HeartOfFearApplied", 123845)
	self:Log("SPELL_AURA_REMOVED", "HeartOfFearRemoved", 123845)

	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PoorMansDissonanceTimers", "boss1")
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "Phase3Warn", "boss1")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 62837)
end

function mod:OnEngage(diff)
	self:OpenProximity(5)
	self:Berserk(900)
	self:Bar("ej:6325", 123627, 20, 123627) --Dissonance Field
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HeartOfFearRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:HeartOfFearApplied(args)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Important", args.spellId, "Info")
	self:PrimaryIcon(args.spellId, args.destName)
	if UnitIsUnit("player", args.destName) then
		self:FlashShake(args.spellId)
		self:Say(args.spellId, args.spellName)
	end
end

function mod:Dispatch(args)
	-- this is for interrupting, maybe check if the person can interrupt
	if UnitGUID("target") == args.sourceGUID or UnitGUID("focus") == args.sourceGUID then
		self:LocalMessage(args.spellId, CL["cast"]:format(args.spellName), "Personal", args.spellId, "Long")
		self:FlashShake(args.spellId)
	end
end

function mod:Poison(args)
	if UnitIsUnit("player", args.destName) then
		self:Bar(args.spellId, L["fumes_bar"], 30, args.spellId)
	end
end

function mod:DreadScreech(args)
	self:Bar(args.spellId, "~"..args.spellName, 6, args.spellId) -- healers wanted it, think it is useless
end

function mod:ConsumingTerror(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Alert")
	self:Bar(args.spellId, "~"..args.spellName, 31, args.spellId) -- 31.3-37.7
	self:FlashShake(args.spellId)
end

function mod:CryOfTerror(args)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Attention", args.spellId, "Long")
	self:PrimaryIcon(args.spellId, args.args.destName)
	self:Bar(args.spellId, args.spellName, 25, args.spellId)
	if UnitIsUnit("player", args.destName) then
		self:FlashShake(args.spellId)
	end
end

function mod:CryOfTerrorRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local prev = 0
	function mod:VisionsDispel(args)
		if self:Dispeller("magic") or select(2, UnitClass("player")) == "SHAMAN" then -- shamans too because of tremor totem
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:LocalMessage(124862, args.spellName, "Attention", args.spellId, "Alert")
			end
		end
	end
end

function mod:VisionsRemoved(args)
	self:CloseProximity(args.spellId)
end

do
	local visionsList, scheduled = mod:NewTargetList(), nil
	local function warnVisions(spellId)
		mod:TargetMessage(spellId, spellId, visionsList, "Important", spellId, "Alarm")
		scheduled = nil
	end
	function mod:Visions(args)
		visionsList[#visionsList + 1] = args.destName
		if UnitIsUnit("player", args.destName) then
			self:Say(args.spellId, args.spellName) -- not sure if this is needed, I think most people bunch up for healing, say bubble spam is not really helpful
			self:FlashShake(args.spellId)
			self:OpenProximity(8, args.spellId)
		end
		--self:Bar(spellId, "~"..spellName, 19, spellId) -- 19.3-27.7 (ew)
		if not scheduled then
			scheduled = self:ScheduleTimer(warnVisions, 0.1, args.spellId)
		end
	end
end

function mod:Fixate(args)
	self:TargetMessage(args.spellId, args.spellName, args.destName, "Attention", args.spellId, "Info")
	if UnitIsUnit("player", args.destName) then
		self:FlashShake(args.spellId)
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
		self:TargetBar(args.spellId, args.spellName, args.destName, 20, args.spellId)
	end
end

function mod:FixateRemoved(args)
	if UnitIsUnit("player", args.destName) then
		self:StopBar(CL["you"]:format(args.spellName))
	end
end

function mod:Resin(args)
	if UnitIsUnit("player", args.destName) then
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
	end
end

function mod:AmberTrap(args)
	local buffStack = args.amount or 1
	if buffStack < 5 then
		self:Message(125826, ("%s (%d)"):format(args.spellName, buffStack), "Attention", 125826) --Sticky Resin (124748)
	else
		self:Message(125826, 125826, "Attention", 125826) --Amber Trap
	end
end

do
	local warned = 0
	function mod:PoorMansDissonanceTimers(unitId)
		local power = UnitPower(unitId)
		if warned == power then return end
		warned = power
		if power == 149 then
			self:OpenProximity(5)
			self:Bar("ej:6325", 123627, 19, 128353) --Dissonance Field
			self:Bar("phases", CL["phase"]:format(2), 149, L.phases_icon)
			self:StopBar(CL["phase"]:format(1))
		elseif power == 130 then
			self:Bar("ej:6325", 123627, 65, 128353)
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 65 then
			self:Message("ej:6325", 123627, "Attention", 128353)
		elseif power == 2 then
			self:CloseProximity()
			self:Bar("phases", CL["phase"]:format(1), 158, L.phases_icon)
		end
	end
end

function mod:Eyes(args)
	if self:Tank() then
		local buffStack = args.amount or 1
		local player = args.destName:gsub("%-.+", "*")
		self:StopBar(L["eyes_message"]:format(player, buffStack - 1))
		self:Bar("eyes", L["eyes_message"]:format(player, buffStack), 30, args.spellId)
		self:LocalMessage("eyes", L["eyes_message"], "Urgent", args.spellId, buffStack > 2 and "Info" or nil, player, buffStack)
	end
end

function mod:UltimateCorruption(args)
	self:Message("phases", "30% - "..CL["phase"]:format(3), "Positive", args.spellId, "Info")
	self:StopBar(CL["phase"]:format(2))
	self:StopBar(123627) -- Dissonance Field
	self:CloseProximity()
	--self:Bar(124862, "~"..mod:SpellName(124862), 6, 124862) -- Visions of Demise
	self:Bar(124849, "~"..mod:SpellName(124849), 10, 124849) -- Consuming Terror
end

function mod:Phase3Warn(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 35 then -- phase starts at 30
		self:Message("phases", CL["soon"]:format(CL["phase"]:format(3)), "Positive", L.phases_icon, "Info")
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

