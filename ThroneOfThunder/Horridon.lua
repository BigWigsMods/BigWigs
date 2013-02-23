--[[
TODO:
	figure out dino mancer spawn timer start trigger ( last checked in 10 H ptr and still sometimes 10 sec off )
]]--

if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Horridon", 930, 819)
if not mod then return end
mod:RegisterEnableMob(68476, 69374) -- Horridon, War-God Jalak

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

	L.deadly_plague, L.deadly_plague_desc = EJ_GetSectionInfo(7119)
	L.deadly_plague_icon = 136710

	L.venom_bolt_volley = EJ_GetSectionInfo(7112).." " ..mod:GetFlagIcon(9)..mod:GetFlagIcon(6)
	L.venom_bolt_volley_desc = "|cFFFF0000WARNING: Only the timer for your 'focus' target will show because all Volley casters have separate cooldowns.|r "..select(2, EJ_GetSectionInfo(7112))
	L.venom_bolt_volley_warning = "Your focus is casting Volley!"
	L.venom_bolt_volley_bar = "Focus: Volley"
	L.venom_bolt_volley_icon = 136587

	L.blazingSunlight, L.blazingSunlight_desc = EJ_GetSectionInfo(7109)
	L.blazingSunlight_icon = 136719

	L.puncture_message = "Puncture"

	L.charge_trigger = "sets his eyes" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!
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
		-7086, -7090, -7092, -7087, 136817, 136821,
		"fireball", "chain_lightning", "hex", {136490, "FLASH"},
		"deadly_plague", {-7120, "HEALER"}, {136573, "FLASH"},
		{"venom_bolt_volley", "FLASH"}, {136646, "FLASH"},
		"blazingSunlight", {136723, "FLASH"},
		{-7078, "TANK_HEALER"}, 136741, {136769, "FLASH", "SAY", "ICON"},"berserk", "bosskill",
	}, {
		[-7086] = -7085,
		["fireball"] = -7084,
		["deadly_plague"] = -7083,
		["venom_bolt_volley"] = -7082,
		["blazingSunlight"] = -7081,
		[-7078] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "BossEngage")
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
	self:Log("SPELL_CAST_START", "Swipe", 136741, 136770) -- 136770 is only after charge
	self:Emote("Charge", L["charge_trigger"])

	self:Death("Win", 68476)
end

function mod:OnEngage()
	self:Berserk(600) -- XXX assumed
	self:Bar(-7086, self:Heroic() and 75 or 90, nil, 138686) -- Dino Mancer spawn timer
	self:Bar(-7086, 25, "The Farraki", 138686) -- sort of?
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- The Zandalari

function mod:BossEngage()
	self:CheckBossStatus()
	if self:MobId(UnitGUID("boss2")) == 69374 then -- War-God Jalak
		self:Message(-7087, "Positive", "Info") -- War-God Jalak
		self:StopBar(-7087)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:Rampage(args)
	self:Message(args.spellId, "Important", "Long")
end

function mod:BestialCry(args)
	self:Bar(args.spellId, 11) -- might help to pop personal cooldowns
end

function mod:CrackedShell(args)
	if args.amount == 4 then
		self:Bar(-7087, 45) -- War-God Jalak
	end
end

function mod:LastPhase(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 35 and not UnitExists("boss2") then -- phase starts at 30, except if the boss is already there
		self:Message(-7087, "Positive", "Info", CL["soon"]:format(self:SpellName(-7087))) -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unitId)
	end
end

function mod:Headache()
	-- Dino Mancer spawn timer
	-- this is assumed in every aspect (timer might not start here, and might not be this long)
	self:Bar(-7086, 90, nil, 138686) -- dino looking like icon -- dino mancer
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "LastPhase", "boss1") -- don't need to register this on engage
end

function mod:DinoForm()
	-- tie it to this event, this is when you can use the orb
	self:Message(-7092, "Positive", nil, L["orb_message"], 137445) -- orb of control icon
end

function mod:DinoMending(args)
	self:Message(-7090, "Important", "Long") -- maybe should give the interruptable icon to the options menu for this too
	self:CDBar(-7090, 8) -- to help interrupters keep track
end

-- The Amani

do
	local prev = 0
	function mod:LightningNova(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Hex(args)
	if self:Dispeller("curse") then
		self:Message("hex", "Important", "Alarm", args.spellName, args.spellId)
	end
end

do
	local prev = 0
	function mod:ChainLightning(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("chain_lightning", "Personal", "Alert", L["chain_lightning_warning"], args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:Fireball(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("fireball", "Personal", "Alert", L["fireball_warning"], args.spellId)
		end
	end
end

-- The Drakkari

do
	local prev = 0
	function mod:FrozenOrb(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName)) -- not exactly under you
			self:Flash(args.spellId)
		end
	end
end

function mod:MortalStrikeRemoved(args)
	self:StopBar(args.spellName, args.destName)
end

function mod:MortalStrike(args)
	self:Message(-7120, "Urgent")
	self:TargetBar(-7120, args.destName, 8, args.spellId)
end

do
	local prev = 0
	function mod:DeadlyPlague(args)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("disease") then -- don't spam
			prev = t
			self:Message("deadly_plague", "Important", "Alarm", args.spellName, args.spellId)
		end
	end
end

-- The Gurubashi

do
	local prev = 0
	function mod:LivingPoison(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
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
			self:Message("venom_bolt_volley", "Important", "Alarm", args.spellName, args.spellId)
		end
	end
end

function mod:VenomBoltVolley(args)
	if UnitGUID("focus") == args.sourceGUID then
		self:Message("venom_bolt_volley", "Personal", "Alert", L["venom_bolt_volley_warning"], args.spellId)
		self:Bar("venom_bolt_volley", 16, L["venom_bolt_volley_bar"], args.spellId)
	end
end

-- The Farraki

do
	local prev = 0
	function mod:SandTrap(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName), args.spellId)
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
			self:Message("blazingSunlight", "Important", "Alarm", args.spellName, args.spellId)
		end
	end
end

-- general

function mod:Charge(_, _, _, _, player)
	self:TargetMessage(-7080, player, "Attention", "Long")
	self:CDBar(-7080, 11)
	if UnitIsUnit("player", player) then
		self:Flash(-7080)
		self:Say(-7080)
		self:PrimaryIcon(-7080, player)
	end
	self:ScheduleTimer("PrimaryIcon", 10, -7080) -- remove icon
end

function mod:Swipe(args)
	self:Message(136741, "Urgent")
	local timer = (args.spellID == 136770) and 11 or 19 -- after charge swipe is ~10 sec, then ~19 till next charge ( 10 H ptr )
	self:CDBar(136741, self:LFR() and 16 or timer) -- someone needs to verify LFR timer
end

function mod:Puncture(args)
	self:StackMessage(-7078, args.destName, args.amount, "Urgent",  "Info", L["puncture_message"])
end

