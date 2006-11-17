------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Kel'Thuzad"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local mcTime
local frostBlastTime

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad Chamber",

	phase_cmd = "phase",
	phase_name = "Phase Warnings",
	phase_desc = "Warn for phases.",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control Alert",
	mc_desc = "Alerts when people are mind controlled.",

	fissure_cmd = "fissure",
	fissure_name = "Shadow Fissure Alert",
	fissure_desc = "Alerts about incoming Shadow Fizzures.",

	frostblast_cmd = "frostblast",
	frostblast_name = "Frost Blast Alert",
	frostblast_desc = "Alerts when people get Frost Blasted.",

	detonate_cmd = "detonate",
	detonate_name = "Detonate Mana Warning",
	detonate_desc = "Warns about Detonate Mana soon.",

	detonateicon_cmd = "detonateicon",
	detonateicon_name = "Raid Icon on Detonate",
	detonateicon_desc = "Place a raid icon on people with Detonate Mana.",

	guardians_cmd = "guardians",
	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",

	mc_trigger1 = "Your soul is bound to me, now!",
	mc_trigger2 = "There will be no escape!",
	mc_warning = "Mind Control!",

	start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	start_warning = "Kel'Thuzad encounter started! ~5min till he is active!",
	start_bar = "Phase 2",

	phase2_trigger = "Pray for mercy!",
	phase2_warning = "Phase 2, Kel'Thuzad incoming!",
	phase2_bar = "Kel'Thuzad Active!",

	phase3_soon_warning = "Phase 3 soon!",
	phase3_trigger = "Master, I require aid!",
	phase3_warning = "Phase 3, Guardians in ~15sec!",

	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

	fissure_trigger = "Kel'Thuzad casts Shadow Fissure.",
	fissure_warning = "Shadow Fissure!",

	frostblast_bar = "Possible Frost Blast",
	frostblast_trigger = "^([^%s]+) ([^%s]+) afflicted by Frost Blast",
	frostblast_warning = "Frost Blast!",
	frostblast_soon_message = "Possible Frost Blast in ~5sec!",

	detonate_trigger = "^([^%s]+) ([^%s]+) afflicted by Detonate Mana",
	detonate_bar = "Detonate Mana - %s",
	detonate_possible_bar = "Possible Detonate",
	detonate_warning = "%s has Detonate Mana!",

	you = "You",
	are = "are",
} end )

L:RegisterTranslations("koKR", function() return {

	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "캘투자드 연구실",

	phase_name = "단계 알림",
	phase_desc = "단계에 대한 알림.",

	mc_name = "정신 지배",
	mc_desc = "정신 지배 경고.",

	fissure_name = "어둠의 분열 경고",
	fissure_desc = "어둠의 분열 시전에 관한 경고.",

	frostblast_name = "냉기작열 경고",
	frostblast_desc = "냉기 작열에 걸렸을 때 경고.",

	detonate_name = "마나 폭발 경고",
	detonate_desc = "마나 폭발에 대한 경고.",

	detonateicon_name = "폭발 공격대 아이콘",
	detonateicon_desc = "마나 폭발인 사람에게 공격대 아이콘 지정.",

	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",

	mc_trigger1 = "Your soul is bound to me, now!", -- CHECK
	mc_trigger2 = "There will be no escape!", -- CHECK
	mc_warning = "정신 지배!",

	start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!", -- CHECK
	start_warning = "Kel'Thuzad encounter started! ~5min till he is active!", -- CHECK
	start_bar = "2 단계",

	phase2_trigger = "Pray for mercy!", -- CHECK
	phase2_warning = "2 단계, 켈투자드 다가옴!",
	phase2_bar = "켈투자드 활동!",

	phase3_soon_warning = "곧 3 단계 돌입!",
	phase3_trigger = "Master, I require aid!", -- CHECK
	phase3_warning = "3 단계, Guardians in ~15sec!",

	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!", -- CHECK
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

	fissure_trigger = "켈투자드|1이;가; 어둠의 분열|1을;를; 시전합니다.",
	fissure_warning = "어둠의 분열!",

	frostblast_bar = "냉기 작열 가능",
	frostblast_trigger = "^([^|;%s]*)(.*)냉기 작열에 걸렸습니다%.$",
	frostblast_warning = "냉기 작열!",
	frostblast_soon_message = "냉기 작열 가능 - 약 5초 이내!",

	detonate_trigger = "^([^|;%s]*)(.*)마나 폭발에 걸렸습니다%.$",
	detonate_bar = "마나 폭발 - %s",
	detonate_possible_bar = "폭발 가능",
	detonate_warning = "%s%|1이;가; 마나 폭발!",

	you = "",
	are = "",
} end )

