
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
local mineCount, novaCount, aberrationCount = 1, 1, 1
local markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova = nil, nil, nil, nil
local fixateMarks, brandedMarks = {}, {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.branded_say = "%s (%d) %dy"

	L.volatile_anomaly = -9919 -- Volatile Anomaly
	L.volatile_anomaly_icon = "spell_arcane_arcane04"

	L.custom_off_fixate_marker = "Fixate Marker"
	L.custom_off_fixate_marker_desc = "Mark Gorian Warmage's Fixate targets with {rt1}{rt2}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fixate_marker_icon = 1

	L.custom_off_branded_marker = "Branded Marker"
	L.custom_off_branded_marker_desc = "Mark Branded targets with {rt3}{rt4}, requires promoted or leader."
	L.custom_off_branded_marker_icon = 3
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Imperator Mar'gok ]]--
		{159515, "TANK"}, -- Accelerated Assault
		156238, -- Arcane Wrath
		{156225, "PROXIMITY", "SAY", "ME_ONLY"}, -- Branded
		"custom_off_branded_marker",
		156467, -- Destructive Resonance
		156471, -- Summon Arcane Aberration
		{158605, "ICON", "PROXIMITY", "FLASH", "SAY"}, -- Mark of Chaos
		{157349, "PROXIMITY"}, -- Force Nova
		--[[ Intermission ]]--
		"volatile_anomaly",
		--[[ Gorian Warmage ]]--
		{157801, "DISPEL"}, -- Slow
		{157763, "PROXIMITY", "FLASH", "SAY"}, -- Fixate
		"custom_off_fixate_marker",
		--[[ Gorian Reaver ]]--
		{158553, "TANK"}, -- Crush Armor
		{158563, "TANK"}, -- Kick to the Face
		--[[ General ]]--
		"stages",
		"bosskill"
	}, {
		[159515] = mod.displayName,
		["volatile_anomaly"] = "intermission",
		[157801] = -9922, -- Gorian Warmage
		[158553] = -9921, -- Gorian Reaver
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "Phases", "boss1")
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcceleratedAssault", 159515)
	-- Spell, Spell: Displacement, Spell: Fortification, Spell: Replication
	self:Log("SPELL_CAST_START", "ArcaneWrath", 156238, 163988, 163989, 163990)
	self:Log("SPELL_AURA_APPLIED", "Branded", 156225, 164004, 164005, 164006)
	self:Log("SPELL_AURA_REMOVED", "BrandedRemoved", 156225, 164004, 164005, 164006)
	self:Log("SPELL_CAST_START", "DestructiveResonance", 156467, 164075, 164076, 164077)
	self:Log("SPELL_CAST_START", "ArcaneAberration", 156471, 164299, 164301, 164303)
	self:Log("SPELL_CAST_START", "MarkOfChaos", 158605, 164176, 164178, 164191)
	self:Log("SPELL_AURA_APPLIED", "MarkOfChaosApplied", 158605, 164176, 164178, 164191)
	self:Log("SPELL_AURA_REMOVED", "MarkOfChaosRemoved", 158605, 164176, 164178, 164191)
	self:Log("SPELL_CAST_START", "ForceNova", 157349, 164232, 164235, 164240)
	-- Intermission
	self:Log("SPELL_AURA_APPLIED", "IntermissionStart", 174057, 157289) -- Arcane Protection
	self:Log("SPELL_AURA_REMOVED", "IntermissionEnd", 174057, 157289)
	self:Log("SPELL_AURA_APPLIED", "Slow", 157801)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 157763)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 157763)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 158553) -- XXX 10s cast, 4s debuff?
	self:Log("SPELL_CAST_SUCCESS", "KickToTheFace", 158563)
end

