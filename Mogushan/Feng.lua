
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Feng the Accursed", 896, 689)
if not mod then return end
mod:RegisterEnableMob(60009)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_yell = "Tender your souls, mortals! These are the halls of the dead!"

	L.phase_lightning_trigger = "Oh great spirit! Grant me the power of the earth!"
	L.phase_flame_trigger = "Oh exalted one! Through me you shall melt flesh from bone!"
	L.phase_arcane_trigger =  "Oh sage of the ages! Instill to me your arcane wisdom!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!"

	L.phase_lightning = "Lightning phase!"
	L.phase_flame = "Flame phase!"
	L.phase_arcane = "Arcane phase!"
	L.phase_shadow = "(Heroic) Shadow phase!"

	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"

	-- Tanks
	L.tank = "Tank Alerts"
	L.tank_desc = "Tank alerts only. Count the stacks of Lightning Lash, Flaming Spear, Arcane Shock & Shadowburn (Heroic)."
	L.lash_message = "%2$dx Lash on %1$s"
	L.spear_message = "%2$dx Spear on %1$s"
	L.shock_message = "%2$dx Shock on %1$s"
	L.burn_message = "%2$dx Burn on %1$s"
end
L = mod:GetLocale()
L.tank = L.tank.." "..INLINE_TANK_ICON

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		116157, 116018,
		{116784, "ICON", "FLASHSHAKE", "SAY"}, 116711,
		{116417, "ICON", "SAY", "FLASHSHAKE", "PROXIMITY"}, 116364,
		118071,
		"stages", 115817, 115911, "tank", "berserk", "bosskill",
	}, {
		[116157] = L["phase_lightning"],
		[116784] = L["phase_flame"],
		[116417] = L["phase_arcane"],
		[118071] = L["phase_shadow"],
		stages = "general",
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

	-- needed so we can have bars up for abilities used straight after phase switches
	self:Yell("LightningPhase", L["phase_lightning_trigger"])
	self:Yell("FlamePhase", L["phase_flame_trigger"])
	self:Yell("ArcanePhase", L["phase_arcane_trigger"])
	self:Yell("ShadowPhase", L["phase_shadow_trigger"]) -- heroic only

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60009)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Shroud(player, spellId, source)
	if not self:LFR() then
		self:TargetMessage(spellId, L["shroud_message"], player, "Urgent", spellId, nil, source)
	end
end

function mod:NullificationBarrier(_, spellId)
	self:Message(spellId, L["barrier_message"], "Urgent", spellId, "Info")
	self:Bar(spellId, L["barrier_message"], 6, spellId)
end

-- LIGHTNING
do
	local epicenter = GetSpellInfo(116018)
	function mod:LightningPhase()
		self:Message("stages", L["phase_lightning"], "Positive", 116363)
		self:Bar(116018, "~"..epicenter, 32, 116018)
	end
end

function mod:LightningFists(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Urgent", spellId)
	self:Bar(spellId, "~"..spellName, 14, spellId) -- might need to disable this if it feels unnecesary
end

function mod:Epicenter(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
	self:Bar(spellId, spellName, 30, spellId)
end

-- FLAME
do
	local drawflame = GetSpellInfo(116711)
	function mod:FlamePhase()
		self:Message("stages", L["phase_flame"], "Positive", 116363)
		self:Bar(116711, "~"..drawflame, 35, 116711)
	end
end

do
	local wildfire = GetSpellInfo(116793)
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
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
	self:Bar(spellId, "~"..spellName, 35, spellId)
end

-- ARCANE
do
	local arcanevelocity = GetSpellInfo(116364)
	function mod:ArcanePhase()
		self:Message("stages", L["phase_arcane"], "Positive", 116363)
		self:DelayedMessage(116364, 10, CL["soon"]:format(arcanevelocity), "Attention")
	end
end

do
	local resonance = GetSpellInfo(33657)
	local markUsedOn = nil
	function mod:ArcaneResonanceApplied(player, spellId)
		self:TargetMessage(spellId, resonance, player, "Urgent", spellId, "Alert")
		if not markUsedOn then
			self:PrimaryIcon(spellId, player)
			markUsedOn = player
		else
			self:SecondaryIcon(spellId, player)
		end
		if UnitIsUnit("player", player) then
			self:FlashShake(spellId)
			self:OpenProximity(6, spellId)
			self:Say(spellId, CL["say"]:format(resonance))
		end
	end
	function mod:ArcaneResonanceRemoved(player, spellId)
		if UnitIsUnit("player", player) then
			self:CloseProximity(spellId)
		end
		if player == markUsedOn then
			self:PrimaryIcon(spellId)
			markUsedOn = nil
		else
			self:SecondaryIcon(spellId)
		end
	end
end

function mod:ArcaneVelocity(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Alarm")
	self:Bar(spellId, "~"..spellName, 28, spellId)
	self:DelayedMessage(spellId, 25.5, CL["soon"]:format(spellName), "Attention")
end

-- SHADOW
do
	local siphoningShield = (GetSpellInfo(118071))
	function mod:ShadowPhase()
		self:Bar(118071, "~"..siphoningShield, 4, 118071)
	end
end


function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, spellName, _, _, spellId)
	if spellId == 117203 and unit:match("boss") then
		self:Message(118071, spellName, "Important", 118071, "Alarm")
		self:Bar(118071, "~"..spellName, 35, 118071)
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
			self:LocalMessage("tank", msgTbl[spellId], "Urgent", spellId, "Info", player, stack)
		end
	end
end

