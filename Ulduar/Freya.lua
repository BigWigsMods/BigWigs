----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Freya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32906
mod.toggleoptions = {"phase", -1, "wave", "attuned", "fury", "sunbeam", -1, "root", "tremor", "energy", -1, "proximity", "icon", "berserk", "bosskill"}
mod.proximityCheck = "bandage"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local attunedCount = 150
local dCount = 0
local eCount = 0
local p2warned = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format
local root = {}

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Freya",

	engage_trigger1 = "The Conservatory must be protected!",
	engage_trigger2 = "Elders, grant me your strength!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2!",
	phase2_soon = "Phase 2 soon",

	wave = "Waves",
	wave_desc = "Warn for Waves.",
	wave_bar = "Next Wave",
	conservator_trigger = "Eonar, your servant requires aid!",
	detonate_trigger = "The swarm of the elements shall overtake you!",
	elementals_trigger = "Children, assist me!",
	tree_trigger = "A |cFF00FFFFLifebinder's Gift|r begins to grow!",
	conservator_message = "Conservator!",
	detonate_message = "Detonating lashers!",
	elementals_message = "Elementals!",
	tree_message = "Tree is up!",

	attuned = "Attuned to Nature",
	attuned_desc = "Warn for Attuned to Nature.",
	attuned_message = "Attuned x%d",

	fury = "Nature's Fury",
	fury_desc = "Tells you who has been hit by Nature's Fury.",
	fury_you = "Fury on YOU!",
	fury_other = "Fury: %s",

	sunbeam = "Sunbeam",
	sunbeam_desc = "Warn who Freya casts Sunbeam on.",
	sunbeam_you = "Sunbeam on YOU!",
	sunbeam_other = "Sunbeam: %s",

	tremor = "Ground Tremor",
	tremor_desc = "Warn when Freya casts Ground Tremor (Elder Stonebark).",
	tremor_message = "Ground Tremor!",
	tremor_warning = "Ground Tremor soon!",
	tremor_bar = "~Next Ground Tremor",

	root = "Iron Roots",
	root_desc = "Warn who has Iron Roots (Elder Ironbranch).",
	root_message = "Root: %s",

	energy = "Unstable Energy",
	energy_desc = "Warn on Unstable Energy (Elder Brightleaf).",
	energy_message = "Unstable Energy on YOU!",

	icon = "Place Icon",
	icon_desc = "Place a Raid Target Icon on the player targetted by Sunbeam and Nature's Fury. (requires promoted or higher)",

	end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "어떻게 해서든 정원을 수호해야 한다!",
	engage_trigger2 = "장로여, 내게 힘을 나눠다오!",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_message = "2 단계 !",
	phase2_soon = "곧 2 단계",

	wave = "웨이브",
	wave_desc = "웨이브에 대해 알립니다.",
	wave_bar = "다음 웨이브",
	conservator_trigger = "이오나여, 당신의 종이 도움을 청합니다!",
	detonate_trigger = "정령의 무리가 너희를 덮치리라!",
	elementals_trigger = "얘들아, 날 도와라!",
	tree_trigger = "|cFF00FFFF생명의 어머니의 선물|r이 자라기 시작합니다!",
	conservator_message = "수호자 소환",
	detonate_message = "폭발 덩굴손 소환",
	elementals_message = "정령 3 소환",
	tree_message = "생명결속자의 선물 소환",

	attuned = "자연 조화",
	attuned_desc = "자연 조화를 알립니다.",
	attuned_message = "조화 x%d",

	fury = "자연의 격노",
	fury_desc = "자연의 격노에 걸린 플레이어를 알립니다.",
	fury_you = "당신은 자연의 격노!",
	fury_other = "자연의 격노: %s!",

	sunbeam = "태양 광선",
	sunbeam_desc = "프레이야의 태양 광선 시전 대상을 알립니다.",
	sunbeam_you = "당신에게 태양 광선!",
	sunbeam_other = "태양 광선: %s",

	tremor = "지진",
	tremor_desc = "프레이야의 지진 시전을 알립니다.",
	tremor_message = "지진!",
	tremor_warning = "곧 지진!",
	tremor_bar = "~다음 지진",

	root = "무쇠 뿌리",
	root_desc = "무쇠 뿌리에 걸린 플레이어를 알립니다.",
	root_message = "무쇠 뿌리: %s",
	
	energy = "불안정한 힘",
	energy_desc = "불안정한 힘을 알립니다.",
	energy_message = "당신은 불안정한 힘!",

	icon = "전술 표시",
	icon_desc = "태양 광선 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "내게서 그의 지배력이 걷혔다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다.",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Le jardin doit être protégé !",
	engage_trigger2 = "Anciens, donnez-moi votre force !",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 !",
	phase2_soon = "Phase 2 imminente",

	wave = "Vagues",
	wave_desc = "Prévient de l'arrivée des vagues.",
	wave_bar = "Prochaine vague",
	conservator_trigger = "Eonar, ta servante a besoin d'aide !",
	detonate_trigger = "La nuée des éléments va vous submerger !",
	elementals_trigger = "Mes enfants, venez m'aider !",
	tree_trigger = "Un |cFF00FFFFdon de la Lieuse-de-vie|r commence à pousser !",
	conservator_message = "Ancien conservateur !",
	detonate_message = "Flagellants explosifs !",
	elementals_message = "Élémentaires !",
	tree_message = "Un arbre pousse !",

	attuned = "En harmonie avec la Nature",
	attuned_desc = "Prévient quand l'empilement d'En harmonie avec la Nature a changé.",
	attuned_message = "En harmonie x%d",

	fury = "Fureur de la nature",
	fury_desc = "Prévient quand un joueur subit les effets d'une Fureur de la nature.",
	fury_you = "Fureur de la nature sur VOUS !",
	fury_other = "Fureur de la nature : %s",

	sunbeam = "Rayon de soleil",
	sunbeam_desc = "Prévient quand un joueur subit les effets d'un Rayon de soleil.",
	sunbeam_you = "Rayon de soleil sur VOUS !",
	sunbeam_other = "Rayon de soleil : %s",

	tremor = "Tremblement de terre",
	tremor_desc = "Prévient quand Freya incante un Tremblement de terre.",
	tremor_message = "Tremblement de terre !",
	tremor_warning = "Tremblement de terre imminent !",
	tremor_bar = "~Prochain Tremblement de terre",

	root = "Racines de fer",
	root_desc = "Prévient quand un joueur subit les effets des Racines de fer.",
	root_message = "Racines de fer : %s",

	energy = "Energie instable",
	energy_desc = "Prévient quand vous subissez les effets d'une Energie instable.",
	energy_message = "Energie instable sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Rayon de soleil (nécessite d'être assistant ou mieux).",

	end_trigger = "Son emprise sur moi se dissipe. J'y vois à nouveau clair. Merci, héros.",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Das Konservatorium muss verteidigt werden!",
	engage_trigger2 = "Ihr Ältesten, gewährt mir Eure Macht!",-- needs check

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_message = "Phase 2!",
	phase2_soon = "Phase 2 bald!",

	wave = "Wellen",
	wave_desc = "Warnt vor den Wellen.",
	wave_bar = "Nächste Welle",
	conservator_trigger = "Eonar, Eure Dienerin braucht Hilfe!",
	detonate_trigger = "Der Schwarm der Elemente soll über Euch kommen!",
	elementals_trigger = "Helft mir, Kinder!",
	tree_trigger = "Ein |cFF00FFFFGeschenk der Lebensbinderin|r fängt an zu wachsen!",
	conservator_message = "Konservator!",
	detonate_message = "Explosionspeitscher!",
	elementals_message = "Elementare!",
	tree_message = "Eonars Gabe!",

	attuned = "Einstimmung auf die Natur",
	attuned_desc = "Warnt vor der Anzahl von Einstimmung auf die Natur.",
	attuned_message = "Einstimmung: (%d)",

	fury = "Furor der Natur",
	fury_desc = "Warnt, wer von Furor der Natur betroffen ist.",
	fury_you = "Furor auf DIR!",
	fury_other = "Furor: %s!",

	sunbeam = "Sonnenstrahl",
	sunbeam_desc = "Warnt, auf wen Sonnenstrahl gewirkt wird.",
	sunbeam_you = "Sonnenstrahl auf DIR!",
	sunbeam_other = "Sonnenstrahl: %s!",

	tremor = "Bebende Erde",
	tremor_desc = "Warnt, wenn Bebende Erde gewirkt wird.",
	tremor_message = "Bebende Erde!",
	tremor_warning = "Bebende Erde bald!",
	tremor_bar = "~Bebende Erde",

	root = "Eiserne Wurzeln",
	root_desc = "Warnt, wer von Eiserne Wurzeln betroffen ist.",
	root_message = "Wurzeln: %s!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sonnenstrahl und Furor der Natur betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Seine Macht über mich beginnt zu schwinden. Endlich kann ich wieder klar sehen. Ich danke Euch, Helden.",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "The Conservatory must be protected!",