function mod:OnEngage()
	phase = 1
	mineCount, novaCount, aberrationCount = 1, 1, 1
	markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova = nil, nil, nil, nil
	wipe(fixateMarks)
	wipe(brandedMarks)
	self:Bar(156238, 6)  -- Arcane Wrath
	self:Bar(156467, 15) -- Destructive Resonance
	self:Bar(156471, 25) -- Arcane Aberration
	self:Bar(158605, 34) -- Mark of Chaos
	self:Bar(157349, 45) -- Force Nova
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity()
	-- mark of chaos > fixate > branded > nova
	-- open in reverse order so if you disable one it doesn't block others from showing
	if replicatingNova then
		mod:OpenProximity(157349, 4)
	end
	if brandedOnMe then
		local _, _, _, amount = UnitDebuff("player", mod:SpellName(brandedOnMe))
		if not amount then amount = 1 end
		local jumpDistance = (brandedOnMe == 164005 and 0.75 or 0.5)^(amount - 1) * 200
		if jumpDistance < 50 then
			mod:OpenProximity(156225, jumpDistance)
		end
	end
	if fixateOnMe then
		mod:OpenProximity(157763, 8)
	end
	if markOfChaosTarget then
		if UnitIsUnit("player", markOfChaosTarget) then
			mod:OpenProximity(158605, 35)
		else
			mod:OpenProximity(158605, 35, markOfChaosTarget)
		end
	end
end

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
		mineCount, novaCount, aberrationCount = 1, 1, 1

		if spellId == 164336 then -- no intermission for Displacement
			 -- XXX first transform messes with timers, typically adding ~10s
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
		self:CDBar(156238, 8)  -- Arcane Wrath
		self:CDBar(156467, 18) -- Destructive Resonance
		self:CDBar(156471, 28) -- Arcane Aberration
		self:CDBar(158605, 38) -- Mark of Chaos
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
	self:Message(156238, "Urgent", self:Healer() and "Alert")
	self:Bar(156238, 50)
	wipe(brandedMarks)
end

