------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Arlokk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local playerName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Arlokk",

	youmark_cmd = "youmark",
	youmark_name = "You're marked alert",
	youmark_desc = "Warn when you are marked",

	othermark_cmd = "othermark",
	othermark_name = "Others are marked alert",
	othermark_desc = "Warn when others are marked",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on the marked person (requires promoted or higher)",

	mark_trigger = "Feast on ([^%s]+), my pretties!$",

	mark_warning_self = "You are marked!",
	mark_warning_other = "%s is marked!",
} end )

L:RegisterTranslations("frFR", function() return {
	youmark_name = "Alerte quand vous \195\170tes marqu\195\169",
	youmark_desc = "Pr\195\169viens quand vous \195\170tes marqu\195\169.",

	othermark_name = "Alerte quand d'autres sont marqu\195\169s",
	othermark_desc = "Pr\195\169viens quand d'autres joueurs sont marqu\195\169s.",

	icon_name = "Ic\195\180ne de raid",
	icon_desc = "Place une ic\195\180ne de raid sur la derni\195\168re personne marqu\195\169e (requiert d'\195\170tre promus ou plus)",

	mark_trigger ="D\195\169vorez ([^%s]+), mes jolies !",

	mark_warning_self = "Tu es marqu\195\169 !",
	mark_warning_other = "%s est marqu\195\169 !",
} end )

L:RegisterTranslations("deDE", function() return {
	youmark_name = "Du bist markiert",
	youmark_desc = "Warnung, wenn Du markiert bist.",

	othermark_name = "X ist markiert",
	othermark_desc = "Warnung, wenn andere Spieler markiert sind.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der markiert ist. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	mark_trigger = "Labt euch an ([^%s]+), meine S\195\188\195\159en!$",

	mark_warning_self = "Du bist markiert!",
	mark_warning_other = "%s ist markiert!",
} end )

L:RegisterTranslations("koKR", function() return {
	youmark_name = "자신의 표적 경고",
	youmark_desc = "자신이 표적이 됐을 때 경고",

	othermark_name = "타인의 표적 경고",
	othermark_desc = "타인이 표적이 됐을 때 경고",

	icon_name = "아이콘 지정",
	icon_desc = "표적이된 사람에게 해골 아이콘 지정 (승급자 이상 필요)",

	mark_trigger = "내 귀여운 것들아, (.+)%|1을;를; 잡아먹어라!$",

	mark_warning_self = "당신은 표적입니다!",
	mark_warning_other = "%s님은 표적입니다!",
} end )

L:RegisterTranslations("zhCN", function() return {
	youmark_name = "玩家标记警报",
	youmark_desc = "当你被标记时发出警报",

	othermark_name = "队友标记警报",
	othermark_desc = "当队友被标记时发出警报",

	icon_name = "标记被标记者",
	icon_desc = "团队标记被标记者 (需要助理或更高权限)",

	mark_trigger = "吞噬(.+)的躯体吧！$",

	mark_warning_self = "你被标记了！",
	mark_warning_other = "%s被标记了！",
} end )

L:RegisterTranslations("zhTW", function() return {
	youmark_name = "玩家標記警報",
	youmark_desc = "當高階祭司婭爾羅標記你給她的黑豹時發出警報。",

	othermark_name = "隊友標記警報",
	othermark_desc = "當高階祭司婭爾羅標記一個隊友給她的黑豹時發出警報。",

	icon_name = "標記被標記者",
	icon_desc = "團隊標記被標記者 (需要助理或更高權限)",

	mark_trigger = "吞噬(.+)的軀體吧，我的小可愛們！$",

	mark_warning_self = "你被標記了！",
	mark_warning_other = "%s 被標記了！ 牧師照顧一下他！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsArlokk = BigWigs:NewModule(boss)
BigWigsArlokk.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
BigWigsArlokk.enabletrigger = boss
BigWigsArlokk.toggleoptions = {"youmark", "othermark", "icon", "bosskill"}
BigWigsArlokk.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsArlokk:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Events              --
------------------------------

function BigWigsArlokk:CHAT_MSG_MONSTER_YELL( msg )
	local _,_, n = string.find(msg, L["mark_trigger"])
	if n then
		if n == playerName and self.db.profile.youmark then
			self:TriggerEvent("BigWigs_Message", L["mark_warning_self"], "Important", true, "Alarm")
			self:TriggerEvent("BigWigs_Message", string.format(L["mark_warning_other"], UnitName("player")), "Attention", nil, nil, true)
		elseif self.db.profile.othermark then
			self:TriggerEvent("BigWigs_Message", string.format(L["mark_warning_other"], n), "Attention")
			self:TriggerEvent("BigWigs_SendTell", n, L["mark_warning_self"])
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", n)
		end

	end
end
