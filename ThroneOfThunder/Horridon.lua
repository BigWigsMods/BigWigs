--[[
TODO:
	figure out dino mancer spawn timer start trigger ( last checked in 10 N ptr
]]--

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

-- XXX Fix this
do
	local icons = {
		"6:21:7:27",		-- [0] tank
		"39:55:7:27",		-- [1] damage
		"70:86:7:27",		-- [2] healer
		"102:118:7:27",		-- [3] heroic only
		"133:153:7:27",		-- [4] deadly
		"168:182:7:27",		-- [5] important
		"198:214:7:27",		-- [6] interruptable
		"229:247:7:27",		-- [7] magic
		"6:21:40:58",		-- [8] curse
		"39:55:40:58",		-- [9] poison
		"70:86:40:58",		-- [10] disease
		"102:118:40:58",	-- [11] enrage
	}
	-- XXX this can potentially be extended to get a whole description from EJ ID with description and flag icons
	function mod:GetFlagIcon(flag)
		flag = flag + 1
		return "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:16:16:0:0:255:66:".. icons[flag] .."|t"
	end
end

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

	L.venom_bolt_volley = EJ_GetSectionInfo(7112).." " ..mod:GetFlagIcon(9)..mod:GetFlagIcon(6)
	L.venom_bolt_volley_desc = "|cFFFF0000WARNING: Only the timer for your 'focus' target will show because all Volley casters have separate cooldowns.|r "..select(2, EJ_GetSectionInfo(7112))
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
L.deadly_plague = L.deadly_plague.." "..mod:GetFlagIcon(10)
L.fireball = L.fireball .. " " .. mod:GetFlagIcon(6)
L.chain_lightning = L.chain_lightning .. " " .. mod:GetFlagIcon(6)
L.hex = L.hex .. " " ..mod:GetFlagIcon(8)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"ej:7086", "ej:7090", "ej:7092", "ej:7087", 136817, 136821,
		"fireball", "chain_lightning", "hex", {136490, "FLASH"},
		"deadly_plague", {"mortal_strike", "HEALER"}, {136573, "FLASH"},
		{"venom_bolt_volley", "FLASH"}, {136646, "FLASH"},
		"blazingSunlight", {136723, "FLASH"},
		{"puncture", "TANK_HEALER"}, 136741, {"ej:7080", "FLASH", "SAY", "ICON"},"berserk", "bosskill",
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

	--Horridon sets his eyes on NAME and stamps his tail!
	self:Emote("Charge", "sets his eyes")

	self:Death("Win", 68476)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX assumed
	self:Bar("ej:7086", (EJ_GetSectionInfo(7086)), 90, 138686) -- Dino Mancer spawn timer
	self:Bar("ej:7086", "The Farraki", 25, 138686) -- sort of?
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- The Zandalari

function mod:Rampage(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
end

function mod:BestialCry(args)
	self:Bar(args.spellId, args.spellName, 11, args.spellId) -- might help to pop personal cooldowns
end

function mod:CrackedShell(args)
	if args.amount == 4 then
		self:Message("ej:7087", (EJ_GetSectionInfo(7087)), "Positive", 136821, "Info") -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:LastPhase(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 35 and select(4,UnitBuff(unitId, self:SpellName(137240))) ~= 4 then -- phase starts at 30
		self:Message("ej:7087", CL["soon"]:format((EJ_GetSectionInfo(7087))), "Positive", 136821, "Info") -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:Headache()
	-- Dino Mancer spawn timer
	-- this is assumed in every aspect (timer might not start here, and might not be this long)
	self:Bar("ej:7086", (EJ_GetSectionInfo(7086)), 90, 138686) -- dino looking like icon -- dino mancer
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "LastPhase", "boss1") -- don't need to register this on engage
end

function mod:DinoForm()
	-- tie it to this event, this is when you can use the orb
	self:Message("ej:7092", L["orb_message"], "Positive", 137445) -- orb of control icon
end

function mod:DinoMending(args)
	self:Message("ej:7090", args.spellName, "Important", args.spellId, "Long") -- maybe should give the interruptable icon to the options menu for this too
end

-- The Amani

do
	local prev = 0
	function mod:LightningNova(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:Hex(args)
	if self:Dispeller("curse") then
		self:Message("hex", args.spellName, "Important", args.spellId, "Alarm")
	end
end

do
	local prev = 0
	function mod:ChainLightning(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("chain_lightning", L["chain_lightning_warning"], "Personal", args.spellId, "Alert")
		end
	end
end

do
	local prev = 0
	function mod:Fireball(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("fireball", L["fireball_warning"], "Personal", args.spellId, "Alert")
		end
	end
end

-- The Drakkari

do
	local prev = 0
	function mod:FrozenOrb(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info") -- not exactly under you
			self:Flash(args.spellId)
		end
	end
end

function mod:MortalStrikeRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

function mod:MortalStrike(args)
	self:Message("mortal_strike", args.spellName, "Urgent", args.spellId, nil, args.destName)
	self:TargetBar("mortal_strike", args.spellName, args.destName, 8, args.spellId)
end

do
	local prev = 0
	function mod:DeadlyPlague(args)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("disease") then -- don't spam
			prev = t
			self:Message("deadly_plague", args.spellName, "Important", args.spellId, "Alarm")
		end
	end
end

-- The Gurubashi

do
	local prev = 0
	function mod:LivingPoison(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:VenomBoltVolleyDispell(args)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("poison") then -- don't spam
			prev = t
			self:Message("venom_bolt_volley", args.spellName, "Important", args.spellId, "Alarm")
		end
	end
end

function mod:VenomBoltVolley(args)
	if UnitGUID("focus") == args.sourceGUID then
		self:Message("venom_bolt_volley", L["venom_bolt_volley_warning"], "Personal", args.spellId, "Alert")
		self:Bar("venom_bolt_volley", L["venom_bolt_volley_bar"], 16, args.spellId)
	end
end

-- The Farraki

do
	local prev = 0
	function mod:SandTrap(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:BlazingSunlight(args)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("magic") then -- don't spam
			prev = t
			self:Message("blazingSunlight", args.spellName, "Important", args.spellId, "Alarm")
		end
	end
end

-- general

function mod:Charge(_,_,_,_,player)
	self:TargetMessage("ej:7080", self:SpellName(136769), player, "Attention", 136769, "Long")
	self:Bar("ej:7080", "~"..self:SpellName(136769), 11, 136769)
	if UnitIsUnit("player", player) then
		self:Flash("ej:7080")
		self:Say("ej:7080", 136769) -- charge
		self:PrimaryIcon("ej:7080", player)
	end
	self:ScheduleTimer("PrimaryIcon", 10, "ej:7080") -- remove icon
end

function mod:Swipe(args)
	self:Message(136741, args.spellName, "Urgent", args.spellId)
	self:Bar(136741, "~"..args.spellName, self:LFR() and 16 or 11, args.spellId)
end

function mod:Puncture(args)
	args.amount = args.amount or 1
	self:Message("puncture", CL["stack"], "Urgent", args.spellId, "Info", args.destName, args.amount, L["puncture_message"])
end

