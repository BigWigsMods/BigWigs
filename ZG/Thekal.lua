------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priest Thekal")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "thekal",
	
	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	tiger_cmd = "tiger",
	tiger_name = "Tigers Alert",
	tiger_desc = "Warn for incoming tigers",

	trigger1 = "High Priest Thekal performs Summon Zulian Guardians.",
	trigger2 = "Zealot Lor'Khan begins to cast Great Heal.",
	warn1 = "Incoming Tigers!",
	warn2 = "Lor'Khan Casting Heal!",	
} end )

L:RegisterTranslations("enUS", function() return {
	cmd = "thekal",
	
	heal_cmd = "heal",
	heal_name = "Heilung",
	heal_desc = "Warnung, wenn Zealot Lor'Khan sich heilt.",

	tiger_cmd = "tiger",
	tiger_name = "Tiger",
	tiger_desc = "Warnung, wenn Tiger kommen.",

	trigger1 = "High Priest Thekal performs Summon Zulian Guardians.", -- ?
	trigger2 = "Zealot Lor'Khan begins to cast Great Heal.", -- ?
	warn1 = "Tiger!",
	warn2 = "Lor'Khan heilt sich!",	
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Z\195\169lote Lor'Khan commence \195\160 lancer Soins exceptionnels%.",
	trigger2 = "Shirvallah, que ta RAGE m\226\128\153envahisse !",

	warn1 = "Lor'Khan lance un soins !",
	warn2 = "Transformation en tigre !",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "대사제 데칼|1이;가; 줄리안 수호표범 소환|1을;를; 사용했습니다.",
	trigger2 = "광신도 로르칸|1이;가; 상급 치유|1을;를; 시전합니다.",

	warn1 = "호랑이 소환!!!",
	warn2 = "로르칸, 상급 치유 시전!!!",
} end )

L:RegisterTranslations("zhCN", function() return {
	heal_name = "治疗警报",
	heal_desc = "治疗警报",

	tiger_name = "老虎警报",
	tiger_desc = "小老虎出现时发出警报",

	trigger1 = "高阶祭司塞卡尔使用了召唤祖利安守护者。",
	trigger2 = "狂热者洛卡恩开始施放强效治疗术。",
	warn1 = "老虎出现！",
	warn2 = "狂热者洛卡恩正在施放治疗，赶快打断它！",	
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThekal = BigWigs:NewModule(boss)
BigWigsThekal.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsThekal.enabletrigger = boss
BigWigsThekal.toggleoptions = {"heal", "tiger", "bosskill"}
BigWigsThekal.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsThekal:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.tiger and arg1 == L"trigger1" then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Yellow")
	elseif self.db.profile.heal and arg1 == L"trigger2" then
		self:TriggerEvent("BigWigs_Message", L"warn2", "Orange")
	end
end
