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

	["raidwarn"] = true,
	["broadcast"] = true,
	["whisper"] = true,
	["showwhispers"] = true,
	["useraidchannel"] = true,

	["Broadcast over RaidWarning"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting over Raidwarning."] = true,
	
	["Whisper"] = true,
	["Whisper warnings"] = true,
	["Toggle whispering warnings to players."] = true,
	
	["Show whispers"] = true,
	["Toggle showing whispers sent by BigWigs locally."] = true,

	["Use Raidchannel"] = true,
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = true,
	
	["Options for RaidWarning."] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	["RaidWarning"] = "공격대 경고",

	["Broadcast over RaidWarning"] = "공격대 경고로 알림",
	["Broadcast"] = "알림",
	["Toggle broadcasting over Raidwarning."] = "공격대 경고로 알림 토글",
	
	["Whisper"] = "귓속말",
	["Whisper warnings"] = "귓속말 경고",
	["Toggle whispering warnings to players."] = "플레이어에게 귓속말 경고 알림 토글",
	
	["Use Raidchannel"] = "공격대 채널 사용",
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = "공격대 경고 혹은 채널 사용 토글",
	
	["Options for RaidWarning."] = "공격대 경고 설정",
	
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队警报",

	["raidwarn"] = "团队警报",
	["broadcast"] = "广播",
	["whisper"] = "密语",
	["useraidchannel"] = "使用团队聊天",

	["Broadcast over RaidWarning"] = "通过团队警告频道发送信息",
	["Broadcast"] = "广播",
	["Toggle broadcasting over Raidwarning."] = "切换是否通过团队警告频道发送信息",
	
	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "切换是否通过密语向玩家发送信息",
	
	["Use Raidchannel"] = "使用团队聊天",
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = "切换是否使用团队聊天来代替团队警告频道来播放boss的信息",

	["Options for RaidWarning."] = "团队警告设置",
} end )


