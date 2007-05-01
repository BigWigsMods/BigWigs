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

	deepbreath = "Deep Breath alert",
	deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath",

	phase1 = "Phase 1 alert",
	phase1_desc = "Warn for Phase 1",

	phase2 = "Phase 2 alert",
	phase2_desc = "Warn for Phase 2",

	phase3 = "Phase 3 alert",
	phase3_desc = "Warn for Phase 3",

	fear = "Fear",
	fear_desc = "Warn for Bellowing Roar in phase 3",

	deepbreath_trigger = "%s takes in a deep breath...",
	phase1_trigger = "How fortuitous",
	phase2_trigger = "from above",
	phase3_trigger = "It seems you'll need another lesson",
	fear_trigger = "Onyxia begins to cast Bellowing Roar.",

	deepbreath_message = "Deep Breath incoming!",
	phase1_message = "%s Engaged - Phase 1!",
	phase2_message = "65% - Phase 2 Incoming!",
	phase3_message = "40% - Phase 3 Incoming!",
	fear_message = "Fear in 1.5sec!",
} end )

L:RegisterTranslations("frFR", function() return {
	deepbreath = "Alerte Grande inspiration",
	deepbreath_desc = "Pr\195\169viens quand Onyxia se pr\195\169pare \195\160 prendre une grande inspiration.",

	phase1 = "Alerte Phase 1",
	phase1_desc = "Pr\195\169viens quand Onyxia passe en phase 1.",

	phase2 = "Alerte Phase 2",
	phase2_desc = "Pr\195\169viens quand Onyxia passe en phase 2.",

	phase3 = "Alerte Phase 3",
	phase3_desc = "Pr\195\169viens quand Onyxia passe en phase 3.",

	fear = "Alerte Peur",
	fear_desc = "Pr\195\169viens quand Onyxia utilise son Rugissement puissant en phase 3.",

	deepbreath_trigger = "%s prend une grande inspiration...",
	--phase1_trigger = "How fortuitous",
	phase2_trigger = "un seul coup !",
	phase3_trigger = "Il semble que vous ayez besoin d'une autre le\195\167on, mortels !",
	fear_trigger = "Onyxia commence \195\160 lancer Rugissement puissant.",

	deepbreath_message = "Souffle imminent !",
	--phase1_message = "%s Engaged - Phase 1!",
	phase2_message = "Arriv\195\169e de la phase 2 !",
	phase3_message = "Arriv\195\169e de la phase 3 !",
	fear_message = "Peur de zone dans 1,5 sec. !",
} end )

L:RegisterTranslations("deDE", function() return {
	deepbreath = "Tiefer Atem",
	deepbreath_desc = "Warnung, wenn Onyxia tief einatmet.",

	phase1 = "Phase 1",
	phase1_desc = "Warnung, wenn Onyxia abhebt und in Phase 1 eintritt.",

	phase2 = "Phase 2",
	phase2_desc = "Warnung, wenn Onyxia abhebt und in Phase 2 eintritt.",

	phase3 = "Phase 3",
	phase3_desc = "Warnung, wenn Onyxia landet und in Phase 3 eintritt.",

	fear = "Furcht",
	fear_desc = "Warnung vor AoE Furcht in Phase 3.",

	deepbreath_trigger = "%s atmet tief ein...",
	--phase1_trigger = "How fortuitous",
	phase2_trigger = "^Diese sinnlose Anstrengung langweilt mich", -- ?
	phase3_trigger = "^Mir scheint, dass Ihr noch eine Lektion braucht", -- ?
	fear_trigger = "Onyxia beginnt Dr\195\182hnendes Gebr\195\188ll zu wirken.",

	deepbreath_message = "Tiefer Atem!",
	--phase1_message = "%s Engaged - Phase 1!",
	phase2_message = "Phase 2 - Onyxia hebt ab!",
	phase3_message = "Phase 3 - Onyxia landet!",
	fear_message = "Dr\195\182hnendes Gebr\195\188ll in 1.5 Sekunden",
} end )

