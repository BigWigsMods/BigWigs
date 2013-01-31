
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Feng the Accursed", 896, 689)
if not mod then return end
mod:RegisterEnableMob(60009)

--------------------------------------------------------------------------------
-- Locals
--

local counter, p2, p3 = 1, nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Tender your souls, mortals! These are the halls of the dead!"

	L.phase_lightning_trigger = "Oh great spirit! Grant me the power of the earth!"
	L.phase_flame_trigger = "Oh exalted one! Through me you shall melt flesh from bone!"
	L.phase_arcane_trigger = "Oh sage of the ages! Instill to me your arcane wisdom!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!"

	L.phase_lightning = "Lightning phase!"
	L.phase_flame = "Flame phase!"
	L.phase_arcane = "Arcane phase!"
	L.phase_shadow = "(Heroic) Shadow phase!"

	L.phase_message = "New phase soon!"
	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.shroud_can_interrupt = "%s can interrupt %s!"
	L.barrier_message = "Barrier UP!"
	L.barrier_cooldown = "Barrier cooldown"

	-- Tanks
	L.tank = "Tank Alerts"
	L.tank_desc = "Count the stacks of Lightning Lash, Flaming Spear, Arcane Shock & Shadowburn (Heroic)."
	L.tank_icon = "inv_shield_05"
	L.lash_message = "%2$dx Lash on %1$s"
	L.spear_message = "%2$dx Spear on %1$s"
	L.shock_message = "%2$dx Shock on %1$s"
	L.burn_message = "%2$dx Burn on %1$s"
end
L = mod:GetLocale()
L.tank = L.tank.." "..INLINE_TANK_ICON
L.tank_desc = CL.tank..L.tank_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		116157, 116018,
		{116784, "ICON", "FLASHSHAKE", "SAY"}, 116711,
		{116417, "ICON", "SAY", "FLASHSHAKE", "PROXIMITY"}, 116364,
		118071,
		115817, 115911, "tank", "stages", "berserk", "bosskill",
	}, {
		[116157] = L["phase_lightning"],
		[116784] = L["phase_flame"],
		[116417] = L["phase_arcane"],
		[118071] = L["phase_shadow"],
		[115817] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "LightningFists", 116157, 116295)
	self:Log("SPELL_CAST_START", "Epicenter", 116018)

	self:Log("SPELL_AURA_APPLIED", "WildfireSparkApplied", 116784)
	self:Log("SPELL_AURA_REMOVED", "WildfireSparkRemoved", 116784)
	self:Log("SPELL_AURA_APPLIED", "DrawFlame", 116711)
	self:Log("SPELL_DAMAGE", "Wildfire", 116793)
	self:Log("SPELL_MISSED", "Wildfire", 116793)

	self:Log("SPELL_AURA_APPLIED", "ArcaneResonanceApplied", 116417)
	self:Log("SPELL_AURA_REMOVED", "ArcaneResonanceRemoved", 116417)
	self:Log("SPELL_AURA_APPLIED", "ArcaneVelocity", 116364)

	self:Log("SPELL_CAST_SUCCESS", "NullificationBarrier", 115817)

	-- Tanks
	self:Log("SPELL_AURA_APPLIED", "TankAlerts", 131788, 116942, 131790, 131792) -- Lash, Spear, Shock, Burn
	self:Log("SPELL_AURA_APPLIED_DOSE", "TankAlerts", 131788, 116942, 131790, 131792)

	self:Log("SPELL_CAST_SUCCESS", "Shroud", 115911)
	self:Log("SPELL_AURA_APPLIED", "LightningFistsReversal", 118302)
	self:Log("SPELL_AURA_APPLIED", "LightningFistsReversalOnBoss", 115730)

	-- needed so we can have bars up for abilities used straight after phase switches
	self:Yell("LightningPhase", L["phase_lightning_trigger"])
	self:Yell("FlamePhase", L["phase_flame_trigger"])
	self:Yell("ArcanePhase", L["phase_arcane_trigger"])
	self:Yell("ShadowPhase", L["phase_shadow_trigger"]) -- heroic only

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60009)
end

