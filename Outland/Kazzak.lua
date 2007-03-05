------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Timers for enrage",

	enrage_trigger1 = "For the Legion! For Kil'Jaeden!",
	enrage_trigger2 = "%s becomes enraged!",
	enrage_warning1 = "%s Engaged - Enrage in 1min",
	enrage_warning2 = "Enrage in 5 sec",
	enrage_message = "Enrage for 10sec!",
	enrage_finished = "Enrage over",
	enrage_bar = "Enrage",
} end)

L:RegisterTranslations("frFR", function() return {
	enrage_name = "Alerte Enrager",
	enrage_desc = "D\195\169lais entre p\195\169riode enrag\195\169.",

	enrage_trigger1 = "Pour la L\195\169gion ! Pour Kil'Jaeden !",
	enrage_trigger2 = "%s devient fou furieux !",
	enrage_warning1 = "%s Engag\195\169 - Enrag\195\169 dans 1min",
	enrage_warning2 = "Enrag\195\169 dans 5 sec",
	enrage_message = "Enrag\195\169 pendant 10sec!",
	enrage_finished = "Enrag\195\169 fini",
	enrage_bar = "Enrag\195\169",
} end)

L:RegisterTranslations("koKR", function() return {
	enrage_name = "격노",
	enrage_desc = "격노에 대한 타이머",

	enrage_trigger1 = "불타는 군단과 킬제덴을 위하여!",
	enrage_trigger2 = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_warning1 = "%s 전투 개시 - 1분 후 격노",
	enrage_warning2 = "격노 5초 전",
	enrage_message = "10초간 격노!",
	enrage_finished = "격노 종료",
	enrage_bar = "격노",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hellfire Peninsula"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger1"] then
		self:Message(L["enrage_warning1"]:format(boss), "Attention")
		self:DelayedMessage(55, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger2"] then
		self:Message(L["enrage_message"], "Important")
		self:DelayedMessage(10, L["enrage_finished"], "Positive")
		self:Bar(L["enrage_bar"], 10, "Spell_Shadow_UnholyFrenzy")
	end
end
