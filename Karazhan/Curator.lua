------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Curator"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageannounced

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Curator",

	berserk = "Berserk",
	berserk_desc = "Warn for berserk after 10min.",

	enrage = "Enrage",
	enrage_desc = "Warn for enrage at 15%.",

	weaken = "Weaken",
	weaken_desc = "Warn for weakened state",

	weaktime = "Weaken Countdown",
	weaktime_desc = "Countdown warning and bar untill next weaken.",

	weaken_trigger = "Your request cannot be processed.",
	weaken_message = "Evocation - Weakened for 20sec!",
	weaken_bar = "Evocation",
	weaken_fade_message = "Evocation Finished - Weakened Gone!",
	weaken_fade_warning = "Evocation over in 5sec!",

	weaktime_message1 = "Evocation in ~10 seconds",
	weaktime_message2 = "Evocation in ~30 seconds",
	weaktime_message3 = "Evocation in ~70 seconds",
	weaktime_bar = "Next Evocation",

	berserk_trigger = "The Menagerie is for guests only.",
	berserk_message = "%s engaged, 10min to berserk!",
	berserk_bar = "Berserk",

	enrage_trigger = "Failure to comply will result in offensive action.",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage soon!",
} end )

L:RegisterTranslations("frFR", function() return {
	berserk = "Alerte Berserk",
	berserk_desc = "Pr\195\169viens du mode berserk apr\195\168s 10 minutes.",

	enrage = "Alerte Enrag\195\169",
	enrage_desc = "Pr\195\169viens du mode enrag\195\169 \195\160 15%.",

	weaken = "Alerte Affaiblissement",
	weaken_desc = "Pr\195\169viens quand le Conservateur est affaibli.",

	weaktime = "Compteur d'affaiblissement",
	weaktime_desc = "Affiche un compteur pour le nombre et le prochain affaiblissement.",

	weaken_trigger = "Impossible de traiter votre requ\195\170te.",
	weaken_message = "Evocation - Affaibli pour 20 secondes !",
	weaken_bar = "Evocation",
	weaken_fade_message = "Evocation termin\195\169e - Affaiblissement parti !",
	weaken_fade_warning = "Evocation termin\195\169e dans 5 secondes !",

	weaktime_message1 = "Evocation dans ~10 secondes",
	weaktime_message2 = "Evocation dans ~30 secondes",
	weaktime_message3 = "Evocation dans ~70 secondes",
	weaktime_bar = "Prochaine Evocation",

	berserk_trigger = "L'acc\195\168s \195\160 la M\195\169nagerie est r\195\169serv\195\169 aux invit\195\169s.",
	berserk_message = "%s engag\195\169, 10min avant berserk !",
	berserk_bar = "Berserk",

	enrage_trigger = "Toute d\195\169sob\195\169issance entra\195\174nera une action offensive",
	enrage_message = "Enrag\195\169 !",
	enrage_warning = "Enrag\195\169 imminent !",
} end )

L:RegisterTranslations("deDE", function() return {
	berserk = "Berserker",
	berserk_desc = "Warnung f\195\188r Berserker nach 10min.",

	enrage = "Rage",
	enrage_desc = "Warnung f\195\188r Rage bei 15%.",

	weaken = "Schw\195\164chung",
	--weaken_desc = "Warn for weakened state", --enUS changed

	weaktime = "Schw\195\164chungs Timer",
	weaktime_desc = "Timer und Anzeige f\195\188r die n\195\164chste Schw\195\164chung.",

	weaken_trigger = "Ihre Anfrage kann nicht bearbeitet werden.",
	weaken_message = "Hervorrufung f\195\188r 20 sekunden!",
	weaken_bar = "Hervorrufung",
	weaken_fade_message = "Hervorrufung beendet - Kurator nicht mehr geschw\195\164cht!",
	weaken_fade_warning = "Hervorrufung in 5 sekunden beendet!",

	weaktime_message1 = "Hervorrufung in ~10 sekunden",
	weaktime_message2 = "Hervorrufung in ~30 sekunden",
	weaktime_message3 = "Hervorrufung in ~70 sekunden",
	weaktime_bar = "N\195\164chste Hervorrufung",

	berserk_trigger = "Die Menagerie ist nur f\195\188r G\195\164ste.",
	berserk_message = "%s aktiviert, 10min bis Berserker!",
	berserk_bar = "Berserker",

	enrage_trigger = "Die Nichteinhaltung wird zur Angriffshandlungen f\195\188hren.",
	enrage_message = "Kurator in Rage!",
	enrage_warning = "Kurator bald in Rage!",
} end )

