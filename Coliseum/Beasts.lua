--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Beasts of Northrend", "Trial of the Crusader")
if not mod then return end
mod.toggleOptions = {"snobold", 67477, 66330, {67472, "FLASHSHAKE"}, "submerge", {67641, "FLASHSHAKE"}, "spew", "sprays", {67618, "FLASHSHAKE"}, 66869, 68335, "proximity", 67654, {"charge", "ICON", "SAY", "FLASHSHAKE"}, 66758, 66759, "bosses", "berserk", "bosskill"}
mod.optionHeaders = {
	snobold = "Gormok the Impaler",
	submerge = "Jormungars",
	[67654] = "Icehowl",
	bosses = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local difficulty = 0
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()
local snobolledWarned = {}
local snobolled = GetSpellInfo(66406)
local icehowl, jormungars, gormok = nil, nil, nil
local sprayTimer = nil
local handle_Jormungars = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.enable_trigger = "You have heard the call of the Argent Crusade and you have boldly answered"
	L.wipe_trigger = "Tragic..."

	L.engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!"
	L.jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!"
	L.icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!"
	L.boss_incoming = "%s incoming"

	-- Gormok
	L.snobold = "Snobold"
	L.snobold_desc = "Warn who gets a Snobold on their heads."
	L.snobold_message = "Add"
	L.impale_message = "%2$dx Impale on %1$s"
	L.firebomb_message = "Fire on YOU!"

	-- Jormungars
	L.submerge = "Submerge"
	L.submerge_desc = "Show a timer bar for the next time the worms will submerge."
	L.spew = "Acidic/Molten Spew"
	L.spew_desc = "Warn for Acidic/Molten Spew."
	L.sprays = "Sprays"
	L.sprays_desc = "Show timers for the next Paralytic and Burning Sprays."
	L.slime_message = "Slime on YOU!"
	L.burn_spell = "Burn"
	L.toxin_spell = "Toxin"
	L.spray = "~Next Spray"

	-- Icehowl
	L.butt_bar = "~Butt Cooldown"
	L.charge = "Furious Charge"
	L.charge_desc = "Warn about Furious Charge on players."
	L.charge_trigger = "glares at"
	L.charge_say = "Charge on me!"

	L.bosses = "Bosses"
	L.bosses_desc = "Warn about bosses incoming"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:RegisterEnableMob(
		34796, -- Gormok
		34799, -- Dreadscale
		35144, -- Acidmaw
		34797  -- Icehowl
	)
	self:RegisterEnableYell(L["enable_trigger"])

	icehowl = BigWigs:Translate("Icehowl")
	jormungars = BigWigs:Translate("Jormungars")
	gormok = BigWigs:Translate("Gormok the Impaler")
end

function mod:OnBossEnable()
	-- Gormok
	self:Log("SPELL_DAMAGE", "FireBomb", 67472, 66317, 67475)
	self:Log("SPELL_AURA_APPLIED", "Impale", 67477, 66331, 67478, 67479)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331, 67478, 67479)
	self:Log("SPELL_CAST_START", "StaggeringStomp", 66330, 67647, 67648, 67649)
	self:RegisterEvent("UNIT_AURA")

	-- Jormungars
	self:Log("SPELL_CAST_SUCCESS", "SlimeCast", 67641, 67642, 67643)
	self:Log("SPELL_DAMAGE", "Slime", 67640)
	-- Acidic, Molten
	self:Log("SPELL_CAST_START", "Spew", 66818, 66821)
	-- First 4 are Paralytic, last 4 are Burning
	self:Log("SPELL_CAST_START", "Spray", 67617, 67616, 67615, 66901, 67629, 67628, 67627, 66902)
	self:Log("SPELL_AURA_APPLIED", "Toxin", 67618, 67619, 67620, 66823)
	self:Log("SPELL_AURA_APPLIED", "Burn", 66869, 66870)
	self:Log("SPELL_AURA_APPLIED", "Enraged", 68335)
	self:Yell("Jormungars", L["jormungars_trigger"])

	-- Icehowl
	self:Log("SPELL_AURA_APPLIED", "Rage", 66759, 67658, 67657, 67659)
	self:Log("SPELL_AURA_APPLIED", "Daze", 66758)
	self:Log("SPELL_AURA_APPLIED", "Butt", 67654, 67655, 66770)
	self:Yell("Icehowl", L["icehowl_trigger"])
	self:Emote("Charge", L["charge_trigger"])

	-- Common
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Reboot", L["wipe_trigger"])
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Reboot")
	self:Death("Win", 34797)
end

function mod:OnEngage(diff)
	difficulty = diff
	self:CloseProximity()
	self:Bar("bosses", L["boss_incoming"]:format(gormok), 20, 67477)
	if diff > 2 then
		self:Bar("bosses", L["boss_incoming"]:format(jormungars), 180, "INV_Misc_MonsterScales_18")
	else
		self:Berserk(900)
	end
	wipe(snobolledWarned)
end

function mod:Jormungars()
	local m = L["boss_incoming"]:format(jormungars)
	self:Message("bosses", m, "Positive")
	self:Bar("bosses", m, 15, "INV_Misc_MonsterScales_18")
	if difficulty > 2 then
		self:Bar("bosses", L["boss_incoming"]:format(icehowl), 200, "INV_Misc_MonsterHorn_07")
	end
	self:OpenProximity(10)
	-- The first worm to spray is Acidmaw, he has a 10 second spray timer after emerge
	sprayTimer = 10
	handle_Jormungars = self:ScheduleTimer("Emerge", 15)
