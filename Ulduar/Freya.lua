----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Freya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32906
mod.toggleOptions = {"phase", "wave", "tree", 62589, 62623, "icon", "proximity", 62861, 62437, 62865, "berserk", "bosskill"}
mod.optionHeaders = {
	phase = CL.normal,
	[62861] = CL.hard,
	berserk = CL.general,
}
mod.proximityCheck = "bandage"
mod.consoleCmd = "Freya"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format
local root = mod:NewTargetList()

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger1 = "The Conservatory must be protected!",
	engage_trigger2 = "Elders grant me your strength!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_message = "Phase 2!",

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
	
	tree = "Eonar's Gift",
	tree_desc = "Alert when Freya spawns a Eonar's Gift.",
	tree_message = "Tree is up!",

	fury_message = "Fury",
	fury_other = "Fury: %s",

	tremor_warning = "Ground Tremor soon!",
	tremor_bar = "~Next Ground Tremor",
	energy_message = "Unstable Energy on YOU!",
	sunbeam_message = "Sun beams up!",
	sunbeam_bar = "~Next Sun Beams",

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
	tree_message = "이오나의 선물 소환",

	fury_message = "격노",
	fury_other = "자연의 격노: %s!",

	tremor_warning = "곧 지진!",
	tremor_bar = "~다음 지진",
	energy_message = "당신은 불안정한 힘!",
	sunbeam_message = "태양 광선!",
	sunbeam_bar = "~다음 태양 광선",

	icon = "전술 표시",
	icon_desc = "태양 광선과 자연의 격노의 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	end_trigger = "내게서 그의 지배력이 걷혔다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다.",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Le jardin doit être protégé !",
	engage_trigger2 = "Anciens, donnez-moi votre force !",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	phase2_message = "Phase 2 !",

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

	fury_message = "Fury",
	fury_other = "Fureur : %s",

	tremor_warning = "Tremblement de terre imminent !",
	tremor_bar = "~Prochain Tremblement",
	energy_message = "Energie instable sur VOUS !",
	sunbeam_message = "Rayons de soleil actif !",
	sunbeam_bar = "~Prochains Rayons de soleil",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par un Rayon de soleil (nécessite d'être assistant ou mieux).",

	end_trigger = "Son emprise sur moi se dissipe. J'y vois à nouveau clair. Merci, héros.",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger1 = "Das Konservatorium muss verteidigt werden!",
	engage_trigger2 = "Ihr Ältesten, gewährt mir Eure Macht!",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_message = "Phase 2",

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
	tree_message = "Eonars Geschenk!",

	fury_message = "Furor",
	fury_other = "Furor: %s",

	tremor_warning = "Bebende Erde bald!",
	tremor_bar = "~Bebende Erde",
	energy_message = "Instabile Energie auf DIR!",
	sunbeam_message = "Sonnenstrahl!",
	sunbeam_bar = "~Sonnenstrahl",
	
	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, die von Sonnenstrahl und Furor der Natur betroffen sind (benötigt Assistent oder höher).",

	end_trigger = "Seine Macht über mich beginnt zu schwinden. Endlich kann ich wieder klar sehen. Ich danke Euch, Helden.",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "The Conservatory must be protected!",
--	engage_trigger2 = "Elders grant me your strength!",

	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase2_message = "第二阶段！",

	wave = "波",
	wave_desc = "当一波小怪时发出警报。",
	wave_bar = "<下一波>",
--	conservator_trigger = "Eonar, your servant requires aid!",
--	detonate_trigger = "The swarm of the elements shall overtake you!",
--	elementals_trigger = "Children, assist me!",
--	tree_trigger = "A Lifebinder's Gift begins to grow!",
	conservator_message = "Conservator!",
	detonate_message = "Detonating lashers!",
	elementals_message = "古代水之精魂！",
	tree_message = "Eonar's Gift出现！",

	fury_message = "Fury",
	fury_other = "自然之怒：>%s<！",

	tremor_warning = "即将 大地震颤！",
	tremor_bar = "<下一大地震颤>",
	energy_message = ">你<不稳定的能量！",

	icon = "位置标记",
	icon_desc = "为中了阳光的队员打上团队标记。（需要权限）",

--	end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "必須守護大溫室!",
	engage_trigger2 = "長者們，賦予我你們的力量!",

	phase = "階段",
	phase_desc = "當進入不同階段發出警報。",
	phase2_message = "第二階段！",

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

	fury_message = "自然烈怒",
	fury_other = "自然烈怒：>%s<！",

	tremor_warning = "即將 地面震顫！",
	tremor_bar = "<下一地面震顫>",
	energy_message = ">你< 不穩定的能量！",
	sunbeam_message = "即將 太陽光束！",
	sunbeam_bar = "<下一太陽光束>",

	icon = "位置標記",
	icon_desc = "為中了太陽光束的隊員打上團隊標記。（需要權限）",

	end_trigger = "他對我的操控已然退散。我已再次恢復神智了。感激不盡，英雄們。",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger1 = "Нужно защитить Оранжерею!",
	engage_trigger2 = "Древни, дайте мне силы!",

	phase = "Фазы",
	phase_desc = "Предупреждать о смене фаз.",
	phase2_message = "2ая фаза!",

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

	fury_message = "Fury",
	fury_other = "Гнев на: |3-5(%s)",

	tremor_warning = "Скоро Дрожание земли!",
	tremor_bar = "~Дрожание земли",
	energy_message = "Нестабильная энергия на ВАС!",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, на которого нацелен Луч солнца. (необходимо быть лидером группы или рейда)",

	end_trigger = "Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Energy", 62865, 62451)             -- Elder Brightleaf
	self:AddCombatListener("SPELL_CAST_SUCCESS", "EnergySpawns", 62865, 62451)       -- Elder Brightleaf
	self:AddCombatListener("UNIT_DIED", "Deaths")                                    -- Elder Brightleaf
	self:AddCombatListener("SPELL_AURA_APPLIED", "Root", 62861, 62930, 62283, 62438) -- Elder Ironbranch
	self:AddCombatListener("SPELL_CAST_START", "Tremor", 62437, 62859, 62325, 62932) -- Elder Stonebark
	self:AddCombatListener("SPELL_CAST_START", "Sunbeam", 62623, 62872)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Fury", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FuryRemove", 62589, 63571)
	self:AddCombatListener("SPELL_AURA_REMOVED", "AttunedRemove", 62519)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

