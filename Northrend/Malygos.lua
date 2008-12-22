------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Malygos"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local UnitName = UnitName
local pName = UnitName("player")
local db = nil
local started = nil
local phase = nil
local p2 = nil
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malygos",

	sparks = "Power Spark",
	sparks_desc = "Warns on Power Spark spawns.",
	sparks_message = "Power Spark spawns!",
	sparks_warning = "Power Spark in ~5sec!",

	vortex = "Vortex",
	vortex_desc = "Warn for vortex and show a bar.",
	vortex_message = "Vortex!",
	vortex_warning = "Possible Vortex in ~5sec!",
	vortex_next = "Vortex Cooldown",
	
	overload = "Arcane Overload",
	overload_desc = "Warn for Arcane Overload and show a bar.",
	overload_warning = "Arcane Overload in ~5sec!",
	overload_next = "Next Overload",

	breath = "Deep Breath",
	breath_desc = "Deep Breath warnings.",
	breath_message = "Deep Breath!",
	breath_warning = "Deep Breath in ~5sec!",

	surge = "Surge of Power",
	surge_desc = "Warn who has Surge of Power.",
	surge_you = "Surge of Power on YOU!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player that Surge of Power is being cast on(requires promoted or higher)",

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
	
	overload = "비전 과부하",
	overload_desc = "비전 과부하에 대한 알림과 바를 표시합니다.",
	overload_warning = "약 5초 후 비전 과부하!",
	overload_next = "다음 과부하",

	breath = "깊은 숨결",
	breath_desc = "깊은 숨결을 알립니다.",
	breath_message = "깊은 숨결!",
	breath_warning = "약 5초 후 깊은 숨결!",

	surge = "마력의 쇄도",
	surge_desc = "마력의 쇄도의 대상을 알립니다.",
	surge_you = "당신에게 마력의 쇄도!",

	icon = "전술 표시",
	icon_desc = "마력의 쇄도의 시전 대상의 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 요구)",

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

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne sur laquelle la Vague de puissance est incantée (nécessite d'être promu ou mieux).",

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
	vortex_desc = "当施放漩涡是发出警报及显示计时条。",
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

	icon = "团队标记",
	icon_desc = "为中了能量涌动的玩家打上团队标记。（需要权限）",

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

	icon = "團隊標記",
	icon_desc = "為中了力量奔騰的玩家打上團隊標記。（需要權限）",

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
	sparks_message = "Появление Искры мощи!",
	sparks_warning = "Искра мощи через ~5сек!",

	vortex = "Воронка",
	vortex_desc = "Предупреждать о воронках и отображать полосу.",
	vortex_message = "Воронка!",
	vortex_warning = "Воронка через ~5сек!",
	vortex_next = "перезарядка воронки",

	breath = "Дыхание Чар",
	breath_desc = "Предупреждать о Дыхании Чар.",
	breath_message = "Дыхание Чар!",
	breath_warning = "Дыхание Чар через ~5сек!",

	surge = "Прилив мощи",
	surge_desc = "Предупреждать кто получает Прилив мощи.",
	surge_you = "На ВАС Прилив мощи!",

	icon = "Отмечать икнокой",
	icon_desc = "Отмечать рейдовой иконой игрока, попавшего под Прилив мощи (необходимо быть лидером группы или рейда)",

	phase = "Фазы",
	phase_desc = "Предупреждать о смене фаз.",
	phase2_warning = "Скоро 2-я фаза!",
	phase2_trigger = "I had hoped to end your lives quickly",
	phase2_message = "Фаза 2 - Повелитель нексуса и Потомок вечности!",
	phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic",
	phase3_warning = "Скоро 3-я фаза!",
	phase3_trigger = "Now your benefactors make their",
	phase3_message = "Фаза 3!",
} end )