--	engage_trigger2 = "Elders, grant me your strength!",

	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase2_message = "第二阶段！",
	phase2_soon = "即将 - 第二阶段！",

	wave = "波",
	wave_desc = "当一波小怪时发出警报。",
	wave_bar = "<下一波>",
--	conservator_trigger = "Eonar, your servant requires aid!",
--	detonate_trigger = "The swarm of the elements shall overtake you!",
--	elementals_trigger = "Children, assist me!",
--	tree_trigger = "A Lifebinder's Gift begins to grow!",
	conservator_message = "Conservator!",
	detonate_message = "Detonating lashers!",
	elementals_message = "Elementals!",
	tree_message = "Eonar's Gift出现！",

	attuned = "自然协调",
	attuned_desc = "当施放自然协调时发出警报。",
	attuned_message = "自然协调：>%d<！",

	fury = "自然之怒",
	fury_desc = "当玩家中了自然之怒时向自己发出警报。",
	fury_you = ">你< 自然之怒！",
	fury_other = "自然之怒：>%s<！",

	sunbeam = "Sunbeam",
	sunbeam_desc = "当弗蕾亚施放Sunbeam于玩家时发出警报。.",
	sunbeam_you = ">你< Sunbeam！",
	sunbeam_other = "Sunbeam：>%s<！",

	tremor = "大地震颤",
	tremor_desc = "当弗蕾亚施放大地震颤时发出警报。",
	tremor_message = "大地震颤！",
	tremor_warning = "即将 大地震颤！",
	tremor_bar = "<下一大地震颤>",

	root = "钢铁根须",
	root_desc = "当玩家中了钢铁根须时发出警报。",
	root_message = "钢铁根须：>%s<！",

	energy = "不稳定的能量",
	energy_desc = "当玩家中了不稳定的能量时发出警报。",
	energy_message = ">你<不稳定的能量！",

	icon = "位置标记",
	icon_desc = "为中了Sunbeam的队员打上团队标记。（需要权限）",

