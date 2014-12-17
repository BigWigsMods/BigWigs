
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
local mineCount, novaCount, aberrationCount, nightCount = 1, 1, 1, 1
local addDeathWarned = nil
local markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova, gazeOnMe = nil, nil, nil, nil, nil
local fixateMarks, brandedMarks, gazeTargets = {}, {}, {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase4_trigger = "You know nothing of the power you meddle with"

	L.branded_say = "%s (%d) %dy"
	L.add_death_soon = "Add dying soon!"
	L.slow_fixate = "Slow+Fixate"

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
		--[[ Mythic ]]--
		178607, -- Dark Star
		165102, -- Infinite Darkness
		165116, -- Entropy
		165876, -- Enveloping Night
		165243, -- Glimpse of Madness
		{165595, "PROXIMITY", "FLASH", "SAY"}, -- Gaze of the Abyss
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
		{158553, "TANK"}, -- Crush Armor
		{158563, "TANK"}, -- Kick to the Face
		--[[ General ]]--
		"stages",
		"bosskill"
	}, {
		[178607] = "mythic",
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
	self:Log("SPELL_AURA_REFRESH", "FixateApplied", 157763)
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 157763)
	self:Log("SPELL_AURA_APPLIED", "CrushArmor", 158553) -- XXX 10s cast, 4s debuff?
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushArmor", 158553)
	self:Log("SPELL_CAST_SUCCESS", "KickToTheFace", 158563)
	-- Mythic
	self:Log("SPELL_AURA_APPLIED_DOSE", "NetherEnergy", 178468)
	self:Yell("Phase4", L.phase4_trigger)
	self:Log("SPELL_CAST_START", "GlimpseOfMadness", 165243)
	self:Log("SPELL_CAST_START", "EnvelopingNight", 165876)
	self:Log("SPELL_AURA_APPLIED", "InfiniteDarkness", 165102)
	self:Log("SPELL_AURA_APPLIED", "Entropy", 165116)
	self:Log("SPELL_AURA_APPLIED", "GazeOfTheAbyssApplied", 165595)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GazeOfTheAbyssApplied", 165595)
	self:Log("SPELL_AURA_REMOVED", "GazeOfTheAbyssRemoved", 165595)
	self:Log("SPELL_AURA_APPLIED", "GazeClosestApplied", 176537)
	self:Log("SPELL_AURA_REMOVED", "GazeClosestRemoved", 176537)
	self:Log("SPELL_AURA_APPLIED", "GrowingDarkness", 176533)
	self:Log("SPELL_PERIODIC_DAMAGE", "GrowingDarkness", 176533)

	self:Death("ReaverDeath", 78549) -- Gorian Reaver
end

function mod:OnEngage()
	phase = 1
	mineCount, novaCount, aberrationCount = 1, 1, 1
	markOfChaosTarget, brandedOnMe, fixateOnMe, replicatingNova = nil, nil, nil, nil
	addDeathWarned = nil
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
	-- Gaze of the Abyss
	if mod:Mythic() and phase == 4 then
		if gazeOnMe then
			mod:OpenProximity(165595, 8)
		elseif #gazeTargets > 0 then
			mod:OpenProximity(165595, 8, gazeTargets)
		else
			mod:CloseProximity(165595)
		end
		return
	end

	-- mark of chaos > fixate > branded > nova
	-- open in reverse order so if you disable one it doesn't block others from showing
	if replicatingNova then
		mod:OpenProximity(157349, 4)
	end
	if brandedOnMe then
		local _, _, _, amount = UnitDebuff("player", mod:SpellName(brandedOnMe))
		if not amount then
			BigWigs:Print("For some reason the proximity check failed on you, tell a developer!")
		else
			local jumpDistance = (brandedOnMe == 164005 and 0.75 or 0.5)^(amount - 1) * 200
			if jumpDistance < 50 then
				mod:OpenProximity(156225, jumpDistance)
			end
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

-- Mythic

function mod:Phase4()
	phase = phase + 1
	nightCount = 1
	gazeOnMe = true
	wipe(gazeTargets)
	self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
	--self:CDBar("adds", 30) -- Night-Twisted adds (repeating timer)
	self:CDBar(165102, 47) -- Infinite Darkness
	self:CDBar(165243, 53) -- Glimpse of Madness
	self:CDBar(178607, 64) -- Dark Star
	self:CDBar(165876, 90, CL.count:format(self:SpellName(165876), nightCount)) -- Enveloping Night
	self:DelayedMessage(165876, 80, "Important", CL.soon:format(CL.count:format(self:SpellName(165876), nightCount)), false, "Info")
end