do
	local scheduled = nil
	local function mark()
		-- custom_on so try and keep the marks in the same order (just in case)
		sort(brandedMarks)
		for index, name in ipairs(brandedMarks) do
			SetRaidTarget(name, index + 2)
		end
		scheduled = nil
	end

	function mod:Branded(args)
		brandedMarks[#brandedMarks+1] = args.destName

		local _, _, _, amount = UnitDebuff(args.destName, args.spellName)
		if not amount then amount = 1 end
		local jumpDistance = (args.spellId == 164005 and 0.75 or 0.5)^(amount - 1) * 200 -- Fortification takes longer to get rid of

		if self:Me(args.destGUID) and not self:LFR() then
			brandedOnMe = args.spellId
			local text = self:SpellName(156225)
			if jumpDistance < 50 then
				text = L.branded_say:format(text, amount, jumpDistance)
			elseif amount > 1 then
				text = CL.count:format(text, amount)
			end
			self:Say(156225, text)
			updateProximity()
		end
		self:TargetMessage(156225, args.destName, "Attention", nil, L.branded_say:format(self:SpellName(156225), amount, jumpDistance))

		if self.db.profile.custom_off_branded_marker and not scheduled then
			scheduled = self:ScheduleTimer(mark, 0.2)
		end
	end
end

function mod:BrandedRemoved(args)
	tDeleteItem(brandedMarks, args.destName)
	if self:Me(args.destGUID) then
		brandedOnMe = nil
		self:CloseProximity(156225)
		updateProximity()
	end
	if self.db.profile.custom_off_branded_marker then
		SetRaidTarget(args.destName, 0)
	end
end

do
	local mineTimes = {
		[3] = { 24, 15.8, 24, 19.4, 28, 23 },
		[4] = { 24, },
	}
	-- 24.3
	-- 20.7 19.4 20.6 15.8 15.8 20.7
	-- 24.2 15.8 24.3 19.4 27.9 23.1
	-- 24.3 24.3 15.8

	-- 24.3
	-- 15.9 15.8 15.8 20.6 15.8 24.3 15.8
	-- 24.3 15.8 24.2 19.4 28.0 23.1
	-- 24.3 15.8 24.2 19.5
	function mod:DestructiveResonance(args)
		local sound = self:Healer() or self:Damager() == "RANGED"
		self:Message(156467, "Urgent", sound and "Warning")
		local t = not self:Mythic() and mineTimes[phase] and mineTimes[phase][mineCount] or 15
		self:CDBar(156467, phase == 1 and 24 or t)
		mineCount = mineCount + 1
	end
end

function mod:ArcaneAberration(args)
	self:Message(156471, "Urgent", not self:Healer() and "Info")
	self:CDBar(156471, aberrationCount == 1 and 46 or 51)
	aberrationCount = aberrationCount + 1
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(158605, name, "Urgent", "Alarm", nil, nil, true)
	end
	function mod:MarkOfChaos(args)
		self:Bar(158605, 51) -- 51-52 with some random cases of 55
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
	end
end

function mod:MarkOfChaosApplied(args)
	markOfChaosTarget = args.destName
	self:PrimaryIcon(158605, args.destName)
	self:TargetBar(158605, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(158605)
		if args.spellId == 164178 then -- Fortification (you're rooted)
			self:Say(158605)
		end
	elseif args.spellId == 164178 and self:Range(args.destName) < 35 then -- Fortification (target rooted)
		self:Flash(158605)
	end
	updateProximity()
end

function mod:MarkOfChaosRemoved(args)
	markOfChaosTarget = nil
	self:PrimaryIcon(158605)
	self:CloseProximity(158605)
	updateProximity()
end

do
	local function replicatingNovaStop()
		replicatingNova = nil
		mod:CloseProximity(157349)
		updateProximity()
	end
	function mod:ForceNova(args)
		self:Message(157349, "Urgent")
		self:CDBar(157349, novaCount == 1 and 46 or 50)
		if args.spellId == 164235 then -- Fortification (three novas)
			self:Bar(157349, 10.5, args.spellName)
			self:ScheduleTimer("Bar", 8, 157349, 10.5, args.spellName)
		elseif args.spellId == 164240 then -- Replication (aoe damage on hit)
			replicatingNova = self:ScheduleTimer(replicatingNovaStop, 8) -- XXX how long should the proximity be open?
			updateProximity()
		end
		novaCount = novaCount + 1
	end
end

-- Intermission

do
	local timer, intermissionEnd = nil, 0
	local function nextAdd(self)
		self:Message("volatile_anomaly", "Attention", "Info", CL.incoming:format(self:SpellName(L.volatile_anomaly)), L.volatile_anomaly_icon)
		self:Bar("volatile_anomaly", 12, L.volatile_anomaly, L.volatile_anomaly_icon)
		if GetTime() + 12 < intermissionEnd then -- instead of counting
			timer = self:ScheduleTimer(nextAdd, 12, self)
		end
	end

	function mod:IntermissionStart(args)
		self:Message("stages", "Neutral", nil, CL.intermission, false)
		local intermissionTime = args.spellId == 174057 and 65 or 60
		intermissionEnd = GetTime() + intermissionTime
		self:Bar("stages", intermissionTime, CL.intermission, "spell_arcane_blast")
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
		self:TargetMessage(args.spellId, args.destName, "Attention", "Alert", nil, nil, true)
	end
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		fixateOnMe = true
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:TargetBar(args.spellId, 15, args.destName)
		self:Flash(args.spellId)
		self:Say(args.spellId)
		updateProximity()
	end
	if self.db.profile.custom_off_fixate_marker then
		local index = next(fixateMarks) and 2 or 1
		fixateMarks[args.destName] = index
		SetRaidTarget(args.destName, index)
	end
end

function mod:FixateRemoved(args)
	if self:Me(args.destGUID) then
		fixateOnMe = nil
		self:CloseProximity(args.spellId)
		updateProximity()
	end
	if self.db.profile.custom_off_fixate_marker then
		fixateMarks[args.destName] = nil
		SetRaidTarget(args.destName, 0)
	end
end

function mod:CrushArmor(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 2 and "Warning")
end

function mod:KickToTheFace(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

