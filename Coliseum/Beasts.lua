--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("The Beasts of Northrend", "Trial of the Crusader")
if not mod then return end
mod:Toggle("snobold", "MESSAGE")
mod:Toggle(67477, "MESSAGE")
mod:Toggle(67472, "MESSAGE", "FLASHNSHAKE")
mod:Toggle(67641, "MESSAGE", "FLASHNSHAKE")
mod:Toggle("spew", "MESSAGE")
mod:Toggle(67618, "MESSAGE", "FLASHNSHAKE")
mod:Toggle(66869, "MESSAGE")
mod:Toggle(68335, "MESSAGE")
mod:Toggle("proximity")
mod:Toggle(67654, "MESSAGE", "BAR")
mod:Toggle("charge", "MESSAGE", "BAR", "ICON", "FLASHNSHAKE")
mod:Toggle(66758, "MESSAGE", "BAR")
mod:Toggle(66759, "MESSAGE", "BAR")
mod:Toggle("berserk")
mod:Toggle("bosskill")
--[[
mod.toggleOptions = {"snobold", 67477, 67472, 67641, "spew", 67618, 66869, 68335, "proximity", 67654, 
"charge", 66758, 66759, "berserk", "bosskill"}
--]]
mod.optionHeaders = {
	snobold = "Gormok the Impaler",
	[67641] = "Jormungars",
	[67654] = "Icehowl",
	berserk = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local difficulty = nil
local pName = UnitName("player")
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()
local snobolledWarned = {}
local snobolled = GetSpellInfo(66406)
local icehowl, jormungars, gormok = nil, nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
if L then
	L.enable_trigger = "You have heard the call of the Argent Crusade and you have boldly answered"

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
	L.spew = "Acidic/Molten Spew"
	L.spew_desc = "Warn for Acidic/Molten Spew."

	L.slime_message = "Slime on YOU!"
	L.burn_spell = "Burn"
	L.toxin_spell = "Toxin"

	-- Icehowl
	L.butt_bar = "~Butt Cooldown"
	L.charge = "Furious Charge"
	L.charge_desc = "Warn about Furious Charge on players."
	L.charge_trigger = "glares at"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Northrend Beasts")
mod.locale = L

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
	self:Log("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331, 67478, 67479)
	self:RegisterEvent("UNIT_AURA")

	-- Jormungars
	self:Log("SPELL_CAST_SUCCESS", "SlimeCast", 67641, 67642, 67643)
	self:Log("SPELL_DAMAGE", "Slime", 67640)
	self:Log("SPELL_CAST_START", "Acidic", 66818)
	self:Log("SPELL_CAST_START", "Molten", 66821)
	self:Log("SPELL_AURA_APPLIED", "Toxin", 67618, 67619, 67620, 66823)
	self:Log("SPELL_AURA_APPLIED", "Burn", 66869, 66870)
	--self:Log("SPELL_AURA_REMOVED", "BurnRemoved", 66869, 66870)
	self:Log("SPELL_AURA_APPLIED", "Enraged", 68335)
	self:Yell("Jormungars", L["jormungars_trigger"])

	-- Icehowl
	self:Log("SPELL_AURA_APPLIED", "Rage", 66759, 67658)
	self:Log("SPELL_AURA_APPLIED", "Daze", 66758)
	self:Log("SPELL_AURA_APPLIED", "Butt", 67654, 67655, 66770)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:Yell("Icehowl", L["icehowl_trigger"])

	-- Common
	self:Yell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 34797)

	difficulty = GetRaidDifficulty()
end

function mod:OnEngage()
	self:CloseProximity()
	if difficulty > 2 then
		self:Bar(L["boss_incoming"]:format(gormok), 20, 67477)
		self:Bar(L["boss_incoming"]:format(jormungars), 180, "INV_Misc_MonsterScales_18")
	elseif self.db.profile.berserk then
		self:Berserk(900)
	end
	wipe(snobolledWarned)
end

function mod:Jormungars()
	local m = L["boss_incoming"]:format(jormungars)
	self:IfMessage(m, "Positive")
	self:Bar(m, 15, "INV_Misc_MonsterScales_18")
	if difficulty > 2 then
		self:Bar(L["boss_incoming"]:format(icehowl), 200, "INV_Misc_MonsterHorn_07")
	end
	self:OpenProximity(10)
end

function mod:Icehowl()
	local m = L["boss_incoming"]:format(icehowl)
	self:IfMessage(m, "Positive")
	self:Bar(m, 10, "INV_Misc_MonsterHorn_07")
	if difficulty > 2 and self.db.profile.berserk then
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

function mod:Impale(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(67477, L["impale_message"], player, "Urgent", icon, "Info", stack)
	end
end

do
	local last = nil
	function mod:FireBomb(player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(67472, L["firebomb_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Jormungars
--

function mod:SlimeCast(_, spellId, _, _, spellName)
	self:IfMessage(67641, spellName, "Attention", spellId)
end

function mod:Molten(_, spellId, _, _, spellName)
	self:IfMessage("spew", spellName, "Attention", spellId)
end

function mod:Acidic(_, spellId, _, _, spellName)
	self:IfMessage("spew", spellName, "Attention", spellId)
end

do
	local dontWarn = nil
	local function toxinWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(67618, L["toxin_spell"], toxin, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(toxin)
		end
	end
	function mod:Toxin(player, spellId)
		toxin[#toxin + 1] = player
		self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TargetMessage(67618, L["toxin_spell"], player, "Personal", spellId, "Info")
		end
	end
end

do
	local dontWarn = nil
	local function burnWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(66869, L["burn_spell"], burn, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(burn)
		end
	end
	function mod:Burn(player, spellId)
		burn[#burn + 1] = player
		self:ScheduleEvent("BWburnWarn", burnWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TargetMessage(66869, L["burn_spell"], player, "Important", spellId, "Info")
		end
	end
end

function mod:Enraged(_, spellId, _, _, spellName)
	self:IfMessage(68335, spellName, "Important", spellId, "Long")
end

do
	local last = nil
	function mod:Slime(player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(67641, L["slime_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Icehowl
--

function mod:Rage(_, spellId, _, _, spellName)
	self:IfMessage(66759, spellName, "Important", spellId)
	self:Bar(66759, spellName, 15, spellId)
end

function mod:Daze(_, spellId, _, _, spellName)
	self:IfMessage(66758, spellName, "Positive", spellId)
	self:Bar(66758, spellName, 15, spellId)
end

function mod:Butt(player, spellId, _, _, spellName)
	self:TargetMessage(67654,spellName, player, "Attention", spellId)
	self:Bar(67654,L["butt_bar"], 12, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, message, unit, _, _, player)
	if unit == icehowl and message:find(L["charge_trigger"]) then
		local spellName = GetSpellInfo(52311)
		self:TargetMessage("charge", spellName, player, "Personal", 52311, "Alarm")
		self:Bar("charge", spellName, 7.5, 52311)
		self:PrimaryIcon("charge", player)
	end
end

