--[[
TODO:
	I assume pushing horridon below 30% before all doors open does not actually prevent new doors from opening
]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Horridon", 930, 819)
if not mod then return end
mod:RegisterEnableMob(68476, 69374) -- Horridon, War-God Jalak

--------------------------------------------------------------------------------
-- Locals
--

local doorCounter = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.charge_trigger = "sets his eyes" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!
	L.door_trigger = "pour" -- "Farraki forces pour from the Farraki Tribal Door!

	L.chain_lightning, L.chain_lightning_desc = EJ_GetSectionInfo(7124)
	L.chain_lightning_icon = 136480
	L.chain_lightning_message = "Your focus is casting Chain Lightning!"
	L.chain_lightning_bar = "Focus: Chain Lightning"

	L.fireball, L.fireball_desc = EJ_GetSectionInfo(7122)
	L.fireball_icon = 136465
	L.fireball_message = "Your focus is casting Fireball!"
	L.fireball_bar = "Focus: Fireball"

	L.venom_bolt_volley, L.venom_bolt_volley_desc = EJ_GetSectionInfo(7112)
	L.venom_bolt_volley_icon = 136587
	L.venom_bolt_volley_message = "Your focus is casting Volley!"
	L.venom_bolt_volley_bar = "Focus: Volley"

	L.adds = "Adds spawning"
	L.adds_desc = "Warnings for when the Farraki, the Gurubashi, the Drakkari, the Amani, and War-God Jalak spawn."
	L.adds_icon = "inv_misc_head_troll_01"

	L.door_opened = "Door opened!"
	L.door_bar = "Next door (%d)"
	L.balcony_adds = "Balcony adds"
	L.orb_message = "Orb of Control dropped!"

	L.focus_only = "|cffff0000Focus target alerts only.|r "
end
L = mod:GetLocale()
L.venom_bolt_volley_desc = L.focus_only..L.venom_bolt_volley_desc
L.fireball_desc = L.focus_only..L.fireball_desc
L.chain_lightning_desc = L.focus_only..L.chain_lightning_desc

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		137458,
		-7086, -7090, -7092,
		{-7109, "DISPEL"}, {136723, "FLASH"}, -- Farraki
		{"venom_bolt_volley", "FLASH"}, {136646, "FLASH"}, -- Gurubashi
		{-7119, "DISPEL"}, {-7120, "HEALER"}, {136573, "FLASH"}, -- Drakkari
		"fireball", "chain_lightning", {-7125, "DISPEL"}, {136490, "FLASH"}, -- Amani
		136817, 136821, -- War-God Jalak
		{-7078, "TANK_HEALER"}, 136741, {-7080, "FLASH", "SAY", "ICON"}, 137240, "adds", "berserk", "bosskill",
	}, {
		[137458] = "heroic",
		[-7086] = -7086,
		[-7109] = -7081,
		["venom_bolt_volley"] = -7082,
		[-7119] = -7083,
		["fireball"] = -7084,
		[136817] = -7087,
		[-7078] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "BossEngage")
	-- The Zandalari
	self:Log("SPELL_AURA_APPLIED", "Rampage", 136821)
	self:Log("SPELL_CAST_SUCCESS", "BestialCry", 136817)
	self:Log("SPELL_AURA_APPLIED", "CrackedShell", 137240)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrackedShell", 137240)
	self:Log("SPELL_AURA_APPLIED", "DinoForm", 137237)
	self:Log("SPELL_CAST_SUCCESS", "DinoMending", 136797)
	self:Log("SPELL_INTERRUPT", "DinoMendingInterrupt", "*")
	-- The Amani
	self:Log("SPELL_DAMAGE", "LightningNova", 136490)
	self:Log("SPELL_CAST_START", "Hex", 136512)
	self:Log("SPELL_CAST_START", "ChainLightning", 136480)
	self:Log("SPELL_CAST_START", "Fireball", 136465)
	-- The Drakkari
	self:Log("SPELL_DAMAGE", "FrozenOrb", 136573)
	self:Log("SPELL_AURA_REMOVED", "MortalStrikeRemoved", 136670)
	self:Log("SPELL_AURA_APPLIED", "MortalStrike", 136670)
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
	-- General
	self:Log("SPELL_AURA_APPLIED", "Puncture", 136767)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Puncture", 136767)
	self:Log("SPELL_CAST_START", "Swipe", 136741, 136770) -- 136770 is only after charge
	self:Emote("Charge", L["charge_trigger"])
	self:Emote("Doors", L["door_trigger"])
	self:Log("SPELL_CAST_START", "DireCall", 137458)
	self:Log("SPELL_AURA_APPLIED", "DireFixation", 140946)

	self:Death("Win", 68476)
end

function mod:OnEngage()
	doorCounter = 1
	self:Berserk(720)
	self:CDBar("adds", 16, L["door_bar"]:format(doorCounter), "inv_shield_11")
	self:CDBar(-7078, 10) -- Triple Puncture
	self:CDBar(-7080, 33) -- Charge
	if self:Heroic() then
		self:Bar(137458, 63) -- Dire Call
	end
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "LastPhase", "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- The Zandalari

