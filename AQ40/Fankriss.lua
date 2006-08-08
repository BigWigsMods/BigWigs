------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Fankriss the Unyielding")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Fankriss",
	worm_cmd = "worm",
	worm_name = "Worm Alert",
	worm_desc = "Warn for Incoming Worms",

	wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
	wormwarn = "Incoming Worm!",
} end )

L:RegisterTranslations("zhCN", function() return {
	worm_name = "虫子警报",
	worm_desc = "召唤虫子出现时发出警报",
	
	wormtrigger = "顽强的范克瑞斯施放了召唤虫子。",
	wormwarn = "虫子出现 - 赶快杀掉！",
} end )

L:RegisterTranslations("koKR", function() return {
	wormtrigger = "불굴의 판크리스|1이;가; 벌레 소환|1을;를; 시전합니다.",
	wormwarn = "벌레 소환 - 제거!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFankriss = BigWigs:NewModule(boss)
BigWigsFankriss.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsFankriss.enabletrigger = boss
BigWigsFankriss.toggleoptions = {"worm", "bosskill"}
BigWigsFankriss.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFankriss:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(arg1)
	if self.db.profile.worm and arg1 == L"wormtrigger" then
		self:TriggerEvent("BigWigs_Message", L"wormwarn", "Orange")
	end
end