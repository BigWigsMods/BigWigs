assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsRaidWarn")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["RaidWarning"] = true,

	["raidwarn"] = true,
	["broadcast"] = true,
	["whisper"] = true,

	["Broadcast over RaidWarning"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting over Raidwarning."] = true,
	
	["Whisper"] = true,
	["Whisper warnings"] = true,
	["Toggle whispering warnings to players."] = true,
	
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
	
	["Options for RaidWarning."] = "공격대 경고 설정",
	
} end )

L:RegisterTranslations("zhCN", function() return {
	["RaidWarning"] = "团队警报",

	["Broadcast over RaidWarning"] = "通过团队警告频道发送信息",
	["Broadcast"] = "广播",
	["Toggle broadcasting over Raidwarning."] = "切换是否通过团队警告频道发送信息",
	
	["Whisper"] = "密语",
	["Whisper warnings"] = "密语警报",
	["Toggle whispering warnings to players."] = "切换是否通过密语向玩家发送信息",
	
	["Options for RaidWarning."] = "团队警告设置",
} end )

L:RegisterTranslations("deDE", function() return {
	["RaidWarning"] = "RaidWarning",

	-- ["raidwarn"] = true,
	-- ["broadcast"] = true,
	-- ["whisper"] = true,

	["Broadcast over RaidWarning"] = "Broadcast \195\188ber RaidWarning",
	["Broadcast"] = "Broadcast",
	["Toggle broadcasting over Raidwarning."] = "W\195\164hle, ob Warnungen \195\188ber RaidWarning gesendet werden sollen.",
	
	["Whisper"] = "Fl\195\188stern",
	["Whisper warnings"] = "Fl\195\188ster Warnungen",
	["Toggle whispering warnings to players."] = "W\195\164hle, ob Warnungen an andere Spieler gefl\195\188stert werden sollen.",
	
	["Options for RaidWarning."] = "Optionen f\195\188r RaidWarning.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRaidWarn = BigWigs:NewModule(L["RaidWarning"])
BigWigsRaidWarn.defaultDB = {
	whisper = false,
	broadcast = false,
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
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsRaidWarn:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_SendTell")
end

function BigWigsRaidWarn:BigWigs_Message(msg, color, noraidsay)
	if not self.db.profile.broadcast or not msg or noraidsay or ( not IsRaidLeader() and not IsRaidOfficer() ) then
		return 
	end
	SendChatMessage("*** "..msg.." ***", "RAID_WARNING")
end

function BigWigsRaidWarn:BigWigs_SendTell(player, msg )
	if not self.db.profile.whisper or not player or not msg or ( not IsRaidLeader() and not IsRaidOfficer() ) then return end
	SendChatMessage(msg, "WHISPER", nil, player)
end


