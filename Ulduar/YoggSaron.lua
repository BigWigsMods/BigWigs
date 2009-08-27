----------------------------------
--      Module Declaration      --
----------------------------------

local sara = BB["Sara"]
local boss = BB["Yogg-Saron"]
local brain = BB["Brain of Yogg-Saron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
--Sara = 33134, Yogg brain = 33890
mod.guid = 33288 --Yogg
mod.toggleOptions = {"phase", 63050, 63120, "icon", -1, 62979, -1, "tentacle" , 63830, 63802, 64125, "portal", "weakened", 64059, -1, 64189, 64465, "empowericon", 64163, "berserk", "bosskill"}
mod.consoleCmd = "Yogg"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local guardianCount = 1
local crusherCount = 1
local pName = UnitName("player")
local UnitGUID = _G.UnitGUID
local GetNumRaidMembers = _G.GetNumRaidMembers
local fmt = _G.string.format
local guid = nil

local madnessWarningID = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["Crusher Tentacle"] = true,
	["The Observation Ring"] = true,

	phase = "Phase",
	phase_desc = "Warn for phase changes.",
	engage_warning = "Phase 1",
	engage_trigger = "^The time to",
	phase2_warning = "Phase 2",
	phase2_trigger = "^I am the lucid dream",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Look upon the true face",

	portal = "Portal",
	portal_desc = "Warn for Portals.",
	portal_trigger = "Portals open into %s's mind!",
	portal_message = "Portals open!",
	portal_bar = "Next portals",

	sanity_message = "You're going insane!",

	weakened = "Stunned",
	weakened_desc = "Warn when Yogg-saron becomes stunned.",
	weakened_message = "%s is stunned!",
	weakened_trigger = "The illusion shatters and a path to the central chamber opens!",

	madness_warning = "Madness in 5sec!",
	malady_message = "Malady: %s",

	tentacle = "Crusher Tentacle",
	tentacle_desc = "Warn for Crusher Tentacle spawn.",
	tentacle_message = "Crusher %d!",

	link_warning = "You are linked!",

	gaze_bar = "~Gaze Cooldown",
	empower_bar = "~Empower Cooldown",

	insane_message = "Insane: %s",
	guardian_message = "Guardian %d!",

	empowericon = "Empower Icon",
	empowericon_desc = "Place a skull on the Immortal Guardian with Empowering Shadows.",
	empowericon_message = "Empower Faded!",

	roar_warning = "Roar in 5sec!",
	roar_bar = "Next Roar",

	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Malady of the Mind. (requires promoted or higher)",
} end )

L:RegisterTranslations("ruRU", function() return {
	["Crusher Tentacle"] = "Тяжелое щупальце",
	["The Observation Ring"] = "Круг Наблюдения",

	phase = "Фазы",
	phase_desc = "Сообщать о смене фаз.",
	engage_warning = "1-ая фаза",
	engage_trigger = "^Скоро мы сразимся с главарем этих извергов!",
	phase2_warning = "2-ая фаза",
	phase2_trigger = "^Я – это сон наяву",
	phase3_warning = "3-ая фаза",
	phase3_trigger = "^ПАДИТЕ НИЦ ПЕРЕД БОГОМ СМЕРТИ!",

	portal = "Портал",
	portal_desc = "Сообщать о портале.",
	portal_trigger = "В сознание |3-1(%s) открываются порталы!",
	portal_message = "Порталы открыты!",
	portal_bar = "Следующий портал",

	sanity_message = "Вы теряете рассудок!",

	weakened = "Оглушение",
	weakened_desc = "Сообщать, когда Йогг-Сарон производит оглушение.",
	weakened_message = "%s оглушен!",
	weakened_trigger = "Иллюзия разрушена и путь в центральную комнату открыт!",

	madness_warning = "Помешательство через 5сек!",
	malady_message = "Болезнь у: |3-1(%s)",

	tentacle = "Тяжелое щупальце",
	tentacle_desc = "Сообщать о появлении тяжелого щупальца.",
	tentacle_message = "Щупальце %d!",

	link_warning = "У вас схожее мышление!",

	gaze_bar = "~Взгляд безумца",
	empower_bar = "~Сгущение тьмы",

	empowericon = "Иконка сгущения тьмы",
	empowericon_desc = "Помечать черепом Бессмертного стража со сгущением тьмы.",
	empowericon_message = "Сгущение тьмы закончилось!",

	roar_warning = "Крик через 5 сек!",
	roar_bar = "Следущий крик",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока с душевной болезнью или находящегося под контролем разума (необходимо обладать промоутом).",
} end )

