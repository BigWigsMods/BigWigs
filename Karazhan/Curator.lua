------------------------------
--      Are you local?      --
------------------------------

local boss = BB["The Curator"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local enrageWarn = nil
local CheckInteractDistance = CheckInteractDistance

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Curator",

	berserk_trigger = "The Menagerie is for guests only.",

	enrage_trigger = "Failure to comply will result in offensive action.",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage soon!",

	weaken = "Weaken",
	weaken_desc = "Warn for weakened state.",
	weaken_trigger = "Your request cannot be processed.",
	weaken_message = "Evocation - Weakened for 20sec!",
	weaken_bar = "Evocation",
	weaken_fade_message = "Evocation Finished - Weakened Gone!",
	weaken_fade_warning = "Evocation over in 5sec!",

	weaktime = "Weaken Countdown",
	weaktime_desc = "Countdown warning and bar until next weaken.",
	weaktime_message1 = "Evocation in ~10 seconds",
	weaktime_message2 = "Evocation in ~30 seconds",
	weaktime_message3 = "Evocation in ~70 seconds",
	weaktime_bar = "~Evocation Cooldown",
} end )

L:RegisterTranslations("frFR", function() return {
	berserk_trigger = "L'accès à la Ménagerie est réservé aux invités.",

	enrage_trigger = "Toute désobéissance entraînera une action offensive.",
	enrage_message = "Enragé !",
	enrage_warning = "Bientôt enragé !",

	weaken = "Affaiblissement",
	weaken_desc = "Préviens quand le Conservateur est affaibli.",
	weaken_trigger = "Impossible de traiter votre requête.",
	weaken_message = "Evocation - Affaibli pendant 20 sec. !",
	weaken_bar = "Evocation",
	weaken_fade_message = "Evocation terminée - Fin de l'Affaiblissement !",
	weaken_fade_warning = "Evocation terminée dans 5 sec. !",

	weaktime = "Compte à rebours Affaiblissement",
	weaktime_desc = "Affiche des avertissements et une barre temporelle indiquant le prochain Affaiblissement.",
	weaktime_message1 = "Evocation dans ~10 sec.",
	weaktime_message2 = "Evocation dans ~30 sec.",
	weaktime_message3 = "Evocation dans ~70 sec.",
	weaktime_bar = "~Cooldown Evocation",
} end )

L:RegisterTranslations("deDE", function() return {
	berserk_trigger = "Die Menagerie ist nur f\195\188r G\195\164ste.",

	enrage_trigger = "Die Nichteinhaltung wird zur Angriffshandlungen f\195\188hren.",
	enrage_message = "Kurator in Rage!",
	enrage_warning = "Kurator bald in Rage!",

	weaken = "Schw\195\164chung",
	weaken_desc = "Warnung f\195\188r den geschw\195\164chten Zustand",
	weaken_trigger = "Ihre Anfrage kann nicht bearbeitet werden.",
	weaken_message = "Hervorrufung f\195\188r 20 sekunden!",
	weaken_bar = "Hervorrufung",
	weaken_fade_message = "Hervorrufung beendet - Kurator nicht mehr geschw\195\164cht!",
	weaken_fade_warning = "Hervorrufung in 5 sekunden beendet!",

	weaktime = "Schw\195\164chungs Timer",
	weaktime_desc = "Timer und Anzeige f\195\188r die n\195\164chste Schw\195\164chung.",
	weaktime_message1 = "Hervorrufung in ~10 sekunden",
	weaktime_message2 = "Hervorrufung in ~30 sekunden",
	weaktime_message3 = "Hervorrufung in ~70 sekunden",
	weaktime_bar = "N\195\164chste Hervorrufung",
} end )

L:RegisterTranslations("koKR", function() return {
	berserk_trigger = "박물관에는 초대받은 손님만 입장하실 수 있습니다.",

	enrage_trigger = "규칙 위반으로 경보가 발동됐습니다.",
	enrage_message = "격노!",
	enrage_warning = "잠시 후 격노!",

	weaken = "약화",
	weaken_desc = "약화된 상태인 동안 알립니다.",
	weaken_trigger = "현재 요청하신 내용은 처리가 불가능합니다.",
	weaken_message = "환기 - 20초간 약화!",
	weaken_bar = "환기",
	weaken_fade_message = "환기 종료 - 약화 종료!",
	weaken_fade_warning = "5초 후 환기 종료!",

	weaktime = "약화 카운트다운",
	weaktime_desc = "다음 약화에 대한 바와 시간을 카운트다운 합니다.",
	weaktime_message1 = "약 10초 후 환기",
	weaktime_message2 = "약 30초 후 환기",
	weaktime_message3 = "약 70초 후 환기",
	weaktime_bar = "~환기 대기시간",
} end )