end

function mod:Icehowl()
	local m = L["boss_incoming"]:format(icehowl)
	self:Message("bosses", m, "Positive")
	self:Bar("bosses", m, 10, "INV_Misc_MonsterHorn_07")
	self:CancelTimer(handle_Jormungars, true)
	handle_Jormungars = nil
	self:SendMessage("BigWigs_StopBar", self, L["spray"])
	self:SendMessage("BigWigs_StopBar", self, L["submerge"])
	if difficulty > 2 then
		self:Berserk(220, true, icehowl)
	end
	self:CloseProximity()
end

--------------------------------------------------------------------------------
-- Gormok the Impaler
--

function mod:UNIT_AURA(event, unit)
	local name, _, icon = UnitDebuff(unit, snobolled)
	local n = UnitName(unit)
	if snobolledWarned[n] and not name then
		snobolledWarned[n] = nil
	elseif name and not snobolledWarned[n] then
		self:TargetMessage("snobold", L["snobold_message"], n, "Attention", icon)
		snobolledWarned[n] = true
	end
end

function mod:Impale(player, spellId, _, _, spellName, stack)
	if stack and stack > 1 then
		self:TargetMessage(67477, L["impale_message"], player, "Urgent", spellId, "Info", stack)
	end
	self:Bar(67477, spellName, 10, spellId)
end

function mod:StaggeringStomp(_, spellId, _, _, spellName)
	self:Message(66330, spellName, "Important", spellId)
	self:Bar(66330, spellName, 21, spellId)
end

do
	local last = nil
	function mod:FireBomb(player, spellId)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(67472, L["firebomb_message"], "Personal", spellId, last and nil or "Alarm")
				self:FlashShake(67472)
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Jormungars
--

do
	local function submerge()
		handle_Jormungars = mod:ScheduleTimer("Emerge", 10)
	end

	function mod:Emerge()
		self:Bar("submerge", L["submerge"], 45, "INV_Misc_MonsterScales_18")
		handle_Jormungars = self:ScheduleTimer(submerge, 45)
		-- Rain of Fire icon as a generic AoE spray icon .. good enough?
		self:Bar("sprays", L["spray"], sprayTimer, 5740)
		sprayTimer = sprayTimer == 10 and 20 or 10
	end

	function mod:Spray(_, spellId, _, _, spellName)
		self:Message("sprays", spellName, "Important", spellId)
		self:Bar("sprays", L["spray"], 20, 5740)
	end
end


function mod:SlimeCast(_, spellId, _, _, spellName)
	self:Message(67641, spellName, "Attention", spellId)
end

function mod:Spew(_, spellId, _, _, spellName)
	self:Message("spew", spellName, "Attention", spellId)
end

do
	local handle = nil
	local dontWarn = nil
	local function toxinWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(67618, L["toxin_spell"], toxin, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(toxin)
		end
		handle = nil
	end
	function mod:Toxin(player, spellId)
		toxin[#toxin + 1] = player
		if handle then self:CancelTimer(handle) end
		handle = self:ScheduleTimer(toxinWarn, 0.2, spellId)
		if UnitIsUnit(player, "player") then
			dontWarn = true
			self:TargetMessage(67618, L["toxin_spell"], player, "Personal", spellId, "Info")
			self:FlashShake(67618)
		end
	end
end

do
	local handle = nil
	local dontWarn = nil
	local function burnWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(66869, L["burn_spell"], burn, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(burn)
		end
		handle = nil
	end
	function mod:Burn(player, spellId)
		burn[#burn + 1] = player
		if handle then self:CancelTimer(handle) end
		handle = self:ScheduleTimer(burnWarn, 0.2, spellId)
		if UnitIsUnit(player, "player") then
			dontWarn = true
			self:TargetMessage(66869, L["burn_spell"], player, "Important", spellId, "Info")
		end
	end
end

function mod:Enraged(_, spellId, _, _, spellName)
	self:Message(68335, spellName, "Important", spellId, "Long")
end

do
	local last = nil
	function mod:Slime(player, spellId)
		if UnitIsUnit(player, "player") then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(67641, L["slime_message"], "Personal", spellId, last and nil or "Alarm")
				self:FlashShake(67641)
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Icehowl
--

function mod:Rage(_, spellId, _, _, spellName)
	self:Message(66759, spellName, "Important", spellId)
	self:Bar(66759, spellName, 15, spellId)
end

function mod:Daze(_, spellId, _, _, spellName)
	self:Message(66758, spellName, "Positive", spellId)
	self:Bar(66758, spellName, 15, spellId)
end

function mod:Butt(player, spellId, _, _, spellName)
	self:TargetMessage(67654,spellName, player, "Attention", spellId)
	self:Bar(67654,L["butt_bar"], 12, spellId)
end

function mod:Charge(msg, unit, _, _, player)
	if unit ~= icehowl then return end
	local spellName = GetSpellInfo(52311)
	self:TargetMessage("charge", spellName, player, "Personal", 52311, "Alarm")
	if UnitIsUnit(player, "player") then
		self:FlashShake("charge")
		self:Say("charge", L["charge_say"])
	end
	self:Bar("charge", spellName, 7.5, 52311)
	self:PrimaryIcon("charge", player)
end

