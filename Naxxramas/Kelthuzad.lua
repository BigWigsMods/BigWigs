------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Kel'Thuzad")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

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
	phase3_trigger = "Master, I require aid!",
	phase3_warning = "Phase 3, Guardians in ~15sec!",

	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKelThuzad = BigWigs:NewModule(boss)
BigWigsKelThuzad.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsKelThuzad.enabletrigger = boss
BigWigsKelThuzad.toggleoptions = { "frostblast", "fissure", "mc", -1, "detonate", "detonateicon", -1 ,"guardians", "phase", "bosskill" }
BigWigsKelThuzad.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKelThuzad:OnInitialize()
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

