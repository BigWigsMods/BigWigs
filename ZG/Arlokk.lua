------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priestess Arlokk")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "arlokk",
	
	youmark_cmd = "youmark",
	youmark_name = "You're marked alert",
	youmark_desc = "Warn when you are marked",
	
	othermark_cmd = "othermark",
	othermark_name = "Others are marked alert",
	othermark_desc = "Warn when others are marked",

	trigger1 = "Feast on ([^%s]+), my pretties!$",

	warn1 = "You are marked!",
	warn2 = "%s is marked!",	
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 ="Labt euch an ([^%s]+), meine S\195\188\195\159en!$",

	warn1 = "Du bist markiert!",
	warn2 = "%s ist markiert!",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "내 귀여운 것들아, (.+)%|1을;를; 잡아먹어라!$",

	warn1 = "당신은 표적입니다!",
	warn2 = "%s님은 표적입니다!",
} end )

L:RegisterTranslations("zhCN", function() return {
	youmark_name = "玩家标记警报",
	youmark_desc = "当你被标记时发出警报",
	
	othermark_name = "队友标记警报",
	othermark_desc = "当队友被标记时发出警报",

	trigger1 = "吞噬(.+)的躯体吧！$",

	warn1 = "你被标记了！",
	warn2 = "%s被标记了！",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsArlokk = BigWigs:NewModule(boss)
BigWigsArlokk.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsArlokk.enabletrigger = boss
BigWigsArlokk.toggleoptions = {"youmark", "othermark", "bosskill"}
BigWigsArlokk.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsArlokk:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsArlokk:CHAT_MSG_MONSTER_YELL( msg )
	local _,_, n = string.find(msg, L"trigger1")
	if n then
		if n == UnitName("player") then
			if self.db.profile.youmark then self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true, "Alarm") end
		elseif self.db.profile.othermark then
			self:TriggerEvent("BigWigs_Message", string.format(L"warn2", n), "Yellow")
			self:TriggerEvent("BigWigs_SendTell", n, L"warn1")
		end
	end
end
