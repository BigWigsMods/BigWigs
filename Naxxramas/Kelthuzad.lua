----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kel'Thuzad"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15990
mod.toggleOptions = { 27808, 27810, 28410, -1, 27819, "icon", -1 ,"guardians", "phase", "proximity", "bosskill" }
mod.proximityCheck = function(unit) return CheckInteractDistance(unit, 3) end
mod.consoleCmd = "Kelthuzad"

------------------------------
--      Are you local?      --
------------------------------

local fbTargets = mod:NewTargetList()
local mcTargets = mod:NewTargetList()

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kelthuzad", "enUS", true)
if L then
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad's Chamber"

	L.start_trigger = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!"
	L.start_warning = "Kel'Thuzad encounter started! ~3min 30sec till he is active!"
	L.start_bar = "Phase 2"

	L.phase = "Phase"
	L.phase_desc = "Warn for phases."
	L.phase2_trigger1 = "Pray for mercy!"
	L.phase2_trigger2 = "Scream your dying breath!"
	L.phase2_trigger3 = "The end is upon you!"
	L.phase2_warning = "Phase 2, Kel'Thuzad incoming!"
	L.phase2_bar = "Kel'Thuzad Active!"
	L.phase3_soon_warning = "Phase 3 soon!"
	L.phase3_trigger = "Master, I require aid!"
	L.phase3_warning = "Phase 3, Guardians in ~15 sec!"

	L.mc_message = "Mind Control: %s"
	L.mc_warning = "Mind controls soon!"
	L.mc_nextbar = "~Mind Controls"

	L.frostblast_bar = "Possible Frost Blast"
	L.frostblast_soon_message = "Possible Frost Blast in ~5 sec!"

	L.detonate_other = "Detonate - %s"
	L.detonate_possible_bar = "Possible Detonate"
	L.detonate_warning = "Next Detonate in 5 sec!"

	L.guardians = "Guardian Spawns"
	L.guardians_desc = "Warn for incoming Icecrown Guardians in phase 3."
	L.guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!"
	L.guardians_warning = "Guardians incoming in ~10sec!"
	L.guardians_bar = "Guardians incoming!"

	L.icon = "Raid Icon"
	L.icon_desc = "Place a raid icon on people with Detonate Mana."
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Kelthuzad")
mod.locale = L

