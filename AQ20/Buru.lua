------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Buru the Gorger"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Buru",

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
	you_name = "Alerte quand vous \195\170tes surveill\195\169",
	you_desc = "Pr\195\169viens quand vous \195\170tes surveill\195\169.",

	other_name = "Alerte quand d'autres sont surveill\195\169s",
	other_desc = "Pr\195\169viens quand d'autres joueurs sont surveill\195\169s.",

	icon_name = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le personnage surveill\195\169 (requiert d'\195\170tre promus ou plus).",

	watchtrigger = "pose ses yeux sur (.+) !",
	watchwarn = " est surveill\195\169 !",
	watchwarnyou = "Tu es surveill\195\169 !",
	you = "Vous",
} end )

L:RegisterTranslations("deDE", function() return {
	you_name = "Du wirst beobachtet",
	you_desc = "Warnung, wenn Du beobachtet wirst.",

	other_name = "X wird beobachtet",
	other_desc = "Warnung, wenn andere Spieler beobachtet werden.",

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

L:RegisterTranslations("zhTW", function() return {
	you_name = "玩家凝視警報",
	you_desc = "當你被吞咽者布魯盯住時發出警報。",

	other_name = "隊友凝視警報",
	other_desc = "當隊友被吞咽者布魯盯住時發出警報。",

	icon_name = "標記圖標",
	icon_desc = "在被凝視的隊友頭上標記（需要助理或領隊權限）",

	watchtrigger = "凝視著(.+)！",
	watchwarn = "被盯上了！往下一個蛋移動！",
	watchwarnyou = "你被盯上了！往下一個蛋移動！",
	you = "你",
} end )

L:RegisterTranslations("koKR", function() return {
	you_name = "당신을 노려봄 경고",
	you_desc = "당신을 노려볼 때 경고",

	other_name = "타인을 노려봄 경고",
	other_desc = "타인을 노려볼 때 경고",

	icon_name = "아이콘 지정",
	icon_desc = "노려보는 사람에게 레이드 아이콘 지정(승급자 이상 요구)",

	watchtrigger = "(.+)|1을;를; 노려봅니다!",
	watchwarn = "님을 노려봅니다!",
	watchwarnyou = "당신을 주시합니다!",

	you = UnitName("player"),
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ruins of Ahn'Qiraj"]
mod.enabletrigger = boss
mod.toggleoptions = {"you", "other", "icon", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function mod:CHAT_MSG_MONSTER_EMOTE( msg )
	if GetLocale() == "koKR" then
		msg = msg:gsub("%%s|1이;가; ", "")
	end
	local player = select(3, msg:find(L["watchtrigger"]))
	if player then
		if player == L["you"] and self.db.profile.you then
			player = UnitName("player")
			self:TriggerEvent("BigWigs_Message", L["watchwarnyou"], "Personal", true)
			self:TriggerEvent("BigWigs_Message", UnitName("player") .. L["watchwarn"], "Attention", nil, nil, true)
		elseif self.db.profile.other then
			self:TriggerEvent("BigWigs_Message", player .. L["watchwarn"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["watchwarnyou"])
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player )
		end
	end
end