L:RegisterTranslations("zhCN", function() return {
	berserk_trigger = "展览厅只对访客开放。",

	enrage_trigger = "不合作将导致攻击行动。",
	enrage_message = "狂暴！",
	enrage_warning = "馆长将进入狂暴！",

	weaken = "唤醒",
	weaken_desc = "当馆长进入唤醒时发送警告。",
	weaken_trigger = "你的请求未能得到批准。",
	weaken_message = "唤醒 - 20秒虚弱计时开始",
	weaken_bar = "<唤醒>",
	weaken_fade_message = "唤醒结束 - 准备击杀小电球！",
	weaken_fade_warning = "5秒后 唤醒 结束！",

	weaktime = "虚弱提示",
	weaktime_desc = "显示计时条预计下一次虚弱的时间。",
	weaktime_message1 = "唤醒  大约10秒后",
	weaktime_message2 = "唤醒  大约30秒后",
	weaktime_message3 = "唤醒  大约70秒后",
	weaktime_bar = "<虚弱>",
} end )

L:RegisterTranslations("zhTW", function() return {
	berserk_trigger = "展示廳是賓客專屬的。",

	enrage_trigger = "不順從就會招致攻擊性的行動。",
	enrage_message = "狂暴",
	enrage_warning = "館長即將進入狂暴狀態",

	weaken = "喚醒提示",
	weaken_desc = "當館長進入喚醒時發送警告",
	weaken_trigger = "無法處理你的要求。",
	weaken_message = "喚醒 - 20 秒虛弱時間開始",
	weaken_bar = "喚醒",
	weaken_fade_message = "喚醒結束 - 準備擊殺小電球",
	weaken_fade_warning = "喚醒將於 5 秒後結束",

	weaktime = "虛弱提示",
	weaktime_desc = "顯示計時條預測下一次虛弱時間",
	weaktime_message1 = "10 秒後館長進入喚醒狀態",
	weaktime_message2 = "30 秒後館長進入喚醒狀態",
	weaktime_message3 = "70 秒後館長進入喚醒狀態",
	weaktime_bar = "虛弱",
} end )

L:RegisterTranslations("esES", function() return {
	berserk_trigger = "La Sala de los Animales es solo para invitados.",

	enrage_trigger = "Su no cumplimiento resultará en una acción ofensiva.",
	enrage_message = "Enfurecido!",
	enrage_warning = "Efurecimiento pronto!",

	weaken = "Debilidad",
	weaken_desc = "Aviso del estado de debilidad.",
	weaken_trigger = "Su solicitud no puede ser procesada.",
	weaken_message = "Evocacion - Debilidad durante 20sec!",
	weaken_bar = "Evocacion",
	weaken_fade_message = "Evocacion Finalizada - Debilidad desaparecida!",
	weaken_fade_warning = "Evocacion en unos 5sec!",

	weaktime = "Cuenta atras de Debilidad",
	weaktime_desc = "Barra de cuenta atras hasta la proxima debilidad.",
	weaktime_message1 = "Evocacion en ~10 segundos",
	weaktime_message2 = "Evocacion en ~30 segundos",
	weaktime_message3 = "Evocacion en ~70 segundos",
	weaktime_bar = "~Enfriamiento de Evocacion",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"weaken", "weaktime", "berserk", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
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
		enrageWarn = nil
		self:TriggerEvent("BigWigs_ShowProximity", self)

		if self.db.profile.berserk then
			self:Enrage(600, true)
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
		if health > 16 and health <= 19 and not enrageWarn then
			self:Message(L["enrage_warning"], "Positive")
			enrageWarn = true
		elseif health > 50 and enrageWarn then
			enrageWarn = false
		end
	end
end
