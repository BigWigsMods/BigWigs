--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Magtheridon", 544, 1566)
if not mod then return end
mod:RegisterEnableMob(17257, 17256) --Magtheridon, Hellfire Channeler

local abycount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.escape = "Escape"
	L.escape_desc = "Countdown until Magtheridon breaks free."
	L.escape_icon = 20589
	L.escape_trigger1 = "%%s's bonds begin to weaken!"
	L.escape_trigger2 = "I... am... unleashed!"
	L.escape_warning1 = "%s Engaged - Breaks free in 2min!"
	L.escape_warning2 = "Breaks free in 1min!"
	L.escape_warning3 = "Breaks free in 30sec!"
	L.escape_warning4 = "Breaks free in 10sec!"
	L.escape_warning5 = "Breaks free in 3sec!"
	L.escape_bar = "Released..."
	L.escape_message = "%s Released!"

	L.abyssal = "Burning Abyssal"
	L.abyssal_desc = "Warn when a Burning Abyssal is created."
	L.abyssal_icon = 30511
	L.abyssal_message = "Burning Abyssal Created (%d)"

	L.heal = "Heal"
	L.heal_desc = "Warn when a Hellfire Channeler starts to heal."
	L.heal_icon = 30528
	L.heal_message = "Healing!"

	L.banish = "Banish"
	L.banish_desc = "Warn when you Banish Magtheridon."
	L.banish_icon = 30168
	L.banish_message = "Banished for ~10sec"
	L.banish_over_message = "Banish Fades!"
	L.banish_bar = "<Banished>"

	L.exhaust = mod:SpellName(44032)
	L.exhaust_desc = "Timer bars for Mind Exhaustion on players."
	L.exhaust_icon = 44032
	L.exhaust_bar = "[%s] Exhausted"

	L.debris_trigger = "Let the walls of this prison tremble"
	L.debris_message = "30% - Incoming Debris!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"escape", "abyssal", "heal",
		30616, "banish", 36449,
		"exhaust", "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Exhaustion", 44032)
	self:Log("SPELL_AURA_APPLIED", "Debris", 36449)
	self:Log("SPELL_SUMMON", "Abyssal", 30511)
	self:Log("SPELL_CAST_START", "Heal", 30528)
	self:Log("SPELL_CAST_START", "Nova", 30616)

	self:Log("SPELL_AURA_APPLIED", "Banished", 30168)
	self:Log("SPELL_AURA_REMOVED", "BanishRemoved", 30168)

	self:BossYell("Start", L["escape_trigger2"])
	self:BossYell("DebrisInc", L["debris_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:Death("Win", 17257)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")
	abycount = 1

	self:MessageOld("escape", "yellow", nil, L["escape_warning1"]:format(self.displayName), 20589)
	self:Bar("escape", 120, L["escape_bar"], 20589)
	self:DelayedMessage("escape", 60, "green", L["escape_warning2"])
	self:DelayedMessage("escape", 90, "yellow", L["escape_warning3"])
	self:DelayedMessage("escape", 110, "orange", L["escape_warning4"])
	self:DelayedMessage("escape", 117, "orange", L["escape_warning5"], false, "long")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if msg:find(L["escape_trigger1"]) then
		self:Engage()
	end
end

function mod:Exhaustion(args)
	self:Bar("exhaust", 30, L["exhaust_bar"]:format(args.destName), args.spellId)
end

function mod:Abyssal()
	self:MessageOld("abyssal", "yellow", nil, L["abyssal_message"]:format(abycount), 30511)
	abycount = abycount + 1
end

function mod:Heal(args)
	self:MessageOld("heal", "orange", "alarm", L["heal_message"], args.spellId)
	self:Bar("heal", 2, L["heal_message"], args.spellId)
end

function mod:Banished(args)
	self:MessageOld("banish", "red", "info", L["banish_message"], args.spellId)
	self:Bar("banish", 10, L["banish_bar"], args.spellId)
	self:StopBar(CL["cast"]:format(self:SpellName(30616))) -- Blast Nova
end

function mod:BanishRemoved(args)
	self:MessageOld("banish", "yellow", nil, L["banish_over_message"], args.spellId)
	self:StopBar(L["banish_bar"])
end

function mod:Start()
	self:CDBar(30616, 58) -- Nova
	self:DelayedMessage(30616, 56, "orange", CL["soon"]:format(self:SpellName(30616))) -- Nova
	self:Berserk(1200)

	self:StopBar(L["escape_bar"])
	self:CancelDelayedMessage(L["escape_warning2"])
	self:CancelDelayedMessage(L["escape_warning3"])
	self:CancelDelayedMessage(L["escape_warning4"])
	self:CancelDelayedMessage(L["escape_warning5"])
end

function mod:Nova(args)
	self:MessageOld(args.spellId, "green")
	self:CDBar(args.spellId, 51)
	self:Bar(args.spellId, 12, CL["cast"]:format(args.spellName))
	self:DelayedMessage(args.spellId, 48, "orange", CL["soon"]:format(args.spellName))
end

function mod:Debris(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "red", "alert", CL["you"]:format(args.spellName))
	end
end

function mod:DebrisInc()
	self:MessageOld(36449, "green", nil, L["debris_message"])
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 17257 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 30 and hp < 37 then
			local debris = self:SpellName(36449)
			self:MessageOld(36449, "green", nil, CL["soon"]:format(debris), false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

