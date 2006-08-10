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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRaidWarn = BigWigs:NewModule(L"RaidWarning")
BigWigsRaidWarn.defaultDB = {
	whisper = false,
	broadcast = false,
}
BigWigsRaidWarn.consoleCmd = L"raidwarn"
BigWigsRaidWarn.consoleOptions = {
	type = "group",
	name = L"RaidWarning",
	desc = L"Options for RaidWarning.",
	args   = {
		[L"broadcast"] = {
			type = "toggle",
			name = L"Broadcast",
			desc = L"Toggle broadcasting over Raidwarning.",
			get = function() return BigWigsRaidWarn.db.profile.broadcast end,
			set = function(v) BigWigsRaidWarn.db.profile.broadcast = v end,		
		},
		[L"whisper"] = {
			type = "toggle",
			name = L"Whisper",
			desc = L"Toggle whispering warnings to players.",
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
	if not self.db.profile.whisper or not player or not msg then return end
	SendChatMessage(msg, "WHISPER", nil, player)
end
