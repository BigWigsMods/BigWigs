------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Sartharion"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local enrage_warned = nil
local drakes = nil
local fmt = string.format
local shadron, tenebron, vesperon = nil, nil, nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sartharion",

	tsunami = "Flame Tsunami",
	tsunami_desc = "Warn for churning lava and show a bar.",
	tsunami_warning = "Flame Tsunami in ~5sec!",
	tsunami_message = "Flame Tsunami!",
	tsunami_cooldown = "Flame Tsunami Cooldown",
	tsunami_trigger = "The lava surrounding Sartharion churns!",

	breath = "Flame Breath",
	breath_desc = "Warn for Flame Breath casting.",
	breath_warning = "Flame Breath in ~5sec!",
	breath_message = "Flame Breath!",
	breath_cooldown = "Flame Breath Cooldown",

	drakes = "Drake Adds",
	drakes_desc = "Warn when each drake add will join the fight.",
	drakes_incomingbar = "%s incoming",
	drakes_incomingsoon = "%s incoming in ~5sec!",
	drakes_incoming = "%s incoming!",
	drakes_activebar = "%s active",
	drakes_active = "%s is active!",

	vesperon = "Vesperon",
	vesperon_trigger = "Vesperon, the clutch is in danger! Assist me!",

	shadron = "Shadron",
	shadron_trigger = "Shadron! Come to me! All is at risk!",

	tenebron = "Tenebron",
	tenebron_trigger = "Tenebron! The eggs are yours to protect as well!",

	drakedeath = "Drake Death",
	drakedeath_desc = "Warn when one of the drake adds die.",
	drakedeath_message = "%s died!",

	enrage = "Enrage",
	enrage_warning = "Enrage soon!",
	enrage_message = "Enraged!",
} end )

L:RegisterTranslations("koKR", function() return {
	tsunami = "용암 파도",
	tsunami_desc = "용암파도에 바와 알림입니다.",
	tsunami_warning = "약 5초 후 용암 파도!",
	tsunami_message = "용암 파도!",
	tsunami_cooldown = "용암 파도 대기시간",
	tsunami_trigger = "둘러싼 용암이 끓어오릅니다!",

	breath = "화염 숨결",
	breath_desc = "화염 숨결 시전을 알립니다.",
	breath_warning = "약 5초 후 화염 숨결!",
	breath_message = "화염 숨결!",
	breath_cooldown = "화염 숨결 대기시간",

	drakes = "비룡 추가",
	drakes_desc = "각 비룡이 전투에 추가되는 것을 알립니다.",
	drakes_incomingbar = "잠시 후 %s 출현",
	drakes_incomingsoon = "약 5초 후 %s 출현!",
	drakes_incoming = "%s 출현!",
	drakes_activebar = "%s 활동",
	drakes_active = "%s 활동!",

	vesperon = "베스페론",
	vesperon_trigger = "베스페론, 알이 위험하다! 날 도와라!",

	shadron = "샤드론",
	shadron_trigger = "샤드론! 이리 와라! 위험한 상황이다!",

	tenebron = "테네브론",
	tenebron_trigger = "테네브론! 너도 알을 지킬 책임이 있어!",

	drakedeath = "비룡 죽음",
	drakedeath_desc = "비룡의 죽음에 대해 알립니다.",
	drakedeath_message = "%s 죽음!",

	enrage = "광폭화",
	enrage_warning = "잠시 후 광폭화!",
	enrage_message = "광폭화!",
} end )

L:RegisterTranslations("zhCN", function() return {
	tsunami = "烈焰之啸",
	tsunami_desc = "当熔岩搅动时显示计时条。",
	tsunami_warning = "约5秒，烈焰之啸！",
	tsunami_message = "烈焰之啸！",
	tsunami_cooldown = "烈焰之啸冷却！",
	tsunami_trigger = "The lava surrounding %s churns!",	--check

	breath = "烈焰吐息",
	breath_desc = "当正在施放烈焰吐息时发出警报。",
	breath_warning = "约5秒，烈焰吐息！",
	breath_message = "烈焰吐息！",
	breath_cooldown = "烈焰吐息冷却！",

	drakes = "幼龙增援",
	drakes_desc = "当每只幼龙增援加入战斗时发出警报。",
	drakes_incomingbar = "<%s：即将到来>",
	drakes_incomingsoon = "约5秒后，%s即将到来！",
	drakes_incoming = "%s即将到来！",
	drakes_activebar = "<%s：已激活>",
	drakes_active = "%s - 已激活！",

	vesperon = "维斯匹隆",
	vesperon_trigger = "Vesperon, the clutch is in danger! Assist me!",

	shadron = "沙德隆",
	shadron_trigger = "Shadron! Come to me! All is at risk!",

	tenebron = "塔尼布隆",
	tenebron_trigger = "Tenebron! The eggs are yours to protect as well!",

	drakedeath = "幼龙死亡",
	drakedeath_desc = "当增援幼龙死亡时发出警报。",
	drakedeath_message = "%s死亡！",

	enrage = "狂暴",
	enrage_warning = "即将 狂暴！",
	enrage_message = "狂暴！",
} end )