L:RegisterTranslations("koKR", function() return {
	["Crusher Tentacle"] = "분쇄의 촉수",
	["The Observation Ring"] = "관찰 지구",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^짐승의 대장을 칠 때가 곧 다가올 거예요",
	phase2_warning = "2 단계",
	phase2_trigger = "^나는, 살아 있는 꿈이다",
	phase3_warning = "3 단계",
	phase3_trigger = "^죽음의 진정한 얼굴을 보아라",

	portal = "차원문",
	portal_desc = "차원문을 알립니다.",
	portal_trigger = "%s의 마음속으로 가는 차원문이 열립니다!",
	portal_message = "차원문 열림!",
	portal_bar = "다음 차원문",

	sanity_message = "당신의 이성 위험!",

	weakened = "기절",
	weakened_desc = "기절 상태를 알립니다.",
	weakened_message = "%s 기절!",
	weakened_trigger = "환상이 부서지며, 중앙에 있는 방으로 가는 길이 열립니다!",

	madness_warning = "5초 후 광기 유발!",
	malady_message = "병든 정신: %s",

	tentacle = "촉수 소환",
	tentacle_desc = "촉수 소환을 알립니다.",
	tentacle_message ="분쇄의 촉수(%d)",

	link_warning = "당신은 두뇌의 고리!",

	gaze_bar = "~시선 대기시간",
	empower_bar = "~강화 대기시간",

	insane_message = "정신 지배: %s",
	guardian_message = "수호자 소환 %d!",

	empowericon = "암흑 강화 아이콘",
	empowericon_desc = "암흑 강화에 걸린 수호병에게 해골 표시를 지정합니다. (승급자 이상 권한 필요)",
	empowericon_message = "암흑 강화 사라짐!",

	roar_warning = "5초 후 포효!",
	roar_bar = "다음 포효",

	icon = "전술 표시",
	icon_desc = "병든 정신에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	["Crusher Tentacle"] = "Tentacule écraseur",
	["The Observation Ring"] = "le cercle d'observation",

	phase = "Phase",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	engage_trigger = "^Il sera bientôt temps de",
	phase2_warning = "Phase 2",
	phase2_trigger = "^Je suis le rêve éveillé",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Contemplez le vrai visage de la mort",

	portal = "Portail",
	portal_desc = "Prévient de l'arrivée des portails.",
	portal_trigger = "Des portails s'ouvrent sur l'esprit |2 %s !",
	portal_message = "Portails ouverts !",
	portal_bar = "Prochains portails",

	sanity_message = "Vous allez devenir fou !",

	weakened = "Étourdi",
	weakened_desc = "Prévient quand Yogg-Saron est étourdi.",
	weakened_message = "%s est étourdi !",
	weakened_trigger = "L'illusion se brise et un chemin s'ouvre vers la salle centrale !",

	madness_warning = "Susciter la folie dans 5 sec. !",
	malady_message = "Mal : %s",

	tentacle = "Tentacule écraseur",
	tentacle_desc = "Prévient quand un Tentacule écraseur apparaît.",
	tentacle_message = "Écraseur %d !",

	link_warning = "Votre cerveau est lié !",

	gaze_bar = "~Recharge Regard",
	empower_bar = "~Recharge Renforcement",

	insane_message = "Emprise : %s",
	guardian_message = "Gardien %d !",

	empowericon = "Renforcement - Icône",
	empowericon_desc = "Place un crâne sur le Gardien immortel ayant Renforcement des ombres.",
	empowericon_message = "Renforcement terminé !",

	roar_warning = "Rugissement dans 5 sec. !",
	roar_bar = "Prochain Rugissement",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Mal de la raison (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	["Crusher Tentacle"] = "Schmettertentakel",
	["The Observation Ring"] = "Der Beobachtungsring",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "^Bald ist die Zeit",
	phase2_warning = "Phase 2",
	phase2_trigger = "^Ich bin der strahlende Traum",
	phase3_warning = "Phase 3",
	phase3_trigger = "^Erblickt das wahre Antlitz des Todes",

	portal = "Portale",
	portal_desc = "Warnt, wenn Portale erscheinen.",
	portal_trigger = "Portale öffnen sich im Geist von %s!",
	portal_message = "Portale offen!",
	portal_bar = "Nächsten Portale",

	sanity_message = "DU wirst verrückt!",

	weakened = "Geschwächt",
	weakened_desc = "Warnt, wenn Yogg-Saron geschwächt ist.",
	weakened_message = "%s ist geschwächt!",
	weakened_trigger = "Die Illusion fällt in sich zusammen und der Weg in den zentralen Raum wird frei!",

	madness_warning = "Wahnsinn in 5 sek!",
	malady_message = "Geisteskrank: %s!",

	tentacle = "Schmettertentakel",
	tentacle_desc = "Warnung und Timer für das Auftauchen der Schmettertentakel.",
	tentacle_message = "Schmettertentakel %d!",

	link_warning = "DU bist verbunden!",

	gaze_bar = "~Blick",
	empower_bar = "~Machtvolle Schatten",

	insane_message = "Gedankenkontrolle: %s!",
	guardian_message = "Wächter %d!",

	empowericon = "Schatten-Symbol",
	empowericon_desc = "Platziert einen Totenkopf über der Unvergänglichen Wache, die von Machtvolle Schatten betroffen ist (benötigt Assistent oder höher).",
	empowericon_message = "Schatten verblasst!",

	roar_warning = "Gebrüll in 5 sek!",
	roar_bar = "Nächstes Gebrüll",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Geisteskrankheit oder Gedanken beherrschen betroffen sind (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	["Crusher Tentacle"] = "重压触须",
--	["The Observation Ring"] = true,

	phase = "阶段",
	phase_desc = "当阶段改变发出警报。",
	engage_warning = "第一阶段！",
--	engage_trigger = "^The time to",
	phase2_warning = "第二阶段！",
--	phase2_trigger = "^I am the lucid dream",
	phase3_warning = "第三阶段！",
--	phase3_trigger = "^Look upon the true face",

	portal = "传送门",
	portal_desc = "当传送门时发出警报。",
--	portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "开启传送门！",
	portal_bar = "<下一传送门>",

	sanity_message = ">你< 即将疯狂！",

	weakened = "昏迷",
	weakened_desc = "当尤格-萨隆昏迷时发出警报。",
	weakened_message = "昏迷：>%s<！",
--	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness_warning = "5秒后，疯狂诱导！",
	malady_message = "心灵疾病：>%s<！",

	tentacle = "粉碎触须",
	tentacle_desc = "当粉碎触须出现时发出警报。",
	tentacle_message = "粉碎触须：>%d<！",

	link_warning = ">你< 心智链接！",

	gaze_bar = "<疯乱凝视 冷却>",
	empower_bar = "<暗影信标 冷却>",

	insane_message = "统御意志：>%s<！",
	guardian_message = "召唤卫士：>%d<！",

	empowericon = "暗影信标标记",
	empowericon_desc = "为中了暗影信标的不朽守护者打上骷髅标记。（需要权限）.",
	empowericon_message = "暗影信标 消退！",

	roar_warning = "5秒后，震耳咆哮！",
	roar_bar = "<下一震耳咆哮>",

	icon_desc = "为中了心灵疾病的队员打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	["Crusher Tentacle"] = "粉碎觸手",
	["The Observation Ring"] = "觀察之環",

	phase = "階段",
	phase_desc = "當階段改變發出警報。",
	engage_warning = "第一階段",
	engage_trigger = "我們即將有機會打擊怪物的首腦!現在將你的憤怒與仇恨貫注在他的爪牙上!",
	phase2_warning = "第二階段！",
	phase2_trigger = "我是清醒的夢境。",
	phase3_warning = "第三階段！",
	phase3_trigger = "在我的真身面前顫抖吧。", --看看死亡的真實面貌，瞭解你們的末日降臨了!

	portal = "傳送門",
	portal_desc = "當傳送門時發出警報。",
	portal_trigger = "傳送門開啟進入%s的心靈!",
	portal_message = "開啟傳送門！",
	portal_bar = "<下一傳送門>",

	sanity_message = ">你< 即將瘋狂！！",

	weakened = "昏迷",
	weakened_desc = "當尤格薩倫昏迷時發出警報。",
	weakened_message = "昏迷：>%s<！",
	weakened_trigger = "幻影粉碎，然後中央房間的道路就打開了!",

	madness_warning = "5秒後，瘋狂誘陷！",
	malady_message = "心靈缺陷：>%s<！",

	tentacle = "粉碎觸手",
	tentacle_desc = "當粉碎觸手出現時發出警報。",
	tentacle_message = "粉碎觸手：>%d<！",

	link_warning = ">你< 腦波連結！",

	gaze_bar = "<癡狂凝視 冷卻>",
	empower_bar = "<暗影信標 冷卻>",

	insane_message = "支配心靈：>%s<！",
	guardian_message = "尤格薩倫守護者：>%d<！ ",

	empowericon = "暗影信標標記",
	empowericon_desc = "為中了暗影信標的不朽守護者打上骷髏標記。（需要權限）",
	empowericon_message = "暗影信標 消失！",

	roar_warning = "5秒後，震耳咆哮！",
	roar_bar = "<下一震耳咆哮>",

	icon_desc = "為中了心靈缺陷的隊員打上團隊標記。（需要權限）",
} end )

-- We need to add the player name to block those extremely stupid sanity loss
-- warnings blizz puts in the emote frame. The source for those messages USED
-- TO BE the boss, but Blizzard CHANGED IT to the player himself, for some
-- insanely crappy, unknown, stupid reason.
mod.enabletrigger = {boss, sara, brain, pName}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Roar", 64189)
	self:AddCombatListener("SPELL_CAST_START", "Madness", 64059)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Empower", 64465)
	self:AddCombatListener("SPELL_AURA_APPLIED", "EmpowerIcon", 64465)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveEmpower", 64465)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Tentacle", 64144)
	--self:AddCombatListener("SPELL_AURA_APPLIED", "Fervor", 63138)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Squeeze", 64125, 64126)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Linked", 63802)
	self:AddCombatListener("SPELL_AURA_REMOVED", "Gaze", 64163)
	self:AddCombatListener("SPELL_AURA_APPLIED", "CastGaze", 64163)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Malady", 63830, 63881)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveMalady", 63830, 63881)
	-- 63120 is the MC when you go insane in p2/3.
	self:AddCombatListener("SPELL_AURA_APPLIED", "Insane", 63120)
	self:AddCombatListener("SPELL_AURA_REMOVED_DOSE", "SanityDecrease", 63050)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "SanityIncrease", 63050)
	self:AddCombatListener("SPELL_SUMMON", "Guardian", 62979)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
	guid = nil