--	end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "必須守護大溫室!",
	engage_trigger2 = "長者，賦予我你們的力量!",

	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	phase2_message = "第二階段！",
	phase2_soon = "即將 - 第二階段！",

	wave = "波",
	wave_desc = "當一波小怪時發出警報。",
	wave_bar = "<下一波>",
	conservator_trigger = "伊歐娜，你的僕從需要協助!",
	detonate_trigger = "元素們將襲捲你們!",
	elementals_trigger = "孩子們，協助我!",
	tree_trigger = "一個|cFF00FFFF生命守縛者之禮|r開始生長!",
	conservator_message = "古樹護存者！",
	detonate_message = "引爆鞭笞者！",
	elementals_message = "上古水之靈！",
	tree_message = "伊歐娜的贈禮 出現！",

	attuned = "自然和諧",
	attuned_desc = "當施放自然和諧時發出警報。",
	attuned_message = "自然和諧：>%d<！",

	fury = "自然烈怒",
	fury_desc = "當玩家中了自然烈怒時向自己發出警報。",
	fury_you = ">你< 自然烈怒！",
	fury_other = "自然烈怒：>%s<！",

	sunbeam = "太陽光束",
	sunbeam_desc = "當芙蕾雅施放太陽光束于玩家時發出警報。",
	sunbeam_you = ">你< 太陽光束！",
	sunbeam_other = "太陽光束：>%s<！",

	tremor = "地面震動",
	tremor_desc = "當芙蕾雅施放地面震動時發出警報。",
	tremor_message = "地面震動！",
	tremor_warning = "即將 地面震動！",
	tremor_bar = "<下一地面震動>",

	root = "鐵之根鬚",
	root_desc = "當玩家中了鐵之根鬚時發出警報。",
	root_message = "鐵之根鬚：>%s<！",

	energy = "不穩定的能量",
	energy_desc = "當玩家中了不穩定的能量時發出警報。",
	energy_message = ">你< 不穩定的能量！",

	icon = "位置標記",
	icon_desc = "為中了太陽光束的隊員打上團隊標記。（需要權限）",

	end_trigger = "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger1 = "Нужно защитить Оранжерею!",
	--engage_trigger2 = "Elders, grant me your strength!",

	phase = "Фазы",
	phase_desc = "Предупреждать о смене фаз.",
	phase2_message = "2ая фаза!",
	phase2_soon = "Скоро начнётся 2ая фаза",

	wave = "Волны",
	wave_desc = "Предупреждать о волнах.",
	wave_bar = "Следующая волна",
	conservator_trigger = "Эонар, твоей прислужнице нужна помощь!",
	detonate_trigger = "Вас захлестнет сила стихий!",
	elementals_trigger = "Помогите мне, дети мои!",
	tree_trigger = "|cFF00FFFFДар Хранительницы жизни|r начинает расти!",
	conservator_message = "Древний опекун!",
	detonate_message = "Взрывные плеточники!",
	elementals_message = "Элементали!",
	tree_message = "Появление Дара Эонара!",

	attuned = "Гармония природы",
	attuned_desc = "Предупреждать о Гармонии природы.",
	attuned_message = "Гармония: (%d)",

	fury = "Гнев природы",
	fury_desc = "Сообщает вам, на кого наложен Гнев природы.",
	fury_you = "Гнев на ВАС!",
	fury_other = "Гнев на: |3-5(%s)",

	sunbeam = "Луч солнца",
	sunbeam_desc = "Предупреждать на кого Фрейя применяет Луч солнца.",
	sunbeam_you = "Луч солнца на ВАС!",
	sunbeam_other = "Луч солнца на |3-5(%s)",

	tremor = "Дрожание земли",
	tremor_desc = "Предупреждать когда Фрейя применяет Дрожание земли.",
	tremor_message = "Дрожание земли!",
	tremor_warning = "Скоро Дрожание земли!",
	tremor_bar = "~Дрожание земли",

	root = "Железные корни",
	root_desc = "Сообщать кто заточен в Железные корни.",
	root_message = "В корнях: %s",
	
	energy = "Нестабильная энергия",
	energy_desc = "Сообщать о Нестабильной энергии",
	energy_message = "Нестабильная энергия на ВАС!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелен Луч солнца. (необходимо быть лидером группы или рейда)",

	end_trigger = "Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Energy", 62865, 62451)			--HardMode abilities from Elder Brightleaf
	self:AddCombatListener("SPELL_CAST_SUCCESS", "EnergyCooldown", 62865, 62451)		--HardMode abilities from Elder Brightleaf
	self:AddCombatListener("SPELL_AURA_APPLIED", "Root", 62861, 62930, 62283, 62438)	--HardMode abilities from Elder Ironbranch
	self:AddCombatListener("SPELL_CAST_START", "Tremor", 62437, 62859, 62325, 62932)	--HardMode abilities from Elder Stonebark 
	self:AddCombatListener("SPELL_CAST_START", "Sunbeam", 62623, 62872)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	wipe(root)
