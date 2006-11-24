------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Razorgore the Untamed"]
local controller = AceLibrary("Babble-Boss-2.2")["Grethok the Controller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local eggs

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	start_trigger = "Intruders have breached",
	start_message = "Razorgore engaged! Mobs in 45sec!",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",

	mindcontrol_trigger = "Foolish ([^%s]+).",
	mindcontrol_message = "%s has been mind controlled!",

	egg_trigger = "casts Destroy Egg",
	egg_message = "%d/30 eggs destroyed!",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.",
	phase2_message = "All eggs destroyed, Razorgore loose!",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Warn when players are mind controlled",

	eggs_cmd = "eggs",
	eggs_name = "Don't count eggs",
	eggs_desc = "Don't count down the remaining eggs - this option does not work for everyone, we need better triggers.",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Alert on phase 1 and 2",
} end)

L:RegisterTranslations("koKR", function() return {
	start_trigger = "침입자들이 들어왔다! 어떤 희생이 있더라도 알을 반드시 수호하라!",
	start_message = "폭군 서슬송곳니 전투 시작",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",

	mindcontrol_trigger = "자! ([^%s]+), 이제부터 나를 섬겨라!",
	mindcontrol_message = "<<%s>> 정신 지배 되었습니다.",

	egg_trigger = "폭군 서슬송곳니|1이;가; 알 파괴|1을;를; 시전합니다.",
	egg_message = "%d/30 알을 파괴하였습니다.",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.", -- CHECK
	phase2_message = "모든 알이 파괴되었습니다, 서슬송곳니가 풀려납니다.", -- CHECK

	mc_name = "정신 지배",
	mc_desc = "플레이어가 정신 지배 되었을 때 경고",

	eggs_name = "알 개수 알림 미사용",
	eggs_desc = "남은 알 개수 알림 미사용",

	phase_name = "단계",
	phase_desc = "단계 1 과 2 알림",
} end)

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Eindringlinge sind in die",
	start_message = "Razorgore angegriffen!",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",

	mindcontrol_trigger = "^([^%s]+), Ihr Narr, Ihr dient jetzt mir!",
	mindcontrol_message = "%s wurde \195\188bernommen!",

	egg_trigger = "Razorgore der Ungez\195\164hmte wirkt Ei zerst\195\182ren.",
	egg_message = "%d/30 Eier zerst\195\182rt!",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.", -- CHECK
	phase2_message = "Alle Eier zerst\195\182rt!",

	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnung, wenn Spieler \195\188bernommen werden.",

	eggs_name = "Eier nicht z\195\164hlen",
	eggs_desc = "Die zerst\195\182rten Eier nicht z\195\164hlen.",

	phase_name = "Phasen",
	phase_desc = "Warnung beim Eintritt in Phase 1 und 2.",
} end)

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Sonnez l'alarme",
	start_message = "Tranchetripe engag\195\169 ! 45 secondes avant l'arriv\195\169e des gardes !",
	start_soon = "Arriv\195\169e des gardes dans 5 secondes !",
	start_mob = "Arriv\195\169e des gardes",

	mindcontrol_trigger = "Stupide ([^%s]+), tu es mon esclave maintenant !",
	mindcontrol_message = "%s est sous Contr\195\180le mental !",

	egg_trigger = "Tranchetripe l'Indompt\195\169 lance D\195\169truire (.*)%.",
	egg_message = "%d oeufs sur 30 d\195\169truits !",

	phase2_trigger = "Flammes \195\169chauffantes .+ Tranchetripe l'Indompt\195\169 gu\195\169rit Tranchetripe l'Indompt\195\169 de .*%.",
	phase2_message = "Tous les oeufs ont \195\169t\195\169 d\195\169truits !",

	mc_name = "Alerte Contr\195\180le mental",
	mc_desc = "Pr\195\169viens quand un joueur subit subit un contr\195\180le mental.",

	eggs_name = "Ne pas compter les oeufs",
	eggs_desc = "Ne compte pas le nombre d'oeufs restants - cette option ne fonctionne pas chez tout le monde, un meilleur d\195\169clencheur doit \195\170tre trouv\195\169.",

	phase_name = "Alerte Phases",
	phase_desc = "Pr\195\169viens de l'arriv\195\169e des phases 1 & 2.",
} end)

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "入侵者",
	start_message = "狂野的拉佐格尔 战斗开始!",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",

	mindcontrol_trigger = "愚蠢的(.+)",
	mindcontrol_message = "%s被精神控制！",

	egg_trigger = "狂野的拉佐格尔施放了(.+)",
	egg_message = "%d/30 龙蛋已经摧毁",

	phase2_trigger = "狂野的拉佐格尔的温暖之焰为狂野的拉佐格尔恢复了.*点生命值。",
	phase2_message = "所有龙蛋摧毁",

	mc_name = "精神控制",
	mc_desc = "当一个玩家使用精神控制时向团队发出警报。",

	eggs_name = "取消龙蛋计数",
	eggs_desc = "取消剩余龙蛋计数 - 该功能还在完善中。。。",

	phase_name = "第二阶段警报",
	phase_desc = "第二阶段警报",
} end)

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "入侵者",
	start_message = "狂野的拉佐格爾進入戰鬥！",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",

	mindcontrol_trigger = "愚蠢的(.+)，",
	mindcontrol_message = "%s 被心靈控制",

	egg_trigger = "狂野的拉佐格爾施放了摧毀蛋。",
	egg_message = "已摧毀 %d/30 個龍蛋！",

	phase2_trigger = "狂野的拉佐格爾的溫暖之焰為狂野的拉佐格爾恢復了.*點生命力。",
	phase2_message = "已摧毀所有龍蛋",

	mc_name = "精神控制",
	mc_desc = "當一個玩家使用精神控制時向團隊發出警報。",

	eggs_name = "取消龍蛋計數",
	eggs_desc = "取消剩餘龍蛋計數 - 該功能還在改善中。。。",

	phase_name = "第二階段警報",
	phase_desc = "第二階段警報",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.toggleoptions = { "mc", "eggs", "phase", "bosskill" }
BigWigsRazorgore.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	eggs = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 8)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["start_trigger"]) then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["start_message"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["start_mob"], 45, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
			self:ScheduleEvent("BigWigs_Message", 40, L["start_soon"], "Important")
		end
		eggs = 0
	elseif self.db.profile.mc then
		local _, _, player = string.find(msg, L["mindcontrol_trigger"]);
		if player then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], player), "Important")
		end
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	if string.find(msg, L["egg_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(eggs + 1))
	end
end

function BigWigsRazorgore:BigWigs_RecvSync(sync, rest)
	if sync ~= "RazorgoreEgg" or not rest then return end
	rest = tonumber(rest)

	if rest == (eggs + 1) then
		eggs = eggs + 1
		if not self.db.profile.eggs then
			self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], eggs), "Positive")
		end

		if eggs == 30 and self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Important")
		end
	end
end