L:RegisterTranslations("koKR", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "켈투자드의 방",

	start_trigger = "어둠의 문지기와 하수인, 그리고 병사들이여! 나 켈투자드가 부르니 명을 받들라!",
	start_warning = "켈투자드 전투 시작! 약 3분 30초 후 활동!",
	start_bar = "2 단계",

	phase = "단계",
	phase_desc = "단계 변경을 알립니다.",
	phase2_trigger1 = "자비를 구하라!", -- CHECK
	phase2_trigger2 = "마지막 숨이나 쉬어라!",
	phase2_trigger3 = "최후를 맞이하라!",
	phase2_warning = "2 단계, 켈투자드!",
	phase2_bar = "켈투자드 활동!",
	phase3_soon_warning = "잠시 후 3 단계!",
	phase3_trigger = "주인님, 도와주소서!",
	phase3_warning = "3 단계, 약 15초 이내 수호자 등장!",

	mc_message = "정신 지배: %s",
	mc_warning = "정신 지배 대기시간 종료 - 곧 사용!",
	mc_nextbar = "~정배 대기 시간",

	frostblast_bar = "냉기 작렬 가능",
	frostblast_soon_message = "약 5초 이내 냉기 작렬 가능!",

	detonate_other = "마나 폭발 - %s",
	detonate_possible_bar = "폭발 가능",
	detonate_warning = "약 5초 이내 마나 폭발 가능!",

	guardians = "수호자 생성",
	guardians_desc = "3 단계의 수호자 소환을 알립니다.",
	guardians_trigger = "좋다. 얼어붙은 땅의 전사들이여, 일어나라! 너희에게 싸울 것을 명하노라. 날 위해 죽고, 날 위해 죽여라! 한 놈도 살려두지 마라!",
	guardians_warning = "10초 이내 수호자 등장!",
	guardians_bar = "수호자 등장!",

	icon = "전술 표시",
	icon_desc = "마나 폭발 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("deDE", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzads Gemach",

	start_trigger = "Lakaien, Diener, Soldaten der eisigen Finsternis! Folgt dem Ruf von Kel'Thuzad!",
	start_warning = "Kel'Thuzad gestartet! ~3:30 min, bis er aktiv wird!",
	start_bar = "Phase 2",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_trigger1 = "Betet um Gnade!",
	phase2_trigger2 = "Schreiend werdet ihr diese Welt verlassen!",
	phase2_trigger3 = "Euer Ende ist gekommen!",
	phase2_warning = "Phase 2, Kel'Thuzad kommt!",
	phase2_bar = "Kel'Thuzad aktiv",
	phase3_soon_warning = "Phase 3 bald!",
	phase3_trigger = "Meister, ich benötige Beistand.",
	phase3_warning = "Phase 3, Wächter in ~15 sek!",

	mc_message = "Gedankenkontrolle: %s",
	mc_warning = "Gedankenkontrolle bald!",
	mc_nextbar = "~Gedankenkontrolle",

	frostblast_bar = "~Frostschlag",
	frostblast_soon_message = "Frostschlag in ~5 sek!",

	detonate_other = "Detonierendes Mana: %s",
	detonate_possible_bar = "~Detonierendes Mana",
	detonate_warning = "Detonierendes Mana in 5 sek!",

	guardians = "Wächter",
	guardians_desc = "Warnt vor den Wächtern von Eiskrone in Phase 3.",
	guardians_trigger = "Wohlan, Krieger der Eisigen Weiten, erhebt euch! Ich befehle euch für euren Meister zu kämpfen, zu töten und zu sterben! Keiner darf überleben!",
	guardians_warning = "Wächter in ~10 sek!",
	guardians_bar = "Wächter kommen",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Detonierendes Mana gewirkt wird (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "克尔苏加德的大厅",

	start_trigger = "仆从们，侍卫们，隶属于黑暗与寒冷的战士们！听从克尔苏加德的召唤！",
	start_warning = "战斗开始，约3分30秒后，克尔苏加德激活！",
	start_bar = "<第二阶段>",

	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	phase2_trigger1 = "祈祷我的慈悲吧！",
	phase2_trigger2 = "呼出你的最后一口气！",
	phase2_trigger3 = "你的末日临近了！",
	phase2_warning = "第二阶段 - 克尔苏加德！",
	phase2_bar = "<激活克尔苏加德>",
	phase3_soon_warning = "即将 第三阶段！",
	phase3_trigger = "主人，我需要帮助！",
	phase3_warning = "第三阶段 - 约15秒后，寒冰皇冠卫士出现！",

	mc_message = "克尔苏加德锁链：>%s<！",
	mc_warning = "即将 克尔苏加德锁链！",
	mc_nextbar = "<下一克尔苏加德锁链>",

	frostblast_bar = "<可能 冰霜冲击>",
	frostblast_soon_message = "约5秒后，可能冰霜冲击！",

	detonate_other = "自爆法力：>%s<！",
	detonate_possible_bar = "<可能 自爆法力>",
	detonate_warning = "约5秒后，自爆法力！",

	guardians = "寒冰皇冠卫士",
	guardians_desc = "当第三阶段召唤寒冰皇冠卫士时发出警报。",
	guardians_trigger = "很好，冰荒废土的战士们，起来吧！我命令你们为主人而战斗，杀戮，直到死亡！一个活口都不要留！",
	guardians_warning = "约10秒后，寒冰皇冠卫士出现！",
	guardians_bar = "<寒冰皇冠卫士出现>",

	icon = "团队标记",
	icon_desc = "为中了自爆法力的玩家打上团队标记。（需要权限）",
} end )


L:RegisterTranslations("zhTW", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "科爾蘇加德之間",

	start_trigger = "僕從們，侍衛們，隸屬於黑暗與寒冷的戰士們!聽從科爾蘇加德的召喚!",
	start_warning = "戰鬥開始，約3分30秒後，科爾蘇加德進入戰鬥！",
	start_bar = "<第二階段>",

	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	phase2_trigger1 = "祈禱我的慈悲吧!",
	phase2_trigger2 = "呼出你的最後一口氣!",
	phase2_trigger3 = "你的末日臨近了!",
	phase2_warning = "第二階段 - 科爾蘇加德！",
	phase2_bar = "<科爾蘇加德進入戰鬥>",
	phase3_soon_warning = "即將 第三階段！",
	phase3_trigger = "主人，我需要幫助!",
	phase3_warning = "第三階段開始， 約15秒後，寒冰皇冠守衛者出現！",

	mc_message = "科爾蘇加德之鍊：>%s<！",
	mc_warning = "即將 科爾蘇加德之鍊！",
	mc_nextbar = "<下一科爾蘇加德之鍊>",

	frostblast_bar = "<可能 冰霜衝擊>",
	frostblast_soon_message = "約5秒後，可能冰霜衝擊！",

	detonate_other = "爆裂法力：>%s<！",
	detonate_possible_bar = "<可能 爆裂法力>",
	detonate_warning = "約5秒後，爆裂法力！",

	guardians = "寒冰皇冠守護者",
	guardians_desc = "當第三階段召喚寒冰皇冠守護者時發出警報。",
	guardians_trigger = "非常好，凍原的戰士們，起來吧!我命令你們作戰，為你們的主人殺戮或獻身吧!不要留下活口!",
	guardians_warning = "約10秒後，寒冰皇冠守護者出現！",
	guardians_bar = "<寒冰皇冠守護者出現>",

	icon = "團隊標記",
	icon_desc = "為中了爆裂法力的玩家打上團隊標記。（需要權限）",
} end )

