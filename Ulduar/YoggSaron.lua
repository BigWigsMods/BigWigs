----------------------------------
--      Module Declaration      --
----------------------------------

local sara = BB["Sara"]
local boss = BB["Yogg-Saron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = {"sara", "boss"}
--Sara = 33134, Yogg brain = 33890
mod.guid = 33288 --Yogg
mod.toggleoptions = {"phase", "guardian", "mindcontrol", "link", "squeeze", "portal", "weakened", "madness", "malady", "ray", "tentacle", -1, "empower", "gaze", "icon", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local squeezeName = GetSpellInfo(64126)
local linkedName = GetSpellInfo(63802)
local linked = {}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["Crusher Tentacle"] = true,

	cmd = "YoggSaron",

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
	portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "Portals open!",
	portal_bar = "Next Portal",

	weakened = "Weakened",
	weakened_desc = "Warn for Weakened State.",
	weakened_message = "%s is weakened!",
	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness = "Induce Madness",
	madness_desc = "Show Timer for Induce Madness.",
	madness_warning = "Induce Madness in 5sec!",

	malady = "Malady of the Mind",
	malady_desc = "Warn when a player has Malady of the Mind.",
	malady_message = "Malady: %s",
	--malady_bar = "~Next Malady",

	tentacle = "Tentacle spawn",
	tentacle_desc = "Warn for Tentacle spawn.",

	ray = "Death Ray",
	ray_desc = "Warn when Sara casts a Death Ray.",
	ray_message = "Death Ray!",
	ray_bar = "~Next Death Ray",

	squeeze = squeezeName,
	squeeze_desc = "Warn which player has Squeeze.",
	squeeze_message = squeezeName .. ": %s",

	link = linkedName,
	link_desc = "Warn which players are linked.",
	link_message = linkedName .. ": %s",

	gaze = "Lunatic Gaze",
	gaze_desc = "Warn when Yogg-Saron gains Lunatic Gaze.",
	gaze_message = "Lunatic Gaze!",
	gaze_bar = "~Gaze Cooldown",

	empower = "Empowering Shadows",
	empower_desc = "Warn for Empowering Shadows.",
	empower_message = "Empowering Shadows!",
	empower_bar = "~Empower Cooldown",

	mindcontrol = "Mind Control",
	mindcontrol_desc = "Warn who is Mind Controlled.",
	mindcontrol_message = "Mind Control: %s",
	
	guardian = "Guardian spawn", --phase 1
	guardian_desc = "Warn when the Guardian of Yogg-Saron spawns.",
	guardian_message = "Guardian spawn!",

	icon = "Place Icon",
	icon_desc = "Place a Raid Icon on the player with Malady of the Mind. (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	["Crusher Tentacle"] = "분쇄의 촉수",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	engage_warning = "1 단계",
	engage_trigger = "^짐승의",	--check
	phase2_warning = "2 단계",
	phase2_trigger = "^나는 살아있는 꿈이다",	--check
	phase3_warning = "3 단계",
	phase3_trigger = "^죽음의 진정한 얼굴을 보아라",	--check

	portal = "차원문",
	portal_desc = "차원문을 알립니다.",
	--portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "차원문 열림!",
	portal_bar = "다음 차원문",

	weakened = "약화",
	weakened_desc = "약화 상태를 알립니다.",
	weakened_message = "%s 약화!",
	--weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness = "광기 유발",
	madness_desc = "광기 유발의 타이머를 표시합니다.",
	madness_warning = "5초 후 광기 유발!",

	ray = "죽음의 광선",
	ray_desc = "죽음의 광선 시전을 알립니다.",
	ray_message = "죽음의 광선!",
	ray_bar = "~다음 광선",

	malady = "병든 정신",
	malady_desc = "병든 정신에 걸린 플레이어를 알립니다.",
	malady_message = "병든 정신: %s",
	--malady_bar = "~다음 병든 정신",

	tentacle = "촉수 소환",
	tentacle_desc = "촉수 소환을 알립니다.",

	squeeze = squeezeName,
	squeeze_desc = "압착에 붙잡힌 플레이어를 알립니다.",

	link = linkedName,
	link_desc = "두뇌의 고리에 연결된 플레이어를 알립니다.",

	gaze = "광기의 시선",
	gaze_desc = "요그사론의 광기의 시선 획득을 알립니다.",
	gaze_message = "광기의 시선!",
	gaze_bar = "~시선 대기시간",

	empower = "암흑 강화",
	empower_desc = "암흑 강화를 알립니다.",
	empower_message = "암흑 강화!",
	empower_bar = "~강화 대기시간",
	
	mindcontrol = "정신 지배",
	mindcontrol_desc = "정신 지배에 걸린 플레이어를 알립니다.",
	mindcontrol_message = "정신 지배: %s",
	
	guardian = "수호자 소환", --phase 1
	guardian_desc = "요그사론의 수호자 소환을 알립니다.",
	guardian_message = "수호자 소환!",
	
	icon_desc = "병든 정신에 걸린 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 스샷등을 http://cafe.daum.net/SCU15 통해 알려주세요.",
} end )