L:RegisterTranslations("zhTW", function() return {
	tsunami = "炎嘯",
	tsunami_desc = "當熔岩攪動時發出警報及顯示計時條。",
	tsunami_warning = "約5秒，炎嘯！",
	tsunami_message = "炎嘯！",
	tsunami_cooldown = "炎嘯冷卻！",
	tsunami_trigger = "圍繞著%s的熔岩開始劇烈地翻騰!",	--check

	breath = "火息術",
	breath_desc = "當正在施放火息術時發出警報。",
	breath_warning = "約5秒，火息術！",
	breath_message = "火息術！",
	breath_cooldown = "火息術冷卻！",

	drakes = "飛龍增援",
	drakes_desc = "當每只飛龍增援加入戰斗時發出警報。",
	drakes_incomingbar = "<%s：即將到來>",
	drakes_incomingsoon = "約5秒后。%s即將到來！",
	drakes_incoming = "%s即將到來！",
	drakes_activebar = "<%s：已激活>",
	drakes_active = "%s已激活！",

	vesperon = "維斯佩朗",
	vesperon_trigger = "Vesperon, the clutch is in danger! Assist me!",

	shadron = "夏德朗",
	shadron_trigger = "Shadron! Come to me! All is at risk!",

	tenebron = "坦納伯朗",
	tenebron_trigger = "坦納伯朗!你也應該要保護龍蛋!",

	drakedeath = "飛龍死亡",
	drakedeath_desc = "當增援飛龍死亡時發出警報。",
	drakedeath_message = "%s死亡！",

	enrage = "狂暴",
	enrage_warning = "即將 狂暴！",
	enrage_message = "狂暴！",
} end )

L:RegisterTranslations("frFR", function() return {
	tsunami = "Tsunami de flammes",
	tsunami_desc = "Prévient de l'arrivée des Tsunami de flammes.",
	tsunami_warning = "Tsunami de flammes dans ~5 sec. !",
	tsunami_message = "Tsunami de flammes !",
	tsunami_cooldown = "Recharge Tsunami de flammes",
	tsunami_trigger = "La lave qui entoure Sartharion bouillonne !",

	breath = "Souffle de flammes",
	breath_desc = "Prévient quand un Souffle de flammes est incanté.",
	breath_warning = "Souffle de flammes dans ~5 sec. !",
	breath_message = "Souffle de flammes !",
	breath_cooldown = "Recharge Souffle de flammes",

	drakes = "Arrivée des drakes",
	drakes_desc = "Prévient quand chaque drake se joint au combat.",
	drakes_incomingbar = "Arrivée |2 %s",
	drakes_incomingsoon = "Arrivée |2 %s dans ~5 sec. !",
	drakes_incoming = "Arrivée |2 %s !",
	drakes_activebar = "%s actif",
	drakes_active = "%s est actif !",

	vesperon = "Vespéron",
	vesperon_trigger = "Vespéron, la portée est en danger ! À moi !", -- à vérifier

	shadron = "Obscuron",
	shadron_trigger = "Obscuron ! Viens à moi ! Nous risquons de tout perdre !", -- à vérifier

	tenebron = "Ténébron",
	tenebron_trigger = "Ténébron ! Toi aussi, tu dois protéger les oeufs !", -- à vérifier

	drakedeath = "Mort des drakes",
	drakedeath_desc = "Prévient quand un des drakes arrivé en renfort meurt.",
	drakedeath_message = "%s est mort !",

	enrage = "Enrager",
	enrage_warning = "Enrager imminent !",
	enrage_message = "Enragé !",
} end )

