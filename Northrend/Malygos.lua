----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Malygos"]
local mod = BigWigs:New(boss, tonumber(("$Revision$"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["The Eye of Eternity"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 28859
mod.toggleoptions = {"phase", -1, "sparks", "vortex", -1, "breath", -1, "surge", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local UnitName = UnitName
local pName = UnitName("player")
local db = nil
local started = nil
local phase = nil
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Malygos",

	sparks = "Power Spark",
	sparks_desc = "Warns on Power Spark spawns.",
	sparks_message = "Power Spark spawns!",
	sparks_warning = "Power Spark in ~5sec!",

	vortex = "Vortex",
	vortex_desc = "Warn for Vortex in phase 1.",
	vortex_message = "Vortex!",
	vortex_warning = "Possible Vortex in ~5sec!",
	vortex_next = "Vortex Cooldown",

	breath = "Deep Breath",
	breath_desc = "Warn when Malygos is using Deep Breath in phase 2.",
	breath_message = "Deep Breath!",
	breath_warning = "Deep Breath in ~5sec!",

	surge = "Surge of Power",
	surge_desc = "Warn when Malygos uses Surge of Power on you in phase 3.",
	surge_you = "Surge of Power on YOU!",
	surge_trigger = "%s fixes his eyes on you!",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_warning = "Phase 2 soon!",
	phase2_trigger = "I had hoped to end your lives quickly",
	phase2_message = "Phase 2 - Nexus Lord & Scion of Eternity!",
	phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic",
	phase3_warning = "Phase 3 soon!",
	phase3_trigger = "Now your benefactors make their",
	phase3_message = "Phase 3!",
} end )

L:RegisterTranslations("koKR", function() return {
	sparks = "마력의 불꽃",
	sparks_desc = "마력의 불꽃 소환을 알립니다.",
	sparks_message = "마력의 불꽃 소환!",
	sparks_warning = "약 5초 후 마력의 불꽃!",

	vortex = "회오리",
	vortex_desc = "회오리에 대한 알림과 바를 표시합니다.",
	vortex_message = "회오리!",
	vortex_warning = "약 5초 후 회오리 사용가능!",
	vortex_next = "회오리 대기시간",

	breath = "깊은 숨결",
	breath_desc = "깊은 숨결을 알립니다.",
	breath_message = "깊은 숨결!",
	breath_warning = "약 5초 후 깊은 숨결!",

	surge = "마력의 쇄도",
	surge_desc = "마력의 쇄도의 대상을 알립니다.",
	surge_you = "당신에게 마력의 쇄도!",
	surge_trigger = "%s|1이;가; 당신을 주시합니다!",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_warning = "잠시 후 2 단계!",
	phase2_trigger = "되도록 빨리 끝내 주고 싶었다만",
	phase2_message = "2 단계 - 마력의 군주 & 영원의 후예!",
	phase2_end_trigger = "그만! 아제로스의 마력을 되찾고",
	phase3_warning = "잠시 후 3 단계!",
	phase3_trigger = "네놈들의 후원자가 나타났구나",
	phase3_message = "3 단계!",
} end )

L:RegisterTranslations("frFR", function() return {
	sparks = "Etincelle de puissance",
	sparks_desc = "Prévient quand une Etincelle de puissance apparait.",
	sparks_message = "Etincelle de puissance apparue !",
	sparks_warning = "Etincelle de puissance dans ~5 sec. !",

	vortex = "Vortex",
	vortex_desc = "Prévient de l'arrivée des Vortex.",
	vortex_message = "Vortex !",
	vortex_warning = "Vortex probable dans ~5 sec. !",
	vortex_next = "Recharge Vortex",

	breath = "Inspiration profonde",
	breath_desc = "Prévient quand Malygos inspire profondément.",
	breath_message = "Inspiration profonde !",
	breath_warning = "Inspiration profonde dans ~5 sec. !",

	surge = "Vague de puissance",
	surge_desc = "Prévient quand un joueur subit les effets de la Vague de puissance.",
	surge_you = "Vague de puissance sur VOUS !",
	surge_trigger = "%s fixe le regard sur vous !",

	phase = "Phases",
	phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase.",
	phase2_warning = "Phase 2 imminente !",
	phase2_trigger = "Je pensais mettre rapidement fin à vos existences",
	phase2_message = "Phase 2 - Seigneurs du Nexus & Scions de l'Éternité !",
	phase2_end_trigger = "ASSEZ ! Si c'est la magie d'Azeroth que vous voulez, alors vous l'aurez !",
	phase3_warning = "Phase 3 imminente !",
	phase3_trigger = "Vos bienfaiteurs font enfin leur entrée, mais ils arrivent trop tard !",
	phase3_message = "Phase 3 !",
} end )

L:RegisterTranslations("zhCN", function() return {
	sparks = "能量火花",
	sparks_desc = "当能量火花出现时发出警报。",
	sparks_message = "出现 能量火花！",
	sparks_warning = "约5秒后，能量火花！",

	vortex = "漩涡",
	vortex_desc = "当施放漩涡时发出警报及显示计时条。",
	vortex_message = "漩涡！",
	vortex_warning = "约5秒后，可能漩涡！",
	vortex_next = "<漩涡 冷却>",

	breath = "深呼吸",
	breath_desc = "当施放深呼吸时发出警报。",
	breath_message = "深呼吸！",
	breath_warning = "约5秒后，深呼吸！",

	surge = "能量涌动",
	surge_desc = "当玩家中了能量涌动时发出警报。",
	surge_you = ">你< 能量涌动！",

	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	phase2_warning = "即将 第二阶段！",
	phase2_trigger = "I had hoped to end your lives quickly", -- yell required
	phase2_message = "第二阶段 - 魔枢领主与永恒子嗣!",
	phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic", -- yell required
	phase3_warning = "即将 第三阶段！",
	phase3_trigger = "Now your benefactors make their", -- yell required
	phase3_message = "第三阶段！",
} end )

L:RegisterTranslations("zhTW", function() return {
	sparks = "力量火花",
	sparks_desc = "當力量火花出現時發出警報。",
	sparks_message = "出現 力量火花！",
	sparks_warning = "約5秒后，力量火花！",

	vortex = "漩渦",
	vortex_desc = "當施放漩渦時發出警報及顯示計時條。",
	vortex_message = "漩渦！",
	vortex_warning = "約5秒后，可能漩渦！",
	vortex_next = "<漩渦 冷卻>",

	breath = "深呼吸",
	breath_desc = "當施放深呼吸時發出警報。",
	breath_message = "深呼吸！",
	breath_warning = "約5秒后，深呼吸！",

	surge = "力量奔騰",
	surge_desc = "當玩家中了力量奔騰時發出警報。",
	surge_you = ">你< 力量奔騰！",

	phase = "階段",
	phase_desc = "當進入不同階段時發出警報。",
	phase2_warning = "即將 第二階段！",
	phase2_trigger = "我原本只是想盡快結束你們的生命",
	phase2_message = "第二階段 - 奧核領主與永恆之裔！",
	phase2_end_trigger = "夠了!既然你們這麼想奪回艾澤拉斯的魔法，我就給你們!",
	phase3_warning = "即將 第三階段！",
	phase3_trigger = "現在你們幕後的主使終於出現",
	phase3_message = "第三階段！",
} end )

L:RegisterTranslations("ruRU", function() return {
	sparks = "Искра мощи",
	sparks_desc = "Предупреждать о появлениях Искры мощи.",
	sparks_message = "Появилась Искра мощи!",
	sparks_warning = "Искра мощи через ~5сек!",

	vortex = "Воронка",
	vortex_desc = "Предупреждать о воронках и отображать полосу.",
	vortex_message = "Воронка!",
	vortex_warning = "Воронка через ~5сек!",
	vortex_next = "Перезарядка воронки",

	surge = "Прилив мощи",
	surge_desc = "Предупреждать кто получает Прилив мощи.",
	surge_you = "На ВАС Прилив мощи!",

	phase = "Фазы",
	phase_desc = "Предупреждать о смене фаз.",
	phase2_warning = "Скоро 2 фаза!",
	phase2_trigger = "Я рассчитывал быстро покончить с вами, однако вы оказались более… более стойкими, чем я рассчитывал",
	phase2_message = "2 Фаза - Повелители нексуса и Потомоки вечности!",
	phase2_end_trigger = "ХВАТИТ! Если ты намерен вернуть себе магию Азерота, ты ее получишь!",
	phase3_warning = "Скоро 3 фаза!",
	phase3_trigger = "А-а, вот и твои благодетели!",
	phase3_message = "3 Фаза!",
} end )

L:RegisterTranslations("deDE", function() return {
	sparks = "Energiefunke",
	sparks_desc = "Warnungen und Timer für das Erscheinen von Energiefunken.",
	sparks_message = "Energiefunke!",
	sparks_warning = "Energiefunke in ~5 sek!",

	vortex = "Vortex",
	vortex_desc = "Warnungen und Timer für Vortex.",
	vortex_message = "Vortex!",
	vortex_warning = "Vortex in ~5 sek!",
	vortex_next = "~Vortex",

	breath = "Tiefer Atem",
	breath_desc = "Warnungen und Timer für Tiefer Atem (Kraftsog) in Phase 2.",
	breath_message = "Tiefer Atem!",
	breath_warning = "Tiefer Atem in ~5 sek!",

	surge = "Kraftsog",
	surge_desc = "Warnt, wenn ein Spieler von Kraftsog in Phase 3 betroffen ist.",
	surge_you = "Kraftsog auf DIR!",
	surge_trigger = "Die Augen von %s sind auf Euch fixiert!",

	phase = "Phasen",
	phase_desc = "Warnt bei Phasenwechsel.",
	phase2_warning = "Phase 2 bald!",
	phase2_trigger = "Ich hatte gehofft, eure Leben schnell zu beenden, doch ihr zeigt euch... hartnäckiger als erwartet. Nichtsdestotrotz sind eure Bemühungen vergebens. Ihr törichten, leichtfertigen Sterblichen tragt die Schuld an diesem Krieg. Ich tue, was ich tun muss, und wenn das eure Auslöschung bedeutet... dann SOLL ES SO SEIN!",
	phase2_message = "Phase 2, Nexuslords & Saat der Ewigkeit!",
	phase2_end_trigger = "GENUG! Wenn ihr die Magie Azeroths zurückhaben wollt, dann sollt ihr sie bekommen!",
	phase3_warning = "Phase 3 bald!",
	phase3_trigger = "Eure Wohltäter sind eingetroffen, doch sie kommen zu spät! Die hier gespeicherten Energien reichen aus, die Welt zehnmal zu zerstören. Was, denkt ihr, werden sie mit euch machen?",
	phase3_message = "Phase 3!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Vortex", 56105)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	db = self.db.profile
	phase = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Vortex(_, spellID)
	if db.vortex then
		self:Bar(L["vortex"], 10, 56105)
		self:IfMessage(L["vortex_message"], "Attention", spellID)
		self:Bar(L["vortex_next"], 59, 56105)
		self:DelayedMessage(54, L["vortex_warning"], "Attention")
		if db.sparks then
			self:Bar(L["sparks"], 17, 56152)
			self:DelayedMessage(12, L["sparks_warning"], "Attention")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(msg, mob)
	if phase == 3 and db.surge and msg == L["surge_trigger"] then
		self:LocalMessage(L["surge_you"], "Personal", 60936, "Alarm") -- 60936 for phase 3, not 56505
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if phase == 1 then
		if db.sparks then
			self:Message(L["sparks_message"], "Important", 56152, "Alert")
			self:Bar(L["sparks"], 30, 56152)
			self:DelayedMessage(25, L["sparks_warning"], "Attention")
		end
	elseif phase == 2 then
		if db.breath then
			-- 43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
			-- Correct SpellId for 'breath" in phase 2 is 56505 
			self:Message(L["breath_message"], "Important", 43810, "Alert")
			self:Bar(L["breath"], 59, 43810)
			self:DelayedMessage(54, L["breath_warning"], "Attention")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["sparks"])
		self:TriggerEvent("BigWigs_StopBar", self, L["vortex_next"])
		self:Message(L["phase2_message"], "Attention")
		if db.breath then
			self:Bar(L["breath"], 92, 43810)
			self:DelayedMessage(87, L["breath_warning"], "Attention")
		end
	elseif msg:find(L["phase2_end_trigger"]) then
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["breath"])
		self:Message(L["phase3_warning"], "Attention")
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:Message(L["phase3_message"], "Attention")
	end
end

function mod:UNIT_HEALTH(msg)
	if phase ~= 1 or not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 54 then
			self:Message(L["phase2_warning"], "Attention")
		end
	end
end	

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.vortex then
			self:Bar(L["vortex_next"], 29, 56105)
			self:ScheduleEvent("VortexWarn", "BigWigs_Message", 24, L["vortex_warning"], "Attention")
		end
		if db.sparks then
			self:Bar(L["sparks"], 25, 56152)
			self:ScheduleEvent("SparkWarn", "BigWigs_Message", 20, L["sparks_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end

