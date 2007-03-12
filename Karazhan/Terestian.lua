------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Terestian Illhoof"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Terestian",
	
	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = ("Alert when %s is engaged"):format(boss),
	
	engage_trigger = "Ah, you're just in time. The rituals are about to begin!",
	engage_message = ("%s Engaged!"):format(boss),

	sacrifice_name = "Sacrifice",
	sacrifice_desc = "Warn for Sacrifice of players",

	enrage_name = "Enrage",
	enrage_desc = "Warn about enrage after 10min.",

	weak_name = "Weakened",
	weak_desc = "Warn for weakened state",

	enrage_warning = "Enrage in %d sec!",
	enrage_bar = "Enrage",

	sacrifice_you = "You",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) afflicted by Sacrifice",
	sacrifice_message = "%s is being Sacrificed!",
	sacrifice_bar = "Sacrifice: %s",

	weak_trigger = "afflicted by Broken Pact",
	weak_message = "Weakened for 30sec!",
	weak_warning1 = "Weakened over in 5sec!",
	weak_warning2 = "Weakened over!",
	weak_bar = "Weakened",
} end )

L:RegisterTranslations("deDE", function() return {
	sacrifice_name = "Opferung",
	sacrifice_desc = "Warnt welcher Spieler geopfert wird",

	weak_name = "Geschw\195\164cht",
	weak_desc = "Warnt wenn Terestian geschw\195\164cht ist",

	sacrifice_you = "Ihr",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) von Opferung betroffen",
	sacrifice_message = "%s wird geopfert!",
	sacrifice_bar = "Opferung: %s",

	weak_trigger = "von Mal der Flamme betroffen",
	weak_message = "Geschw\195\164cht f\195\188r 30 Sek!",
	weak_warning1 = "Geschw\195\164cht vorbei in 5 Sek!",
	weak_warning2 = "Geschw\195\164cht vorbei!",
	weak_bar = "Geschw\195\164cht",
} end )

L:RegisterTranslations("frFR", function() return {
	sacrifice_name = "Sacrifice",
	sacrifice_desc = "Pr\195\169viens quand un joueur est sacrifi\195\169",

	weak_name = "Affaibli",
	weak_desc = "Pr\195\169viens quand Terestian est affaibli",

	sacrifice_you = "Vous",
	sacrifice_trigger = "^([^%s]+) ([^%s]+) les effets .* Sacrifice",
	sacrifice_message = "%s est sacrifi\195\169!",
	sacrifice_bar = "Sacrifice: %s",

	weak_trigger = "les effets .* Pacte rompu",
	weak_message = "Affaibli pour 30sec!",
	weak_warning1 = "Affaibli plus que  5sec!",
	weak_warning2 = "Plus affaibli!",
	weak_bar = "Affaibli",
} end )

L:RegisterTranslations("koKR", function() return {
	sacrifice_name = "희생",
	sacrifice_desc = "플레이어의 희생에 대한 경고",

	weak_name = "약화",
	weak_desc = "약화 상태에 대한 경고",

	sacrifice_you = "당신은",
	sacrifice_trigger = "^([^|;%s]*)(.*)희생에 걸렸습니다%.$",
	sacrifice_message = "%s님이 희생되었습니다!",
	sacrifice_bar = "희생: %s",

	weak_trigger = "깨진 서약에 걸렸습니다.",
	weak_message = "30초간 약화!",
	weak_warning1 = "5초 후 약화 종료!",
	weak_warning2 = "약화 종료!",
	weak_bar = "약화",
} end )

----------------------------------
--    Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "sacrifice", "weak", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
	end
end

function mod:CheckSacrifice(msg)
	if not self.db.profile.sacrifice then return end
	local splayer, stype = select(3, msg:find(L["sacrifice_trigger"]))
	if splayer then
		if splayer == L["sacrifice_you"] then
			splayer = UnitName("player")
		end
		self:Message(L["sacrifice_message"]:format(splayer), "Attention")
		self:Bar(L["sacrifice_bar"]:format(splayer), 30, "Spell_Shadow_AntiMagicShell")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync() and not started then
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		started = true
		if self.db.profile.enrage then
			self:DelayedMessage(540, L["enrage_warning"]:format(60), "Attention")
			self:DelayedMessage(570, L["enrage_warning"]:format(30), "Urgent")
			self:DelayedMessage(590, L["enrage_warning"]:format(10), "Important")
			self:Bar(L["enrage_bar"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if self.db.profile.weak and msg:find(L["weak_trigger"]) then
		self:Message(L["weak_message"], "Important", nil, "Alarm")
		self:DelayedMessage(25, L["weak_warning1"], "Attention")
		self:DelayedMessage(30, L["weak_warning2"], "Attention")
		self:Bar(L["weak_bar"], 30, "Spell_Shadow_Cripple")
	end
end

