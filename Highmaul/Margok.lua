
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Mar'gok", 994, 1197)
if not mod then return end
mod:RegisterEnableMob(77428, 78623) -- Imperator Mar'gok, Cho'gall (Mythic)
mod.engageId = 1705

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local mineCount, novaCount, aberrationCount, nightCount, glimpseCount = 1, 1, 1, 1, 1
local addDeathWarned = nil
local markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova, gazeOnMe = nil, nil, nil, nil, nil
local novaTimer = nil
local fixateMarks, brandedMarks, gazeTargets = {}, {}, {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.branded_say = "%s (%d) %dy"
	L.add_death_soon = "Add dying soon!"
	L.slow_fixate = "Slow+Fixate"

	L.adds = "Night-Twisted Faithful"
	L.adds_desc = "Timer for when Night-Twisted Faithful enter the fight."
	L.adds_icon = "spell_shadow_raisedead"

	L.volatile_anomaly = -9919 -- Volatile Anomaly
	L.volatile_anomaly_icon = "spell_arcane_arcane04"

	L.custom_off_fixate_marker = "Fixate Marker"
	L.custom_off_fixate_marker_desc = "Mark Gorian Warmage's Fixate targets with {rt1}{rt2}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
	L.custom_off_fixate_marker_icon = 1

	L.custom_off_branded_marker = "Branded Marker"
	L.custom_off_branded_marker_desc = "Mark Branded targets with {rt3}{rt4}, requires promoted or leader."
	L.custom_off_branded_marker_icon = 3
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Mythic ]]--
		178607, -- Dark Star
		165102, -- Infinite Darkness
		165116, -- Entropy
		165876, -- Enveloping Night
		165243, -- Glimpse of Madness
		{176537, "FLASH"}, -- Eyes of the Abyss
		{165595, "PROXIMITY", "SAY"}, -- Gaze of the Abyss
		"adds", -- Night-Twisted Faithful
		{176533, "FLASH"}, -- Growing Darkness
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
		178468, -- Nether Energy (Mythic)
		"custom_off_fixate_marker",
		--[[ Gorian Reaver ]]--
		-9921, -- Gorian Reaver
		{158553, "TANK_HEALER"}, -- Crush Armor
		{158563, "TANK"}, -- Kick to the Face
		--[[ General ]]--
		"stages",
		"berserk",
	}, {
		[178607] = "mythic",
		[159515] = mod.displayName,
		["volatile_anomaly"] = "intermission",
		[157801] = -9922, -- Gorian Warmage
		[-9921] = -9921, -- Gorian Reaver
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PhaseEnd", 181089) -- Encounter Event
	self:Log("SPELL_AURA_APPLIED", "DisplacementPhaseStart", 158013) -- Power of Displacement
	self:Log("SPELL_AURA_APPLIED", "PhaseStart", 158012, 157964) -- Power of Fortification, Replication
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
	self:Log("SPELL_AURA_REFRESH", "FixateApplied", 157763)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 157763)
	self:Log("SPELL_AURA_APPLIED", "CrushArmor", 158553)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 158553)
	self:Log("SPELL_CAST_SUCCESS", "KickToTheFace", 158563)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED_DOSE", "NetherEnergy", 178468)
	self:Log("SPELL_CAST_START", "GlimpseOfMadness", 165243)
	self:Log("SPELL_CAST_START", "DarkStar", 178607)
	self:Log("SPELL_CAST_START", "EnvelopingNight", 165876)
	self:Log("SPELL_AURA_APPLIED", "InfiniteDarkness", 165102)
	self:Log("SPELL_AURA_APPLIED", "Entropy", 165116)
	self:Log("SPELL_AURA_APPLIED", "GazeOfTheAbyssApplied", 165595)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GazeOfTheAbyssApplied", 165595)
	self:Log("SPELL_AURA_REMOVED", "GazeOfTheAbyssRemoved", 165595)
	self:Log("SPELL_AURA_APPLIED", "EyesOfTheAbyssApplied", 176537)
	self:Log("SPELL_AURA_REMOVED", "EyesOfTheAbyssRemoved", 176537)
	self:Log("SPELL_AURA_APPLIED", "GrowingDarknessDamage", 176525)
	self:Log("SPELL_CAST_SUCCESS", "ChogallSpawn", 181113) -- Encounter Spawn

	self:Death("ReaverDeath", 78549) -- Gorian Reaver
