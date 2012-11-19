
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
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_CAST_START", "LightningFists", 116157)
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
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LightningFistsReversalOnBoss(_, spellId, source, _, spellName)
	if not self:LFR() then
		self:StopBar(CL["other"]:format(source, spellName))
		self:Message(115911, CL["onboss"]:format(spellName), "Urgent", spellId, "Info")
	end
end

function mod:LightningFistsReversal(player, spellId, _, _, spellName)
	if not self:LFR() then
		self:Message(115911, L["shroud_can_interrupt"]:format(player, self:SpellName(116018)), "Urgent", spellId)
		self:Bar(115911, CL["other"]:format(player, spellName), 20, spellId)
	end
end

function mod:Shroud(player, spellId, source)
	if not self:LFR() then
		self:TargetMessage(spellId, L["shroud_message"], player, "Urgent", spellId, nil, source)
	end
end

function mod:NullificationBarrier(_, spellId)
	self:Message(spellId, L["barrier_message"], "Urgent", spellId, "Info")
	self:Bar(spellId, L["barrier_message"], 6, spellId)
	if not self:LFR() then
		self:Bar(spellId, L["barrier_cooldown"], 55, spellId)
	end
end

do
	local msgTbl = {
		[131788] = L["lash_message"],
		[116942] = L["spear_message"],
		[131790] = L["shock_message"],
		[131792] = L["burn_message"],
	}
	function mod:TankAlerts(player, spellId, _, _, _, stack)
		if self:Tank() then
			stack = stack or 1
			self:LocalMessage("tank", msgTbl[spellId], "Urgent", spellId, stack > 1 and "Info", player, stack)
		end
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unitId)
	if unitId == "boss1" then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		--a 5% warning is like forever away from the actual transition (especially in LFR, lol)
		if not self:Heroic() then
			if (hp < 68 and not p2) or (hp < 35) then --66/33
				self:Message("stages", L["phase_message"], "Positive", nil, "Info")
				if not p2 then
					p2 = true
				else
					self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
				end
			end
		elseif (hp < 77 and not p2) or (hp < 52 and not p3) or (hp < 27) then --75/50/25
			self:Message("stages", L["phase_message"], "Positive", nil, "Info")
			if not p2 then
				p2 = true
			elseif not p3 then
				p3 = true
			else
				self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
			end
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

function mod:LightningFists(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, "~"..spellName, 14, spellId)
end

function mod:Epicenter(_, spellId, _, _, spellName)
	self:Message(spellId, ("%s (%d)"):format(spellName, counter), "Important", spellId, "Alarm")
	counter = counter + 1
	self:Bar(spellId, "~"..("%s (%d)"):format(spellName, counter), 30, spellId)
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
	function mod:WildfireSparkApplied(player, spellId)
		self:TargetMessage(spellId, wildfire, player, "Urgent", spellId, "Alert")
		self:PrimaryIcon(spellId, player)
		if UnitIsUnit("player", player) then
			self:FlashShake(spellId)
			self:Bar(spellId, CL["you"]:format(wildfire), 5, spellId)
			self:Say(spellId, CL["say"]:format(wildfire))
		end
	end
	function mod:WildfireSparkRemoved(player, spellId)
		self:PrimaryIcon(spellId)
	end

	-- Standing on the Wildfire
	local prev = 0
	function mod:Wildfire(player)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(116784, CL["underyou"]:format(wildfire), "Personal", 116784, "Info")
			self:FlashShake(116784)
		end
	end
end

function mod:DrawFlame(_, spellId, _, _, spellName)
	self:Message(spellId, ("%s (%d)"):format(spellName, counter), "Important", spellId, "Alarm")
	counter = counter + 1
	self:Bar(spellId, "~"..("%s (%d)"):format(spellName, counter), 35, spellId)
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
	function mod:ArcaneResonanceApplied(player, spellId)
		self:Bar(spellId, "~"..resonance, 15.4, spellId) --15.4 - 21.5
		resonanceMarkers[#resonanceMarkers+1] = player
		if UnitIsUnit("player", player) then
			self:FlashShake(spellId)
			self:OpenProximity(6, spellId)
			self:Say(spellId, CL["say"]:format(resonance))
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(warnResonance, 0.15, spellId)
		end
	end
	function mod:ArcaneResonanceRemoved(player, spellId)
		if UnitIsUnit("player", player) then
			self:CloseProximity(spellId)
		end
	end
end

function mod:ArcaneVelocity(_, spellId, _, _, spellName)
	self:Message(spellId, ("%s (%d)"):format(spellName, counter), "Important", spellId, "Alarm")
	counter = counter + 1
	self:Bar(spellId, "~"..("%s (%d)"):format(spellName, counter), 28, spellId)
	self:DelayedMessage(spellId, 25.5, CL["soon"]:format(("%s (%d)"):format(spellName, counter)), "Attention")
end

--------------------------------------------------------------------------------
-- SHADOW (HEROIC)
--

function mod:ShadowPhase()
	self:Bar(118071, "~"..("%s (%d)"):format(self:SpellName(118071), counter), 4, 118071) -- Siphoning Shield
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if unit ~= "boss1" then return end

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

