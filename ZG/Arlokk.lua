------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priestess Arlokk")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
	mark_trigger ="D\195\169vorez ([^%s]+), mes jolies !",

	mark_warning_self = "Tu es marqu\195\169 !",
	mark_warning_other = "%s est marqu\195\169 !",
} end )

L:RegisterTranslations("deDE", function() return {
	youmark_name = "Du bist markiert",
	youmark_desc = "Warnung, wenn Du markiert bist.",

	othermark_name = "X ist markiert",
	othermark_desc = "Warnung, wenn andere Spieler markiert sind.",

	mark_trigger ="Labt euch an ([^%s]+), meine S\195\188\195\159en!$",

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

	mark_trigger = "吞噬(.+)的躯体吧！$",

	mark_warning_self = "你被标记了！",
	mark_warning_other = "%s被标记了！",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsArlokk = BigWigs:NewModule(boss)
BigWigsArlokk.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
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
			self:TriggerEvent("BigWigs_Message", L["mark_warning_self"], "Red", true, "Alarm")
		elseif self.db.profile.othermark then
			self:TriggerEvent("BigWigs_Message", string.format(L["mark_warning_other"], n), "Yellow")
			self:TriggerEvent("BigWigs_SendTell", n, L["mark_warning_self"])
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", n)
		end

	end
end