L:RegisterTranslations("deDE", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzads Gem\195\164cher",

	phase_name = "Phasenwarnung",
	phase_desc = "Warnt vor den verschiedenen Phasen.",

	mc_name = "Gedankenkontrolle Warnung",
	mc_desc = "Warnt, wenn Spieler von Gedankenkontrolle betroffen sind.",

	fissure_name = "Schattenspalt Warnung",
	fissure_desc = "Warnt vor Schattenspalt.",

	frostblast_name = "Frostschlag Warnung",
	frostblast_desc = "Warnt wenn Leute Frostschlag bekommen.",

	detonate_name = "Detonierendes Mana Warnung",
	detonate_desc = "Warnt vor Detonierendes Mana.",

	detonateicon_name = "Schlachtzugicon bei Detonierung",
	detonateicon_desc = "Plaziert ein Icon auf Spielern mit Detonierendes Mana.",

	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",

	mc_trigger1 = "Eure Seele geh\195\182rt jetzt mir!",
	mc_trigger2 = "Es gibt kein Entkommen!",
	mc_warning = "Gedankenkontrolle!",

	start_trigger = "Diener, J\195\188nger, Soldaten der eisigen Finsternis! Folgt dem Ruf von Kel'Thuzad!",
	start_warning = "Kel'Thuzad Encounter gestarted! ~5min bis er aktiv wird!",
	start_bar = "Phase 2",

	phase2_trigger = "Fleht um Gnade!",
	phase2_warning = "Phase 2, Kel'Thuzad kommt!",
	phase2_bar = "Kel'Thuzad aktiv!",

	phase3_soon_warning = "Phase 3 bald!",
	phase3_trigger = "Meister, helft mir!",
	phase3_warning = "Phase 3, W\195\164chter in ~15sek!",

	guardians_trigger = "Also gut. Erhebt euch, Krieger der eisigen Weiten! Ich befehle euch zu k\195\164mpfen, zu t\195\182ten und f\195\188r euren Meister zu sterben! Lasst keinen am Leben!",
	guardians_warning = "W\195\164chter in ~10sek!",
	guardians_bar = "W\195\164chter kommen!",

	fissure_trigger = "Kel'Thuzad wirkt Schattenspalt.",
	fissure_warning = "Schattenspalt!",

	frostblast_trigger = "^([^%s]+) ([^%s]+) von Frostschlag betroffen",
	frostblast_warning = "Frostschlag!",

	detonate_trigger = "^([^%s]+) ([^%s]+) von Detonierendes Mana betroffen",
	detonate_bar = "Detonierendes Mana - %s",
	detonate_possible_bar = "Detonierendes Mana",
	detonate_warning = "%s hat Detonierendes Mana!",

	you = "Ihr",
	are = "seid",
} end )