do
	local list, scheduled = mod:NewTargetList(), nil
	local function warn(self, spellId)
		self:TargetMessage(spellId, list, "Attention", self:Healer() and "Alert", nil, nil, true)
		scheduled = nil
	end
	function mod:InfiniteDarkness(args)
		-- magic debuff on 3 players, causes Entropy when dispelled
		list[#list + 1] = args.destName
		if not scheduled then
			self:CDBar(args.spellId, 62)
			scheduled = self:ScheduleTimer(warn, 0.2, self, args.spellId)
		end
	end
end

function mod:Entropy(args)
	if self:Me(args.destName) then
		local text = args.amount and args.amount > 0 and ("%s +%d"):format(args.spellName, args.amount) or nil -- XXX shooould have an amount
		self:Message(args.spellId, "Positive", nil, text)
		self:Bar(args.spellId, 10) -- XXX just refresh the bar, might not be useful!
	end
end

function mod:EntropyRemoved(args)
	if self:Me(args.destName) and not UnitDebuff("player", args.spellName) then
		-- all gone
		self:StopBar(args.spellId)
	end
end

function mod:DarkStar(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	self:Bar(args.spellId, 7, ("<%s>"):format(args.spellName))
	self:CDBar(args.spellId, 60)
end

function mod:EnvelopingNight(args)
	self:Message(args.spellId, "Important", "Long", CL.count:format(args.spellName, nightCount))
	self:Bar(args.spellId, 3, CL.cast:format(CL.count:format(args.spellName, nightCount)))
	nightCount = nightCount + 1
	self:CDBar(args.spellId, 63, CL.count:format(args.spellName, nightCount))
	self:DelayedMessage(args.spellId, 53, "Important", CL.soon:format(CL.count:format(args.spellName, nightCount)), false, "Info")
end

function mod:GlimpseOfMadness(args)
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 27)
end

do -- GazeOfTheAbyss
	-- i may be trying to be too clever here, but hopefully i over-engineered it enough to play nice
	-- only show the proximity for people that aren't targeted by an add (debuff will fall off)

	-- debuff scanning because the two add debuffs have the same name :\
	local function checkDebuff(unit, id)
		if select(11, UnitDebuff(unit, (GetSpellInfo(id)))) == id then return true end -- only one?
		for i = 1, 10 do
			if select(11, UnitDebuff(unit, i)) == id then return true end
		end
	end

	local timeLeft, timer = 10, nil
	local function sayCountdown(self)
		timeLeft = timeLeft - 1
		if timeLeft < 5 then
			self:Say(165595, timeLeft, true)
			if timeLeft > 3 then
				self:Flash(165595)
			end
			if timeLeft < 2 then
				self:CancelTimer(timer)
			end
		end
	end

	function mod:GazeOfTheAbyssApplied(args)
		if self:Me(args.destGUID) then
			gazeOnMe = true
			self:StackMessage(args.spellId, args.destName, args.amount, "Personal")
			if args.amount and args.amount > 2 then
				self:PlaySound(args.spellId, "Warning")
			end
			self:TargetBar(args.spellId, 10, args.destName)

			self:CancelTimer(timer)
			timeLeft = 10
			timer = self:ScheduleRepeatingTimer(sayCountdown, 1, self)

			updateProximity()
		elseif not checkDebuff(args.destName, 176537) and not tContains(gazeTargets, args.destName) then -- no "closest" debuff and not currently tracked (failsafe)
			gazeTargets[#gazeTargets + 1] = args.destName
			updateProximity()
		end
	end

	function mod:GazeOfTheAbyssRemoved(args)
		if self:Me(args.destGUID) then
			gazeOnMe = nil
			self:StopBar(args.spellId, args.destName)
			self:CancelTimer(timer)
			self:CloseProximity(args.spellId)
		end
		tDeleteItem(gazeTargets, args.destName)
		updateProximity()
	end

	function mod:GazeClosestApplied(args)
		tDeleteItem(gazeTargets, args.destName)
		updateProximity()
	end

	function mod:GazeClosestRemoved(args)
		if checkDebuff(args.destName, 165595) and not tContains(gazeTargets, args.destName) then -- the explody debuff
			gazeTargets[#gazeTargets + 1] = args.destName
			updateProximity()
		end
	end
end

do
	local prev = 0
	function mod:GrowingDarkness(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 2 then
			self:Message(args.spellId, "Personal", "Alarm", CL.underyou:format(args.spellName)) -- you ded, so ded.
			self:Flash(args.spellId)
			prev = t
		end
	end
end

-- General

function mod:UNIT_HEALTH_FREQUENT(unit)
	local mobId = self:MobId(UnitGUID(unit))
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if mobId == 77428 then
		if self:Mythic() then
			if (phase == 1 and hp < 71) or (phase == 2 and hp < 38) then -- phases at 66% and 33%
				self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
				self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
			end
		elseif (phase == 1 and hp < 90) or (phase == 2 and hp < 60) or (phase == 3 and hp < 30) then -- phases at 85%, 55%, and 25%
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
			self:Message("stages", "Neutral", "Info", CL.soon:format(CL.phase:format(phase+1)), false)
		end
	elseif mobId == 77879 and not addDeathWarned and hp < 30 then -- Displacement
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		self:Message(156471, "Attention", "Warning", L.add_death_soon)
		addDeathWarned = true
	end
end

function mod:Phases(unit, spellName, _, _, spellId)
	if spellId == 164336 or spellId == 164751 or spellId == 164810 then -- Teleport to Displacement, Fortification, Replication (Phase end)
		phase = phase + 1
		mineCount, novaCount, aberrationCount = 1, 1, 1

		if spellId == 164336 then -- no intermission for Displacement
			 -- XXX first transform messes with timers, typically adding ~10s
			self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, unit)
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
			self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, unit)
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

		local _, _, _, amount = UnitDebuff(self:Me(args.destGUID) and "player" or args.destName, args.spellName)
		if not amount then
			self:ScheduleTimer(
				function(dst, spl)
					local _, _, _, a = UnitDebuff(dst, spl)
					if a then
						BigWigs:Print("The debuff scan worked after a delay, tell a developer!")
					else
						BigWigs:Print("The debuff scan failed even after a delay, tell a developer!")
					end
				end,
				0.4, self:Me(args.destGUID) and "player" or args.destName, args.spellName
			)
			local _, _, h, w = GetNetStats()
			BigWigs:Print(("The debuff scan failed, tell a developer! Latency: %d/%d"):format(h, w))
			amount = 0 -- don't show count or distance
		end
		local fortification = args.spellId == 164005 or (self:Mythic() and phase == 3)
		local jumpDistance = (fortification and 0.75 or 0.5)^(amount - 1) * 200 -- Fortification takes longer to get rid of

		if self:Me(args.destGUID) then
			brandedOnMe = args.spellId
			self:TargetBar(156225, 4, args.destName)
			if not self:LFR() then
				local text = self:SpellName(156225)
				if amount > 0 and jumpDistance < 50 then
					text = L.branded_say:format(text, amount, jumpDistance)
				elseif amount > 1 then
					text = CL.count:format(text, amount)
				end
				self:Say(156225, text)
			end
			updateProximity()
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
		[4] = { 24, },
	}
	function mod:DestructiveResonance(args)
		local sound = self:Healer() or self:Damager() == "RANGED"
		self:Message(156467, "Urgent", sound and "Warning")
		local t = not self:Mythic() and mineTimes[phase] and mineTimes[phase][mineCount] or 15.8
		self:CDBar(156467, phase == 1 and 24 or t)
		mineCount = mineCount + 1
	end
end

function mod:ArcaneAberration(args)
	self:Message(156471, "Urgent", not self:Healer() and "Info", CL.add_spawned)
	self:CDBar(156471, aberrationCount == 1 and 46 or 51, -9945, 156471) -- Arcane Aberration
	aberrationCount = aberrationCount + 1
	if args.spellId == 164299 or (self:Mythic() and phase == 2) then -- Displacing
		addDeathWarned = nil
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss2")
	end
end

do
	local function printTarget(self, name, guid)
		self:Message(158605, "Urgent", self:Tank() and "Alarm", CL.casting:format(CL.on:format(self:SpellName(158605), name)))
		if self:Me(guid) then
			self:Flash(158605)
		end
	end
	function mod:MarkOfChaos(args)
		self:Bar(158605, 51) -- 51-52 with some random cases of 55
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
	end
end

function mod:MarkOfChaosApplied(args)
	markOfChaosTarget = args.destName
	self:PrimaryIcon(158605, args.destName)
	self:TargetMessage(158605, args.destName, "Urgent", "Alarm") -- warn again for the tank in case the cast target changed
	self:TargetBar(158605, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(158605)
		if args.spellId == 164178 then -- Fortification (you're rooted)
			self:Say(158605)
		end
	elseif args.spellId == 164178 and self:Range(args.destName) < 35 then -- Fortification (target rooted)
		self:RangeMessage(158605)
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
	local count = 0
	local function nextAdd(self)
		self:Message("volatile_anomaly", "Attention", "Info", CL.incoming:format(self:SpellName(L.volatile_anomaly)), L.volatile_anomaly_icon)
		count = count - 1
		if count > 0 then
			self:Bar("volatile_anomaly", 12, L.volatile_anomaly, L.volatile_anomaly_icon)
			self:ScheduleTimer(nextAdd, 12, self)
		end
	end

	function mod:IntermissionStart(args)
		local first = args.spellId == 174057
		self:Message("stages", "Neutral", nil, ("%d%% - %s"):format(self:Mythic() and (first and 66 or 33) or (first and 55 or 25), CL.intermission), false)
		self:Bar("stages", first and 65 or 60, CL.intermission, "spell_arcane_blast")
		self:Bar("volatile_anomaly", 14, L.volatile_anomaly, L.volatile_anomaly_icon)
		count = first and 5 or 4
		self:ScheduleTimer(nextAdd, 14, self)
		if not first then
			self:ScheduleTimer("Message", 15, "stages", "Neutral", "Info", -9921, false) -- Gorian Reaver
			self:CDBar(158563, 29) -- Kick to the Face
		end
	end

	function mod:IntermissionEnd(args)
		self:Message("stages", "Neutral", "Long", CL.phase:format(phase), false)
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

function mod:CrushArmor(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Attention", amount > 2 and "Warning")
	self:Bar(args.spellId, 6)
end

function mod:KickToTheFace(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:Bar(args.spellId, 20)
end

function mod:ReaverDeath(args)
	self:StopBar(158553)
	self:StopBar(158563)
end

