assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidWarn")
local sentWhispers = nil

local UnitInRaid = UnitInRaid
local IsRaidLeader = IsRaidLeader
local IsRaidOfficer = IsRaidOfficer
local SendChatMessage = SendChatMessage
local GetNumPartyMembers = GetNumPartyMembers

----------------------------
--      Localization      --
----------------------------

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

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队通知",

	["Broadcast over RaidWarning"] = "通过团队通知(RW)发送警报信息。",
	["Broadcast"] = "广播(RW)",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "在Raid空闲时,通过团队警报频道发送您的BigWigs信息。\n\n备注:若你不想看到这些信息,只需禁用\"信息阻止\".",

	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "通过密语向玩家发送信息",

	["Show whispers"] = "显示密语",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "显示通过BigWigs发送的本地信息, 举例来说当玩家中瘟疫或相似的警报信息.",

	["Broadcast to chat"] = "广播到聊天框",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "通过广播BOSS信息到每个队伍或者团队频道代替团队警告频道\n\n同样;若你不想看到这些信息,只需禁用\"信息阻止\"",

	desc = "设置除本地输出之外的,BigWigs发送的BOSS预警信息.",
} end )
L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队警报",

	["Broadcast over RaidWarning"] = "通过团队警告频道发送信息",
	["Broadcast"] = "广播",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "切换是否通过团队警告频道发送信息",

	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "切换是否通过密语向玩家发送信息",

	["Broadcast to chat"] = "使用团队聊天",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "切换是否使用团队聊天来代替团队警告频道来播放boss的信息",

	desc = "团队警告设置",
} end )

L:RegisterTranslations("zhTW", function() return {
	["RaidWarning"] = "團隊警報",

	["Broadcast over RaidWarning"] = "通過團隊警告頻道發送訊息",
	["Broadcast"] = "廣播",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "切換是否通過團隊警告頻道發送訊息",

	["Whisper"] = "密語",
	["Whisper warnings"] = "密語警報",
	["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息",

	["Broadcast to chat"] = "使用團隊聊天",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "切換是否使用團隊聊天來代替團隊警告頻道來播放boss的訊息",

	desc = "團隊警告選項",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "RaidWarnung",

	["Broadcast over RaidWarning"] = "Verbreiten \195\188ber Sclachtzugswarnung",
	["Broadcast"] = "Verbreiten",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Meldungen \195\188ber Schlachtzugswarnung an Alle senden.",

	["Whisper"] = "Fl\195\188stern",
	["Whisper warnings"] = "Warnungen fl\195\188stern",
	["Toggle whispering warnings to players."] = "Warnungen an andere Spieler fl\195\188stern.",

	["Broadcast to chat"] = "Schlachtzugschat benutzen",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Schlachtzugschat anstelle des Schlachtzugswarungschats für Boss Nachrichten benutzen.",

	desc = "Optionen f\195\188r RaidWarnung.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "AvertissementRaid",

	["Broadcast over RaidWarning"] = "Diffuser sur l'Avertissement Raid",
	["Broadcast"] = "Diffuser",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Diffuse ou non les messages sur l'Avertissement Raid.\n\nNotez que vous ne verrez pas ces messages diffusés vous-même sauf si vous avez désactivé BossBlock.",

	["Whisper"] = "Chuchoter",
	["Whisper warnings"] = "Chuchoter les avertissements",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	["Show whispers"] = "Afficher les chuchotements",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Affiche ou non localement les chuchotements envoyés par BigWigs, par exemple quand les joueurs sont affectés par des choses telles que la peste ou similaire.",

	["Broadcast to chat"] = "Diffuser sur le canal",
	["Toggle broadcasting messages to either party or raid chat instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Diffuse ou non les messages soit sur le canal Groupe, soit sur le canal Raid au lieu de l'Avertissement Raid pour les messages des boss.\n\nMême chose ici ; vous ne verrez pas vos propres messages à moins que BossBlock ne soit désactivé.",

	desc = "Vous permet de déterminer où BigWigs doit envoyer ses messages en plus de ses messages locaux.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("RaidWarning", "AceHook-2.1")
plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.defaultDB = {
	whisper = false,
	broadcast = false,
	useraidchannel = false,
	showwhispers = true,
}
plugin.consoleCmd = L["RaidWarning"]
plugin.consoleOptions = {
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
			disabled = function() return plugin.db.profile.useraidchannel end,
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
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_SendTell")

	sentWhispers = {}

	self:Hook("ChatFrame_MessageEventHandler", "WhisperHandler", true)
end

function plugin:BigWigs_Message(msg, color, noraidsay)
	if not self.db.profile.broadcast or not msg or noraidsay then
		return
	end
	-- In a 5-man group, everyone can use the raid warning channel.
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then
		return
	elseif GetNumPartyMembers() == 0 and not UnitInRaid("player") then
		return
	end
	if self.db.profile.useraidchannel then
		if UnitInRaid("player") then
			SendChatMessage("*** "..msg.." ***", "RAID")
		else
			SendChatMessage("*** "..msg.." ***", "PARTY")
		end
	else
		SendChatMessage("*** "..msg.." ***", "RAID_WARNING")
	end
end

function plugin:BigWigs_SendTell(player, msg)
	if not self.db.profile.whisper or not player or not msg then return end
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

function plugin:WhisperHandler(event)
	if not self.db.profile.showwhispers and sentWhispers[arg1] then
		BigWigs:Debug("Suppressing self-sent whisper.", event, arg1)
		return
	end
	return self.hooks["ChatFrame_MessageEventHandler"](event)
end

