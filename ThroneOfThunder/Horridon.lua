if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Horridon", 930, 819)
if not mod then return end
mod:RegisterEnableMob(68476)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.orb_message = "Orb of Control dropped!"

	L.hex, L.hex_desc = EJ_GetSectionInfo(7125)
	L.hex_icon = 136512

	L.chain_lightning, L.chain_lightning_desc = EJ_GetSectionInfo(7124)
	L.chain_lightning_icon = 136480
	L.chain_lightning_warning = "Your focus is casting Chain Lightning!"
	L.chain_lightning_bar = "Focus: Chain Lightning"

	L.fireball, L.fireball_desc = EJ_GetSectionInfo(7122)
	L.fireball_icon = 136465
	L.fireball_warning = "Your focus is casting Fireball!"
	L.fireball_bar = "Focus: Fireball"

	L.mortal_strike, L.mortal_strike_desc = EJ_GetSectionInfo(7120)
	L.mortal_strike_icon = 136670

	L.deadly_plague, L.deadly_plague_desc = EJ_GetSectionInfo(7119)
	L.deadly_plague_icon = 136710

	L.venom_bolt_volley = EJ_GetSectionInfo(7112) .. " " ..mod:GetFlagIcon(9)..mod:GetFlagIcon(6)
	L.venom_bolt_volley_desc = "|cFFFF0000WARNING: Only the timer for your 'focus' target will show because all Volley casters have separate cooldowns.|r "
	L.venom_bolt_volley_warning = "Your focus is casting Volley!"
	L.venom_bolt_volley_bar = "Focus: Volley"
	L.venom_bolt_volley_icon = 136587

	L.blazingSunlight, L.blazingSunlight_desc = EJ_GetSectionInfo(7109)
	L.blazingSunlight_icon = 136719

	L.puncture, L.puncture_desc = EJ_GetSectionInfo(7078)
	L.puncture_icon = 136767
	L.puncture_message = "Puncture"
