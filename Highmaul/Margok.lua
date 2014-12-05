
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Mar'gok", 994, 1197)
if not mod then return end
mod:RegisterEnableMob(77428)
mod.engageId = 1705

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local mineCount = 1
local fixateList = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.volatile_anomaly = -9919 -- Volatile Anomaly
	L.volatile_anomaly_icon = "spell_arcane_arcane04"
	
	L.arcane_wrath = "{156238} ({156225})" -- Arcane Wrath (Branded)
	L.arcane_wrath_desc = 156238
	L.arcane_wrath_icon = 156238

	L.custom_off_fixate_marker = "Fixate Marker"
	L.custom_off_fixate_marker_desc = "Mark Gorian Warmage's Fixate targets with {rt1}{rt2}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fixate_marker_icon = 1
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{159515, "TANK"}, {"arcane_wrath", "ICON", "SAY"}, 156467, 156471, {158605, "ICON", "PROXIMITY", "FLASH", "SAY"}, 157349,
		"volatile_anomaly",
		{157801, "DISPEL"}, {157763, "FLASH"}, "custom_off_fixate_marker",
		{158553, "TANK"}, {158563, "TANK"},
		"stages", "bosskill"
	}, {
		[159515] = mod.displayName,
		["volatile_anomaly"] = "intermission",
		[157801] = -9922,
		[158553] = -9921,
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Phases", "boss1")
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcceleratedAssault", 159515)
	self:Log("SPELL_CAST_START", "ArcaneWrath", 156238, 163988, 163989, 163990) -- Arcane Wrath, Displacement, Fortification, Replication
	self:Log("SPELL_AURA_APPLIED", "Branded", 156225, 164004, 164005, 164006) -- Branded
	self:Log("SPELL_CAST_START", "DestructiveResonance", 156467, 164075, 164076, 164077)
	self:Log("SPELL_CAST_START", "ArcaneAberration", 156471, 164299, 164301, 164303)
	self:Log("SPELL_AURA_APPLIED", "MarkOfChaosApplied", 158605, 164176, 164178, 164191)
	self:Log("SPELL_AURA_REMOVED", "MarkOfChaosRemoved", 158605, 164176, 164178, 164191)
	self:Log("SPELL_CAST_START", "ForceNova", 157349, 164232, 164235, 164240)
	-- Intermission
	self:Log("SPELL_AURA_APPLIED", "IntermissionStart", 174057) -- Arcane Power
	self:Log("SPELL_AURA_REMOVED", "IntermissionEnd", 174057)
	self:Log("SPELL_AURA_APPLIED", "Slow", 157801)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 157763)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 157763)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 158553)
	self:Log("SPELL_CAST_SUCCESS", "KickToTheFace", 158563)
end

function mod:OnEngage()
	phase = 1
	mineCount = 1
	wipe(fixateList)
	self:Bar("arcane_wrath", 6, 156238) -- Arcane Wrath
	self:Bar(156467, 15) -- Destructive Resonance
	self:Bar(156471, 25) -- Arcane Aberration
	self:Bar(158605, 35) -- Mark of Chaos
	self:Bar(157349, 45) -- Force Nova
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if self:Mythic() then
		if (phase == 1 and hp < 71) or (phase == 2 and hp < 38) then -- phases at 66% and 33%
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
			self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
		end
	elseif (phase == 1 and hp < 90) or (phase == 2 and hp < 60) or (phase == 3 and hp < 30) then -- phases at 85%, 55%, and 25%
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
		self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
	end
end

function mod:Phases(unit, spellName, _, _, spellId)
	if spellId == 164336 or spellId == 164751 or spellId == 164810 then -- Teleport to Displacement, Fortification, Replication (Phase end)
		phase = phase + 1
		mineCount = 1

		if spellId == 164336 then -- no intermission for Displacement
			self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
		else
			self:StopBar(156238) -- Arcane Wrath
			self:StopBar(156467) -- Destructive Resonance
			self:StopBar(156471) -- Arcane Aberration
			self:StopBar(158605) -- Mark of Chaos
			self:StopBar(157349) -- Force Nova
		end
	elseif spellId == 158012 or spellId == 157964 then -- Power of Fortification, Replication (Phase start)
		self:CDBar("arcane_wrath", 8, 156238) -- Arcane Wrath
		self:CDBar(156467, 18) -- Destructive Resonance
		self:CDBar(158605, 28) -- Arcane Aberration
		self:CDBar(156471, 38) -- Mark of Chaos
		self:CDBar(157349, 48) -- Force Nova
		if spellId ~= 157964 then -- Replication is the last phase
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
		end
	end
end

