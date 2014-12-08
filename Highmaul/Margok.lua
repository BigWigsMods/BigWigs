
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
local markOfChaosTarget, brandedOnMe = nil, nil
local fixateList = {}

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
		{156225, "ICON", "PROXIMITY", "SAY", "ME_ONLY"}, -- Branded
		156467, -- Destructive Resonance
		156471, -- Summon Arcane Aberration
		{158605, "ICON", "PROXIMITY", "FLASH", "SAY"}, -- Mark of Chaos
		157349, -- Force Nova
		--[[ Intermission ]]--
		"volatile_anomaly",
		--[[ Gorian Warmage ]]--
		{157801, "DISPEL"}, -- Slow
		{157763, "FLASH"}, -- Fixate
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
	mineCount = 1
	markOfChaosTarget, brandedOnMe = nil, nil
	wipe(fixateList)
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
		self:CDBar(156238, 8) -- Arcane Wrath
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
end

function mod:Branded(args)
	-- custom marking? need two marks (the first jump replicates)
	if args.spellId ~= 164006 then -- Replication
		self:SecondaryIcon(156225, args.destName)
	end

	local _, _, _, amount = UnitDebuff(args.destName, args.spellName)
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
		if jumpDistance < 50 and not markOfChaosTarget then
			self:OpenProximity(156225, jumpDistance)
		end
	end
	self:TargetMessage(156225, args.destName, "Attention", nil, L.branded_say:format(self:SpellName(156225), amount, jumpDistance))
end

function mod:BrandedRemoved(args)
	if self:Me(args.destGUID) then
		brandedOnMe = nil
		if not markOfChaosTarget then
			self:CloseProximity(156225)
		end
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
		self:Message(156467, "Urgent")
		local t = not self:Mythic() and mineTimes[phase] and mineTimes[phase][mineCount] or 15
		self:CDBar(156467, phase == 1 and 24 or t)
		if phase > 1 then
			mineCount = mineCount + 1
			if mineCount > 3 then mineCount = 1 end
		end
	end
end

function mod:ArcaneAberration(args)
	self:Message(156471, "Urgent", not self:Healer() and "Info")
	self:CDBar(156471, 46) -- 46 or 51
end

do
	local isFortification = nil
	local function printTarget(self, name, guid)
		markOfChaosTarget = name
		self:PrimaryIcon(158605, name)
		self:TargetBar(158605, 10, name)
		if self:Me(guid) then
			self:Flash(158605)
			self:OpenProximity(158605, 35)
			if isFortification then -- Fortification (you're rooted)
				self:Say(158605)
			end
		else
			if isFortification and self:Range(name) < 35 then -- Fortification (target rooted)
				self:Flash(158605)
			end
			self:OpenProximity(158605, 35, name)
		end
		self:TargetMessage(158605, name, "Urgent", "Alarm", nil, nil, true)
	end
	function mod:MarkOfChaos(args)
		self:Bar(158605, 51) -- 51-52 with some random cases of 55
		isFortification = args.spellId == 164178
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
	end
end

function mod:MarkOfChaosRemoved(args)
	markOfChaosTarget = nil
	self:PrimaryIcon(158605)
	self:CloseProximity(158605)
	if brandedOnMe then
		local _, _, _, amount = UnitDebuff("player", self:SpellName(brandedOnMe))
		local jumpDistance = (brandedOnMe == 164005 and 0.75 or 0.5)^(amount - 1) * 200
		if jumpDistance < 50 then
			self:OpenProximity(156225, jumpDistance)
		end
	end
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
		self:Bar("stages", args.spellId == 174057 and 65 or 60, CL.intermission, "spell_arcane_blast")
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
		self:Message(args.spellId, "Personal", "Alarm", CL.you:format(args.spellName))
		self:TargetBar(args.spellId, 15, args.destName)
		self:Flash(args.spellId)
	end
	if self.db.profile.custom_off_fixate_marker then
		local index = next(fixateList) and 2 or 1
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
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", args.amount > 2 and "Warning")
end

function mod:KickToTheFace(args)
	self:Message(args.spellId, "Urgent", "Warning")
end