end

function mod:VerifyEnable(unit)
	return UnitIsEnemy(unit, "player") and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

local function rootWarn()
	mod:IfMessage(L["root_message"]:format(table.concat(root, ", ")), "Attention", 62930, "Info")
	wipe(root)
end

function mod:Root(player, spellID)
	if db.root then
		table.insert(root, player)
		self:ScheduleEvent("BWrootWarn", rootWarn, 0.2, spellID)
	end
end

do
	local _, class = UnitClass("player")
	local fury = GetSpellInfo(25780)
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return nil end
		if class == "PALADIN" then
			for i = 1, 40 do
				local name = UnitBuff("player", i)
				if not name then break
				elseif name == fury then return nil
				end
			end
		end
		return true
	end

	function mod:Tremor(_, spellID)
		if db.tremor then
			local caster = isCaster()
			local color = caster and "Personal" or "Attention"
			local sound = caster and "Long" or nil
			self:IfMessage(L["tremor_message"], color, spellID, sound)
			if phase == 1 then
				self:Bar(L["tremor"], 2, spellID)
				self:Bar(L["tremor_bar"], 30, spellID)
				self:DelayedMessage(26, L["tremor_warning"], "Attention")
			elseif phase == 2 then
				self:Bar(L["tremor"], 2, spellID)
				self:Bar(L["tremor_bar"], 23, spellID)
				self:DelayedMessage(20, L["tremor_warning"], "Attention")
			end
		end
	end