L:RegisterTranslations("frFR", function() return {
	--["Crusher Tentacle"] = true,

	phase = "Phase",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	engage_warning = "Phase 1",
	engage_trigger = "^Il sera bientôt temps de", -- à vérifier
	phase2_warning = "Phase 2",
	phase2_trigger = "^Je suis le rêve éveillé", -- à vérifier
	phase3_warning = "Phase 3",
	phase3_trigger = "^Contemplez le vrai visage de la mort", -- à vérifier

	portal = "Portail",
	portal_desc = "Prévient de l'arrivée des portails.",
	portal_trigger = "Portals open into Yogg-Saron's mind!", -- à traduire (Des portails s'ouvrent dans l'esprit de Yogg-Saron !")
	portal_message = "Portails ouverts !",
	portal_bar = "Prochain portail",

	weakened = "Affaibli",
	weakened_desc = "Prévient quand Yogg-Saron est affaibli.",
	weakened_message = "%s est affaibli !",
	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!", -- à traduire (L'Illusion se brise et un passage vers la chambre centrale s'ouvre !)

	madness = "Susciter la folie",
	madness_desc = "Affiche le délai avant la fin de l'incantation de Susciter la folie.",
	madness_warning = "Susciter la folie dans 5 sec. !",

	malady = "Mal de la raison",
	malady_desc = "Prévient quand un joueur subit les effets d'un Mal de la raison.",
	malady_message = "Mal : %s",
	--malady_bar = "~Prochain Mal",

	tentacle = "Tentacule",
	tentacle_desc = "Prévient quand une tentacule apparaît.",

	ray = "Rayon mortel",
	ray_desc = "Prévient quand Sara incante un Rayon mortel.",
	ray_message = "Rayon mortel !",
	ray_bar = "~Prochain Rayon mortel",

	squeeze = squeezeName, -- doesn't appear in the dropdown menu if not mentioned here
	squeeze_desc = "Prévient quand un joueur subit les effets d'un Ecrasement.",
	squeeze_message = squeezeName .. " : %s",

	link = linkedName,
	link_desc = "Indique quels joueurs sont liées.",
	link_message = linkedName .. " : %s",

	gaze = "Regard lunatique",
	gaze_desc = "Prévient quand Yogg-Saron incante un Regard lunatique.",
	gaze_message = "Regard lunatique !",
	gaze_bar = "Recharge Regard",

	empower = "Renforcement des ombres",
	empower_desc = "Prévient de l'arrivée des Renforcements des ombres.",
	empower_message = "Renforcement des ombres !",
	empower_bar = "~Recharge Renforcement",
	
	--mindcontrol = "Mind Control",
	--mindcontrol_desc = "Warn who is Mind Controlled.",
	--mindcontrol_message = "Mind Control: %s",
	
	--guardian = "Guardian spawn", --phase 1
	--guardian_desc = "Warn when the Guardian of Yogg-Saron spawns.",
	--guardian_message = "Guardian spawn!",

	icon_desc = "Place une icône de raid sur la dernière personne affectée par un Mal de la raison (nécessite d'être assistant ou mieux).",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de donnees, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {
	--["Crusher Tentacle"] = true,

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	engage_warning = "Phase 1",
	engage_trigger = "^Bald ist die Zeit", -- needs verification!
	phase2_warning = "Phase 2",
	phase2_trigger = "^Ich bin der strahlende Traum", -- needs verification!
	phase3_warning = "Phase 3",
	phase3_trigger = "^Erblicket das wahre Antlitz des Todes", -- needs verification!

	portal = "Portale",
	portal_desc = "Warnt, wenn Portale erscheinen.",
	--portal_trigger = "Portals open into Yogg-Saron's mind!", -- NEED!
	portal_message = "Portale offen!",
	portal_bar = "Nächsten Portale",

	weakened = "Geschwächt",
	weakened_desc = "Warnt, wenn Yogg-Saron geschwächt ist.",
	weakened_message = "%s ist geschwächt!",
	--weakened_trigger = "The Illusion shatters and a path to the central chamber opens!", -- NEED!

	madness = "Wahnsinn hervorrufen",
	madness_desc = "Warnung und Timer für Wahnsinn hervorrufen.",
	madness_warning = "Wahnsinn hervorrufen in 5 sek!",

	--malady = "Malady of the Mind",
	--malady_desc = "Warn when a player has Malady of the Mind.",
	--malady_message = "Malady: %s",
	--malady_bar = "~Next Malady",

	--tentacle = "Tentacle spawn",
	--tentacle_desc = "Warn for Tentacle spawn.",

	ray = "Todesstrahl",
	ray_desc = "Warnung und Timer für Saras Todesstrahl.",
	ray_message = "Todesstrahl!",
	ray_bar = "~Nächster Todesstrahl",

	squeeze = squeezeName,
	squeeze_desc = "Warnt, welcher Spieler von Quetschen betroffen ist.",

	link = linkedName,
	link_desc = "Warnt, welche Spieler gehirnverbunden sind.",

	gaze = "Wahnsinniger Blick",
	gaze_desc = "Warnung und Timer für Wahnsinniger Blick.",
	gaze_message = "Wahnsinniger Blick!",
	gaze_bar = "~Wahnsinniger Blick",

	empower = "Machtvolle Schatten",
	empower_desc = "Warnung und Timer für Machtvolle Schatten.",
	empower_message = "Machtvolle Schatten!",
	--empower_trigger = "%s prepares to unleash Empowering Shadows!", -- NEED!
	empower_bar = "~Machtvolle Schatten",
	
	--mindcontrol = "Mind Control",
	--mindcontrol_desc = "Warn who is Mind Controlled.",
	--mindcontrol_message = "Mind Control: %s",
	
	--guardian = "Guardian spawn", --phase 1
	--guardian_desc = "Warn when the Guardian of Yogg-Saron spawns.",
	--guardian_message = "Guardian spawn!",

	--icon_desc = "Place a Raid Icon on the player with Malady of the Mind. (requires promoted or higher)",

	log = "|cffff0000"..boss.."|r: Für diesen Boss werden noch Daten benötigt, aktiviere bitte dein /combatlog oder das Addon Transcriptor und lass uns die Logs zukommen.",
} end )

L:RegisterTranslations("zhCN", function() return {
--	["Crusher Tentacle"] = true,

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

	weakened = "动摇的决心",
	weakened_desc = "当玩家中了动摇的决心时发出警报。",
	weakened_message = "动摇的决心：>%s<！",
--	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness = "Induce Madness",
	madness_desc = "显示Induce Madness计时器。",
	madness_warning = "5秒后，Induce Madness！",
	
	malady = "Malady of the Mind",
	malady_desc = "当玩家中了Malady of the Mind时发出警报。",
	malady_message = "Malady of the Mind：>%s<！",
	--malady_bar = "<下一Malady of the Mind>",
	
	tentacle = "触手出现",
	tentacle_desc = "当触手出现时发出警报。",
	
	ray = "死亡射线",
	ray_desc = "当萨拉施放死亡射线时发出警报。",
	ray_message = "死亡射线！",
	ray_bar = "<下一死亡射线>",

	squeeze = squeezeName,
	squeeze_desc = "当玩家中了Squeeze时发出警报。",
	squeeze_message = squeezeName .. "：>%s<！",

	link = linkedName,
	link_desc = "当玩家被Brain Link时发出警报。",
	link_message = linkedName .. "：>%s<！",

	gaze = "疯乱凝视",
	gaze_desc = "当尤格-萨隆获得疯乱凝视时发出警报。",
	gaze_message = "疯乱凝视！",
	gaze_bar = "<疯乱凝视 冷却>",

	empower = "Empowering Shadows",
	empower_desc = "当Empowering Shadows时发出警报。",
	empower_message = "Empowering Shadows！",
	empower_bar = "<Empower Shadows 冷却>",
	
	--mindcontrol = "Mind Control",
	--mindcontrol_desc = "Warn who is Mind Controlled.",
	--mindcontrol_message = "Mind Control: %s",
	
	--guardian = "Guardian spawn", --phase 1
	--guardian_desc = "Warn when the Guardian of Yogg-Saron spawns.",
	--guardian_message = "Guardian spawn!",

	icon_desc = "为中了Malady of the Mind的队员打上团队标记。（需要权限）",

	log = "|cffff0000"..boss.."|r：缺乏数据，请考虑开启战斗记录（/combatlog）或 Transcriptor 记录并提交战斗记录，谢谢！",
} end )

L:RegisterTranslations("zhTW", function() return {
--	["Crusher Tentacle"] = true,

	phase = "階段",
	phase_desc = "當階段改變發出警報。",
	engage_warning = "第一階段",
--	engage_trigger = "^The time to",
	phase2_warning = "第二階段！",
--	phase2_trigger = "^I am the lucid dream",
	phase3_warning = "第三階段！",
--	phase3_trigger = "^Look upon the true face",

	portal = "傳送門",
	portal_desc = "當傳送門時發出警報。",
--	portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "開啟傳送門！",
	portal_bar = "<下一傳送門>",

	weakened = "弱化決心",
	weakened_desc = "當玩家中了弱化決心時發出警報。",
	weakened_message = "弱化決心：>%s<！",
--	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness = "瘋狂誘陷",
	madness_desc = "顯示瘋狂誘陷計時條。",
	madness_warning = "5秒后，瘋狂誘陷！",
	
	malady = "心靈缺陷",
	malady_desc = "當玩家中了心靈缺陷時發出警報。",
	malady_message = "心靈缺陷：>%s<！",
	--malady_bar = "<下一心靈缺陷>",
	
	tentacle = "觸手出現",
	tentacle_desc = "當觸手出現時發出警報。",
	
	ray = "死亡射線",
	ray_desc = "當薩拉施放死亡射線時發出警報。",
	ray_message = "死亡射線!",
	ray_bar = "~Next 死亡射線",

	squeeze = squeezeName,
	squeeze_desc = "當玩家中了壓榨時發出警報。",
	squeeze_message = squeezeName .. "：>%s<！",

	link = linkedName,
	link_desc = "當玩家中了腦波連結時發出警報。",
	link_message = linkedName .. "：>%s<！",

	gaze = "癡狂凝視",
	gaze_desc = "當尤格薩倫獲得癡狂凝視時發出警報。",
	gaze_message = "癡狂凝視!",
	gaze_bar = "<癡狂凝視 冷卻>",

	empower = "暗影信標",
	empower_desc = "當暗影信標時發出警報。",
	empower_message = "暗影信標！",
	empower_bar = "<暗影信標 冷卻>",
	
	--mindcontrol = "Mind Control",
	--mindcontrol_desc = "Warn who is Mind Controlled.",
	--mindcontrol_message = "Mind Control: %s",
	
	--guardian = "Guardian spawn", --phase 1
	--guardian_desc = "Warn when the Guardian of Yogg-Saron spawns.",
	--guardian_message = "Guardian spawn!",
	
	icon_desc = "為中了心靈缺陷的隊員打上團隊標記。（需要權限）",

	log = "|cffff0000"..boss.."|r：缺乏數據，請考慮開啟戰斗記錄（/combatlog）或 Transcriptor 記錄并提交戰斗記錄，謝謝！",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Ray", 63891)
	self:AddCombatListener("SPELL_CAST_START", "Madness", 64059)
	self:AddCombatListener("SPELL_CAST_START", "Empower", 64465)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Tentacle", 64144)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Squeeze", 64126)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Linked", 63802)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Gaze", 64163)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Malady", 63830)
	self:AddCombatListener("SPELL_AURA_APPLIED", "MControl", 63042)
	self:AddCombatListener("SPELL_SUMMON", "Guardian", 62979)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile

	BigWigs:Print(L["log"])
	wipe(linked)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Guardian(_, spellID)
	if db.guardian then
		self:IfMessage(L["guardian_message"], "Attention", spellID)
	end
end

function mod:MControl(player, spellId)
	if db.mindcontrol then
		self:IfMessage(L["mindcontrol_message"]:format(player), "Attention", spellId)
		self:Icon(player, "icon")
	end
end

function mod:Tentacle(unit)
	-- Crusher Tentacle (33966) 50 sec
	-- Corruptor Tentacle (33985) 25 sec
	-- Constrictor Tentacle (33983) 20 sec
	if not db.tentacle then return end
	if unit == L["Crusher Tentacle"] then
		self:IfMessage(L["Crusher Tentacle"], "Attention", 64139)
		self:Bar(L["Crusher Tentacle"], 50, 64139)
	end
end

function mod:Malady(player, spellID)
	if db.malady then
		self:IfMessage(L["malady_message"]:format(player), "Attention", spellID)
		--self:Bar(L["malady_bar"], 19, spellID)
		self:Icon(player, "icon")
	end
end

function mod:Ray(_, spellID)
	if db.ray then
		self:IfMessage(L["ray_message"], "Attention", spellID)
		self:Bar(L["ray"], 15, spellID)
		self:Bar(L["ray_bar"], 22, spellID)
	end
end

function mod:Squeeze(player, spellID)
	if db.squeeze then
		self:IfMessage(L["squeeze_message"]:format(player), "Positive", spellID)
	end
end

local function printLinked(spellID)
	local msg = nil
	for k in pairs(linked) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	mod:IfMessage(L["link_message"]:format(msg), "Attention", spellID, "Alert")
	wipe(linked)
end

function mod:Linked(player, spellID)
	if db.link then
		linked[player] = true
		self:ScheduleEvent("BWLinkedWarn", printLinked, 0.2, spellID)
	end
end

function mod:Gaze(_, spellID)
	if db.gaze then
		self:IfMessage(L["gaze_message"], "Attention", spellID)
		self:Bar(L["gaze"], 4, spellID)
		self:Bar(L["gaze_bar"], 13, spellID)
	end
end

function mod:Madness()
	if db.madness then
		self:Bar(L["madness"], 60, 64059)
		self:ScheduleEvent("MadnessWarning", "BigWigs_Message", 55, L["madness_warning"], "Attention")
	end
end

function mod:Empower()
	if db.empower then
		self:IfMessage(L["empower_message"], "Attention", 64465)
		self:Bar(L["empower_bar"], 46, 64465)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["portal_trigger"] and db.portal then
		self:IfMessage(L["portal_message"], "Attention", 35717)
		self:Bar(L["portal_bar"], 90, 35717)
	elseif msg == L["weakened_trigger"] and db.weakened then
		self:IfMessage(L["weakened_message"]:format(boss), "Attention", 50661) --50661, looks like a weakened :)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
		if db.phase then
			self:Message(L["engage_warning"], "Important", nil, "Alarm")
		end
		if db.berserk then
			self:Enrage(900, true, true)
		end
	elseif msg == L["phase2_trigger"] then
		phase = 2
		if db.phase then
			self:IfMessage(L["phase2_warning"], "Important", nil, "Alarm")
		end
		if db.portal then
			self:Bar(L["portal_bar"], 78, 35717)
		end
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["Crusher Tentacle"])
		self:TriggerEvent("BigWigs_StopBar", self, L["ray"])
		self:TriggerEvent("BigWigs_StopBar", self, L["ray_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["portal_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["madness"])
		if db.phase then
			self:IfMessage(L["phase3_warning"], "Important", nil, "Alarm")
		end
		if db.empower then
			self:Bar(L["empower"], 46, 64486)
		end
	end
end

