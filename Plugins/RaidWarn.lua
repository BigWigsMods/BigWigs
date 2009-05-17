----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("RaidWarning", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local sentWhispers = {}
local output = "*** %s ***"

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidWarn")
L:RegisterTranslations("enUS", function() return {
	["RaidWarning"] = true,

	["Broadcast over RaidWarning"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = true,

	["Whisper"] = true,
	["Whisper warnings"] = true,
	["Toggle whispering warnings to players."] = true,

	["Show whispers"] = true,
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = true,

	["Broadcast to chat"] = true,
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = true,

	desc = "Lets you configure where BigWigs should send its boss messages in addition to the local output.",
} end )

L:RegisterTranslations("koKR", function() return {
	["RaidWarning"] = "공격대경보",

	["Broadcast over RaidWarning"] = "공격대 경보로 알림",
	["Broadcast"] = "알림",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "공격대 경보 채널로 당신의 BigWigs 메세지를 알립니다.\n\n주의:만약 보스차단을 사용 중이라면 당신에게 메세지가 보이지 않을 수 있습니다.",

	["Whisper"] = "귓속말",
	["Whisper warnings"] = "귓속말 경보",
	["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경보 알림을 전환합니다.",

	["Show whispers"] = "귓속말 보기",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "BigWigs에 의한 귓속말 메세지를 표시합니다.",

	["Broadcast to chat"] = "대화로 알림",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "보스 메세지를 공격대 경보 채널 대신 파티 혹은 공격대 대화로 알림니다.\n\n주의 : 만약 보스차단을 사용 중이라면 당신에게 메세지가 보이지 않을 수 있습니다.",

	desc = "BigWigs가 보스 메세지를 출력할 곳을 설정하세요.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队通知",

	["Broadcast over RaidWarning"] = "通过团队通知（RW）发送警报信息。",
	["Broadcast"] = "广播（RW）",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "在 Raid 空闲时，通过团队警报频道发送您的 BigWigs 信息。\n\n备注：若你不想看到这些信息，只需禁用\"信息阻止\"。",

	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "通过密语向玩家发送信息。",

	["Show whispers"] = "显示密语",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "显示通过 BigWigs 发送的本地信息，举例来说当玩家中瘟疫或相似的警报信息。",

	["Broadcast to chat"] = "广播到聊天频道",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "通过广播 Boss 信息到每个队伍或者团队频道代替团队警告频道\n\n同样；若你不想看到这些信息，只需禁用\"信息阻止\"。",

	desc = "设置除本地输出之外的，BigWigs 发送的首领预警信息。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["RaidWarning"] = "團隊警報",

	["Broadcast over RaidWarning"] = "通過團隊警告頻道發送訊息",
	["Broadcast"] = "廣播",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "切換是否通過團隊警告頻道發送訊息",

	["Whisper"] = "密語",
	["Whisper warnings"] = "密語警報",
	["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息",

	["Show whispers"] = "顯示密語",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "切換是否顯示本地發送的警報密語，例如當玩家有溫疫時。",

	["Broadcast to chat"] = "使用團隊聊天",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "切換是否使用團隊聊天來代替團隊警告頻道來廣播首領的訊息",

	desc = "團隊警告選項",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "Raidwarnung",

	["Broadcast over RaidWarning"] = "Verbreiten als Schlachtzugswarnung",
	["Broadcast"] = "Verbreiten",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Big Wigs Nachrichten als Schlachtzugswarnung an alle senden.\n\nBeachte, dass du diese Warnungen selbst nicht sehen wirst, außer du hast die entsprechende BossBlock Option deaktiviert.",

	["Whisper"] = "Flüstern",
	["Whisper warnings"] = "Warnungen flüstern",
	["Toggle whispering warnings to players."] = "Warnungen an andere Spieler flüstern.",

	["Show whispers"] = "Zeige Flüstern",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Aktiviert das lokale Anzeigen von geflüsterten Nachrichten, zum Beispiel wenn Spieler Dinge wie eine Seuche oder Ähnliches haben.",

	["Broadcast to chat"] = "Schlachtzugschat",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Benutzt den Schlachtzugschat anstelle des Schlachtzugswarnungschats für Boss-Nachrichten.\n\nBeachte, dass du diese Warnungen selbst nicht sehen wirst, außer du hast die entsprechende BossBlock Option deaktiviert.",

	desc = "Bestimmt, wie Big Wigs die Boss-Nachrichten (zusätzlich zur lokalen Anzeige) an andere Spieler verschickt.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "Avertissement du raid",

	["Broadcast over RaidWarning"] = "Diffuser sur l'Avertissement raid",
	["Broadcast"] = "Diffuser",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Diffuse ou non vos messages BigWigs sur l'Avertissement Raid.\n\nNotez que vous ne verrez pas les messages que vous diffusez sauf si vous avez désactivé Bloquer BossMods.",

	["Whisper"] = "Chuchoter",
	["Whisper warnings"] = "Chuchoter les avertissements",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	["Show whispers"] = "Afficher les chuchotements",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Affiche ou non localement les chuchotements envoyés par BigWigs, par exemple quand les joueurs sont affectés par des choses telles que la peste ou similaire.",

	["Broadcast to chat"] = "Diffuser sur le canal",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Diffuse ou non les messages soit sur le canal Groupe, soit sur le canal Raid au lieu de l'Avertissement Raid.\n\nMême chose ici : vous ne verrez pas vos propres messages à moins que Bloquer BossMods ne soit désactivé.",

	desc = "Vous permet de déterminer où BigWigs doit envoyer ses messages en plus de ses messages locaux.",
} end )

L:RegisterTranslations("esES", function() return {
	["RaidWarning"] = "Aviso de banda",

	["Broadcast over RaidWarning"] = "Emitir en Aviso de Banda",
	["Broadcast"] = "Emitir en Aviso de banda",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Activa la emisión de tus mensajes BigWigs a través del canal de Aviso de banda para el resto de la banda.\n\nTen en cuenta que no verás estos mensajes si tienes activado el plugin de Ocultar mensajes.",

	["Whisper"] = "Susurrar",
	["Whisper warnings"] = "Susurrar avisos",
	["Toggle whispering warnings to players."] = "Activa el susurro de avisos a los jugadores.",

	["Show whispers"] = "Mostrar susurros",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Ativa el mostrar los susurros que manda BigWigs localmente, por ejemplo cuando los jugadores tienen la plaga y similares.",

	["Broadcast to chat"] = "Emitir en chat",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Activa la emisión de mensajes en el chat de grupo o banda en lugar de en Aviso de banda para mensajes de Jefes.\n\nTen en cuenta que no verás estos mensajes si tienes activado el plugin de Ocultar mensajes.",

	desc = "Te permite configurar dónde enviará BigWigs los mensajes de jefes además de en local.",
} end )
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["RaidWarning"] = "Объявление рейду",

	["Broadcast over RaidWarning"] = "Передача через объявление рейду",
	["Broadcast"] = "Передача",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Вкл/Выкл передачу сообщений вашего BigWigsа в канал объявлений рейда остальным игрокам рейда.\n\nЗаметьте что вы не увидите этих предупреждений если у вас будет включен БлокБосс.",

	["Whisper"] = "Шептание",
	["Whisper warnings"] = "Предупреждать шепотом",
	["Toggle whispering warnings to players."] = "Вкл/Выкл шептание предупреждений игрокам.",

	["Show whispers"] = "Показывать шепот",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Вкл/Выкл отображение шептаний посланных локально BigWigs'ом, например когда у игроков чума или подобные отрицательные эффекты.",

	["Broadcast to chat"] = "Передача в чат",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Вкл/Выкл передачу сообщений в чат группы или рейда вместо Объявлений рейду о действиях боссов.\n\nЗаметьте что вы не увидите этих предупреждений если у вас будет включен БлокБосс.",

	desc = "Позволяет настроить куда BigWigs будет передовать предупреждения о действиях босса в дополнении с локальным выводом.",
} end )

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	whisper = false,
	broadcast = false,
	useraidchannel = false,
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
		broadcast = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."],
		},
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
		useraidchannel = {
			type = "toggle",
			name = L["Broadcast to chat"],
			desc = L["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."],
			disabled = function() return plugin.db.profile.broadcast end,
		},
	}
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
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_SendTell")
	
	sentWhispers = wipe(sentWhispers)
end

function plugin:BigWigs_Message(msg, color, noraidsay)
	if not msg or noraidsay or not self.db.profile.broadcast then return end

	local inRaid = UnitInRaid("player")
	-- In a 5-man group, everyone can use the raid warning channel.
	if inRaid and not IsRaidLeader() and not IsRaidOfficer() then
		return
	elseif GetNumPartyMembers() == 0 and not inRaid then
		return
	end

	local clean = msg:gsub("(|c%x%x%x%x%x%x%x%x)", ""):gsub("(|r)", "")
	local o = output:format(clean)
	if self.db.profile.useraidchannel then
		SendChatMessage(o, inRaid and "RAID" or "PARTY")
	else
		SendChatMessage(o, "RAID_WARNING")
	end
end

function plugin:BigWigs_SendTell(player, msg)
	if not self.db.profile.whisper or not player or not msg then return end
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

