--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = "The Beasts of Northrend"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end

local gormok, icehowl, acidmaw, dreadscale, jormungars

local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
mod.bossName = { "Gormok the Impaler", "Icehowl", "Acidmaw", "Dreadscale", "Jormungars" }
mod.displayName = boss
mod.zoneName = "Trial of the Crusader"
mod.enabletrigger = {
	34796, -- Gormok
	34799, -- Dreadscale
	35144, -- Acidmaw
	34797, -- Icehowl
}
mod.guid = 34797 -- Icehowl
mod.toggleOptions = {"snobold", 67477, 67472, 67641, "spew", 67618, 66869, 68335, "proximity", 67654, "charge", 66758, 66759, "bosskill"}
mod.optionHeaders = {
	snobold = "Gormok the Impaler",
	[67641] = "Jormungars",
	[67654] = "Icehowl",
	bosskill = CL.general,
}
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.proximitySilent = true
mod.consoleCmd = "Beasts"

--------------------------------------------------------------------------------
-- Locals
--

local difficulty = nil
local db = nil
local pName = UnitName("player")
local burn = mod:NewTargetList()
local toxin = mod:NewTargetList()
local snobolledWarned = {}
local snobolled = GetSpellInfo(66406)

--------------------------------------------------------------------------------
-- Localization
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
if L then
	L.engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!"
	L.jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!"
	L.icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!"
	L.boss_incoming = "%s incoming"

	-- Gormok
	L.snobold = "Snobold"
	L.snobold_desc = "Warn who gets a Snobold on their heads."
	L.snobold_message = "Add on %s!"
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
	gormok = self.bossName[1]
	icehowl = self.bossName[2]
	acidmaw = self.bossName[3]
	dreadscale = self.bossName[4]
	jormungars = self.bossName[5]
end

function mod:OnBossEnable()
	-- Gormok
	self:AddCombatListener("SPELL_DAMAGE", "FireBomb", 67472, 66317, 67475)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331, 67478, 67479)
	--self:AddCombatListener("SPELL_CAST_START", "Stomp", 67647, 67648, 66330, 67649)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_AURA")

	-- Jormungars
	self:AddCombatListener("SPELL_CAST_SUCCESS", "SlimeCast", 67641, 67642, 67643)
	self:AddCombatListener("SPELL_DAMAGE", "Slime", 67640)
	self:AddCombatListener("SPELL_CAST_START", "Acidic", 66818)
	self:AddCombatListener("SPELL_CAST_START", "Molten", 66821)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Toxin", 67618, 67619, 67620, 66823)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BurnRemoved", 66869, 66870)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 68335)

	-- Icehowl
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rage", 66759, 67658)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Daze", 66758)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Butt", 67654, 67655, 66770)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	-- Common
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	difficulty = GetRaidDifficulty()
	wipe(snobolledWarned)
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
		self:IfMessage(L["snobold_message"]:format(n), "Attention", icon)
		snobolledWarned[n] = true
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg == L["engage_trigger"] then
		self:SendMessage("BigWigs_HideProximity", self)
		if difficulty > 2 then
			self:Bar(L["boss_incoming"]:format(jormungars), 180, "INV_Misc_MonsterScales_18")
		elseif db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg == L["jormungars_trigger"] then
		local m = L["boss_incoming"]:format(jormungars)
		self:IfMessage(m, "Positive")
		self:Bar(m, 15, "INV_Misc_MonsterScales_18")
		if difficulty > 2 then
			self:Bar(L["boss_incoming"]:format(icehowl), 195, "INV_Misc_MonsterHorn_07")
		end
	elseif msg == L["icehowl_trigger"] then
		local m = L["boss_incoming"]:format(icehowl)
		self:IfMessage(m, "Positive")
		self:Bar(m, 10, "INV_Misc_MonsterHorn_07")
		if difficulty > 2 then
			self:Bar(CL.berserk, 190)
		end
	end
end

function mod:Impale(event, player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(L["impale_message"], player, "Urgent", icon, "Info", stack)
	end
end

do
	local last = nil
	function mod:FireBomb(event, player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["firebomb_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Jormungars
--

function mod:SlimeCast(event, _, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
end

function mod:Molten(event, _, spellId, _, _, spellName)
	if db.spew then
		self:IfMessage(spellName, "Attention", spellId)
	end
end

function mod:Acidic(event, _, spellId, _, _, spellName)
	if db.spew then
		self:IfMessage(spellName, "Attention", spellId)
	end
end

do
	local dontWarn = nil
	
	local function toxinWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(L["toxin_spell"], toxin, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(toxin)
		end
	end
	function mod:Toxin(event, player, spellId)
		toxin[#toxin + 1] = player
		self:ScheduleEvent("BWtoxinWarn", toxinWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TargetMessage(L["toxin_spell"], player, "Personal", spellId, "Info")
		end
	end
end

do
	local dontWarn = nil

	local function burnWarn(spellId)
		if not dontWarn then
			mod:TargetMessage(L["burn_spell"], burn, "Urgent", spellId)
		else
			dontWarn = nil
			wipe(burn)
		end
	end
	function mod:Burn(event, player, spellId)
		burn[#burn + 1] = player
		self:ScheduleEvent("BWburnWarn", burnWarn, 0.2, spellId)
		if player == pName then
			dontWarn = true
			self:TriggerEvent("BigWigs_ShowProximity", self)
			self:TargetMessage(L["burn_spell"], player, "Important", spellId, "Info")
		end
	end
end

function mod:BurnRemoved(event, player)
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:Enraged(event, _, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId, "Long")
end

do
	local last = nil
	function mod:Slime(event, player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["slime_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Icehowl
--

function mod:Rage(event, _, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Daze(event, _, spellId, _, _, spellName)
	self:IfMessage(spellName, "Positive", spellId)
	self:Bar(spellName, 15, spellId)
end

function mod:Butt(event, player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Attention", spellId)
	self:Bar(L["butt_bar"], 12, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, message, unit, _, _, player)
	if unit == icehowl and db.charge and message:find(L["charge_trigger"]) then
		local spellName = GetSpellInfo(52311)
		self:TargetMessage(spellName, player, "Personal", 52311, "Alarm")
		self:Bar(spellName..": "..player, 7, 52311)
	end
end