end
L = mod:GetLocale()
L.blazingSunlight = L.blazingSunlight.." "..mod:GetFlagIcon(7)
L.puncture = L.puncture.." "..INLINE_TANK_ICON..INLINE_HEALER_ICON
L.puncture_desc = CL.tankhealer..L.puncture_desc
L.venom_bolt_volley_desc = L.venom_bolt_volley_desc.." "..select(2, EJ_GetSectionInfo(7112))
L.deadly_plague = L.deadly_plague.." "..mod:GetFlagIcon(10)
L.mortal_strike = L.mortal_strike.." "..INLINE_TANK_ICON..INLINE_HEALER_ICON
L.mortal_strike_desc = CL.tankhealer..L.mortal_strike_desc
L.fireball = L.fireball .. " " .. mod:GetFlagIcon(6)
L.chain_lightning = L.chain_lightning .. " " .. mod:GetFlagIcon(6)
L.hex = L.hex .. " " ..mod:GetFlagIcon(8)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:7086", "ej:7090", "ej:7092", "ej:7087", 136817, 136821,
		"fireball", "chain_lightning", "hex", {136490, "FLASHSHAKE"},
		"deadly_plague", "mortal_strike", {136573, "FLASHSHAKE"},
		{"venom_bolt_volley", "FLASHSHAKE"}, {136646, "FLASHSHAKE"},
		"blazingSunlight", {136723, "FLASHSHAKE"},
		"puncture", 136741, {"ej:7080", "FLASHSHAKE", "SAY", "ICON"},"berserk", "bosskill",
	}, {
		["ej:7086"] = "ej:7085",
		["fireball"] = "ej:7084",
		["deadly_plague"] = "ej:7083",
		["venom_bolt_volley"] = "ej:7082",
		["blazingSunlight"] = "ej:7081",
		["puncture"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	-- The Zandalari
	self:Log("SPELL_AURA_APPLIED", "Rampage", 136821)
	self:Log("SPELL_CAST_SUCCESS", "BestialCry", 136817)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrackedShell", 137240)
	self:Log("SPELL_AURA_APPLIED", "Headache", 137294)
	self:Log("SPELL_AURA_APPLIED", "DinoForm", 137237)
	self:Log("SPELL_CAST_SUCCESS", "DinoMending", 136797)
	-- The Amani
	self:Log("SPELL_DAMAGE", "LightningNova", 136490)
	self:Log("SPELL_CAST_START", "Hex", 136512) -- Not sure if interruptable
	self:Log("SPELL_CAST_START", "ChainLightning", 136480)
	self:Log("SPELL_CAST_START", "Fireball", 136465)
	-- The Drakkari
	self:Log("SPELL_DAMAGE", "FrozenOrb", 136573)
	self:Log("SPELL_AURA_REMOVED", "MortalStrikeRemoved", 136670)
	self:Log("SPELL_CAST_SUCCESS", "MortalStrike", 136670)
	self:Log("SPELL_AURA_APPLIED", "DeadlyPlague", 136710)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DeadlyPlague", 136710)
	-- The Gurubashi
	self:Log("SPELL_DAMAGE", "LivingPoison", 136646)
	self:Log("SPELL_AURA_APPLIED", "VenomBoltVolleyDispell", 136587)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VenomBoltVolleyDispell", 136587)
	self:Log("SPELL_CAST_START", "VenomBoltVolley", 136587)
	-- The Farraki
	self:Log("SPELL_DAMAGE", "SandTrap", 136723)
	self:Log("SPELL_CAST_START", "BlazingSunlight", 136719)
	-- general
	self:Log("SPELL_AURA_APPLIED", "Puncture", 136767)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Puncture", 136767)
	self:Log("SPELL_CAST_START", "Swipe", 136741, 136770) -- wouldn't hurt to figure out why there are two spellIds
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", "Charge", "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "ChargeSucceeded", "boss1")

	self:Death("Win", 68476)
end

function mod:OnEngage()
	self:Berserk(600) -- assumed
	self:Bar("ej:7086", (EJ_GetSectionInfo(7086)), 90, 138686) -- Dino Mancer spawn timer
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- The Zandalari

function mod:Rampage(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId, "Long")
end

function mod:BestialCry(_, spellId, _, _, spellName)
	self:Bar(spellId, spellName, 11, spellId) -- might help to pop personal cooldowns
end

function mod:CrackedShell(player, spellId, _, _, _, stack)
	if stack == 4 then
		self:Message("ej:7087", (EJ_GetSectionInfo(7087)), "Positive", 136821, "Info") -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:LastPhase(unit)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 35 and select(4,UnitBuff(unitId, self:SpellName(137240))) ~= 4 then -- phase starts at 30
		self:Message("ej:7087", CL["soon"]:format((EJ_GetSectionInfo(7087))), "Positive", 136821, "Info") -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:Headache()
	-- Dino Mancer spawn timer
	-- this is assumed in every aspect (timer might not start here, and might not be this long)
	self:Bar("ej:7086", (EJ_GetSectionInfo(7086)), 90, 138686) -- dino looking like icon
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "LastPhase", "boss1") -- don't need to register this on engage
end

function mod:DinoForm()
	-- tie it to this event, this is when you can use the orb
	self:Message("ej:7092", L["orb_message"], "Positive", 137445) -- orb of control icon
end

function mod:DinoMending(_, spellId, _, _, spellName)
	self:Message("ej:7090", spellName, "Important", spellId, "Long") -- maybe should give the interruptable icon to the options menu for this too
end

-- The Amani

