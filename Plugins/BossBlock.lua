
----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsBossBlock")

L:RegisterTranslations("enUS", function() return {
	["BossBlock"] = true,
	["Suppress bossmod chat from other players."] = true,

	["Suppress Raid Chat"] = true,
	["Suppress messages in the raid channel."] = true,

	["Suppress RaidWarn Chat"] = true,
	["Suppress RaidWarn messages in the chat frames."] = true,

	["Suppress RaidWarn"] = true,
	["Suppress RaidWarn popup messages."] = true,

	["Suppress RaidSay"] = true,
	["Suppress CTRA RaidSay popup messages."] = true,
	["Suppress oRA RaidSay popup messages."] = true,
	["Suppress oRA2 RaidSay popup messages."] = true,

	["Suppress Tells"] = true,
	["Suppress Tell messages."] = true,

	["Debugging"] = true,
	["Show debug messages."] = true,

	["Suppressing Chatframe"] = true,
	["Suppressing RaidWarningFrame"] = true,
	["Suppressing CT_RAMessageFrame"] = true,

	["Suppressed"] = true,
	["Shown"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["BossBlock"] = "보스차단",
	["Suppress bossmod chat from other players."] = "타인의 보스모드 대화 차단.",
	
	["Suppress Raid Chat"] = "공격대 대화 차단",
	["Suppress messages in the raid channel."] = "공격대 채널에 메세지 차단.",
	
	["Suppress RaidWarn Chat"] = "공격대경고 대화 차단",
	["Suppress RaidWarn messages in the chat frames."] = "대화창에 공격대경고 메세지 차단",
	
	["Suppress RaidWarn"] = "공격대경고 차단",
	["Suppress RaidWarn popup messages."] = "공격대경고 알림 메세지 차단",
	
	["Suppress RaidSay"] = "RaidSay 차단",
	["Suppress CTRA RaidSay popup messages."] = "CTRA RaidSay 알림 메세지 차단",
	["Suppress oRA RaidSay popup messages."] = "oRA RaidSay 알림 메세지 차단",
	["Suppress oRA2 RaidSay popup messages."] = "oRA2 RaidSay 알림 메세지 차단",
	
	["Suppress Tells"] = "일반대화 차단",
	["Suppress Tell messages."] = "일반대화 메세지 차단",
	
	["Debugging"] = "디버깅",
	["Show debug messages."] = "디버그 메세지 표시",
	
	["Suppressing Chatframe"] = "대화창 차단됨",
	["Suppressing RaidWarningFrame"] = "공격대경고창 차단됨",
	["Suppressing CT_RAMessageFrame"] = "CR_RA메세지창 차단됨",
	
	["Suppressed"] = "차단됨",
	["Shown"] = "표시함",

} end)

L:RegisterTranslations("zhCN", function() return {
	["BossBlock"] = "信息阻挡",
	["Suppress bossmod chat from other players."] = "阻挡其他玩家的首领插件发送的信息。",

	["Suppress Raid Chat"] = "阻挡团队频道",
	["Suppress messages in the raid channel."] = "阻挡团队频道中的信息",

	["Suppress RaidWarn Chat"] = "阻挡团队警告聊天",
	["Suppress RaidWarn messages in the chat frames."] = "阻挡聊天窗体中的团队警告信息",

	["Suppress RaidWarn"] = "阻挡团队警告",
	["Suppress RaidWarn popup messages."] = "阻挡团队警告中的信息",

	["Suppress RaidSay"] = "阻挡RS",
	["Suppress CTRA RaidSay popup messages."] = "阻挡团队助手(CTRA)的RS信息",

	["Suppress Tells"] = "阻挡密语",
	["Suppress Tell messages."] = "阻挡密语中的信息",

	["Debugging"] = "除错",
	["Show debug messages."] = "显示除错信息",

	["Suppressing Chatframe"] = "正在阻挡Chatframe",
	["Suppressing RaidWarningFrame"] = "正在阻挡RaidWarningFrame",
	["Suppressing CT_RAMessageFrame"] = "正在阻挡CT_RAMessageFrame",

	["Suppressed"] = "阻挡",
	["Shown"] = "显示",
} end)


L:RegisterTranslations("deDE", function() return {
	["BossBlock"] = "BossBlock",
	["Suppress bossmod chat from other players."] = "Unterdr\195\188cke Bossmod Chat von anderen Spielern.",

	["Suppress Raid Chat"] = "Unterdr\195\188cke Raid Chat",
	["Suppress messages in the raid channel."] = "Unterdr\195\188cke Nachrichten im Raid Channel",

	["Suppress RaidWarn Chat"] = "Unterdr\195\188cke RaidWarn Chat",
	["Suppress RaidWarn messages in the chat frames."] = "Unterdr\195\188cke RaidWarn Nachrichten im Chat Fenster.",

	["Suppress RaidWarn"] = "Unterdr\195\188cke RaidWarn",
	["Suppress RaidWarn popup messages."] = "Unterdr\195\188cke RaidWarn Popup Nachrichten.",

	["Suppress RaidSay"] = "Unterdr\195\188cke RaidSay",
	["Suppress CTRA RaidSay popup messages."] = "Unterdr\195\188cke CTRA RaidSay Popup Nachrichten.",
	["Suppress oRA RaidSay popup messages."] = "Unterdr\195\188cke oRA RaidSay Popup Nachrichten.",

	["Suppress Tells"] = "Unterdr\195\188cke Fl\195\188stern",
	["Suppress Tell messages."] = "Unterdr\195\188cke Fl\195\188stern Nachrichten.",

	["Debugging"] = "Debugging",
	["Show debug messages."] = "Zeige Debug Nachrichten.",

	["Suppressing Chatframe"] = "Unterdr\195\188cke Chatframe",
	["Suppressing RaidWarningFrame"] = "Unterdr\195\188cke RaidWarningFrame",
	["Suppressing CT_RAMessageFrame"] = "Unterdr\195\188cke CT_RAMessageFrame",

	["Suppressed"] = "Unterdr\195\188ckt",
	["Shown"] = "Angezeigt",
} end)

------------------------------
--      Are you local?      --
------------------------------

local raidchans = {
	CHAT_MSG_WHISPER = "hidetells",
	CHAT_MSG_RAID = "hideraidchat",
	CHAT_MSG_RAID_WARNING = "hideraidwarnchat",
	CHAT_MSG_RAID_LEADER = "hideraidchat",
}
local map = {[true] = "|cffff0000"..L["Suppressed"].."|r", [false] = "|cff00ff00"..L["Shown"].."|r"}
local blockregexs = {
	"%*+ .+ %*+$",
}
local blockstrings = {
	-- enUS
	["YOU HAVE THE PLAGUE!"] = true,
	["YOU ARE THE BOMB!"] = true,
	["YOU ARE BEING WATCHED!"] = true,
	["YOU ARE CURSED!"] = true,
	["YOU ARE BURNING!"] = true,
	["YOU ARE AFFLICTED BY VOLATILE INFECTION!"] = true,
	["YOU ARE MARKED!"] = true,

	-- znCH
	["你中了瘟疫！离开人群！"] = true,
	["你是炸弹人！"] = true,
	["你被盯上了！"] = true,
	["你中了诅咒！"] = true,
	["你正在燃烧！"] = true,
	["你中了快速传染！"] = true,
	["你被标记了！"] = true,

	-- deDE
	["DU HAST DIE SEUCHE!"] = true,
	["DU BIST DIE BOMBE!"] = true,
	["DU WIRST BEOBACHTET!"] = true,
	["DU BIST VERFLUCHT!"] = true,
	["DU BRENNST!"] = true,
	-- ["YOU ARE AFFLICTED BY VOLATILE INFECTION!"] = true,
	["DU BIST MARKIERT!"] = true,

	-- frFR
	["TU AS LA PESTE !"] = true,
	["TU ES LA BOMBE !"] = true,
	["TU ES SURVEILLE !"] = true,
	["TU ES MAUDIT !"] = true,
	["TU BRULES !"] = true,
	["TU ES AFFLIGE PAR INFECTION VOLATILE !"] = true,
	["TU ES MARQUE !"] = true,

}


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBossBlock = BigWigs:NewModule("BossBlock", "AceHook-2.0")
BigWigsBossBlock.defaultDB = {
	hideraidwarnchat = true,
	hideraidwarn = true,
	hideraidsay = true,
	hideraidchat = true,
	hidetells = true,
}
BigWigsBossBlock.consoleCmd = "block"
BigWigsBossBlock.consoleOptions = {
	type = "group",
	name = L["BossBlock"],
	desc = L["Suppress bossmod chat from other players."],
	args   = {
		["chat"] = {
			type = "toggle",
			order = 101,
			name = L["Suppress Raid Chat"],
			desc = L["Suppress messages in the raid channel."],
			get = function() return BigWigsBossBlock.db.profile.hideraidchat end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidchat = v end,
			map = map,
		},
		["rs"] = {
			type = "toggle",
			order = 102,
			name = L["Suppress RaidSay"],
			desc = L["Suppress CTRA RaidSay popup messages."],
			get = function() return BigWigsBossBlock.db.profile.hideraidsay end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidsay = v end,
			map = map,
			hidden = function() return not CT_RAMessageFrame end,
		},
		["ora_rs"] = {
			type = "toggle",
			order = 103,
			name = L["Suppress RaidSay"],
			desc = L["Suppress oRA RaidSay popup messages."],
			get = function() return oRA_RaidSay:GetOpt("blockboss") end,
			set = function(v) oRA_RaidSay:TogOpt("blockboss") end,
			map = map,
			hidden = function() return not oRA_RaidSay end,
		},
		["ora2_rs"] = {
			type = "toggle",
			order = 104,
			name = L["Suppress RaidSay"],
			desc = L["Suppress oRA2 RaidSay popup messages."],
			get = function() return oRAPRaidWarn.db.profile.bossblock end,
			set = function(v) oRAPRaidWarn.db.profile.bossblock = v end,
			map = map,
			hidden = function() return not oRAPRaidWarn end,
		},
		["rw"] = {
			type = "toggle",
			order = 105,
			name = L["Suppress RaidWarn"],
			desc = L["Suppress RaidWarn popup messages."],
			get = function() return BigWigsBossBlock.db.profile.hideraidwarn end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidwarn = v end,
			map = map,
		},
		["rwchat"] = {
			type = "toggle",
			order = 106,
			name = L["Suppress RaidWarn Chat"],
			desc = L["Suppress RaidWarn messages in the chat frames."],
			get = function() return BigWigsBossBlock.db.profile.hideraidwarnchat end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidwarnchat = v end,
			map = map,
		},
		["tell"] = {
			type = "toggle",
			order = 107,
			name = L["Suppress Tells"],
			desc = L["Suppress Tell messages."],
			get = function() return BigWigsBossBlock.db.profile.hidetells end,
			set = function(v) BigWigsBossBlock.db.profile.hidetells = v end,
			map = map,
		},
		["debugspacer"] = {
			type = "header",
			order = 108,
			hidden = function() return not BigWigsBossBlock:IsDebugging() and not BigWigs:IsDebugging() end,
		},
		["debug"] = {
			type = "toggle",
			name = L["Debugging"],
			desc = L["Show debug messages."],
			order = 109,
			get = function() return BigWigsBossBlock:IsDebugging() end,
			set = function(v) BigWigsBossBlock:SetDebugging(v) end,
			hidden = function() return not BigWigsBossBlock:IsDebugging() and not BigWigs:IsDebugging() end,
		},
	},
}

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBossBlock:OnEnable()
	self:Hook("ChatFrame_OnEvent")
	self:Hook("RaidWarningFrame_OnEvent")
	if CT_RAMessageFrame then self:Hook(CT_RAMessageFrame, "AddMessage", "CTRA_AddMessage") end
end


function BigWigsBossBlock:ChatFrame_OnEvent(event)
	if self:IsChannelSuppressed(event) and self:IsSpam(arg1) then
		self:Debug(L["Suppressing Chatframe"], event, arg1)
		return
	end
	self.hooks["ChatFrame_OnEvent"](event)
end


function BigWigsBossBlock:RaidWarningFrame_OnEvent(event, message)
	if self.db.profile.hideraidwarn and self:IsSpam(message) then
		self:Debug(L["Suppressing RaidWarningFrame"], message)
		return
	end
	self.hooks["RaidWarningFrame_OnEvent"](event, message)
end


function BigWigsBossBlock:CTRA_AddMessage(obj, text, red, green, blue, alpha, holdTime)
	if self.db.profile.hideraidsay and self:IsSpam(text) then
		self:Debug(L["Suppressing CT_RAMessageFrame"], text)
		return
	end
	self.hooks[obj].AddMessage(obj, text, red, green, blue, alpha, holdTime)
end


function BigWigsBossBlock:IsSpam(text)
	if not text then return end
	if blockstrings[text] then return true end
	for _,regex in pairs(blockregexs) do if string.find(text, regex) then return true end end
end


function BigWigsBossBlock:IsChannelSuppressed(chan)
	if not raidchans[chan] then return end
	return self.db.profile[raidchans[chan]]
end


