------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Onyxia"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

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

	onyfear_cmd = "onyfear",
	onyfear_name = "Fear",
	onyfear_desc = "Warn for Bellowing Roar in phase 3",

	trigger1 = "%s takes in a deep breath...",
	trigger2 = "from above",
	trigger3 = "It seems you'll need another lesson",
	trigger4 = "Onyxia begins to cast Bellowing Roar.",

	warn1 = "Deep Breath incoming!",
	warn2 = "Onyxia phase 2 incoming!",
	warn3 = "Onyxia phase 3 incoming!",
	warn4 = "Fear incoming, 1.5 Seconds!",
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
	deepbreath_name = "Tiefer Atem",
	deepbreath_desc = "Warnung, wenn Onyxia tief einatmet.",

	phase2_name = "Phase 2",
	phase2_desc = "Warnung, wenn Onyxia abhebt und in Phase 2 eintritt.",

	phase3_name = "Phase 3",
	phase3_desc = "Warnung, wenn Onyxia landet und in Phase 3 eintritt.",

	onyfear_name = "Furcht",
	onyfear_desc = "Warnung vor AoE Furcht in Phase 3.",

	trigger1 = "%s atmet tief ein...",
	trigger2 = "^Diese sinnlose Anstrengung langweilt mich", -- ?
	trigger3 = "^Mir scheint, dass Ihr noch eine Lektion braucht", -- ?
	trigger4 = "Onyxia beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",

	warn1 = "Tiefer Atem!",
	warn2 = "Phase 2 - Onyxia hebt ab!",
	warn3 = "Phase 3 - Onyxia landet!",
	warn4 = "Dr\195\182hnendes Gebr\195\188ll in 1.5 Sekunden",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath_name = "深呼吸警报",
	deepbreath_desc = "奥妮克希亚开始施放深呼吸时发出警报",

	phase2_name = "第二阶段警报",
	phase2_desc = "第二阶段警报",

	phase3_name = "第三阶段警报",
	phase3_desc = "第三阶段警报",

	onyfear_name = "低沉咆哮",
	onyfear_desc = "第三阶段低沉咆哮警报",

	trigger1 = "%s深深地吸了一口气……",
	trigger2 = "从上空",
	trigger3 = "看起来需要再给你一次教训",
	trigger4 = "奥妮克希亚开始施放低沉咆哮。",

	warn1 = "奥妮克希亚深呼吸即将出现，向边缘散开！",
	warn2 = "奥妮克希亚进入第二阶段！",
	warn3 = "奥妮克希亚进入第三阶段！",
	warn4 = "1.5秒后恐惧！"
} end )

L:RegisterTranslations("koKR", function() return {

	deepbreath_name = "딥브레스 경고",
	deepbreath_desc = "오닉시아가 딥 브레스 시전 시 경고",

	phase2_name = "2단계 경고",
	phase2_desc = "2단계에 대한 경고",

	phase3_name = "3단계 경고",
	phase3_desc = "3단계에 대한 경고",

	onyfear_name = "공포",
	onyfear_desc = "3단계 공포에 대한 경고",

	trigger1 = "%s|1이;가; 숨을 깊게 들이쉽니다.", --"%s|1이;가; 깊은 숨을 들이쉽니다...",
	trigger2 = "머리 위에서 모조리",
	trigger3 = "혼이 더 나야 정신을 차리겠구나!",
	trigger4 = "오닉시아|1이;가; 우레와같은 울부짖음|1을;를; 시전합니다.", -- CHECK

	warn1 = "경고 : 오닉시아 딥 브레스, 구석으로 피하십시오!",
	warn2 = "오닉시아 2단계 시작!",
	warn3 = "오닉시아 3단계 시작!",
	warn4 = "공포 경고, 1.5 초 전!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOnyxia = BigWigs:NewModule(boss)
BigWigsOnyxia.zonename = AceLibrary("Babble-Zone-2.2")["Onyxia's Lair"]
BigWigsOnyxia.enabletrigger = boss
BigWigsOnyxia.toggleoptions = {"deepbreath", "phase2", "phase3", "onyfear", "bosskill"}
BigWigsOnyxia.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOnyxia:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsOnyxia:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg == L["trigger1"]) then
		if self.db.profile.deepbreath then self:TriggerEvent("BigWigs_Message", L["warn1"], "Important") end
	end
end

function BigWigsOnyxia:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L["trigger2"])) then
		if self.db.profile.phase2 then self:TriggerEvent("BigWigs_Message", L["warn2"], "Urgent") end
	elseif (string.find(msg, L["trigger3"])) then
		if self.db.profile.phase3 then self:TriggerEvent("BigWigs_Message", L["warn3"], "Urgent") end
	end
end


function BigWigsOnyxia:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger4"] and self.db.profile.onyfear then
		self:TriggerEvent("BigWigs_Message", L["warn4"], "Important")
	end
end