L:RegisterTranslations("ruRU", function() return {
	tsunami = "Огненное цунами",
	tsunami_desc = "Предупреждать о взбалтывании лавы и отображать полосу.",
	tsunami_warning = "Огненное цунами через ~5сек!",
	tsunami_message = "Огненное цунами!",
	tsunami_cooldown = "Перезарядка цунами",
	tsunami_trigger = "Лава вокруг Сартарион начинает бурлить!",

	breath = "Огненное дыхание",
	breath_desc = "Предупреждать о применении огненного дыхания.",
	breath_warning = "Огненное дыхание через ~5сек!",
	breath_message = "Огненное дыхание!",
	breath_cooldown = "Перезарядка дыхания",

	drakes = "Драконы",
	drakes_desc = "Предупреждать когда драконы вступят в бой.",
	drakes_incomingbar = "Прилёт %s",
	drakes_incomingsoon = "%s прилетит через ~5сек!",
	drakes_incoming = "Прилетел %s!",
	drakes_activebar = "До активности %s",
	drakes_active = "%s активен!",

	vesperon = "Весперон",
	vesperon_trigger = "Vesperon, the clutch is in danger! Assist me!",

	shadron = "Шадрон",
	shadron_trigger = "Shadron! Come to me! All is at risk!",

	tenebron = "Тенеброн",
	tenebron_trigger = "Тенеброн, и защищать яйца – тоже твоя обязанность!",

	drakedeath = "Смерть драконов",
	drakedeath_desc = "Предупреждать о смерти любого из дополнительных драконов.",
	drakedeath_message = "%s умер!",

	enrage = "Исступление",
	enrage_warning = "Скоро Исступление!",
	enrage_message = "Исступление!",
} end )

L:RegisterTranslations("deDE", function() return {
	tsunami = "Flammentsunami",
	tsunami_desc = "Warnung vor Flammentsunami und Anzeigen einer Leiste.",
	tsunami_warning = "Flammentsunami in ~5sek!",
	tsunami_message = "Flammentsunami!",
	tsunami_cooldown = "Flammentsunami Cooldown",
	tsunami_trigger = "Die Lava um Sartharion brodelt!",

	breath = "Flammenatem",
	breath_desc = "Warnung wenn Flammenatem gewirkt wird.",
	breath_warning = "Flammenatem in ~5sek!",
	breath_message = "Flammenatem!",
	breath_cooldown = "Flammenatem Cooldown",

	drakes = "Drachen Adds",
	drakes_desc = "Warnen wenn einer der Drachen dem Kampf beitritt.",
	drakes_incomingbar = "%s kommt",
	drakes_incomingsoon = "%s kommt in ~5sek!",
	drakes_incoming = "%s kommt!",
	drakes_activebar = "%s aktiv",
	drakes_active = "%s ist aktiv!",

	vesperon = "Vesperon",
	vesperon_trigger = "Vesperon, das Gelege ist in Gefahr! Helft mir!",

	shadron = "Shadron",
	shadron_trigger = "Shadron! Kommt zu mir! Der Sieg steht auf Messers Schneide!",

	tenebron = "Tenebron",
	tenebron_trigger = "Tenebron! Auch Ihr sollt die Eier schützen!",

	drakedeath = "Drachen tot",
	drakedeath_desc = "Warnen wenn einer der Drachen stirbt.",
	drakedeath_message = "%s gestorben!",

	enrage = "Wütend",
	enrage_warning = "In Kürze Wütend!",
	enrage_message = "Wütend!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["The Obsidian Sanctum"]
mod.otherMenu = "Northrend"
mod.enabletrigger = boss
mod.guid = 28860
mod.toggleoptions = {"tsunami", "breath", -1, "drakes", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 61632)
	self:AddCombatListener("SPELL_CAST_START", "Breath", 56908, 58956)
	self:AddCombatListener("UNIT_DIED", "Deaths")
--	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

--	BigWigs:Print(L["log"])
	started = nil
	db = self.db.profile
	enrage_warned = false
	shadron, tenebron, vesperon = nil, nil, nil
	drakes = {
		[30449] = {["name"] = L["vesperon"], ["alive"] = true,},
		[30451] = {["name"] = L["shadron"], ["alive"] = true,},
		[30452] = {["name"] = L["tenebron"], ["alive"] = true,},
	}
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:DrakeCheck(_, spellID)
--	58105 = Shadron
--	61248 = Tenebron
--	61251 = Vesperon

--	Tenebron called in roughly 15s after engage
--	Shadron called in roughly 60s after engage
--	Vesperon called in roughly 105s after engage
	if not db.drakes then return end
	if spellID == 58105 and not shadron then
		self:CancelScheduledEvent("ShadronWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_incomingbar"], L["shadron"]))
		self:Bar(fmt(L["drakes_incomingbar"], L["shadron"]), 60, 58105)
		self:ScheduleEvent("ShadronWarn", "BigWigs_Message", 55, fmt(L["drakes_incomingsoon"], L["shadron"]), "Attention")
		shadron = true
	elseif spellID == 61248 and not tenebron then
		self:CancelScheduledEvent("TenebronWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_incomingbar"], L["tenebron"]))
		self:Bar(fmt(L["drakes_incomingbar"], L["tenebron"]), 15, 61248)
		self:ScheduleEvent("TenebronWarn", "BigWigs_Message", 10, fmt(L["drakes_incomingsoon"], L["tenebron"]), "Attention")
		tenebron = true
	elseif spellID == 61251 and not vesperon then
		self:CancelScheduledEvent("VesperonWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_incomingbar"], L["vesperon"]))
		self:Bar(fmt(L["drakes_incomingbar"], L["vesperon"]), 105, 61251)
		self:ScheduleEvent("VesperonWarn", "BigWigs_Message", 100, fmt(L["drakes_incomingsoon"], L["vesperon"]), "Attention")
		vesperon = true
	end
