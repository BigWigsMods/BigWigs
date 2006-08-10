------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Onyxia")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Onyxia",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath ",

	phase2_cmd = "phase2",
	phase2_name = "Phase 2 alert",
	phase2_desc = "Warn for Phase 2",

	phase3_cmd = "phase3",
	phase3_name = "Phase 3 alert",
	phase3_desc = "Warn for Phase 3",

	trigger1 = "takes in a deep breath...",
	trigger2 = "from above",
	trigger3 = "It seems you'll need another lesson",

	warn1 = "Deep Breath incoming!",
	warn2 = "Onyxia phase 2 incoming!",
	warn3 = "Onyxia phase 3 incoming!",
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 = "prend une grande inspiration%.%.%.",
	trigger2 = "un seul coup !",
	trigger3 = "Il semble que vous ayez besoin d'une autre le\195\167on, mortels !",

	warn1 = "Onyxia va souffler, tous sur les cot\195\169s !",
	warn2 = "Onyxia rentre en phase 2 !",
	warn3 = "Onyxia rentre en phase 3 !",
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 = "atmet tief ein...",
	trigger2 = "von oben",
	trigger3 = "Es sieht so aus",

	warn1 = "Onyxia Tiefer Atem kommt, rennt zu den Seiten!",
	warn2 = "Onyxia Phase 2 kommt!",
	warn3 = "Onyxia Phase 3 kommt!",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath_name = "深呼吸警报",
	deepbreath_desc = "奥妮克希亚开始施放深呼吸时发出警报",

	phase2_name = "第二阶段警报",
	phase2_desc = "第二阶段警报",

	phase3_name = "第三阶段警报",
	phase3_desc = "第三阶段警报",
	
	trigger1 = "深深地吸了一口气……",
	trigger2 = "从上空",
	trigger3 = "看起来需要再给你一次教训",

	warn1 = "奥妮克希亚深呼吸即将出现，向边缘散开！",
	warn2 = "奥妮克希亚进入第二阶段！",
	warn3 = "奥妮克希亚进入第三阶段！",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "깊은 숨을 들이쉽니다...",
	trigger2 = "머리 위에서 모조리",
	trigger3 = "혼이 더 나야 정신을 차리겠구나!",

	warn1 = "경고 : 오닉시아 딥 브레스, 구석으로 피하십시오!",
	warn2 = "오닉시아 2단계 시작!",
	warn3 = "오닉시아 3단계 시작!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOnyxia = BigWigs:NewModule(boss)
BigWigsOnyxia.zonename = AceLibrary("Babble-Zone-2.0")("Onyxia's Lair")
BigWigsOnyxia.enabletrigger = boss
BigWigsOnyxia.toggleoptions = {"deepbreath", "phase2", "phase3", "bosskill"}
BigWigsOnyxia.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOnyxia:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsOnyxia:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg == L"trigger1") then
		if self.db.profile.deepbreath then self:TriggerEvent("BigWigs_Message", L"warn1", "Red") end
	end
end

function BigWigsOnyxia:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L"trigger2")) then
		if self.db.profile.phase2 then self:TriggerEvent("BigWigs_Message", L"warn2", "White") end
	elseif (string.find(msg, L"trigger3")) then
		if self.db.profile.phase3 then self:TriggerEvent("BigWigs_Message", L"warn3", "White") end
	end
end