end

local function scanTarget()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "target")) == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		if target == pName then
			mod:LocalMessage(L["sunbeam_you"], "Attention", 62872)
			mod:WideMessage(L["sunbeam_other"]:format(target))
		else
			mod:TargetMessage(L["sunbeam_other"], target, "Attention", 62872)
			mod:Whisper(player, L["sunbeam_you"])
		end
		mod:Icon(target, "icon")
		mod:CancelScheduledEvent("BWsunbeamToTScan")
	end
end

function mod:Sunbeam()
	if db.sunbeam then
		self:ScheduleEvent("BWsunbeamToTScan", scanTarget, 0.1)
	end
end

function mod:Fury(player, spellID)
	if db.fury then
		if player == pName then
			self:LocalMessage(L["fury_you"], "Personal", spellID, "Alert")
			self:WideMessage(L["fury_other"]:format(player))
			self:TriggerEvent("BigWigs_ShowProximity", self)
		else
			self:TargetMessage(L["fury_other"], player, "Attention", spellID)
			self:Whisper(player, L["fury_you"])
		end
		self:Bar(L["fury_other"]:format(player), 10, spellID)
		self:Icon(player, "icon")
	end
end

function mod:FuryRemove(player)
	if db.fury then
		self:TriggerEvent("BigWigs_StopBar", self, L["fury_other"]:format(player))
		if player == pName then
			self:TriggerEvent("BigWigs_HideProximity", self)
		end
	end
end

function mod:AttunedRemove()
	if db.phase then
		phase = 2
		self:TriggerEvent("BigWigs_StopBar", self, L["wave_bar"])
		self:IfMessage(L["phase2_message"], "Important")
	end
end

function mod:Deaths(_, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == 32918 then
		attunedCount = attunedCount - 2
		dCount = dCount + 1
		if dCount == 10 then
			dCount = 0
			self:AttunedWarn()
		end
	elseif guid == 32919 or guid == 33202 or guid == 32916 then
		eCount = eCount + 1
		if eCount == 3 then
			attunedCount = attunedCount - 30
			eCount = 0
			self:AttunedWarn()
		end
	elseif guid == 33203 then
		attunedCount = attunedCount - 25
		self:AttunedWarn()
	end
end

function mod:AttunedWarn()
	if db.attuned then
		if attunedCount > 3 then
			self:IfMessage(L["attuned_message"]:format(attunedCount), "Positive", 62519)
		elseif not p2warned and attunedCount > 1 and attunedCount <= 10 and db.phase then
			p2warned = true
			self:IfMessage(L["phase2_soon"], "Attention")
		end
	end
end

function mod:Energy(player)
	if db.energy and player == pName then
		self:IfMessage(L["energy_message"], "Personal",  62451, "Alarm")
	end
end

function mod:EnergyCooldown(_,spellID)
	if db.energy then
		self:Bar(L["energy"], 25, spellID)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tree_trigger"] and db.wave then
		self:IfMessage(L["tree_message"], "Urgent", 5420, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger1"] or msg == L["engage_trigger2"] then
		phase = 1
		attunedCount = 150
		dCount = 0
		eCount = 0
		p2warned = nil
		if db.berserk then
			self:Enrage(600, true)
		end
		if db.wave then
			--35594, looks like a wave :)
			self:Bar(L["wave_bar"], 11, 35594)
		end
	elseif msg == L["conservator_trigger"] and db.wave then
		self:IfMessage(L["conservator_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["detonate_trigger"] and db.wave then
		self:IfMessage(L["detonate_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["elementals_trigger"] and db.wave then
		self:IfMessage(L["elementals_message"], "Positive", 35594)
		self:Bar(L["wave_bar"], 60, 35594)
	elseif msg == L["end_trigger"] then
		self:BossDeath(nil, self.guid)
	end
end