L:RegisterTranslations("deDE", function() return {
	sparks = "Energiefunke",
	sparks_desc = "Warnt wenn ein Energiefunke erscheint.",
	sparks_message = "Energiefunke erschienen!",
	sparks_warning = "Energiefunke in ~5sek!",

	vortex = "Vortex",
	vortex_desc = "Warnt vor Vortex und zeigt eine Leiste an.",
	vortex_message = "Vortex!",
	vortex_warning = "Möglicher Vortex in ~5sek!",
	vortex_next = "Vortex Cooldown",

	breath = "Tiefer Atem",
	breath_desc = "Tiefer Atem Warnungen.",
	breath_message = "Tiefer Atem!",
	breath_warning = "Tiefer Atem in ~5sek!",

	surge = "Kraftsog",
	surge_desc = "Warnt wer von Kraftsog betroffen ist.",
	surge_you = "Kraftsog auf DIR!",

	icon = "Schlagzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Symbol auf Spielern auf die Kraftsog gewirkt wird (benötigt Assistent oder höher)",

	phase = "Phasen",
	phase_desc = "Warnungen bei Phasenänderrungen im Kampf.",
	phase2_warning = "Phase 2 bald!",
	phase2_trigger = "Ich hatte gehofft, eure Leben schnell zu beenden doch ihr zeit euch.. hartnäckiger als erwartet.",
	phase2_message = "Phase 2 - Nexuslord & Saat der Ewigkeit!",
	phase2_end_trigger = "GENUG! Wenn ihr die Magie Azeroths zurückhaben wollt, dann sollt ihr sie bekommen!",
	phase3_warning = "Phase 3 bald!",
	phase3_trigger = "Eure Wohltäter sind eingetroffen",
	phase3_message = "Phase 3!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["The Eye of Eternity"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 28859
mod.toggleoptions = {"phase", -1, "sparks", "vortex", -1, "overload", "breath", -1, "surge", "icon", "berserk", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Surge", 57407, 60936)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Vortex", 56105)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

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
		self:CancelScheduledEvent("VortexWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["vortex_next"])
		self:Bar(L["vortex"], 10, 56105)
		self:IfMessage(L["vortex_message"], "Attention", spellID)
		self:Bar(L["vortex_next"], 59, 56105)
		self:ScheduleEvent("VortexWarn", "BigWigs_Message", 54, L["vortex_warning"], "Attention")
		if db.sparks then
			self:CancelScheduledEvent("SparkWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["sparks"])
			self:Bar(L["sparks"], 17, 44780)
			self:ScheduleEvent("SparkWarn", "BigWigs_Message", 12, L["sparks_warning"], "Attention")
		end
	end
end

local cachedId = nil

function mod:Surge()
	if phase == 3 then
		if db.surge then
			self:ScheduleRepeatingEvent("BWMalygosToTScan", self.SurgeCheck, 0.3, self)
		end
	end
end

local last = 0
function mod:SurgeCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName(fmt("%s%d%s", "raid", i, "pet") or "") == boss then
				target = UnitName(fmt("%s%d%s", "raid", i, "targettarget"))
				break
			end
		end
	end
	if target then
		local time = GetTime()
		if (time - last) > 4 then
			last = time
			if target == pName then
				self:LocalMessage(L["surge_you"], "Personal", nil, "Alarm")
			end
			self:Icon(target, "icon")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if phase == 1 then
		if db.sparks then
			-- 44780, looks like a Power Spark :)
			self:CancelScheduledEvent("SparkWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["sparks"])
			self:Message(L["sparks_message"], "Important", 44780, "Alert")
			self:Bar(L["sparks"], 30, 44780)
			self:ScheduleEvent("SparkWarn", "BigWigs_Message", 25, L["sparks_warning"], "Attention")
		end
	elseif phase == 2 then
		if db.breath then
			--19879 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
			self:Message(L["breath_message"], "Important", 43810, "Alert")
			self:Bar(L["breath"], 59, 43810)
			self:ScheduleEvent("BreathWarn", "BigWigs_Message", 54, L["breath_warning"], "Attention")
		end
	end
end

function mod:RepeatOverload()
	self:Bar(L["overload_next"], 15, 56438)
	self:ScheduleEvent("OverloadWarn", "BigWigs_Message", 10, L["overload_next"], "Attention")
	self:ScheduleEvent("Overload", self.RepeatOverload, 15, self)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelScheduledEvent("VortexWarn")
		self:CancelScheduledEvent("SparkWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["sparks"])
		self:TriggerEvent("BigWigs_StopBar", self, L["vortex_next"])
		self:Message(L["phase2_message"], "Attention")
		if db.breath then
			self:Bar(L["breath"], 92, 43810)
			self:DelayedMessage(87, L["breath_warning"], "Attention")
		end
		if db.overload then
			self:Bar(L["overload"], 30, 56438)
			self:DelayedMessage(25, L["overload_warning"], "Attention")
			self:ScheduleEvent("Overload", self.RepeatOverload, 27, self)
		end
	elseif msg:find(L["phase2_end_trigger"]) then
		self:CancelScheduledEvent("BreathWarn")
		self:CancelScheduledEvent("OverloadWarn")
		self:CancelScheduledEvent("Overload")
		self:TriggerEvent("BigWigs_StopBar", self, L["overload_next"])
		self:TriggerEvent("BigWigs_StopBar", self, L["breath"])
		self:Message(L["phase3_warning"], "Attention")
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:Message(L["phase3_message"], "Attention")
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 54 and not p2 then
			self:Message(L["phase2_warning"], "Attention")
			p2 = true
		elseif hp > 60 and p2 then
			p2 = false
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
			self:Bar(L["sparks"], 25, 44780)
			self:ScheduleEvent("SparkWarn", "BigWigs_Message", 20, L["sparks_warning"], "Attention")
		end
		if db.enrage then
			self:Enrage(600, true)
		end
	end
end
