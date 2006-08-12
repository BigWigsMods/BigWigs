------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsBossBlock")

local map = {[true] = "|cffff0000".."Supressed".."|r", [false] = "|cff00ff00".."Shown".."|r"}
local raidchans = {
	CHAT_MSG_WHISPER = "hidetells",
	CHAT_MSG_RAID = "hideraidchat",
	CHAT_MSG_RAID_WARNING = "hideraidwarnchat",
	CHAT_MSG_RAID_LEADER = "hideraidchat",
}
local blockstrings = {
	["YOU HAVE THE PLAGUE!"] = true,
	["YOU ARE THE BOMB!"] = true,
	["YOU ARE BEING WATCHED!"] = true,
	["YOU ARE CURSED!"] = true,
	["YOU ARE BURNING!"] = true,
	["YOU ARE AFFLICTED BY VOLATILE INFECTION!"] = true,
	["YOU ARE MARKED!"] = true,
}
local blockregexs = {
	"%*+ .+ %*+$",
}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["BossBlock"] = true,
	["Supress bossmod chat from other players."] = true,
	
	["Supress Raid Chat"] = true,
	["Supress messages in the raid channel."] = true,
	
	["Supress RaidWarn Chat"] = true,
	["Supress RaidWarn messages in the chat frames."] = true,
	
	["Supress RaidWarn"] = true,
	["Supress RaidWarn popup messages."] = true,
	
	["Supress RaidSay"] = true,
	["Supress CTRA RaidSay popup messages."] = true,
	
	["Supress Tells"] = true,
	["Supress Tell messages."] = true,
	
	["Debugging"] = true,
	["Show debug messages."] = true,
	
	["Supressing Chatframe"] = true,
	["Supressing RaidWarningFrame"] = true,
	["Supressing CT_RAMessageFrame"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["BossBlock"] = "信息阻挡",
	["Supress bossmod chat from other players."] = "阻挡其他玩家的首领插件发送的信息。",
	
	["Supress Raid Chat"] = "阻挡团队频道",
	["Supress messages in the raid channel."] = "阻挡团队频道中的信息",
	
	["Supress RaidWarn Chat"] = "阻挡团队警告聊天",
	["Supress RaidWarn messages in the chat frames."] = "阻挡聊天窗体中的团队警告信息",
	
	["Supress RaidWarn"] = "阻挡团队警告",
	["Supress RaidWarn popup messages."] = "阻挡团队警告中的信息",
	
	["Supress RaidSay"] = "阻挡RS",
	["Supress CTRA RaidSay popup messages."] = "阻挡团队助手(CTRA)的RS信息",
	
	["Supress Tells"] = "阻挡密语",
	["Supress Tell messages."] = "阻挡密语中的信息",
	
	["Debugging"] = "除错",
	["Show debug messages."] = "显示除错信息",
	
	["Supressing Chatframe"] = "正在阻挡Chatframe",
	["Supressing RaidWarningFrame"] = "正在阻挡RaidWarningFrame",
	["Supressing CT_RAMessageFrame"] = "正在阻挡CT_RAMessageFrame",
} end)

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
	name = L"BossBlock",
	desc = L"Supress bossmod chat from other players.",
	args   = {
		["chat"] = {
			type = "toggle",
			order = 1,
			name = L"Supress Raid Chat",
			desc = L"Supress messages in the raid channel.",
			get = function() return BigWigsBossBlock.db.profile.hideraidchat end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidchat = v end,
			map = map,
		},
		["rwchat"] = {
			type = "toggle",
			order = 1,
			name = L"Supress RaidWarn Chat",
			desc = L"Supress RaidWarn messages in the chat frames.",
			get = function() return BigWigsBossBlock.db.profile.hideraidwarnchat end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidwarnchat = v end,
			map = map,
		},
		["rw"] = {
			type = "toggle",
			order = 1,
			name = L"Supress RaidWarn",
			desc = L"Supress RaidWarn popup messages.",
			get = function() return BigWigsBossBlock.db.profile.hideraidwarn end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidwarn = v end,
			map = map,
		},
		["rs"] = {
			type = "toggle",
			order = 1,
			name = L"Supress RaidSay",
			desc = L"Supress CTRA RaidSay popup messages.",
			get = function() return BigWigsBossBlock.db.profile.hideraidsay end,
			set = function(v) BigWigsBossBlock.db.profile.hideraidsay = v end,
			map = map,
			hidden = function() return not CT_RAMessageFrame end,
		},
		["tell"] = {
			type = "toggle",
			order = 1,
			name = L"Supress Tells",
			desc = L"Supress Tell messages.",
			get = function() return BigWigsBossBlock.db.profile.hidetells end,
			set = function(v) BigWigsBossBlock.db.profile.hidetells = v end,
			map = map,
		},
		["debugspacer"] = {
			type = "header",
			order = 99,
			hidden = function() return not BigWigsBossBlock:IsDebugging() and not BigWigs:IsDebugging() end,
		},
		["debug"] = {
			type = "toggle",
			name = L"Debugging",
			desc = L"Show debug messages.",
			order = 100,
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
	if self:IsChannelSupressed(event) and self:IsSpam(arg1) then
		self:Debug(L"Supressing Chatframe", event, arg1)
		return
	end
	self.hooks.ChatFrame_OnEvent.orig(event)
end


function BigWigsBossBlock:RaidWarningFrame_OnEvent(event, message)
	if self.db.profile.hideraidwarn and self:IsSpam(message) then
		self:Debug(L"Supressing RaidWarningFrame", message)
		return
	end
	self.hooks.RaidWarningFrame_OnEvent.orig(event, message)
end


function BigWigsBossBlock:CTRA_AddMessage(obj, text, red, green, blue, alpha, holdTime)
	if self.db.profile.hideraidsay and self:IsSpam(text) then
		self:Debug(L"Supressing CT_RAMessageFrame", text)
		return
	end
	self.hooks[obj].AddMessage.orig(obj, text, red, green, blue, alpha, holdTime)
end


function BigWigsBossBlock:IsSpam(text)
	if not text then return end
	if blockstrings[text] then return true end
	for _,regex in pairs(blockregexs) do if string.find(text, regex) then return true end end
end


function BigWigsBossBlock:IsChannelSupressed(chan)
	if not raidchans[chan] then return end
	return self.db.profile[raidchans[chan]]
end


