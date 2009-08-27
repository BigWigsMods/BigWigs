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

	desc = "Lets you configure where BigWigs should send its boss messages in addition to the local output.",
} end )

L:RegisterTranslations("koKR", function() return {
	["RaidWarning"] = "공격대경보",

	["Whisper"] = "귓속말",
	["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경보 알림을 전환합니다.",

	desc = "BigWigs가 보스 메세지를 출력할 곳을 설정하세요.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队通知",

	["Whisper"] = "密语",
	["Toggle whispering warnings to players."] = "通过密语向玩家发送信息。",

	desc = "设置除本地输出之外的，BigWigs 发送的首领预警信息。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["RaidWarning"] = "團隊警報",

	["Whisper"] = "密語",
	["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息",

	desc = "團隊警告選項",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "Raidwarnung",

	["Whisper"] = "Flüstern",
	["Toggle whispering warnings to players."] = "Warnungen an andere Spieler flüstern.",

	desc = "Bestimmt, wie Big Wigs die Boss-Nachrichten (zusätzlich zur lokalen Anzeige) an andere Spieler verschickt.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "Avertissement du raid",

	["Whisper"] = "Chuchoter",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	desc = "Vous permet de déterminer où BigWigs doit envoyer ses messages en plus de ses messages locaux.",
} end )

L:RegisterTranslations("esES", function() return {
	["RaidWarning"] = "Aviso de banda",

	["Whisper"] = "Susurrar",
	["Toggle whispering warnings to players."] = "Activa el susurro de avisos a los jugadores.",

	desc = "Te permite configurar dónde enviará BigWigs los mensajes de jefes además de en local.",
} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["RaidWarning"] = "Объявление рейду",

	["Whisper"] = "Шептание",
	["Toggle whispering warnings to players."] = "Вкл/Выкл шептание предупреждений игрокам.",

	desc = "Позволяет настроить куда BigWigs будет передовать предупреждения о действиях босса в дополнении с локальным выводом.",
} end )

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	whisper = true,
}
plugin.consoleCmd = L["RaidWarning"]
plugin.advancedOptions = {
	type = "group",
	name = L["RaidWarning"],
	desc = L["desc"],
	args = {
		whisper = {
			type = "toggle",
			name = L["Whisper"],
			desc = L["Toggle whispering warnings to players."],
			get = function() return plugin.db.profile.whisper end,
			set = function(v) plugin.db.profile.whisper = v end,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

local function filter(self, event, msg) if sentWhispers[msg] then return true end end
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

