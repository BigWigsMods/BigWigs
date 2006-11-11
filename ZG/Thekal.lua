------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priest Thekal"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Thekal",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	tiger_cmd = "tiger",
	tiger_name = "Tigers Alert",
	tiger_desc = "Warn for incoming tigers",

	tigers_trigger = "High Priest Thekal performs Summon Zulian Guardians.",
	heal_trigger = "Zealot Lor'Khan begins to cast Great Heal.",

	tigers_message = "Incoming Tigers!",
	heal_message = "Lor'Khan Casting Heal!",
} end )

L:RegisterTranslations("deDE", function() return {
	heal_name = "Heilung",
	heal_desc = "Warnung, wenn Zealot Lor'Khan sich heilt.",

	tiger_name = "Tiger",
	tiger_desc = "Warnung, wenn Hohepriester Thekal Tiger beschw\195\182rt.",

	tigers_trigger = "Hohepriester Thekal f\195\188hrt Zulianische W\195\164chter beschw\195\182ren aus.",
	heal_trigger = "Zelot Lor'Khan beginnt Gro\195\159es Heilen zu wirken.",

	tigers_message = "Tiger!",
	heal_message = "Lor'Khan heilt sich!",
} end )

L:RegisterTranslations("frFR", function() return {
	heal_name = "Alerte Soins",
	heal_desc = "Pr\195\169viens en cas de soin.",

	tiger_name = "Alerte Tigres",
	tiger_desc = "Pr\195\169viens de l'invocation de tigres.",

	tigers_trigger = "Grand pr\195\170tre Thekal ex\195\169cute Invocation de gardiens zuliens.",
	heal_trigger = "Z\195\169lote Lor'Khan commence \195\160 lancer Soins exceptionnels.",

	tigers_message = "Invocation de tigres !",
	heal_message = "Lor'Khan lance un soin !",
} end )

L:RegisterTranslations("koKR", function() return {
	heal_name = "치유 경고",
	heal_desc = "치유에 대한 경고",

	tiger_name = "호랑이 경고",
	tiger_desc = "호랑이 소환시 경고",

	tigers_trigger = "대사제 데칼|1이;가; 줄리안 수호표범 소환|1을;를; 사용했습니다.",
	heal_trigger = "광신도 로르칸|1이;가; 상급 치유|1을;를; 시전합니다.",

	tigers_message = "호랑이 소환!!!",
	heal_message = "로르칸, 상급 치유 시전!!!",
} end )

L:RegisterTranslations("zhCN", function() return {
	heal_name = "治疗警报",
	heal_desc = "治疗警报",

	tiger_name = "老虎警报",
	tiger_desc = "小老虎出现时发出警报",

	tigers_trigger = "高阶祭司塞卡尔使用召唤祖利安守护者。",
	heal_trigger = "狂热者洛卡恩开始施放强力治疗术。",
	tigers_message = "老虎出现！",
	heal_message = "狂热者洛卡恩正在施放治疗，赶快打断它！",	
} end )

L:RegisterTranslations("zhTW", function() return {
	-- High Priest Thekal 高階祭司塞卡爾
	heal_name = "治療警報",
	heal_desc = "治療警報",

	tiger_name = "老虎警報",
	tiger_desc = "小老虎出現時發出警報",

	tigers_trigger = "古拉巴什食腐者使用召喚祖利安守護者。",
	heal_trigger = "狂熱者洛卡恩開始施放強力治療術。",
	tigers_message = "老虎出現！",
	heal_message = "洛卡恩正在補血！快打斷它！",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsThekal = BigWigs:NewModule(boss)
BigWigsThekal.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
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

------------------------------
--      Events              --
------------------------------

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.tiger and msg == L["tigers_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["tigers_message"], "Attention")
	elseif self.db.profile.heal and msg == L["heal_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["heal_message"], "Urgent")
	end
end