do
	local prev = 0
	function mod:LightningNova(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
			self:FlashShake(spellId)
		end
	end
end

function mod:Hex(_, spellId, _, _, spellName)
	if self:Dispeller("curse") then
		self:LocalMessage("hex", spellName, "Important", spellId, "Alarm")
	end
end

do
	local prev = 0
	function mod:ChainLightning(_, spellId, _, _, _, _, _, _, _, _, sGUID)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == sGUID then -- don't spam
			prev = t
			self:LocalMessage("chain_lightning", L["chain_lightning_warning"], "Personal", spellId, "Alert")
		end
	end
end

do
	local prev = 0
	function mod:Fireball(_, spellId, _, _, _, _, _, _, _, _, sGUID)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == sGUID then -- don't spam
			prev = t
			self:LocalMessage("fireball", L["fireball_warning"], "Personal", spellId, "Alert")
		end
	end
end

-- The Drakkari

do
	local prev = 0
	function mod:FrozenOrb(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Info") -- not exactly under you
			self:FlashShake(spellId)
		end
	end
end

function mod:MortalStrikeRemoved(player, spellId, _, _, spellName)
	self:StopBar(("%s - %s"):format(spellName, player))
end

function mod:MortalStrike(player, spellId, _, _, spellName)
	if self:Tank() or self:Healer() then
		self:LocalMessage("mortal_strike", spellName, "Urgent", spellId, nil, player)
		self:Bar("mortal_strike", ("%s - %s"):format(spellName, player), 8, spellId)
	end
end

do
	local prev = 0
	function mod:DeadlyPlague(_, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("disease") then -- don't spam
			prev = t
			self:LocalMessage("deadly_plague", spellName, "Important", spellId, "Alarm")
		end
	end
end

-- The Gurubashi

do
	local prev = 0
	function mod:LivingPoison(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
			self:FlashShake(spellId)
		end
	end
end

do
	local prev = 0
	function mod:VenomBoltVolleyDispell(_, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("poison") then -- don't spam
			prev = t
			self:LocalMessage("venom_bolt_volley", spellName, "Important", spellId, "Alarm")
		end
	end
end

function mod:VenomBoltVolley(_, spellId, _, _, _, _, _, _, _, _, sGUID)
	if UnitGUID("focus") == sGUID then
		self:LocalMessage("venom_bolt_volley", L["venom_bolt_volley_warning"], "Personal", spellId, "Alert")
		self:Bar("venom_bolt_volley", L["venom_bolt_volley_bar"], 16, spellId)
	end
end

-- The Farraki

do
	local prev = 0
	function mod:SandTrap(player, spellId, _, _, spellName)
		if not UnitIsUnit(player, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(spellId, CL["underyou"]:format(spellName), "Personal", spellId, "Info")
			self:FlashShake(spellId)
		end
	end
end

do
	local prev = 0
	function mod:BlazingSunlight(_, spellId, _, _, spellName)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("magic") then -- don't spam
			prev = t
			self:LocalMessage("blazingSunlight", spellName, "Important", spellId, "Alarm")
		end
	end
end

-- general

function mod:ChargeSucceeded(unit)
	self:PrimaryIcon("ej:7080")
end

function mod:Charge(unit)
	local target = UnitName(unit.."target")
	self:TargetMessage("ej:7080", self:SpellName(136769), target, "Attention", 136769, "Long")
	self:Bar("ej:7080", "~"..self:SpellName(136769), 11, 136769)
	if UnitIsUnit("player", target) then
		self:FlashShake("ej:7080")
		self:Say("ej:7080", CL["say"]:format(self:SpellName(136769))) -- charge
		self:PrimaryIcon("ej:7080", target)
	end
end

function mod:Swipe(player, spellId, _, _, spellName)
	self:Message(136741, spellName, "Urgent", spellId)
	self:Bar(136741, "~"..spellName, 11, spellId)
end

function mod:Puncture(player, spellId, _, _, _, stack)
	if self:Tank() or self:Healer() then
		stack = stack or 1
		self:LocalMessage("puncture", CL["stack"], "Urgent", spellId, "Info", player, stack, L["Puncture_message"])
	end
end