function mod:OnEngage()
	p2, p3 = nil, nil
	counter = 1
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", self:Heroic() and "PhaseChangeHC" or "PhaseChange", "boss1")
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LightningFistsReversalOnBoss(args)
	if not self:LFR() then
		self:StopBar(CL["other"]:format(args.sourceName, args.spellName))
		self:Message(115911, CL["onboss"]:format(args.spellName), "Urgent", args.spellId, "Info")
	end
end

function mod:LightningFistsReversal(args)
	if not self:LFR() then
		self:Message(115911, L["shroud_can_interrupt"]:format(args.destName, self:SpellName(116018)), "Urgent", args.spellId)
		self:Bar(115911, CL["other"]:format(args.destName, args.spellName), 20, args.spellId)
	end
end

function mod:Shroud(args)
	if not self:LFR() then
		self:TargetMessage(args.spellId, L["shroud_message"], args.destName, "Urgent", args.spellId, nil, args.sourceName)
	end
end

function mod:NullificationBarrier(args)
	self:Message(args.spellId, L["barrier_message"], "Urgent", args.spellId, "Info")
	self:Bar(args.spellId, L["barrier_message"], 6, args.spellId)
	if not self:LFR() then
		self:Bar(args.spellId, L["barrier_cooldown"], 55, args.spellId)
	end
end

do
	local msgTbl = {
		[131788] = L["lash_message"],
		[116942] = L["spear_message"],
		[131790] = L["shock_message"],
		[131792] = L["burn_message"],
	}
	function mod:TankAlerts(args)
		if self:Tank() then
			local stack = args.amount or 1
			self:LocalMessage("tank", msgTbl[args.spellId], "Urgent", args.spellId, stack > 1 and "Info", args.destName, stack)
		end
	end
end

