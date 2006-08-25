------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priestess Mar'li")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

local lastdrain = 0


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "marli",

	spider_cmd = "spider",
	spider_name = "Spider Alert",
	spider_desc = "Warn when spiders spawn",

	drain_cmd = "drain",
	drain_name = "Drain Alert",
	drain_desc = "Warn for life drain",

	trigger1 = "Aid me my brood!$",
	trigger2 = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).",

	warn1 = "Spiders spawned!",
	warn2 = "High Priestess Mar'li is draining life! Interrupt it!",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "marli",

	spider_cmd = "spider",
	spider_name = "Spinnen",
	spider_desc = "Warnung, wenn Hohepriesterin Mar'li Spinnen beschw\195\182rt.",

	drain_cmd = "drain",
	drain_name = "Drain Alert", -- ?
	drain_desc = "Warn for life drain", -- ?

	trigger1 = "Helft mir, meine Brut!$",
	trigger2 = "^High Priestess Mar'li's Drain Life heals High Priestess Mar'li for (.+).", -- ?

	warn1 = "Spinnen beschworen!",
	warn2 = "High Priestess Mar'li is draining life! Interrupt it!", -- ?
} end )

L:RegisterTranslations("zhCN", function() return {
	spider_name = "蜘蛛警报",
	spider_desc = "小蜘蛛出现时发出警报",


	drain_name = "吸取警报",
	drain_desc = "高阶祭司玛尔里使用生命吸取时发出警报",
	
	trigger1 = "来为我作战吧，我的孩子们！$",
	trigger2 = "^高阶祭司玛尔里的生命吸取治疗了高阶祭司玛尔里(.+)。",

	warn1 = "蜘蛛出现！",
	warn2 = "高阶祭司玛尔里正在施放生命吸取，赶快打断她！",
} end )


L:RegisterTranslations("koKR", function() return {
	trigger1 = "어미를 도와라!$",
	trigger2 = "대여사제 말리의 생명력 흡수|1으로;로; 대여사제 말리의 생명력이 (.+)만큼 회복되었습니다.",

	warn1 = "거미 소환!",
	warn2 = "말리가 생명력을 흡수합니다. 차단해 주세요!",
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMarli = BigWigs:NewModule(boss)
BigWigsMarli.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsMarli.enabletrigger = boss
BigWigsMarli.toggleoptions = {"spider", "drain", "bosskill"}
BigWigsMarli.revision = tonumber(string.sub("$Revision$", 12, -3))


------------------------------
--      Initialization      --
------------------------------

function BigWigsMarli:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
end


function BigWigsMarli:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.spider and string.find(msg, L"trigger1") then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Yellow")
	end
end


function BigWigsMarli:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.drain and string.find(msg, L"trigger2") and lastdrain < (GetTime()-3) then
		lastdrain = GetTime()
		self:TriggerEvent("BigWigs_Message", L"warn2", "Orange")
	end
end
