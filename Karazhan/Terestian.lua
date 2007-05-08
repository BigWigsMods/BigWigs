------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Terestian Illhoof"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Terestian",

	engage_trigger = "Ah, you're just in time.",

	sacrifice = "Sacrifice",
	sacrifice_desc = "Warn for Sacrifice of players",

	icon = "Icon",
	icon_desc = "Place a raid icon on the sacrificed player(requires promoted or higher)",

	enrage = "Enrage",
	enrage_desc = "Warn about enrage after 10min.",

	weak = "Weakened",
	weak_desc = "Warn for weakened state",

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
	sacrifice = "Opferung",
	sacrifice_desc = "Warnt welcher Spieler geopfert wird",

	weak = "Geschw\195\164cht",
	weak_desc = "Warnt wenn Terestian geschw\195\164cht ist",

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
	engage_trigger = "Ah, vous arrivez juste \195\160 temps.",

	sacrifice = "Sacrifice",
	sacrifice_desc = "Pr\195\169viens quand un joueur est sacrifi\195\169.",

	icon = "Ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le joueur sacrifi\195\169 (n\195\169cessite d'\195\170tre promu ou mieux).",

	enrage = "Enrager",
	enrage_desc = "Pr\195\169viens quand Terestian devient enrag\195\169 apr\195\168s 10 minutes.",

	weak = "Affaibli",
	weak_desc = "Pr\195\169viens quand Terestian est affaibli.",

	sacrifice_trigger = "^([^%s]+) ([^%s]+) les effets .* Sacrifice",
	sacrifice_message = "%s est sacrifi\195\169 !",
	sacrifice_bar = "Sacrifice : %s",

	weak_trigger = "les effets .* Pacte rompu",
	weak_message = "Affaibli pendant 30 sec. !",
	weak_warning1 = "Affaibli plus que 5 sec. !",
	weak_warning2 = "Plus affaibli !",
	weak_bar = "Affaibli",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "아, 때맞춰 와줬군.",

	sacrifice = "희생",
	sacrifice_desc = "플레이어의 희생에 대한 경고",

	icon = "아이콘",
	icon_desc = "희생에 걸린 플레이어에 공격대 아이콘 지정(승급자 이상 요구)",

	enrage = "격노",
	enrage_desc = "10분 후 격노에 대한 알림.",

	weak = "약화",
	weak_desc = "약화 상태에 대한 경고",

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
mod.toggleoptions = {"weak", "enrage", -1, "sacrifice", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckSacrifice")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg:find(L["engage_trigger"]) then
		self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
		self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
		self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
		self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
		self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
		self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CheckSacrifice(msg)
	if not self.db.profile.sacrifice then return end
	local splayer, stype = select(3, msg:find(L["sacrifice_trigger"]))
	if splayer then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = UnitName("player")
		end
		self:Message(L["sacrifice_message"]:format(splayer), "Attention")
		self:Bar(L["sacrifice_bar"]:format(splayer), 30, "Spell_Shadow_AntiMagicShell")
		if self.db.profile.icon then
			self:Icon(splayer)
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
