----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("RaidWarning", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local sentWhispers = {}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidWarn")
L:RegisterTranslations("enUS", function() return {
	["RaidWarning"] = true,

	["Whisper"] = true,
	["Toggle whispering warnings to players."] = true,

	["Show whispers"] = true,
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = true,

	desc = "Lets you configure where BigWigs should send its boss messages in addition to the local output.",
} end )

L:RegisterTranslations("koKR", function() return {
	["RaidWarning"] = "공격대경보",

	["Whisper"] = "귓속말",
	["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경보 알림을 전환합니다.",

	["Show whispers"] = "귓속말 보기",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "BigWigs에 의한 귓속말 메세지를 표시합니다.",

	desc = "BigWigs가 보스 메세지를 출력할 곳을 설정하세요.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队通知",

	["Whisper"] = "密语",
	["Toggle whispering warnings to players."] = "通过密语向玩家发送信息。",

	["Show whispers"] = "显示密语",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "显示通过 BigWigs 发送的本地信息，举例来说当玩家中瘟疫或相似的警报信息。",

	desc = "设置除本地输出之外的，BigWigs 发送的首领预警信息。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["RaidWarning"] = "團隊警報",

	["Whisper"] = "密語",
	["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息",

	["Show whispers"] = "顯示密語",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "切換是否顯示本地發送的警報密語，例如當玩家有溫疫時。",

	desc = "團隊警告選項",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "Raidwarnung",

	["Whisper"] = "Flüstern",
	["Toggle whispering warnings to players."] = "Warnungen an andere Spieler flüstern.",

	["Show whispers"] = "Zeige Flüstern",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Aktiviert das lokale Anzeigen von geflüsterten Nachrichten, zum Beispiel wenn Spieler Dinge wie eine Seuche oder Ähnliches haben.",

	desc = "Bestimmt, wie Big Wigs die Boss-Nachrichten (zusätzlich zur lokalen Anzeige) an andere Spieler verschickt.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "Avertissement du raid",

	["Whisper"] = "Chuchoter",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	["Show whispers"] = "Afficher les chuchotements",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Affiche ou non localement les chuchotements envoyés par BigWigs, par exemple quand les joueurs sont affectés par des choses telles que la peste ou similaire.",

	desc = "Vous permet de déterminer où BigWigs doit envoyer ses messages en plus de ses messages locaux.",
} end )

L:RegisterTranslations("esES", function() return {
	["RaidWarning"] = "Aviso de banda",

	["Whisper"] = "Susurrar",
	["Toggle whispering warnings to players."] = "Activa el susurro de avisos a los jugadores.",

	["Show whispers"] = "Mostrar susurros",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Ativa el mostrar los susurros que manda BigWigs localmente, por ejemplo cuando los jugadores tienen la plaga y similares.",

	desc = "Te permite configurar dónde enviará BigWigs los mensajes de jefes además de en local.",
} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["RaidWarning"] = "Объявление рейду",

	["Whisper"] = "Шептание",
	["Toggle whispering warnings to players."] = "Вкл/Выкл шептание предупреждений игрокам.",

	["Show whispers"] = "Показывать шепот",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Вкл/Выкл отображение шептаний посланных локально BigWigs'ом, например когда у игроков чума или подобные отрицательные эффекты.",

	desc = "Позволяет настроить куда BigWigs будет передовать предупреждения о действиях босса в дополнении с локальным выводом.",
} end )

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	whisper = false,
	showwhispers = true,
}
plugin.consoleCmd = L["RaidWarning"]
plugin.advancedOptions = {
	type = "group",
	name = L["RaidWarning"],
	desc = L["desc"],
	pass = true,
	get = function(key) return plugin.db.profile[key] end,
	set = function(key, value) plugin.db.profile[key] = value end,
	args = {
		whisper = {
			type = "toggle",
			name = L["Whisper"],
			desc = L["Toggle whispering warnings to players."],
		},
		showwhispers = {
			type = "toggle",
			name = L["Show whispers"],
			desc = L["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."],
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

local function filter(self, event, msg)
	if not plugin.db.profile.showwhispers and sentWhispers[msg] then return true end
end

function plugin:OnRegister()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
end

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_SendTell")
	sentWhispers = wipe(sentWhispers)
end

function plugin:BigWigs_SendTell(player, msg)
	if not self.db.profile.whisper or not player or not msg then return end
	if not UnitIsPlayer(player) then return end
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

