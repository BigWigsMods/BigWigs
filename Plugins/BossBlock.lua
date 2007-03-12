----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBossBlock")

L:RegisterTranslations("enUS", function() return {
	["BossBlock"] = true,
	desc = "Automatically suppress boss warnings and emotes from players and other sources.",

	["Boss emotes"] = true,
	["Suppress messages sent to the raid boss emote frame.\n\nOnly suppresses messages from bosses that BigWigs knows about, and only suppresses them from showing in that frame, not the chat window."] = true,

	["Raid chat"] = true,
	["Suppress messages sent to raid chat."] = true,

	["Raid warning chat messages"] = true,
	["Suppress raid warning messages from the chat window."] = true,

	["Raid warning messages"] = true,
	["Suppress raid warning messages from the raid message window."] = true,

	["Raid say"] = true,
	["Suppress CTRA RaidSay popup messages."] = true,
	["Suppress oRA RaidSay popup messages."] = true,
	["Suppress oRA2 RaidSay popup messages."] = true,

	["Whispers"] = true,
	["Suppress whispered messages."] = true,

	["Suppressing Chatframe"] = true,
	["Suppressing RaidWarningFrame"] = true,
	["Suppressing CT_RAMessageFrame"] = true,
	["Suppressing RaidBossEmoteFrame"] = true,

	["Suppressed"] = true,
	["Shown"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["BossBlock"] = "보스차단",
	desc = "타인의 보스모드 대화 차단.",

	["Raid chat"] = "공격대 대화 차단",
	["Suppress messages sent to raid chat."] = "공격대 채널에 메세지 차단.",

	["Raid warning chat messages"] = "공격대경고 대화 차단",
	["Suppress raid warning messages from the chat window."] = "대화창에 공격대경고 메세지 차단",

	["Raid warning messages"] = "공격대경고 차단",
	["Suppress raid warning messages from the raid message window."] = "공격대경고 알림 메세지 차단",

	["Raid say"] = "RaidSay 차단",
	["Suppress CTRA RaidSay popup messages."] = "CTRA RaidSay 알림 메세지 차단",
	["Suppress oRA RaidSay popup messages."] = "oRA RaidSay 알림 메세지 차단",
	["Suppress oRA2 RaidSay popup messages."] = "oRA2 RaidSay 알림 메세지 차단",

	["Whispers"] = "일반대화 차단",
	["Suppress whispered messages."] = "일반대화 메세지 차단",

	["Suppressing Chatframe"] = "대화창 차단됨",
	["Suppressing RaidWarningFrame"] = "공격대경고창 차단됨",
	["Suppressing CT_RAMessageFrame"] = "CR_RA메세지창 차단됨",

	["Suppressed"] = "차단됨",
	["Shown"] = "표시함",
} end)

L:RegisterTranslations("zhCN", function() return {
	["BossBlock"] = "信息阻挡",
	desc = "阻挡其他玩家的首领插件发送的信息。",

	["Raid chat"] = "阻挡团队频道",
	["Suppress messages sent to raid chat."] = "阻挡团队频道中的信息",

	["Raid warning chat messages"] = "阻挡团队警告聊天",
	["Suppress raid warning messages from the chat window."] = "阻挡聊天窗体中的团队警告信息",

	["Raid warning messages"] = "阻挡团队警告",
	["Suppress raid warning messages from the raid message window."] = "阻挡团队警告中的信息",

	["Raid say"] = "阻挡RS",
	["Suppress CTRA RaidSay popup messages."] = "阻挡团队助手(CTRA)的RS信息",

	["Whispers"] = "阻挡密语",
	["Suppress whispered messages."] = "阻挡密语中的信息",

	["Suppressing Chatframe"] = "正在阻挡Chatframe",
	["Suppressing RaidWarningFrame"] = "正在阻挡RaidWarningFrame",
	["Suppressing CT_RAMessageFrame"] = "正在阻挡CT_RAMessageFrame",

	["Suppressed"] = "阻挡",
	["Shown"] = "显示",
} end)

L:RegisterTranslations("zhTW", function() return {
	["BossBlock"] = "訊息阻擋",
	desc = "阻擋其他玩家的首領插件發送的訊息。",

	["Raid chat"] = "阻擋團隊頻道",
	["Suppress messages sent to raid chat."] = "阻擋團隊頻道中的訊息",

	["Raid warning chat messages"] = "阻擋團隊警告聊天",
	["Suppress raid warning messages from the chat window."] = "阻擋聊天窗體中的團隊警告訊息",

	["Raid warning messages"] = "阻擋團隊警告",
	["Suppress raid warning messages from the raid message window."] = "阻擋團隊警告中的訊息",

	["Raid say"] = "阻擋RS",
	["Suppress CTRA RaidSay popup messages."] = "阻擋團隊助手(CTRA)的RS訊息",

	["Whispers"] = "阻擋密語",
	["Suppress whispered messages."] = "阻擋密語中的訊息",

	["Suppressing Chatframe"] = "正在阻擋Chatframe",
	["Suppressing RaidWarningFrame"] = "正在阻擋RaidWarningFrame",
	["Suppressing CT_RAMessageFrame"] = "正在阻擋CT_RAMessageFrame",

	["Suppressed"] = "阻擋",
	["Shown"] = "顯示",
} end)

L:RegisterTranslations("deDE", function() return {
	["BossBlock"] = "BossBlock",
	desc = "Bossmod Chat von anderen Spielern unterdr\195\188cken.",

	["Raid chat"] = "Raid Chat unterdr\195\188cken",
	["Suppress messages sent to raid chat."] = "Nachrichten im Raid Channel unterdr\195\188cken",

	["Raid warning chat messages"] = "RaidWarn Chat unterdr\195\188cken",
	["Suppress raid warning messages from the chat window."] = "RaidWarn Nachrichten im Chat Fenster unterdr\195\188cken.",

	["Raid warning messages"] = "RaidWarn unterdr\195\188cken",
	["Suppress raid warning messages from the raid message window."] = "RaidWarn Popup-Nachrichten unterdr\195\188cken.",

	["Raid say"] = "RaidSay unterdr\195\188cken",
	["Suppress CTRA RaidSay popup messages."] = "CTRA RaidSay Popup Nachrichten unterdr\195\188cken.",
	["Suppress oRA RaidSay popup messages."] = "oRA RaidSay Popup Nachrichten unterdr\195\188cken.",
	["Suppress oRA2 RaidSay popup messages."] = "oRA2 RaidSay Popup Nachrichten unterdr\195\188cken.",

	["Whispers"] = "Fl\195\188stern unterdr\195\188cken",
	["Suppress whispered messages."] = "Fl\195\188stern Nachrichten unterdr\195\188cken.",

	["Suppressing Chatframe"] = "Chatframe unterdr\195\188ckt",
	["Suppressing RaidWarningFrame"] = "RaidWarningFrame unterdr\195\188cket",
	["Suppressing CT_RAMessageFrame"] = "CT_RAMessageFrame unterdr\195\188ckt",

	["Suppressed"] = "Unterdr\195\188ckt",
	["Shown"] = "Angezeigt",
} end)

L:RegisterTranslations("frFR", function() return {
	--["BossBlock"] = true,
	desc = "Supprime les messages des BossMods des autres joueurs.",

	["Raid chat"] = "Supprimer les messages du canal Raid",
	["Suppress messages sent to raid chat."] = "Supprime les messages du canal Raid.",

	["Raid warning chat messages"] = "Supprimer les Avertissements Raid du chat",
	["Suppress raid warning messages from the chat window."] = "Supprime les messages de l'Avertissement Raid de la fen\195\170tre de discussion.",

	["Raid warning messages"] = "Supprimer les Avertissements Raid",
	["Suppress raid warning messages from the raid message window."] = "Supprime les messages \195\160 l'\195\169cran de l'Avertissement Raid.",

	["Raid say"] = "Supprimer les RaidSay",
	["Suppress CTRA RaidSay popup messages."] = "Supprime les messages \195\160 l'\195\169cran du RaidSay de CTRA.",
	["Suppress oRA RaidSay popup messages."] = "Supprime les messages \195\160 l'\195\169cran du RaidSay de oRA.",
	["Suppress oRA2 RaidSay popup messages."] = "Supprime les messages \195\160 l'\195\169cran du RaidSay de oRA2.",

	["Whispers"] = "Supprimer les chuchotements",
	["Suppress whispered messages."] = "Supprime les messages chuchot\195\169s.",

	["Suppressing Chatframe"] = "Suppression de la fen\195\170tre de discussion",
	["Suppressing RaidWarningFrame"] = "Suppression du cadre de l'Avertissement Raid",
	["Suppressing CT_RAMessageFrame"] = "Suppression du cadre du RaidSay de CTRA",

	["Suppressed"] = "Supprim\195\169",
	["Shown"] = "Affich\195\169",
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

local plugin = BigWigs:NewModule("BossBlock", "AceHook-2.1")

plugin.revision = tonumber(string.sub("$Revision$", 12, -3))
plugin.defaultDB = {
	chat = true,
	rs = true,
	ora_rs = true,
	ora2_rs = true,
	rw = true,
	rwchat = true,
	tell = true,
	boss = true,
}
plugin.consoleCmd = L["BossBlock"]

plugin.consoleOptions = {
	type = "group",
	name = L["BossBlock"],
	desc = L["desc"],
	pass = true,
	get = function(key) return plugin.db.profile[key] end,
	set = function(key, value) plugin.db.profile[key] = value end,
	args = {
		["chat"] = {
			type = "toggle",
			name = L["Raid chat"],
			desc = L["Suppress messages sent to raid chat."],
			map = map,
		},
		["rs"] = {
			type = "toggle",
			name = L["Raid say"],
			desc = L["Suppress CTRA RaidSay popup messages."],
			map = map,
			hidden = function() return not CT_RAMessageFrame end,
		},
		["ora_rs"] = {
			type = "toggle",
			name = L["Raid say"],
			desc = L["Suppress oRA RaidSay popup messages."],
			map = map,
			hidden = function() return not oRA_RaidSay end,
		},
		["ora2_rs"] = {
			type = "toggle",
			name = L["Raid say"],
			desc = L["Suppress oRA2 RaidSay popup messages."],
			map = map,
			hidden = function() return not oRAPRaidWarn end,
		},
		["rw"] = {
			type = "toggle",
			name = L["Raid warning messages"],
			desc = L["Suppress raid warning messages from the raid message window."],
			map = map,
		},
		["rwchat"] = {
			type = "toggle",
			name = L["Raid warning chat messages"],
			desc = L["Suppress raid warning messages from the chat window."],
			map = map,
		},
		["tell"] = {
			type = "toggle",
			name = L["Whispers"],
			desc = L["Suppress whispered messages."],
			map = map,
		},
		["boss"] = {
			type = "toggle",
			name = L["Boss emotes"],
			desc = L["Suppress messages sent to the raid boss emote frame.\n\nOnly suppresses messages from bosses that BigWigs knows about, and only suppresses them from showing in that frame, not the chat window."],
			map = map,
		}
	},
}

------------------------------
--      Event Handlers      --
------------------------------

function plugin:OnEnable()
	self:Hook("ChatFrame_MessageEventHandler", true)
	self:Hook(RaidWarningFrame, "AddMessage", "RWAddMessage", true)
	self:Hook(RaidBossEmoteFrame, "AddMessage", "RBEAddMessage", true)
	if CT_RAMessageFrame then
		self:Hook(CT_RAMessageFrame, "AddMessage", "CTRA_AddMessage", true)
	end
end


function plugin:ChatFrame_MessageEventHandler(event)
	if self:IsChannelSuppressed(event) and self:IsSpam(arg1) then
		self:Debug(L["Suppressing Chatframe"], event, arg1)
		return
	end
	return self.hooks["ChatFrame_MessageEventHandler"](event)
end

function plugin:RWAddMessage(frame, message, r, g, b, a, t)
	if self.db.profile.hideraidwarn and self:IsSpam(message) then
		self:Debug(L["Suppressing RaidWarningFrame"], message)
		return
	end
	self.hooks[RaidWarningFrame].AddMessage(frame, message, r, g, b, a, t)
end

function plugin:RBEAddMessage(frame, message, r, g, b, a, t)
	if self.db.profile.hidebossemotes and type(arg2) == "string" and BigWigs:HasModule(arg2) then
		self:Debug(L["Suppressing RaidBossEmoteFrame"], message)
		return
	end
	self.hooks[RaidBossEmoteFrame].AddMessage(frame, message, r, g, b, a, t)
end

function plugin:CTRA_AddMessage(obj, text, r, g, b, a, t)
	if self.db.profile.hideraidsay and self:IsSpam(text) then
		self:Debug(L["Suppressing CT_RAMessageFrame"], text)
		return
	end
	self.hooks[obj].AddMessage(obj, text, r, g, b, a, t)
end

function plugin:IsSpam(text)
	if not text then return end
	if blockstrings[text] then return true end
	for _,regex in pairs(blockregexs) do if text:find(regex) then return true end end
end

function plugin:IsChannelSuppressed(chan)
	if not raidchans[chan] then return end
	return self.db.profile[raidchans[chan]]
end