end

function mod:OnEngage()
	phase = 1
	mineCount, novaCount, aberrationCount = 1, 1, 1
	markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova = nil, nil, nil, nil
	addDeathWarned = nil
	wipe(fixateMarks)
	wipe(brandedMarks)
	self:Bar(156238, 6) -- Arcane Wrath
	self:Bar(156467, 15) -- Destructive Resonance
	self:Bar(156471, 25, CL.count:format(self:SpellName(-9945), aberrationCount), 156471) -- Arcane Aberration
	self:Bar(158605, 34) -- Mark of Chaos
	self:Bar(157349, 45) -- Force Nova
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	if self:LFR() then
		self:Berserk(900)
	end
end

function mod:OnBossDisable()
	if self.db.profile.custom_off_branded_marker then
		for _, player in next, brandedMarks do
			SetRaidTarget(player, 0)
		end
		wipe(brandedMarks)
	end
	if self.db.profile.custom_off_fixate_marker then
		for player in next, fixateMarks do
			SetRaidTarget(player, 0)
		end
		wipe(fixateMarks)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function updateProximity()
	-- Gaze of the Abyss
	if mod:Mythic() and phase == 4 then
		if gazeOnMe then
			mod:OpenProximity(165595, 8)
		elseif #gazeTargets > 0 then
			mod:OpenProximity(165595, 8, gazeTargets)
		end
	end

	-- mark of chaos > fixate > branded > nova
	-- open in reverse order so if you disable one it doesn't block others from showing
	if replicatingNova then
		mod:OpenProximity(157349, 4)
	end
	if brandedOnMe and brandedOnMe < 40 then
		mod:OpenProximity(156225, max(5, brandedOnMe))
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

-- Mythic

do
	local function startPhase(self)
		self:StopBar(156238) -- Arcane Wrath
		self:StopBar(156467) -- Destructive Resonance
		self:StopBar(CL.count:format(self:SpellName(-9945), aberrationCount)) -- Arcane Aberration
		self:StopBar(158605) -- Mark of Chaos
		self:StopBar(157349) -- Force Nova
		self:StopBar(164235) -- Force Nova: Fortification
		self:CancelTimer(novaTimer)
		if replicatingNova then
			self:CancelTimer(replicatingNova)
			replicatingNova = nil
			self:CloseProximity(157349)
			updateProximity()
		end
		-- p4 stuff goooooo
		self:CDBar(165102, 36) -- Infinite Darkness
		self:CDBar(165243, 43) -- Glimpse of Madness
		self:CDBar(178607, 53) -- Dark Star
		self:CDBar(165876, 79, CL.count:format(self:SpellName(165876), nightCount)) -- Enveloping Night
	end

	local function nextAdd(self)
		self:Message("adds", "Attention", "Info", CL.incoming:format(CL.adds), L.adds_icon)
		self:Bar("adds", 30, CL.adds, L.adds_icon)
		self:ScheduleTimer(nextAdd, 30, self) -- could use ScheduleRepeatingTimer, but the first time had to be special and ruin it :(
	end

	function mod:ChogallSpawn(args)
		if self:MobId(args.sourceGUID) == 78623 then -- Cho'gall
			self:ScheduleTimer(startPhase, 10, self)
			phase = 4
			nightCount = 1
			glimpseCount = 1
			gazeOnMe = nil
			wipe(gazeTargets)
			self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
			self:CDBar("adds", 32, CL.adds, L.adds_icon)
			self:ScheduleTimer(nextAdd, 32, self)
			self:DelayedMessage(165876, 80, "Important", CL.soon:format(CL.count:format(self:SpellName(165876), nightCount)), false, "Info")
		end
	end
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Attention", self:Healer() and "Alert", nil, nil, true)
		scheduled = nil
	end
	function mod:InfiniteDarkness(args)
		list[#list + 1] = args.destName
		if not scheduled then
			self:CDBar(args.spellId, 62)
			scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
		end
	end
end

function mod:Entropy(args)
	if self:Me(args.destGUID) then
		local text = args.amount and args.amount > 0 and ("%s +%s"):format(args.spellName, BreakUpLargeNumbers(args.amount)) or nil -- XXX shooould have an amount
		self:Message(args.spellId, "Positive", nil, text)
		self:Bar(args.spellId, 10)
	end
end

function mod:EntropyRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId)
	end
end

function mod:DarkStar(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:Bar(args.spellId, 7, ("<%s>"):format(args.spellName))
	self:Bar(args.spellId, 60)
end

function mod:EnvelopingNight(args)
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, nightCount))
	self:Bar(args.spellId, 3, CL.cast:format(CL.count:format(args.spellName, nightCount)))
	nightCount = nightCount + 1
	self:Bar(args.spellId, 63, CL.count:format(args.spellName, nightCount))
	self:DelayedMessage(args.spellId, 53, "Important", CL.soon:format(CL.count:format(args.spellName, nightCount)), false, "Info")
