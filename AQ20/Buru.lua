------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Buru the Gorger")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "buru",
	
	you_cmd = "you",
	you_name = "You're being watched alert",
	you_desc = "Warn when you're being watched",
	
	other_cmd = "other",
	other_name = "Others being watched alert",
	other_desc = "Warn when others are being watched",
	
	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on watched person (requires promoted or higher)",

	watchtrigger = "sets eyes on (.+)!",
	watchwarn = " is being watched!",
	watchwarnyou = "You are being watched!",
	you = "You",	
} end )

L:RegisterTranslations("frFR", function() return {
	watchtrigger = "pose ses yeux sur (.+) !",
	watchwarn = " est surveill\195\169 !",
	watchwarnyou = "Tu es surveill\195\169 !",
	you = "Vous",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "buru",
	
	you_cmd = "you",
	you_name = "Du wirst beobachtet",
	you_desc = "Warnung, wenn Du beobachtet wirst.",
	
	other_cmd = "other",
	other_name = "X wird beobachtet",
	other_desc = "Warnung, wenn andere Spieler beobachtet werden.",
	
	icon_cmd = "icon",
	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der beobachtet wird. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",
	
	watchtrigger = "beh\195\164lt (.+) im Blickfeld!",
	watchwarn = " wird beobachtet!",
	watchwarnyou = "Du wirst beobachtet!",
	you = "Euch",
} end )

L:RegisterTranslations("zhCN", function() return {
	you_name = "玩家凝视警报",
	you_desc = "当你被凝视时发出警报",
	
	other_name = "队友凝视警报",
	other_desc = "当队友被凝视时发出警报",
	
	icon_name = "标记图标",
	icon_desc = "在被凝视的队友头上标记团队图标（需要助理或领袖权限）",
	
	watchtrigger = "凝视着(.+)！",
	watchwarn = "被布鲁盯上了！",
	watchwarnyou = "你被布鲁盯上了！放风筝吧！",
	you = "你",
} end )

L:RegisterTranslations("koKR", function() return {
	watchtrigger = "(.+)|1을;를; 노려봅니다!",
	watchwarn = "님을 노려봅니다!",
	you = UnitName("player"),
	watchtell = "당신을 주시합니다!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBuru = BigWigs:NewModule(boss)
BigWigsBuru.zonename = AceLibrary("Babble-Zone-2.0")("Ruins of Ahn'Qiraj")
BigWigsBuru.enabletrigger = boss
BigWigsBuru.toggleoptions = {"you", "other", "icon", "bosskill"}
BigWigsBuru.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBuru:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsBuru:CHAT_MSG_MONSTER_EMOTE( msg )
	local _, _, player = string.find(msg, L["watchtrigger"])
	if player then
		if player == L["you"] then
			player = UnitName("player")
			if self.db.profile.you then self:TriggerEvent("BigWigs_Message", L["watchwarnyou"], "Red", true) end
		else
			if self.db.profile.other then 
				self:TriggerEvent("BigWigs_Message", player .. L["watchwarn"], "Yellow")
				self:TriggerEvent("BigWigs_SendTell", player, L["watchwarnyou"])
			end
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player )
		end
	end
end