function mod:BossEngage()
	self:CheckBossStatus()
	if self:MobId(UnitGUID("boss2")) == 69374 then -- War-God Jalak
		self:StopBar(-7087)
		self:Message("adds", "Neutral", "Info", -7087, false) -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
		self:Bar(136817, 5) -- Bestial Cry
	end
end

function mod:Rampage(args)
	self:Message(args.spellId, "Important", "Long")
end

function mod:BestialCry(args)
	self:Bar(args.spellId, 11) -- might help to pop personal cooldowns
end

function mod:CrackedShell(args)
	self:Message(args.spellId, "Positive", nil, args.spellName) -- 10s stun timer, too, maybe?
end

function mod:LastPhase(unitId)
	local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
	if hp < 35 then -- phase starts at 30, except if the boss is already there
		self:Message("adds", "Positive", "Info", CL["soon"]:format(self:SpellName(-7087)), "achievement_boss_trollgore") -- War-God Jalak
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1")
	end
end

function mod:DinoForm(args)
	-- tie it to this event, this is when you can use the orb
	self:Message(-7092, "Positive", nil, L["orb_message"])
end

function mod:DinoMending(args)
	self:Message(-7090, "Important", "Long")
	self:CDBar(-7090, 8) -- to help interrupters keep track
end

function mod:DinoMendingInterrupt(args)
	if args.extraSpellId == 136797 then
		self:StopBar(-7090)
		self:Message(-7090, "Positive", nil, CL["interrupted"]:format(self:SpellName(-7090)))
	end
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
	if self:Dispeller("curse", nil, -7125) then
		self:Message(-7125, "Important", "Alarm", args.spellName, args.spellId)
	end
end

do
	local prev = 0
	function mod:ChainLightning(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("chain_lightning", "Personal", "Alert", L["chain_lightning_message"], args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:Fireball(args)
		local t = GetTime()
		if t-prev > 3 and UnitGUID("focus") == args.sourceGUID then -- don't spam
			prev = t
			self:Message("fireball", "Personal", "Alert", L["fireball_message"], args.spellId)
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

function mod:MortalStrike(args)
	self:TargetMessage(-7120, args.destName, "Urgent")
	self:TargetBar(-7120, 8, args.destName)
end

function mod:MortalStrikeRemoved(args)
	self:StopBar(-7120, args.destName)
end

do
	local prev = 0
	function mod:DeadlyPlague(args)
		local t = GetTime()
		if t-prev > 3 and self:Dispeller("disease", nil, -7119) then -- don't spam
			prev = t
			self:Message(-7119, "Important", "Alarm", args.spellName, args.spellId)
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
		self:Message("venom_bolt_volley", "Personal", "Alert", L["venom_bolt_volley_message"], args.spellId)
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
		if t-prev > 3 and self:Dispeller("magic", nil, -7109) then -- don't spam
			prev = t
			self:Message(-7109, "Important", "Alarm", args.spellName, args.spellId)
		end
	end
end

-- General

function mod:Charge(msg, _, _, _, player)
	self:TargetMessage(-7080, player, "Attention", "Warning", nil, nil, true)
	self:CDBar(-7080, 51)
	self:PrimaryIcon(-7080, player)
	if UnitIsUnit("player", player) then
		self:Flash(-7080)
		self:Say(-7080)
	end
	self:ScheduleTimer("PrimaryIcon", 10, -7080) -- remove icon
end

function mod:Doors(msg)
	self:Message("adds", "Neutral", nil, L["door_opened"], "inv_shield_11")
	doorCounter = doorCounter + 1
	-- next door
	if doorCounter < 5 then
		self:Bar("adds", 114, L["door_bar"]:format(doorCounter), "inv_shield_11") -- door like icon
	else
		self:Bar("adds", 143, -7087, "achievement_boss_trollgore") -- War-God Jalak
	end

	-- 1st wave jumps down
	self:Bar("adds", 20, L["balcony_adds"], L.adds_icon)
	self:DelayedMessage("adds", 20, "Neutral", CL["count"]:format(L["balcony_adds"], 1), L.adds_icon)

	-- 2nd wave jumps down
	self:ScheduleTimer("Bar", 20, "adds", 19, L["balcony_adds"], L.adds_icon)
	self:DelayedMessage("adds", 39, "Neutral", CL["count"]:format(L["balcony_adds"], 2), L.adds_icon)

	-- dinomancer jumps down
	self:Bar(-7086, 58, nil, "ability_hunter_beastwithin") -- Zandalari Dinomancer (Dino Form icon)
	self:DelayedMessage(-7086, 58, "Neutral", nil, "ability_hunter_beastwithin")
end

function mod:Swipe(args)
	self:Message(136741, "Urgent", "Long")
	local timer = (args.spellID == 136770) and 11 or 19 -- after charge swipe is ~10 sec, then ~19 till next charge ( 10 H ptr )
	self:CDBar(136741, self:LFR() and 16 or timer) -- someone needs to verify LFR timer
end

function mod:Puncture(args)
	self:StackMessage(-7078, args.destName, args.amount, "Urgent")
	self:CDBar(-7078, 10.9)
end

function mod:DireCall(args)
	self:Message(args.spellId, "Urgent")
	self:Bar(args.spellId, 63)
end

function mod:DireFixation(args)
	if self:Me(args.destGUID) then
		self:Message(137458, "Personal", "Info", CL["you"]:format(args.spellName), args.spellId)
	end
end