L:RegisterTranslations("zhCN", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "克尔苏加德的大厅",

	phase_name = "每个阶段警报",
	phase_desc = "每个阶段警报",

	mc_name = "精神控制警报",
	mc_desc = "当有人被精神控制后警报",

	fissure_name = "暗影裂隙警报",
	fissure_desc = "警报即将来领的暗影裂隙",

	frostblast_name = "冰霜冲击警报",
	frostblast_desc = "当有人被冰霜冲击后警报",

	detonate_name = "自爆法力警报",
	detonate_desc = "警报即将来领的自爆法力",

	detonateicon_name = "自爆法力标记",
	detonateicon_desc = "标记即将自爆法力的人",

	guardians_name = "寒冰皇冠卫士警报",
	guardians_desc = "提前警报第三阶段召唤来的寒冰皇冠卫士",

	mc_trigger1 = "你的灵魂现在属于我了！",
	mc_trigger2 = "没有人能逃得掉！",
	mc_warning = "精神控制！",

	start_trigger = "仆从们，侍卫们，隶属于黑暗与寒冷战士们！听从克尔苏加德的召唤！",
	start_warning = "克尔苏加德之战开始，他将在~5分钟后激活！",
	start_bar = "第二阶段",

	phase2_trigger = "祈祷我的慈悲吧！",
	phase2_warning = "第二阶段开始，克尔苏加德来了！",
	phase2_bar = "克尔苏加德激活！",

	phase3_soon_warning = "第三阶段即将来到！",
	phase3_trigger = "主人，我需要帮助！",
	phase3_warning = "第三阶段开始，~15秒后卫士出现！",

	guardians_trigger = "很好，冰荒废土的战士们，起来吧！我命令你们为主人而战斗，杀戮，直到死亡！一个活口都不要留！",
	guardians_warning = "~10秒后卫士出现！",
	guardians_bar = "卫士出现！",

	fissure_trigger = "克尔苏加德施放了暗影裂隙。",
	fissure_warning = "暗影裂隙！",

	frostblast_bar = "可能的冰霜冲击",
	frostblast_trigger = "^(.+)受到了冰霜冲击的影响。",
	frostblast_warning = "冰霜冲击！",
	frostblast_soon_message = "~5秒后可能有冰霜冲击！",

	detonate_trigger = "^(.+)受到了自爆法力的影响。",
	detonate_bar = "自爆法力 - %s",
	detonate_possible_bar = "可能的自爆",
	detonate_warning = "%s中了自爆法力！",

	you = "你",
	are = "到",
} end )