L:RegisterTranslations("koKR", function() return {
	berserk = "광폭화",
	berserk_desc = "10분 후 광폭화 알림",

	enrage = "격노",
	enrage_desc = "체력 15% 시 격노 알림",

	weaken = "약화",
	weaken_desc = "약화된 상태인 동안 알림",

	weaktime = "약화 카운트다운",
	weaktime_desc = "다음 약화에 대한 바와 시간 카운트다운",

	weaken_trigger = "현재 요청하신 내용은 처리가 불가능합니다.",
	weaken_message = "환기 - 20초간 약화!",
	weaken_bar = "환기",
	weaken_fade_message = "환기 종료 - 약화 종료!",
	weaken_fade_warning = "5초 후 환기 종료!",

	weaktime_message1 = "약 10초 후 환기",
	weaktime_message2 = "약 30초 후 환기",
	weaktime_message3 = "약 70초 후 환기",
	weaktime_bar = "다음 환기",

	berserk_trigger = "박물관에는 초대받은 손님만 입장하실 수 있습니다.",
	berserk_message = "%s 전투 개시, 10분 후 광폭화!",
	berserk_bar = "광폭화",

	enrage_trigger = "규칙 위반으로 경보가 발동됐습니다.",
	enrage_message = "격노!",
	enrage_warning = "잠시 후 격노!",
} end )

----------------------------------
--   Module Declaration   --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"weaken", "weaktime", "berserk", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--     Event Handlers    --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["weaken_trigger"] then -- This Happens everytime an evocate happens
		if self.db.profile.weaken then
			self:Message(L["weaken_message"], "Important", nil, "Alarm")
			self:Bar(L["weaken_bar"], 20, "Spell_Nature_Purge")
			self:ScheduleEvent("weak1", "BigWigs_Message", 15, L["weaken_fade_warning"], "Urgent")
			self:ScheduleEvent("weak2", "BigWigs_Message", 20, L["weaken_fade_message"], "Important", nil, "Alarm")
		end
		if self.db.profile.weaktime then
			self:Bar(L["weaktime_bar"], 115, "Spell_Nature_Purge")
			self:ScheduleEvent("evoc1", "BigWigs_Message", 45, L["weaktime_message3"], "Positive")
			self:ScheduleEvent("evoc2", "BigWigs_Message", 85, L["weaktime_message2"], "Attention")
			self:ScheduleEvent("evoc3", "BigWigs_Message", 105, L["weaktime_message1"], "Urgent")
		end
	elseif msg == L["enrage_trigger"] then -- This only happens towards the end of the fight
		if self.db.profile.enrage then
			self:Message(L["enrage_message"], "Important")
		end
		self:CancelScheduledEvent("weak1")
		self:CancelScheduledEvent("weak2")
		self:CancelScheduledEvent("evoc1")
		self:CancelScheduledEvent("evoc2")
		self:CancelScheduledEvent("evoc3")
		self:TriggerEvent("BigWigs_StopBar", self, L["weaken_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["weaktime_bar"])
	elseif msg == L["berserk_trigger"] then -- This only happens at the start of the fight
		if self.db.profile.berserk then
			self:Message(L["berserk_message"]:format(boss), "Attention")
			self:Bar(L["berserk_bar"], 600, "INV_Shield_01")
		end
		if self.db.profile.weaktime then
			self:Bar(L["weaktime_bar"], 109, "Spell_Nature_Purge")
			self:ScheduleEvent("evoc1", "BigWigs_Message", 39, L["weaktime_message3"], "Positive")
			self:ScheduleEvent("evoc2", "BigWigs_Message", 79, L["weaktime_message2"], "Attention")
			self:ScheduleEvent("evoc3", "BigWigs_Message", 99, L["weaktime_message1"], "Urgent")
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.enrage then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 16 and health <= 19 and not enrageannounced then
			self:Message(L["enrage_warning"], "Positive")
			enrageannounced = true
		elseif health > 50 and enrageannounced then
			enrageannounced = false
		end
	end
end
