assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidWarn")
local sentWhispers = nil

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

	["Use Raidchannel"] = true,
	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = true,

	desc = "Lets you configure where BigWigs should send its boss messages in addition to the local output.",
} end )

L:RegisterTranslations("koKR", function() return {
	["RaidWarning"] = "공격대경보",

	["Broadcast over RaidWarning"] = "공격대 경보로 알림",
	["Broadcast"] = "알림",
--	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = true,

	["Whisper"] = "귓속말",
	["Whisper warnings"] = "귓속말 경보",
	["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경보 알림을 전환합니다.",

	["Show whispers"] = "귓속말 보기",
--	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = true,

	["Use Raidchannel"] = "공격대 채널 사용",
--	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = true,

	desc = "Lets you configure where BigWigs should send its boss messages in addition to the local output.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队警报",

	["Broadcast over RaidWarning"] = "通过团队警告频道发送信息",
	["Broadcast"] = "广播",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "切换是否通过团队警告频道发送信息",

	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "切换是否通过密语向玩家发送信息",

	["Use Raidchannel"] = "使用团队聊天",
	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "切换是否使用团队聊天来代替团队警告频道来播放boss的信息",

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

	["Use Raidchannel"] = "使用團隊聊天",
	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "切換是否使用團隊聊天來代替團隊警告頻道來播放boss的訊息",

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

	["Use Raidchannel"] = "Schlachtzugschat benutzen",
	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Schlachtzugschat anstelle des Schlachtzugswarungschats für Boss Nachrichten benutzen.",

	desc = "Optionen f\195\188r RaidWarnung.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "AvertissementRaid",

	["Broadcast over RaidWarning"] = "Diffuser sur l'Avertissement Raid",
	["Broadcast"] = "Diffuser",
	["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."] = "Diffuse ou non les messages sur l'Avertissement Raid.",

	["Whisper"] = "Chuchoter",
	["Whisper warnings"] = "Chuchoter les avertissements",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	["Show whispers"] = "Afficher les chuchotements",
	["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."] = "Affiche ou non localement les chuchotements envoy\195\169s par BigWigs.",

	["Use Raidchannel"] = "Utiliser le canal Raid",
	["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."] = "Utilise ou non le canal Raid au lieu de l'Avertissement Raid pour les messages des boss.",

	desc = "Options concernant l'Avertissement du Raid.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("RaidWarning", "AceHook-2.1")
plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
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
		["broadcast"] = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting your BigWigs messages over the raid warning channel to the rest of the raid.\n\nNote that you will not see these broadcasts yourself unless you've disabled BossBlock."],
		},
		["whisper"] = {
			type = "toggle",
			name = L["Whisper"],
			desc = L["Toggle whispering warnings to players."],
		},
		["showwhispers"] = {
			type = "toggle",
			name = L["Show whispers"],
			desc = L["Toggle showing whispers sent by BigWigs locally, for example when players have things like the plague and similar."],
		},
		["useraidchannel"] = {
			type = "toggle",
			name = L["Use Raidchannel"],
			desc = L["Toggle using the raid channel instead of the raid warning channel for boss messages.\n\nSame thing here; you will not see your own messages unless BossBlock is disabled."],
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
	if not self.db.profile.broadcast or not msg or noraidsay or ( not IsRaidLeader() and not IsRaidOfficer() ) then
		return 
	end
	if self.db.profile.useraidchannel then
		SendChatMessage("*** "..msg.." ***", "RAID")
	else
		SendChatMessage("*** "..msg.." ***", "RAID_WARNING")
	end
end

function plugin:BigWigs_SendTell(player, msg)
	if not self.db.profile.whisper or not player or not msg or ( not IsRaidLeader() and not IsRaidOfficer() ) then return end
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