L:RegisterTranslations("zhCN", function() return {
	deepbreath = "深呼吸警报",
	deepbreath_desc = "奥妮克希亚开始施放深呼吸时发出警报",

	--phase1 = "Phase 1 alert",
	--phase1_desc = "Warn for Phase 1",

	phase2 = "第二阶段警报",
	phase2_desc = "第二阶段警报",

	phase3 = "第三阶段警报",
	phase3_desc = "第三阶段警报",

	fear = "低沉咆哮",
	fear_desc = "第三阶段低沉咆哮警报",

	deepbreath_trigger = "%s深深地吸了一口气……",
	--phase1_trigger = "How fortuitous",
	phase2_trigger = "从上空",
	phase3_trigger = "看起来需要再给你一次教训",
	fear_trigger = "奥妮克希亚开始施放低沉咆哮。",

	deepbreath_message = "深呼吸即将出现，向边缘散开！",
	--phase1_message = "%s Engaged - Phase 1!",
	phase2_message = "进入第二阶段！",
	phase3_message = "进入第三阶段！",
	fear_message = "1.5秒后恐惧！"
} end )

L:RegisterTranslations("zhTW", function() return {
	deepbreath = "深呼吸警報",
	deepbreath_desc = "奧妮克希亞開始施放深呼吸時發出警報",

	--phase1 = "Phase 1 alert",
	--phase1_desc = "Warn for Phase 1",

	phase2 = "第二階段警報",
	phase2_desc = "第二階段警報",

	phase3 = "第三階段警報",
	phase3_desc = "第三階段警報",

	fear = "低沉咆哮",
	fear_desc = "第三階段低沉咆哮警報",

	deepbreath_trigger = "%s深深地吸了一口氣",
	--phase1_trigger = "How fortuitous",
	phase2_trigger = "從上空",
	phase3_trigger = "看起來需要再給你一次教訓",
	fear_trigger = "奧妮克希亞開始施放低沉咆哮。",

	deepbreath_message = "奧妮克希亞深呼吸即將出現，向邊緣散開！",
	--phase1_message = "%s Engaged - Phase 1!",
	phase2_message = "奧妮克希亞進入第二階段！",
	phase3_message = "奧妮克希亞進入第三階段！",
	fear_message = "1.5秒後恐懼！"
} end )

L:RegisterTranslations("koKR", function() return {
	deepbreath = "딥브레스 경고",
	deepbreath_desc = "오닉시아가 딥 브레스 시전 시 경고",

	phase1 = "1단계 경고",
	phase1_desc = "1단계에 대한 경고",

	phase2 = "2단계 경고",
	phase2_desc = "2단계에 대한 경고",

	phase3 = "3단계 경고",
	phase3_desc = "3단계에 대한 경고",

	fear = "공포",
	fear_desc = "3단계 공포에 대한 경고",

	deepbreath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다.",
	phase1_trigger = "How fortuitous", -- check
	phase2_trigger = "머리 위에서 모조리",
	phase3_trigger = "혼이 더 나야 정신을 차리겠구나!",
	fear_trigger = "오닉시아|1이;가; 우레와같은 울부짖음|1을;를; 시전합니다.", -- CHECK

	deepbreath_message = "경고 : 오닉시아 딥 브레스, 구석으로 피하십시오!",
	phase1_message = "%s 전투 개시 - 1 단계!",
	phase2_message = "65% - 잠시 후 2 단계!",
	phase3_message = "40% - 잠시 후 3 단계!",
	fear_message = "공포 경고, 1.5 초 전!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Onyxia's Lair"]
mod.otherMenu = "Azeroth"
mod.enabletrigger = boss
mod.toggleoptions = {"deepbreath", "phase1", "phase2", "phase3", "fear", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.deepbreath and msg == L["deepbreath_trigger"] then
		self:Message(L["deepbreath_message"], "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.phase1 and msg:find(L["phase1_trigger"]) then
		self:Message(L["phase1_message"]:format(boss), "Urgent")
	elseif self.db.profile.phase2 and msg:find(L["phase2_trigger"]) then
		self:Message(L["phase2_message"], "Urgent")
	elseif self.db.profile.phase3 and msg:find(L["phase3_trigger"]) then
		self:Message(L["phase3_message"], "Urgent")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.fear and msg == L["fear_trigger"] then
		self:Message(L["fear_message"], "Attention")
	end
end