L:RegisterTranslations("zhTW", function() return {
	["RaidWarning"] = "團隊警報",

	["raidwarn"] = "團隊警報",
	["broadcast"] = "廣播",
	["whisper"] = "密語",
	["useraidchannel"] = "使用團隊聊天",

	["Broadcast over RaidWarning"] = "通過團隊警告頻道發送訊息",
	["Broadcast"] = "廣播",
	["Toggle broadcasting over Raidwarning."] = "切換是否通過團隊警告頻道發送訊息",
	
	["Whisper"] = "密語",
	["Whisper warnings"] = "密語警報",
	["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息",
	
	["Use Raidchannel"] = "使用團隊聊天",
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = "切換是否使用團隊聊天來代替團隊警告頻道來播放boss的訊息",

	["Options for RaidWarning."] = "團隊警告選項",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "RaidWarnung",

	--["raidwarn"] = "raidwarnen",
	--["broadcast"] = "verbreiten",
	--["whisper"] = "fl\195\188stern",
	--["useraidchannel"] = "raidchatbenutzen",

	["Broadcast over RaidWarning"] = "Verbreiten \195\188ber Sclachtzugswarnung",
	["Broadcast"] = "Verbreiten",
	["Toggle broadcasting over Raidwarning."] = "Meldungen \195\188ber Schlachtzugswarnung an Alle senden.",
	
	["Whisper"] = "Fl\195\188stern",
	["Whisper warnings"] = "Warnungen fl\195\188stern",
	["Toggle whispering warnings to players."] = "Warnungen an andere Spieler fl\195\188stern.",

	["Use Raidchannel"] = "Schlachtzugschat benutzen",
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = "Schlachtzugschat anstelle des Schlachtzugswarungschats für Boss Nachrichten benutzen.",
	
	["Options for RaidWarning."] = "Optionen f\195\188r RaidWarnung.",
} end )

L:RegisterTranslations("frFR", function() return {
	["RaidWarning"] = "Avertissement du raid",

	--["raidwarn"] = true,
	--["broadcast"] = true,
	--["whisper"] = true,
	--["showwhispers"] = true,
	--["useraidchannel"] = true,

	["Broadcast over RaidWarning"] = "Diffuser sur l'Avertissement Raid",
	["Broadcast"] = "Diffuser",
	["Toggle broadcasting over Raidwarning."] = "Diffuse ou non les messages sur l'Avertissement Raid.",

	["Whisper"] = "Chuchoter",
	["Whisper warnings"] = "Chuchoter les avertissements",
	["Toggle whispering warnings to players."] = "Chuchote ou non les avertissements aux joueurs.",

	["Show whispers"] = "Afficher les chuchotements",
	["Toggle showing whispers sent by BigWigs locally."] = "Affiche ou non localement les chuchotements envoy\195\169s par BigWigs.",

	["Use Raidchannel"] = "Utiliser le canal Raid",
	["Toggle using the raid channel instead of the raid warning channel for boss messages."] = "Utilise ou non le canal Raid au lieu de l'Avertissement Raid pour les messages des boss.",

	["Options for RaidWarning."] = "Options concernant l'Avertissement du Raid.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRaidWarn = BigWigs:NewModule(L["RaidWarning"], "AceHook-2.1")
BigWigsRaidWarn.defaultDB = {
	whisper = false,
	broadcast = false,
	useraidchannel = false,
	showwhispers = true,
}
BigWigsRaidWarn.consoleCmd = L["raidwarn"]
BigWigsRaidWarn.consoleOptions = {
	type = "group",
	name = L["RaidWarning"],
	desc = L["Options for RaidWarning."],
	args   = {
		[L["broadcast"]] = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting over Raidwarning."],
			get = function() return BigWigsRaidWarn.db.profile.broadcast end,
			set = function(v) BigWigsRaidWarn.db.profile.broadcast = v end,
		},
		[L["whisper"]] = {
			type = "toggle",
			name = L["Whisper"],
			desc = L["Toggle whispering warnings to players."],
			get = function() return BigWigsRaidWarn.db.profile.whisper end,
			set = function(v) BigWigsRaidWarn.db.profile.whisper = v end,
		},
		[L["showwhispers"]] = {
			type = "toggle",
			name = L["Show whispers"],
			desc = L["Toggle showing whispers sent by BigWigs locally."],
			get = function() return BigWigsRaidWarn.db.profile.showwhispers end,
			set = function(v) BigWigsRaidWarn.db.profile.showwhispers = v end,
		},
		[L["useraidchannel"]] = {
			type = "toggle",
			name = L["Use Raidchannel"],
			desc = L["Toggle using the raid channel instead of the raid warning channel for boss messages."],
			get = function() return BigWigsRaidWarn.db.profile.useraidchannel end,
			set = function(v) BigWigsRaidWarn.db.profile.useraidchannel = v end,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsRaidWarn:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_SendTell")

	sentWhispers = {}

	if ChatFrame_MessageEventHandler ~= nil and type(ChatFrame_MessageEventHandler) == "function" then
		self:Hook("ChatFrame_MessageEventHandler", "WhisperHandler", true)
	else
		self:Hook("ChatFrame_OnEvent", "WhisperHandler", true)
	end
end

function BigWigsRaidWarn:BigWigs_Message(msg, color, noraidsay)
	if not self.db.profile.broadcast or not msg or noraidsay or ( not IsRaidLeader() and not IsRaidOfficer() ) then
		return 
	end
	if self.db.profile.useraidchannel then
		SendChatMessage("*** "..msg.." ***", "RAID")
	else
		SendChatMessage("*** "..msg.." ***", "RAID_WARNING")
	end
end

function BigWigsRaidWarn:BigWigs_SendTell(player, msg)
	if not self.db.profile.whisper or not player or not msg or ( not IsRaidLeader() and not IsRaidOfficer() ) then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

function BigWigsRaidWarn:WhisperHandler(event)
	if not self.db.profile.showwhispers and sentWhispers[arg1] then
		self:Debug("Suppressing self-sent whisper.", event, arg1)
		return
	end

	if type(self.hooks["ChatFrame_OnEvent"]) == "function" then
		self.hooks["ChatFrame_OnEvent"](event)
	else
		return self.hooks["ChatFrame_MessageEventHandler"](event)
	end
end