end

function mod:VerifyEnable()
	local z = GetSubZoneText()
	if z and z == L["The Observation Ring"] then return false end
	return true
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fervor(player, spellId)
	self:Whisper(player, "DEBUFF, watch out!", true)
end

do
	local warned = {}
	function mod:SanityIncrease(player, spellId, _, _, spellName)
		if not warned[player] then return end
		local _, _, _, stack = UnitDebuff(player, spellName)
		if stack and stack > 70 then warned[player] = nil end
	end
	function mod:SanityDecrease(player, spellId, _, _, spellName)
		if warned[player] then return end
		local _, _, _, stack = UnitDebuff(player, spellName)
		if not stack then return end
		if player == pName then
			if stack > 40 then return end
			self:IfMessage(L["sanity_message"], "Personal", spellId)
			warned[player] = true
		elseif stack < 31 then
			self:Whisper(player, L["sanity_message"], true)
			warned[player] = true
		end
	end
end

function mod:Guardian(_, spellId)
	self:IfMessage(L["guardian_message"]:format(guardianCount), "Positive", spellId)
	guardianCount = guardianCount + 1
end

function mod:Insane(player, spellId)
	self:TargetMessage(L["insane_message"], player, "Attention", spellId)
end

function mod:Tentacle(_, spellId, source, _, spellName)
	-- Crusher Tentacle (33966) 50 sec
	-- Corruptor Tentacle (33985) 25 sec
	-- Constrictor Tentacle (33983) 20 sec
	if source == L["Crusher Tentacle"] and db.tentacle then
		self:IfMessage(L["tentacle_message"]:format(crusherCount), "Important", 64139)
		crusherCount = crusherCount + 1
		self:Bar(L["tentacle_message"]:format(crusherCount), 55, 64139)
	end