function mod:PhaseChange(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	--a 5% warning is like forever away from the actual transition (especially in LFR, lol)
	if (hp < 68 and not p2) or (hp < 35) then --66/33
		self:Message("stages", L["phase_message"], "Positive", nil, "Info")
		if not p2 then
			p2 = true
		else
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		end
	end
end

function mod:PhaseChangeHC(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	--a 5% warning is like forever away from the actual transition (especially in LFR, lol)
	if (hp < 77 and not p2) or (hp < 52 and not p3) or (hp < 27) then --75/50/25
		self:Message("stages", L["phase_message"], "Positive", nil, "Info")
		if not p2 then
			p2 = true
		elseif not p3 then
			p3 = true
		else
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
		end
	end
end

--------------------------------------------------------------------------------
-- LIGHTNING
--

function mod:LightningPhase()
	self:Message("stages", L["phase_lightning"], "Positive", 116363)
	self:Bar(116018, "~"..("%s (%d)"):format(self:SpellName(116018), counter), 18, 116018) -- Epicenter
	self:Bar(116157, "~"..self:SpellName(116157), 12, 116157) -- Lightning Fists
end

function mod:LightningFists(args)
	self:Message(args.spellId, args.spellName, "Urgent", args.spellId)
	self:Bar(args.spellId, "~"..args.spellName, 13, args.spellId)
end

function mod:Epicenter(args)
	self:Message(args.spellId, ("%s (%d)"):format(args.spellName, counter), "Important", args.spellId, "Alarm")
	counter = counter + 1
	self:Bar(args.spellId, "~"..("%s (%d)"):format(args.spellName, counter), 30, args.spellId)
end

--------------------------------------------------------------------------------
-- FLAME
--

function mod:FlamePhase()
	self:Message("stages", L["phase_flame"], "Positive", 116363)
	self:Bar(116711, "~"..("%s (%d)"):format(self:SpellName(116711), counter), 35, 116711) -- Draw Flame
end

do
	local wildfire = mod:SpellName(116793)
	function mod:WildfireSparkApplied(args)
		self:TargetMessage(args.spellId, wildfire, args.destName, "Urgent", args.spellId, "Alert")
		self:PrimaryIcon(args.spellId, args.destName)
		if UnitIsUnit(args.destName, "player") then
			self:FlashShake(args.spellId)
			self:Bar(args.spellId, CL["you"]:format(wildfire), 5, args.spellId)
			self:Say(args.spellId, wildfire)
		end
	end
	function mod:WildfireSparkRemoved(args)
		self:PrimaryIcon(args.spellId)
	end

	-- Standing on the Wildfire
	local prev = 0
	function mod:Wildfire(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(116784, CL["underyou"]:format(wildfire), "Personal", 116784, "Info")
			self:FlashShake(116784)
		end
	end
end

function mod:DrawFlame(args)
	self:Message(args.spellId, ("%s (%d)"):format(args.spellName, counter), "Important", args.spellId, "Alarm")
	counter = counter + 1
	self:Bar(args.spellId, "~"..("%s (%d)"):format(args.spellName, counter), 35, args.spellId)
end

--------------------------------------------------------------------------------
-- ARCANE
--

function mod:ArcanePhase()
	self:Message("stages", L["phase_arcane"], "Positive", 116363)
	self:DelayedMessage(116364, 10, CL["soon"]:format(self:SpellName(116364)), "Attention") -- Arcane Velocity
end

do
	local resonance, resonanceTargets, resonanceMarkers, scheduled = mod:SpellName(33657), mod:NewTargetList(), {}, nil
	local function warnResonance(spellId)
		scheduled = nil
		mod:PrimaryIcon(spellId, resonanceMarkers[1])
		resonanceTargets[1] = resonanceMarkers[1]
		if resonanceMarkers[2] then
			mod:SecondaryIcon(spellId, resonanceMarkers[2])
			resonanceTargets[2] = resonanceMarkers[2]
		end
		mod:TargetMessage(spellId, resonance, resonanceTargets, "Urgent", spellId, "Alert")
		wipe(resonanceMarkers)
	end
	function mod:ArcaneResonanceApplied(args)
		self:Bar(args.spellId, "~"..resonance, 15.4, args.spellId) --15.4 - 21.5
		resonanceMarkers[#resonanceMarkers+1] = args.destName
		if UnitIsUnit(args.destName, "player") then
			self:FlashShake(args.spellId)
			self:OpenProximity(args.spellId, 6)
			self:Say(args.spellId, resonance)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warnResonance, 0.15, args.spellId)
		end
	end
	function mod:ArcaneResonanceRemoved(args)
		if UnitIsUnit(args.destName, "player") then
			self:CloseProximity(args.spellId)
		end
	end
end

function mod:ArcaneVelocity(args)
	self:Message(args.spellId, ("%s (%d)"):format(args.spellName, counter), "Important", args.spellId, "Alarm")
	counter = counter + 1
	self:Bar(args.spellId, "~"..("%s (%d)"):format(args.spellName, counter), 28, args.spellId)
	self:DelayedMessage(args.spellId, 25.5, CL["soon"]:format(("%s (%d)"):format(args.spellName, counter)), "Attention")
end

--------------------------------------------------------------------------------
-- SHADOW (HEROIC)
--

function mod:ShadowPhase()
	self:Bar(118071, "~"..("%s (%d)"):format(self:SpellName(118071), counter), 4, 118071) -- Siphoning Shield
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
	if spellId == 117203 then -- Siphoning Shield
		self:Message(118071, ("%s (%d)"):format(spellName, counter), "Important", 118071, "Alarm")
		counter = counter + 1
		self:Bar(118071, "~"..("%s (%d)"):format(spellName, counter), 35, 118071)
	elseif spellId == 122410 then -- Throw Mainhand (end of phase)
		--SHUT. DOWN. EVERYTHING.
		self:CancelDelayedMessage(CL["soon"]:format(("%s (%d)"):format(self:SpellName(116364), counter)))
		self:StopBar("~"..("%s (%d)"):format(self:SpellName(116364), counter)) -- Arcane Velocity
		self:StopBar("~"..self:SpellName(33657)) -- Resonance
		self:StopBar("~"..("%s (%d)"):format(self:SpellName(118071), counter)) -- Siphoning Shield
		self:StopBar("~"..("%s (%d)"):format(self:SpellName(116018), counter)) -- Epicenter
		self:StopBar("~"..self:SpellName(116157)) -- Lightning Fists
		self:StopBar("~"..("%s (%d)"):format(self:SpellName(116711), counter)) -- Draw flame
		counter = 1
	end
end

