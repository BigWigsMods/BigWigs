------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Moam"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moam",

	adds_cmd = "adds",
	adds_name = "Mana Fiend Alert",
	adds_desc = "Warn for Mana fiends",

	paralyze_cmd = "paralyze",
	paralyze_name = "Paralyze Alert",
	paralyze_desc = "Warn for Paralyze",

	starttrigger = "%s senses your fear.",
	startwarn = "Moam Engaged! 90 Seconds until adds!",
	addsbar = "Adds",
	addsincoming = "Mana Fiends incoming in %s seconds!",
	addstrigger = "%s drains your mana and turns to stone.",
	addswarn = "Mana Fiends spawned! Moam Paralyzed for 90 seconds!",
	paralyzebar = "Paralyze",
	returnincoming = "Moam unparalyzed in %s seconds!",
	returntrigger = "^Energize fades from Moam%.$",
	returnwarn = "Moam unparalyzed! 90 seconds until Mana Fiends!",
} end )

L:RegisterTranslations("frFR", function() return {
	adds_name = "Alerte El\195\169mentaires",
	adds_desc = "Pr\195\169viens lorsque les El\195\169mentaires apparaissents",

	paralyze_name = "Alerte Paralysie",
	paralyze_desc = "Pr\195\169viens lorsque Moam entre en paralysie.",

	starttrigger = "%s sent votre peur.",
	startwarn = "Moam engag\195\169 ! 90 secondes avant les El\195\169mentaires !",

	addsbar = "El\195\169mentaire",
	addsincoming = "Les El\195\169mentaires arrivent dans %s secondes !",
	addstrigger = "%s absorbe votre mana et se change en pierre.",
	addswarn = "El\195\169mentaires ! Moam paralys\195\169 pour 90 secondes.",

	paralyzebar = "Paralysie",
	returnincoming = "Moam d\195\169paralys\195\169 dans %s secondes !",
	returntrigger = "Dynamiser sur Moam vient de se dissiper%.",
	returnwarn = "Retour de Moam ! 90 secondes avant les El\195\169mentaires !",
} end )

L:RegisterTranslations("deDE", function() return {
	adds_name = "Manageister",
	adds_desc = "Warnung, wenn Manageister erscheinen.",

	paralyze_name = "Steinform",
	paralyze_desc = "Warnung, wenn Moam in Steinform.",

	starttrigger = "%s sp\195\188rt Eure Angst.",
	startwarn = "Moam angegriffen! Manageister in 90 Sekunden!",

	addsbar = "Manageister",
	addsincoming = "Manageister in %s Sekunden!",
	addstrigger = "%s entzieht Euch Euer Mana und versteinert Euch.",
	addswarn = "Manageister! Moam in Steinform f\195\188r 90 Sekunden.",

	paralyzebar = "Steinform",
	returnincoming = "Moam erwacht in %s Sekunden!",
	returntrigger = "Energiezufuhr schwindet von Moam.",
	returnwarn = "Moam erwacht! Manageister in 90 Sekunden!",
} end )

L:RegisterTranslations("koKR", function() return {
	adds_name = "정령 경고",
	adds_desc = "정령에 대한 경고",

	paralyze_name = "마비 경고",
	paralyze_desc = "마비에 대한 경고",

	starttrigger = "%s|1이;가; 당신의 공포를 알아챕니다.",
	startwarn = "모암 행동시작! 90초 후 정령 등장!",
	addsbar = "정령 등장",
	addsincoming = "%s초후 정령 등장!",
	addstrigger = "당신의 마나를 흡수한 %s|1이;가; 돌처럼 변합니다.",
	addswarn = "정령 등장! 모암 90초간 멈춤!",
	paralyzebar = "모암 마비",
	returnincoming = "%s초후 모암 행동 재개!",
	returntrigger = "모암의 몸에서 마력 충전 효과가 사라졌습니다.",
	returnwarn = "모암 행동 재개! 90초 후 정령 등장!",
} end )