function mod:VerifyEnable(unit)
	return (UnitIsEnemy(unit, "player") and UnitCanAttack(unit, "player")) and true or false
end

------------------------------
--      Event Handlers      --
------------------------------

local function rootWarn(spellId, spellName)
	mod:TargetMessage(spellName, root, "Attention", spellId, "Info")
end

function mod:Root(player, spellId, _, _, spellName)
	root[#root + 1] = player
	self:ScheduleEvent("BWrootWarn", rootWarn, 0.2, spellId, spellName)
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if class == "PALADIN" then
			local _, _, points = GetTalentTabInfo(1)
			-- If a paladin has less than 20 points in Holy, he's not a caster.
			-- And so it shall forever be, said the Lord.
			if points < 20 then return end
		end
		return true
	end

	function mod:Tremor(_, spellId, _, _, spellName)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		self:IfMessage(spellName, color, spellId, sound)
		if phase == 1 then
			self:Bar(spellName, 2, spellId)
			self:Bar(L["tremor_bar"], 30, spellId)
			self:DelayedMessage(26, L["tremor_warning"], "Attention")
		elseif phase == 2 then
			self:Bar(spellName, 2, spellId)
			self:Bar(L["tremor_bar"], 23, spellId)
			self:DelayedMessage(20, L["tremor_warning"], "Attention")
		end
	end
end

local function scanTarget(spellId, spellName)
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
		mod:TargetMessage(spellName, target, "Attention", spellId)
		mod:SecondaryIcon(target, "icon")
		mod:CancelScheduledEvent("BWsunbeamToTScan")
	end
end

function mod:Sunbeam(_, spellId, _, _, spellName)
	self:ScheduleEvent("BWsunbeamToTScan", scanTarget, 0.1, spellId, spellName)
end

function mod:Fury(player, spellId)
	if player == pName then
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
	self:TargetMessage(L["fury_message"], player, "Personal", spellId, "Alert")
	self:Whisper(player, L["fury_message"])
	self:Bar(L["fury_other"]:format(player), 10, spellId)
	self:PrimaryIcon(player, "icon")
end

function mod:FuryRemove(player)
	self:TriggerEvent("BigWigs_StopBar", self, L["fury_other"]:format(player))
	if player == pName then
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

function mod:AttunedRemove()
	phase = 2
	self:TriggerEvent("BigWigs_StopBar", self, L["wave_bar"])
	if db.phase then
		self:IfMessage(L["phase2_message"], "Important")
	end
end

do
	local last = nil
	function mod:Energy(player)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["energy_message"], "Personal",  62451, "Alarm")
				last = t
			end
		end
	end
end

do
	local sunBeamName = nil
	local last = nil
	function mod:EnergySpawns(unit, spellId, _, _, spellName)
		local t = GetTime()
		if not last or (t > last + 10) then
			sunBeamName = unit
			self:IfMessage(L["sunbeam_message"], "Important", spellId)
			last = t
		end
	end
	function mod:Deaths(name)
		if not sunBeamName or name ~= sunBeamName then return end
		self:Bar(L["sunbeam_bar"], 35, 62865)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tree_trigger"] and db.tree then
		self:IfMessage(L["tree_message"], "Urgent", 5420, "Alarm")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger1"] or msg == L["engage_trigger2"] then
		phase = 1
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