end

function mod:Enraged(_, spellID)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellID, "Alarm")
	end
end

function mod:Breath(_, spellID)
	if db.breath then
		self:CancelScheduledEvent("BreathWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["breath_cooldown"])
		self:Bar(L["breath_cooldown"], 12, 57491)
--		A warning message seems more annoying than helpful
--		self:ScheduleEvent("BreathWarn", "BigWigs_Message", 7, L["breath_warning"], "Attention")
	end
end

function mod:Deaths(_, guid)
--	This is pretty ugly, and probably not needed.  The alternative is to check for yells, or SPELL_CAST_SUCCESS for Twilight Revenge (60639)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid then
		self:BossDeath(nil, self.guid, true)
	elseif guid == 30449 or guid == 30451 or guid == 30452 then
		if not started then
			-- The drake died before engaging Sartharion, so it will not add during the fight.
			drakes[guid]["alive"] = false
		else
			-- The drake died while fighting Sartharion, so warn about the death, but don't mark as dead incase of a wipe.
			self:Message(fmt(L["drakedeath_message"], drakes[guid]["name"]), "Attention")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L["tsunami_trigger"]) and db.tsunami then
		self:CancelScheduledEvent("TsunamiWarn")
		self:TriggerEvent("BigWigs_StopBar", self, L["tsunami_cooldown"])
		self:IfMessage(L["tsunami_message"], "Important", 57491)
		self:Bar(L["tsunami_cooldown"], 30, 57491)
		self:ScheduleEvent("TsunamiWarn", "BigWigs_Message", 25, L["tsunami_warning"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
--	Roughly 12s after the yell, the drakes actually become active
	if not db.drakes then return end
	if msg:find(L["vesperon_trigger"]) then
		self:Message(fmt(L["drakes_incoming"], L["vesperon"]), "Attention")
		self:CancelScheduledEvent("VesperonWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_activebar"], L["vesperon"]))
		self:Bar(fmt(L["drakes_activebar"], L["vesperon"]), 12, 61251)
		self:ScheduleEvent("VesperonWarn", "BigWigs_Message", 12, fmt(L["drakes_active"], L["vesperon"]), "Attention")
	elseif msg:find(L["shadron_trigger"]) then
		self:Message(fmt(L["drakes_incoming"], L["shadron"]), "Attention")
		self:CancelScheduledEvent("ShadronWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_activebar"], L["shadron"]))
		self:Bar(fmt(L["drakes_activebar"], L["shadron"]), 12, 58105)
		self:ScheduleEvent("ShadronWarn", "BigWigs_Message", 12, fmt(L["drakes_active"], L["shadron"]), "Attention")
	elseif msg:find(L["tenebron_trigger"]) then
		self:Message(fmt(L["drakes_incoming"], L["tenebron"]), "Attention")
		self:CancelScheduledEvent("TenebronWarn")
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["drakes_activebar"], L["tenebron"]))
		self:Bar(fmt(L["drakes_activebar"], L["tenebron"]), 12, 61248)
		self:ScheduleEvent("TenebronWarn", "BigWigs_Message", 12, fmt(L["drakes_active"], L["tenebron"]), "Attention")
	end
end

function mod:UNIT_HEALTH(msg)
	if not db.enrage then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 11 and hp <= 14 and not enrage_warned then
			self:Message(L["enrage_warning"], "Attention")
			enrage_warned = true
		end
	end
end	

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.tsunami then
			self:CancelScheduledEvent("TsunamiWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["tsunami_cooldown"])
			self:Bar(L["tsunami_cooldown"], 30, 57491)
			self:ScheduleEvent("TsunamiWarn", "BigWigs_Message", 25, L["tsunami_warning"], "Attention")
		end
--[[
		if db.breath then
			self:CancelScheduledEvent("BreathWarn")
			self:TriggerEvent("BigWigs_StopBar", self, L["breath_cooldown"])
			self:Bar(L["breath_cooldown"], 12, 57491)
			self:ScheduleEvent("BreathWarn", "BigWigs_Message", 7, L["breath_warning"], "Attention")
		end
]]
	end
end