L:RegisterTranslations("zhCN", function() return {
	adds_name = "召唤警报",
	adds_desc = "召唤元素恶魔出现时发出警报",

	paralyze_name = "石化警报",
	paralyze_desc = "莫阿姆进入石化状态时发出警报",

	starttrigger = "%s察觉到了你的恐惧。",
	startwarn = "莫阿姆已激活 - 90秒后召唤元素恶魔",
	addsbar = "召唤",
	addsincoming = "元素恶魔将%s秒后被召唤！",
	addstrigger = "%s吸取了你的魔法能量，变成了石头。",
	addswarn = "元素恶魔被召唤！术士放逐！莫阿姆石化90秒！",
	paralyzebar = "石化",
	returnincoming = "莫阿姆将在%s秒后解除石化！",
	returntrigger = "^充能效果从莫阿姆身上消失。$",
	returnwarn = "莫阿姆解除石化！90秒后重新召唤元素恶魔！",
} end )

L:RegisterTranslations("zhTW", function() return {
	adds_name = "召喚警報",
	adds_desc = "召喚元素惡魔出現時發出警報",

	paralyze_name = "石化警報",
	paralyze_desc = "莫阿姆進入石化狀態時發出警報",

	starttrigger = "%s因神態失常而坐立不安。",
	startwarn = "莫阿姆已進入戰鬥 - 90 秒後召喚元素惡魔",
	addsbar = "召喚惡魔",
	addsincoming = "將在 %s 秒後召喚惡魔！",
	addstrigger = "%s吸取你的法力後變成了石頭。",
	addswarn = "惡魔被召喚！術士放逐！莫阿姆石化90秒！",
	paralyzebar = "石化",
	returnincoming = "將在 %s 秒後解除石化！",
	returntrigger = "^莫阿姆充滿能量。$",
	returnwarn = "已解除石化！ 90 秒後重新召喚惡魔！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMoam = BigWigs:NewModule(boss)
BigWigsMoam.zonename = AceLibrary("Babble-Zone-2.2")["Ruins of Ahn'Qiraj"]
BigWigsMoam.enabletrigger = boss
BigWigsMoam.toggleoptions = {"adds", "paralyze", "bosskill"}
BigWigsMoam.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMoam:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath" )
end

function BigWigsMoam:AddsStart()
	if self.db.profile.adds then
		self:ScheduleEvent("BigWigs_Message", 30, format(L["addsincoming"], 60), "Attention")
		self:ScheduleEvent("BigWigs_Message", 60, format(L["addsincoming"], 30), "Attention")
		self:ScheduleEvent("BigWigs_Message", 75, format(L["addsincoming"], 15), "Urgent")
		self:ScheduleEvent("BigWigs_Message", 85, format(L["addsincoming"], 5), "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["addsbar"], 90, "Interface\\Icons\\Spell_Shadow_CurseOfTounges") 
	end
end

function BigWigsMoam:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["starttrigger"] then
		if self.db.profile.adds then self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important") end
		self:AddsStart()
	elseif msg == L["addstrigger"] then
		if self.db.profile.adds then
			self:TriggerEvent("BigWigs_Message", L["addswarn"], "Important")
		end
		if self.db.profile.paralyze then
			self:ScheduleEvent("BigWigs_Message", 30, format(L["returnincoming"], 60), "Attention")
			self:ScheduleEvent("BigWigs_Message", 60, format(L["returnincoming"], 30), "Attention")
			self:ScheduleEvent("BigWigs_Message", 75, format(L["returnincoming"], 15), "Urgent")
			self:ScheduleEvent("BigWigs_Message", 85, format(L["returnincoming"], 5), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["paralyzebar"], 90, "Interface\\Icons\\Spell_Shadow_CurseOfTounges")
		end
	end
end

function BigWigsMoam:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if string.find( msg, L["returntrigger"]) then
		if self.db.profile.paralyze then self:TriggerEvent("BigWigs_Message", L["returnwarn"], "Important") end
		self:AddsStart()
	end
end