L:RegisterTranslations("frFR", function() return {
	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Appartements de Kel'Thuzad",

	start_trigger = "Serviteurs, valets et soldats des ténèbres glaciales ! Répondez à l'appel de Kel'Thuzad !",
	start_warning = "Kel'Thuzad engagé ! ~3 min. 30 sec. avant qu'il ne soit actif !",
	start_bar = "Phase 2",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase2_trigger1 = "Faites vos prières !",
	phase2_trigger2 = "Hurlez et expirez !",
	phase2_trigger3 = "Votre fin est proche !",
	phase2_warning = "Phase 2, arrivée de Kel'Thuzad !",
	phase2_bar = "Kel'Thuzad actif !",
	phase3_soon_warning = "Phase 3 imminente !",
	phase3_trigger = "Maître, j'ai besoin d'aide !",
	phase3_warning = "Phase 3, gardiens dans ~15 sec. !",

	mc_message = "Contrôle mental : %s",
	mc_warning = "Contrôles mentaux imminents !",
	mc_nextbar = "~Contrôles mentaux",

	frostblast_bar = "Trait de givre probable",
	frostblast_soon_message = "Trait de givre probable dans ~5 sec. !",

	detonate_other = "Détoner mana : %s",
	detonate_possible_bar = "~Prochain Détoner",
	detonate_warning = "Prochain Faire détoner mana dans 5 sec. !",

	guardians = "Apparition des gardiens",
	guardians_desc = "Prévient de l'arrivée des gardiens en phase 3.",
	guardians_trigger = "Très bien. Guerriers des terres gelées, relevez-vous ! Je vous ordonne de combattre, de tuer et de mourir pour votre maître ! N'épargnez personne !",
	guardians_warning = "Arrivée des gardiens dans ~10 sec. !",
	guardians_bar = "Arrivée des gardiens !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par Faire détoner mana (nécessite d'être assistant ou mieux).",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnRegister()
	-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnBossDisable()
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
end

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Fizzure", 27810)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FrostBlast", 27808)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Detonate", 27819)
	self:AddCombatListener("SPELL_AURA_APPLIED", "MC", 28410)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self.warnedAboutPhase3Soon = nil

	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ZONE_CHANGED_INDOORS(msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or BigWigs:IsModuleActive(boss) then return end
	-- Activate the Kel'Thuzad mod!
	BigWigs:EnableModule(boss)
end

function mod:Fizzure(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

local function fbWarn(spellId, spellName)
	mod:TargetMessage(spellName, fbTargets, "Important", spellId, "Alert")
	mod:DelayedMessage(32, L["frostblast_soon_message"], "Attention")
	mod:Bar(L["frostblast_bar"], 37, spellId)
end

function mod:FrostBlast(player, spellId, _, _, spellName)
	fbTargets[#fbTargets + 1] = player
	self:ScheduleEvent("BWFrostBlastWarn", fbWarn, 0.4, spellId, spellName)
end

function mod:Detonate(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Personal", spellId, "Alert")
	self:Whisper(player, spellName)
	self:PrimaryIcon(player, "icon")
	self:Bar(L["detonate_other"]:format(player), 5, spellId)
	self:Bar(L["detonate_possible_bar"], 20, spellId)
	self:DelayedMessage(15, L["detonate_warning"], "Attention")
end

local function mcWarn(spellId)
	local spellName = GetSpellInfo(605) -- Mind Control
	mod:TargetMessage(spellName, mcTargets, "Important", spellId, "Alert")
	mod:Bar(spellName, 20, 28410)
	mod:DelayedMessage(68, L["mc_warning"], "Urgent")
	mod:Bar(L["mc_nextbar"], 68, spellId)
end

function mod:MC(player, spellId)
	mcTargets[#mcTargets + 1] = player
	self:ScheduleEvent("BWMCWarn", mcWarn, 0.5, spellId)
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end

	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 40 and health <= 43 and not self.warnedAboutPhase3Soon then
			self:Message(L["phase3_soon_warning"], "Attention")
			self.warnedAboutPhase3Soon = true
		elseif health > 60 and self.warnedAboutPhase3Soon then
			self.warnedAboutPhase3Soon = nil
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.phase and msg == L["start_trigger"] then
		self:Message(L["start_warning"], "Attention")
		self:Bar(L["start_bar"], 215, "Spell_Fire_FelImmolation")
		wipe(mcTargets)
		wipe(fbTargets)
		self:TriggerEvent("BigWigs_HideProximity", self)
	elseif msg == L["phase2_trigger1"] or msg == L["phase2_trigger2"] or msg == L["phase2_trigger3"] then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_StopBar", self, L["start_bar"])
			self:Message(L["phase2_warning"], "Important")
			self:Bar(L["phase2_bar"], 15, "Spell_Shadow_Charm")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_warning"], "Attention")
	elseif self.db.profile.guardians and msg == L["guardians_trigger"] then
		self:Message(L["guardians_warning"], "Important")
		self:Bar(L["guardians_bar"], 10, 28866)
	end
end