end

function mod:GlimpseOfMadness(args)
	self:Message(args.spellId, "Attention", "Info", CL.count:format(args.spellName, glimpseCount))
	glimpseCount = glimpseCount + 1
	self:Bar(args.spellId, 27, CL.count:format(args.spellName, glimpseCount))
end

do -- Gaze/Eyes of the Abyss
	-- I may be trying to be too clever here, but hopefully I over-engineered it enough to play nice
	-- only show the proximity for people that aren't targeted by an add (debuff will fall off)

	local timeLeft, timer = 15, nil
	local function sayCountdown(self)
		timeLeft = timeLeft - 1
		if timeLeft < 5 then
			self:Say(165595, timeLeft, true)
			if timeLeft < 2 then
				self:CancelTimer(timer)
			end
		end
	end

	function mod:GazeOfTheAbyssApplied(args)
		if self:Me(args.destGUID) then
			gazeOnMe = true
			local amount = args.amount or 1
			self:StackMessage(args.spellId, args.destName, amount, "Personal", amount > 2 and "Warning")
			self:TargetBar(args.spellId, 15, args.destName)

			self:CancelTimer(timer)
			timeLeft = 15
			timer = self:ScheduleRepeatingTimer(sayCountdown, 1, self)

			updateProximity()
		elseif not UnitDebuff(args.destName, self:SpellName(176537)) and not tContains(gazeTargets, args.destName) then -- no "closest" debuff and not currently tracked
			gazeTargets[#gazeTargets + 1] = args.destName
			updateProximity()
		end
	end

	function mod:GazeOfTheAbyssRemoved(args)
		tDeleteItem(gazeTargets, args.destName)
		if self:Me(args.destGUID) then
			gazeOnMe = nil
			self:StopBar(args.spellId, args.destName)
			self:CancelTimer(timer)
			self:CloseProximity(args.spellId)
		elseif #gazeTargets == 0 and not gazeOnMe then
			self:CloseProximity(args.spellId)
		end
		updateProximity()
	end

	function mod:EyesOfTheAbyssApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alarm", CL.you:format(self:SpellName(167536)), args.spellId) -- 167536 = "Eyes"
			self:Flash(args.spellId)
			if gazeOnMe then return end
		end

		tDeleteItem(gazeTargets, args.destName)
		if #gazeTargets == 0 and not gazeOnMe then
			self:CloseProximity(165595) -- Gaze of the Abyss
		end
		updateProximity()
	end

	function mod:EyesOfTheAbyssRemoved(args)
		if not self:Me(args.destGUID) and UnitDebuff(args.destName, self:SpellName(165595)) and not tContains(gazeTargets, args.destName) then -- check explody debuff
			gazeTargets[#gazeTargets + 1] = args.destName
			updateProximity()
		end
	end
end

do
	local prev = 0
	function mod:GrowingDarknessDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL.underyou:format(args.spellName)) -- you ded, so ded.
			self:Flash(args.spellId)
		end
	end
end

-- General

function mod:UNIT_HEALTH_FREQUENT(unit)
	local mobId = self:MobId(UnitGUID(unit))
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if mobId == 77428 then
		if self:Mythic() then
			if (phase == 1 and hp < 71) or (phase == 2 and hp < 38) or (phase == 3 and hp < 10) then -- phases at 66% and 33% and 5%
				self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
				self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
			end
		elseif (phase == 1 and hp < 90) or (phase == 2 and hp < 60) or (phase == 3 and hp < 30) then -- phases at 85%, 55%, and 25%
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
			self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
		end
	elseif mobId == 77879 and not addDeathWarned and hp < 30 then -- Displacing Arcane Aberration
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		self:Message(156471, "Attention", "Info", L.add_death_soon)
		addDeathWarned = true
	end
end

function mod:PhaseEnd()
	phase = phase + 1

	if phase == 2 then -- short intermission for Displacement
		self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
		-- attempt #4 it seems more like paused if < 10, then starts casting with a 3s cd to get caught up with expired spells
		self:StopBar(156467) -- Destructive Resonance
		if self:BarTimeLeft(156238) < 13 then self:PauseBar(156238) end
		if self:BarTimeLeft(156467) < 13 then self:PauseBar(156467) end
		if self:BarTimeLeft(CL.count:format(self:SpellName(-9945), aberrationCount)) < 15 then self:PauseBar(156471, CL.count:format(self:SpellName(-9945), aberrationCount)) end
		if self:BarTimeLeft(158605) < 13 then self:PauseBar(158605) end
		if self:BarTimeLeft(157349) < 13 then self:PauseBar(157349) end
	else
		self:StopBar(156238) -- Arcane Wrath
		self:StopBar(156467) -- Destructive Resonance
		self:StopBar(CL.count:format(self:SpellName(-9945), aberrationCount)) -- Arcane Aberration
		self:StopBar(158605) -- Mark of Chaos
		self:StopBar(157349) -- Force Nova
		self:StopBar(164235) -- Force Nova: Fortification
		self:CancelTimer(novaTimer)

		mineCount, novaCount, aberrationCount = 1, 1, 1
		local phaseToCheck = self:Mythic() and 3 or 4
		self:Bar("volatile_anomaly", phase == phaseToCheck and 12 or 9, CL.count:format(self:SpellName(L.volatile_anomaly), 1), L.volatile_anomaly_icon)
		if phase == phaseToCheck then
			self:Bar(-9921, 15, nil, "ability_warrior_shieldbreak") -- Gorian Reaver
			self:DelayedMessage(-9921, 15, "Neutral", nil, false, "Info")
			-- Kick can vary, think it's similar to Brackenspore's big adds where they'll wait until after they melee someone to start their abilities
			self:ScheduleTimer("CDBar", 15, 158563, 25) -- Kick to the Face
		end
	end
end

function mod:DisplacementPhaseStart(args)
	if not self:Mythic() then
		self:ResumeBar(156238) -- Arcane Wrath
		self:CDBar(156467, 15) -- Destructive Resonance
		self:ResumeBar(156471, CL.count:format(self:SpellName(-9945), aberrationCount)) -- Arcane Aberration
		self:ResumeBar(158605) -- Mark of Chaos
		self:ResumeBar(157349) -- Force Nova
	end
end

function mod:PhaseStart(args)
	if not self.isEngaged then return end -- In Mythic mode he gains this when he's floating around the room before engage.
	self:CDBar(156238, 8) -- Arcane Wrath
	self:CDBar(156467, 18) -- Destructive Resonance
	self:CDBar(156471, 28, CL.count:format(self:SpellName(-9945), aberrationCount)) -- Arcane Aberration
	self:CDBar(158605, 38) -- Mark of Chaos
	self:CDBar(157349, 48) -- Force Nova
	if args.spellId ~= 157964 or self:Mythic() then -- Replication is the last phase
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
	end
end

function mod:AcceleratedAssault(args)
	if args.amount > 5 and args.amount % 3 == 0 then -- at 5 it stacks every second
		-- This is the buff the boss gains if he is hitting the same tank. It's not really a stack message on the tank, but this is a clearer way of presenting it.
		self:StackMessage(args.spellId, self:UnitName("boss1target"), args.amount, "Attention", "Warning")
	end
end

function mod:ArcaneAberration(args)
	self:StopBar(CL.count:format(self:SpellName(-9945), aberrationCount)) -- just to be safe
	self:Message(156471, "Attention", not self:Healer() and "Info", CL.count:format(CL.add_spawned, aberrationCount))
	aberrationCount = aberrationCount + 1
	self:CDBar(156471, aberrationCount == 2 and 46 or 51, CL.count:format(self:SpellName(-9945), aberrationCount), 156471) -- Arcane Aberration
	if args.spellId == 164299 or (self:Mythic() and phase == 2) then -- Displacing
		addDeathWarned = nil
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss2")
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
		sort(brandedMarks)
		for index, name in ipairs(brandedMarks) do
			SetRaidTarget(name, index + 2)
		end
		scheduled = nil
	end

	function mod:Branded(args)
		brandedMarks[#brandedMarks+1] = args.destName

		local _, _, _, amount = UnitDebuff(self:Me(args.destGUID) and "player" or args.destName, args.spellName)
		if not amount then amount = 0 end -- don't show count or distance (never got any reports of this happening, but just to make sure)
		local isFortification = args.spellId == 164005 or (self:Mythic() and phase == 3)
		local jumpDistance = (isFortification and 0.75 or 0.5)^(amount - 1) * 200 -- Fortification takes longer to get rid of

		if self:Me(args.destGUID) then
			self:TargetBar(156225, 4, args.destName)
			if not self:LFR() then
				local text = self:SpellName(156225)
				if amount > 0 and jumpDistance < 100 then
					text = L.branded_say:format(text, amount, jumpDistance)
				elseif amount > 1 then
					text = CL.count:format(text, amount)
				end
				self:Say(156225, text)
			end
			if amount > 0 then
				brandedOnMe = jumpDistance
				updateProximity()
			end
		end
		self:TargetMessage(156225, args.destName, "Attention", nil, amount > 0 and L.branded_say:format(self:SpellName(156225), amount, jumpDistance))

		if self.db.profile.custom_off_branded_marker and not scheduled then
			scheduled = self:ScheduleTimer(mark, 0.2)
		end
	end
end

function mod:BrandedRemoved(args)
	tDeleteItem(brandedMarks, args.destName)
	if self:Me(args.destGUID) then
		brandedOnMe = nil
		self:StopBar(156225, args.destName)
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
	}
	function mod:DestructiveResonance(args)
		self:Message(156467, "Important", self:Ranged() and "Warning")
		local t = mineCount == 1 and 24 or (not self:Mythic() and mineTimes[phase] and mineTimes[phase][mineCount]) or 15.8
		self:CDBar(156467, t)
		mineCount = mineCount + 1
	end
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
		if args.spellId == 164235 or (self:Mythic() and phase == 3) then -- Fortification (three novas)
			self:Bar(157349, 10.5, 164235) -- 164235 = Force Nova: Fortification
			novaTimer = self:ScheduleTimer("Bar", 10.5, 157349, 8, 164235)
		elseif args.spellId == 164240 or (self:Mythic() and phase == 1) then -- Replication (aoe damage on hit)
			replicatingNova = self:ScheduleTimer(replicatingNovaStop, (self:Mythic() and phase == 3) and 26 or 8) -- keep it open longer for fortification+replication
			updateProximity()
		end
		novaCount = novaCount + 1
	end
end

do
	local function printTarget(self, name, guid)
		if self:Me(guid) then
			self:Message(158605, "Personal", "Alarm", CL.casting:format(CL.you:format(self:SpellName(158605))))
			if phase == 3 or (self:Mythic() and phase == 2) then -- Fortification
				self:Flash(158605)
			end
		else
			self:Message(158605, "Urgent", nil, CL.casting:format(CL.on:format(self:SpellName(158605), self:ColorName(name))))
		end
	end
	function mod:MarkOfChaos(args)
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		self:Bar(158605, 51) -- sometimes 50, sometimes 55, but mostly 51
	end
end

function mod:MarkOfChaosApplied(args)
	markOfChaosTarget = args.destName
	self:PrimaryIcon(158605, args.destName)
	self:TargetMessage(158605, args.destName, "Urgent", "Alarm") -- warn again in case the cast target changed
	self:TargetBar(158605, 8, args.destName)
	local isFortification = args.spellId == 164178 or (self:Mythic() and phase == 3)
	if self:Me(args.destGUID) then
		self:Flash(158605)
		self:Say(158605)
	elseif isFortification and self:Range(args.destName) < 35 then -- Fortification (target rooted)
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

-- Intermission

do
	local count = 1
	local function nextAdd(self)
		count = count + 1
		self:DelayedMessage("volatile_anomaly", 12, "Attention", ("%s %d/6"):format(self:SpellName(L.volatile_anomaly), count), L.volatile_anomaly_icon, "Info")
		self:Bar("volatile_anomaly", 12, CL.count:format(self:SpellName(L.volatile_anomaly), count), L.volatile_anomaly_icon)
		if count < 6 then
			self:ScheduleTimer(nextAdd, 12, self)
		end
	end

	function mod:IntermissionStart(args)
		local first = args.spellId == 174057
		self:Message("stages", "Neutral", nil, ("%d%% - %s"):format(self:Mythic() and (first and 66 or 33) or (first and 55 or 25), CL.intermission), false)
		self:Bar("stages", first and 65 or 60, CL.intermission, "spell_arcane_blast")
		count = 1
		self:DelayedMessage("volatile_anomaly", 2, "Attention", ("%s %d/6"):format(self:SpellName(L.volatile_anomaly), count), L.volatile_anomaly_icon, "Info")
		-- first add bar is started in :PhaseEnd
		self:ScheduleTimer(nextAdd, 2, self)
	end

	function mod:IntermissionEnd(args)
		self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
	end
end

-- Warmage
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
	elseif self:Dispeller("magic", nil, 157801) and UnitDebuff(args.destName, self:SpellName(157801)) then -- check if they have Slow and warn again
		self:TargetMessage(157801, args.destName, "Important", "Alert", L.slow_fixate, nil, true)
	end
	if self.db.profile.custom_off_fixate_marker and not fixateMarks[args.destName] then
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

function mod:NetherEnergy(args)
	if UnitGUID("target") == args.destGUID and args.amount > 2 then
		self:Message(args.spellId, "Urgent", "Alert", CL.count:format(args.spellName, args.amount))
	end
end

-- Reaver
function mod:CrushArmor(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Alarm")
	self:CDBar(args.spellId, 10) -- 9.7-15.9
end

function mod:KickToTheFace(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 20) -- 20-30
end

function mod:ReaverDeath(args)
	self:StopBar(158553)
	self:StopBar(158563)
end