function mod:AcceleratedAssault(args)
	if args.amount > 5 and args.amount % 3 == 0 then -- at 5 it stacks every second
		self:Message(args.spellId, "Attention", "Warning", CL.count:format(args.spellName, args.amount))
	end
end

function mod:ArcaneWrath(args)
	self:Message("arcane_wrath", "Urgent", self:Healer() and "Alert", 156238)
	self:Bar("arcane_wrath", 50, 156238) -- XXX first transform messes with the timer (+5-10s)
end

function mod:Branded(args)
	-- custom marking? replication makes it geometric so after three jumps we'd be capped
	-- also might be worth doing a proximity at some point as the jump range lowers (200->100->50->25->13)
	if args.spellId ~= 164006 then -- Replication
		self:SecondaryIcon("arcane_wrath", args.destName)
	end
	if self:Me(args.destGUID) then
		local text = CL.count:format(self:SpellName(156225), args.amount or 1) -- Branded
		self:Message("arcane_wrath", "Personal", "Alarm", CL.you:format(text), 156238)
		self:Say(text)
	end
end

do
	local mineTimes = { 15, 19, 15 } -- patterns!
	function mod:DestructiveResonance(args)
		self:Message(156467, "Urgent")
		self:CDBar(156467, phase == 1 and 24 or mineTimes[mineCount]) -- XXX rp during first transform seems to add 3s to the timer (second cd being 27 pretty consistently)
		if phase > 1 then
			mineCount = mineCount + 1
			if mineCount > 3 then mineCount = 1 end
		end
	end
end

function mod:ArcaneAberration(args)
	self:Message(156471, "Urgent", self:Tank() and "Info")
	self:CDBar(156471, 50)
end

function mod:MarkOfChaosApplied(args)
	self:PrimaryIcon(158605, args.destName)
	self:TargetBar(158605, 8, args.destName)
	self:Bar(158605, 50)
	if self:Me(args.destGUID) then
		self:Flash(158605)
		self:OpenProximity(158605, 35)
		if args.spellId == 164178 then -- Fortification (you're rooted)
			self:Say(158605)
		end
	else
		if args.spellId == 164178 and self:Range(args.destName) < 35 then -- Fortification (target rooted)
			self:Flash(158605)
		end
		self:OpenProximity(158605, 35, args.destName)
	end
	self:TargetMessage(158605, args.destName, "Urgent", "Alarm", nil, nil, true)
end

function mod:MarkOfChaosRemoved(args)
	self:PrimaryIcon(158605)
	self:CloseProximity(158605)
end

function mod:ForceNova(args)
	self:Message(157349, "Urgent")
	self:CDBar(157349, 50) -- sometimes 45 or 54, but usually 50+/-1
	if args.spellId == 164235 then -- Fortification (three novas)
		self:Bar(157349, 8, args.spellName)
		self:ScheduleTimer("Bar", 8, 157349, 8, args.spellName)
	end
end

-- Intermission

do
	local timer = nil
	local function nextAdd(self)
		self:Message("volatile_anomaly", "Attention", "Info", CL.incoming:format(self:SpellName(L.volatile_anomaly)), L.volatile_anomaly_icon)
		self:Bar("volatile_anomaly", 12, L.volatile_anomaly, L.volatile_anomaly_icon)
		timer = self:ScheduleTimer(nextAdd, 12, self)
	end

	function mod:IntermissionStart(args)
		self:Message("stages", "Neutral", nil, CL.intermission, false)
		self:Bar("stages", 65, CL.intermission, "spell_arcane_blast")
		self:Bar("volatile_anomaly", 14, L.volatile_anomaly, L.volatile_anomaly_icon)
		self:ScheduleTimer(nextAdd, 14, self)
	end

	function mod:IntermissionEnd(args)
		self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
		self:CancelTimer(timer)
	end
end

function mod:Slow(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:TargetMessage(args.spellId, args.destName, "Attention", "Alert", nil, true)
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:TargetBar(args.spellId, 15, args.destName)
		self:Flash(args.spellId)
	end
	if self.db.profile.custom_off_fixate_marker then
		local index = next(fixateList) == 1 and 2 or 1
		fixateList[args.destName] = index
		SetRaidTarget(args.destName, index)
	end
end

function mod:FixateRemoved(args)
	if self.db.profile.custom_off_fixate_marker then
		SetRaidTarget(args.destName, 0)
		fixateList[args.destName] = nil
	end
end

function mod:CrushArmor(args)
	if args.amount % 2 == 0 then -- XXX no idea how fast this stacks
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention") -- args.amount > 2 and "Warning"
	end
end

function mod:KickToTheFace(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

