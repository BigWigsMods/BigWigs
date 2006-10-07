------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priest Thekal")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
	tigers_trigger = "Z\195\169lote Lor'Khan commence \195\160 lancer Soins exceptionnels%.",
	heal_trigger = "Shirvallah, que ta RAGE m\226\128\153envahisse !",

	tigers_message = "Lor'Khan lance un soins !",
	heal_message = "Transformation en tigre !",
} end )

L:RegisterTranslations("koKR", function() return {
	heal_name = "?? ??",
	heal_desc = "??? ?? ??",

	tiger_name = "??? ??",
	tiger_desc = "??? ??? ??",

	tigers_trigger = "??? ??|1?;?; ??? ???? ??|1?;?; ??????.",
	heal_trigger = "??? ???|1?;?; ?? ??|1?;?; ?????.",

	tigers_message = "??? ??!!!",
	heal_message = "???, ?? ?? ??!!!",
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