L:RegisterTranslations("zhTW", function() return {
	
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "科爾蘇加德的大廳",

	phase_name = "每個階段警報",
	phase_desc = "每個階段警報",

	mc_name = "心靈控制警報",
	mc_desc = "當有人被心靈控制後警報",

	fissure_name = "暗影裂縫警報",
	fissure_desc = "警報即將來領的暗影裂縫",

	frostblast_name = "冰霜衝擊警報",
	frostblast_desc = "當有人被冰霜衝擊後警報",

	detonate_name = "爆裂法力警報",
	detonate_desc = "警報即將來領的爆裂法力",

	detonateicon_name = "爆裂法力標記",
	detonateicon_desc = "標記即將爆裂法力的人",

	guardians_name = "寒冰皇冠守衛者警報",
	guardians_desc = "提前警報第三階段召喚來的寒冰皇冠守衛者",

	mc_trigger1 = "你的靈魂現在屬於我了！",
	mc_trigger2 = "沒有人能逃得掉！",
	mc_warning = "精神控制！",

	start_trigger = "僕從們，侍衛們，隸屬於黑暗與寒冷的戰士！聽從科爾蘇加德的召換！",
	start_warning = "科爾蘇加德之戰開始，他將在 5 分鐘後進入戰鬥！",
	start_bar = "第二階段",

	phase2_trigger = "祈禱我的慈悲吧！",
	phase2_warning = "第二階段開始，科爾蘇加德來了！",
	phase2_bar = "科爾蘇加德進入戰鬥！",

	phase3_soon_warning = "第三階段即將來到！",
	phase3_trigger = "主人，我需要",
	phase3_warning = "第三階段開始， 15 秒後衛士出現！",

	guardians_trigger = "那好吧。冰冷廢墟的戰士，站起來！我命令你戰鬥，為你的主人而殺，而死！不要留一個！", -- need to check the line
	guardians_warning = " 10 秒後護衛出現！",
	guardians_bar = "護衛出現！",

	fissure_trigger = "科爾蘇加德施放了暗影裂縫。",
	fissure_warning = "暗影裂縫！",

	frostblast_bar = "可能的冰霜衝擊",
	frostblast_trigger = "^(.+)受到(.+)冰霜衝擊的影響。",
	frostblast_warning = "冰霜沖擊！",
	frostblast_soon_message = "~5秒後可能有冰霜衝擊！",

	detonate_trigger = "^(.+)受到(.+)爆裂法力的影響。",
	detonate_bar = "爆裂法力 - %s",
	detonate_possible_bar = "可能的爆裂法力",
	detonate_warning = "%s中了爆裂法力！",

	you = "你",
	are = "了",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "frostblast", "fissure", "mc", -1, "detonate", "detonateicon", -1 ,"guardians", "phase", "bosskill" }
BigWigsKelThuzad.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKelThuzad:OnRegister()
	-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
end

function BigWigsKelThuzad:OnEnable()
	self.warnedAboutPhase3Soon = nil

	frostBlastTime = nil
	mcTime = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Affliction")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "KelDetonate", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFrostBlast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFizzure", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelMindControl", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsKelThuzad:MINIMAP_ZONE_CHANGED(msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or self.core:IsModuleActive(boss) then return end
	-- Activate the Kel'Thuzad mod!
	self.core:EnableModule(boss)
end

function BigWigsKelThuzad:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:TriggerEvent("BigWigs_Message", L["phase3_soon_warning"], "Attention")
			self.warnedAboutPhase3Soon = true
		elseif health > 60 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function BigWigsKelThuzad:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.phase and msg == L["start_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["start_warning"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 320 )
	elseif self.db.profile.phase and msg == L["phase2_trigger"] then
		self:TriggerEvent("BigWigs_StopBar", self, L["start_bar"] )
		self:TriggerEvent("BigWigs_Message", L["phase2_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["phase2_bar"], 20 )
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["phase3_warning"], "Attention")
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		if not mcTime or (mcTime + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "KelMindControl")
			mcTime = GetTime()
		end
	elseif self.db.profile.guardians and msg == L["guardians_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["guardians_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["guardians_bar"], 10)
	end
end

function BigWigsKelThuzad:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if msg == L["fissure_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "KelFizzure")
	end
end

function BigWigsKelThuzad:BigWigs_RecvSync(sync, rest, nick)
	if sync == "KelDetonate" and rest and self.db.profile.detonate then
		self:TriggerEvent("BigWigs_Message", string.format(L["detonate_warning"], rest), "Attention")
		if self.db.profile.detonateicon then self:TriggerEvent("BigWigs_SetRaidIcon", rest ) end
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["detonate_bar"], rest), 5, "Interface\\Icons\\Spell_Nature_WispSplode")
		self:TriggerEvent("BigWigs_StartBar", self, L["detonate_possible_bar"], 20, "Interface\\Icons\\Spell_Nature_WispSplode")
	elseif sync == "KelFrostBlast" and self.db.profile.frostblast then
		self:TriggerEvent("BigWigs_Message", L["frostblast_warning"], "Attention")
		self:ScheduleEvent("bwktfbwarn", "BigWigs_Message", 20, L["frostblast_soon_message"])
		self:TriggerEvent("BigWigs_StartBar", self, L["frostblast_bar"], 25, "Interface\\Icons\\Spell_Frost_FreezingBreath")
	elseif sync == "KelFizzure" and self.db.profile.fissure then
		self:TriggerEvent("BigWigs_Message", L["fissure_warning"], "Important")
	elseif sync == "KelMindControl" and self.db.profile.mc then
		self:TriggerEvent("BigWigs_Message", L["mc_warning"], "Urgent")
	end
end

function BigWigsKelThuzad:Affliction( msg )
	if string.find(msg, L["detonate_trigger"]) then
		local _,_, dplayer, dtype = string.find( msg, L["detonate_trigger"])
		if dplayer and dtype then
			if dplayer == L["you"] and dtype == L["are"] then
				dplayer = UnitName("player")
			end
			self:TriggerEvent("BigWigs_SendSync", "KelDetonate "..dplayer)
		end
	elseif string.find(msg, L["frostblast_trigger"]) then
		if not frostBlastTime or (frostBlastTime + 2) < GetTime() then
			self:TriggerEvent("BigWigs_SendSync", "KelFrostBlast")
			frostBlastTime = GetTime()
		end
	end
end