end

function mod:Roar(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(L["roar_bar"], 60, spellId)
	self:DelayedMessage(55, L["roar_warning"], "Attention")
end

function mod:Malady(player)
	self:Icon(player, "icon")
end

function mod:RemoveMalady(player)
	self:TriggerEvent("BigWigs_RemoveRaidIcon")
end

function mod:Squeeze(player, spellId, _, _, spellName)
	self:TargetMessage(spellName, player, "Positive", spellId)
end

function mod:Linked(player, spellId)
	if player == pName then
		self:LocalMessage(L["link_warning"], "Personal", spellId, "Alarm")
	end
end

function mod:Gaze(_, spellId, _, _, spellName)
	self:Bar(L["gaze_bar"], 9, spellId)
end

function mod:CastGaze(_, spellId, _, _, spellName)
	self:Bar(spellName, 4, spellId)
end

function mod:Madness(_, spellId, _, _, spellName)
	self:Bar(spellName, 60, 64059)
	madnessWarningID = self:DelayedMessage(55, L["madness_warning"], "Urgent")
end

function mod:Empower(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
	self:Bar(L["empower_bar"], 46, spellId)
end

function mod:RemoveEmpower()
	if db.empowericon then
		self:IfMessage(L["empowericon_message"], "Positive", 64465)
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
	end
end

local function scanTarget()
	local target
	if UnitGUID("target") == guid then
		target = "target"
	elseif UnitGUID("focus") == guid then
		target = "focus"
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unitid = fmt("%s%d%s", "raid", i, "target")
			if UnitGUID(unitid) == guid then
				target = unitid
				break
			end
		end
	end
	if target then
		SetRaidTarget(target, 8)
		mod:CancelScheduledEvent("BWGetEmpowerTarget")
	end
end

function mod:EmpowerIcon(...)
	if not IsRaidLeader() and not IsRaidOfficer() then return end
	if not db.empowericon then return end
	guid = select(9, ...)
	self:ScheduleRepeatingEvent("BWGetEmpowerTarget", scanTarget, 0.1)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["portal_trigger"] and db.portal then
		self:IfMessage(L["portal_message"], "Positive", 35717)
		self:Bar(L["portal_bar"], 90, 35717)
	elseif msg == L["weakened_trigger"] and db.weakened then
		self:IfMessage(L["weakened_message"]:format(boss), "Positive", 50661) --50661, looks like a weakened :)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
		guardianCount = 1
		if db.phase then
			self:IfMessage(L["engage_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg:find(L["phase2_trigger"]) then
		phase = 2
		crusherCount = 1
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Attention")
		end
		if db.portal then
			self:Bar(L["portal_bar"], 78, 35717)
		end
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:CancelScheduledEvent(madnessWarningID)

		local madness = GetSpellInfo(64059)
		self:TriggerEvent("BigWigs_StopBar", madness)
		self:TriggerEvent("BigWigs_StopBar", L["tentacle_message"]:format(crusherCount))
		self:TriggerEvent("BigWigs_StopBar", L["portal_bar"])

		if db.phase then
			self:IfMessage(L["phase3_warning"], "Important", nil, "Alarm")
		end
		if self:GetOption(64465) then
			self:Bar(L["empower_bar"], 46, 64486)
		end
	end
end

