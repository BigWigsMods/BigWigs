------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priest Venoxis")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Venoxis",

	renew_cmd = "renew",
	renew_name = "Renew Alert",
	renew_desc = "Warn for Renew",

	phase_cmd = "phase",
	phase_name = "Phase 2 Alert",
	phase_desc = "Warn for Phase 2",

	renew_trigger = "High Priest Venoxis gains Renew.",
	phase2_trigger = "Let the coils of hate unfurl!",

	renew_message = "Renew!",
	phase2_message = "Incoming phase 2 - poison clouds spawning!",
} end )

L:RegisterTranslations("deDE", function() return {

	renew_name = "Erneuerung",
	renew_desc = "Warnung, wenn Venoxis Erneuerung auf sich wirkt.",

	phase_name = "Phase 2",
	phase_desc = "Warnung, wenn Venoxis in Phase 2 eintritt.",

	renew_trigger = "Hohepriester Venoxis bekommt 'Erneuerung'",
	phase2_trigger = "M\195\182ge das Schlachten beginnen", -- ?

	renew_message = "Erneuerung auf Venoxis!",
	phase2_message = "Phase 2 - Vorsicht vor Giftwolken!",	
} end )

L:RegisterTranslations("frFR", function() return {
	renew_trigger = "Grand pr\195\170tre Venoxis gagne R\195\169novation%.",
	phase2_trigger = "Que se d\195\169roulent les anneaux de la haine !",

	renew_message = "R\195\169novation - Dispellez le !",
	phase2_message = "Phase 2, attention aux nuages de poison !",
} end )

L:RegisterTranslations("zhCN", function() return {
	renew_name = "恢复警报",
	renew_desc = "恢复警报",
	
	phase_name = "第二阶段警报",
	phase_desc = "第二阶段警报",
	
	renew_trigger = "高阶祭司温诺希斯获得了恢复的效果。",
	phase2_trigger = "让仇恨的",

	renew_message = "恢复 - 立即驱散！",
	phase2_message = "进入第二阶段，小心毒云！",
} end )

L:RegisterTranslations("koKR", function() return {
	
	renew_name = "소생 경고",
	renew_desc = "소생에 대한 경고",
	
	phase_name = "2 단계 경고",
	phase_desc = "2 단계에 대한 경고",
	
	renew_trigger = "대사제 베녹시스|1이;가; 소생 효과를 얻었습니다.",
	phase2_trigger = "증오의 또아리를 틀 시간이다!",

	renew_message = "소생 - 마법 해제해주세요!",
	phase2_message = "2단계 시작 - 독구름을 조심하세요!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsVenoxis = BigWigs:NewModule(boss)
BigWigsVenoxis.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsVenoxis.enabletrigger = boss
BigWigsVenoxis.toggleoptions = {"renew", "phase", "bosskill"}
BigWigsVenoxis.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsVenoxis:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Events              --
------------------------------

function BigWigsVenoxis:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.renew and msg == L["renew_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["renew_message"], "Urgent")
	end
end

function BigWigsVenoxis:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.phase and string.find(msg, L["phase2_trigger"]) then
		self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Attention")
	end
end
