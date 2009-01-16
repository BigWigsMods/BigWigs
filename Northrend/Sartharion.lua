------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Sartharion"]
local shadron, tenebron, vesperon = BB["Shadron"], BB["Tenebron"], BB["Vesperon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local db = nil
local started = nil
local enrage_warned = nil
local fmt = string.format
local shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sartharion",

	tsunami = "Flame Wave",
	tsunami_desc = "Warn for churning lava and show a bar.",
	tsunami_warning = "Wave in ~5sec!",
	tsunami_message = "Flame Wave!",
	tsunami_cooldown = "Wave Cooldown",
	tsunami_trigger = "The lava surrounding %s churns!",

	breath = "Flame Breath",
	breath_desc = "Warn for Flame Breath casting.",
	breath_warning = "Breath in ~5sec!",
	breath_message = "Breath!",
	breath_cooldown = "Breath Cooldown",

	drakes = "Drake Adds",
	drakes_desc = "Warn when each drake add will join the fight.",
	drakes_incomingbar = "%s incoming",
	drakes_incomingsoon = "%s landing in ~5sec!",

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
	tsunami_trigger = "%s|1을;를; 둘러싼 용암이 끓어오릅니다!",

	breath = "화염 숨결",
	breath_desc = "화염 숨결 시전을 알립니다.",
	breath_warning = "약 5초 후 화염 숨결!",
	breath_message = "화염 숨결!",
	breath_cooldown = "화염 숨결 대기시간",

	drakes = "비룡 추가",
	drakes_desc = "각 비룡이 전투에 추가되는 것을 알립니다.",
	drakes_incomingbar = "잠시 후 %s 출현",
	drakes_incomingsoon = "약 5초 후 %s 착지!",

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

	enrage = "狂暴",
	enrage_warning = "即將 狂暴！",
	enrage_message = "狂暴！",
} end )

L:RegisterTranslations("frFR", function() return {
	tsunami = "Tsunami de flammes",
	tsunami_desc = "Prévient de l'arrivée des Tsunami de flammes.",
	tsunami_warning = "Tsunami de flammes dans ~5 sec. !",
	tsunami_message = "Tsunami de flammes !",
	tsunami_cooldown = "Recharge Tsunami",
	tsunami_trigger = "La lave qui entoure %s bouillonne !",

	breath = "Souffle de flammes",
	breath_desc = "Prévient quand un Souffle de flammes est incanté.",
	breath_warning = "Souffle de flammes dans ~5 sec. !",
	breath_message = "Souffle de flammes !",
	breath_cooldown = "Recharge Souffle",

	drakes = "Arrivée des drakes",
	drakes_desc = "Prévient quand chaque drake se joint au combat.",
	drakes_incomingbar = "Arrivée |2 %s",
	drakes_incomingsoon = "%s atterrit dans ~5 sec. !",

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
	tsunami_trigger = "Лава вокруг %s начинает бурлить!",

	breath = "Огненное дыхание",
	breath_desc = "Предупреждать о применении огненного дыхания.",
	breath_warning = "Огненное дыхание через ~5сек!",
	breath_message = "Огненное дыхание!",
	breath_cooldown = "Перезарядка дыхания",

	drakes = "Драконы",
	drakes_desc = "Предупреждать когда драконы вступят в бой.",
	drakes_incomingbar = "Прилёт %s",
	drakes_incomingsoon = "%s прилетит через ~5сек!",

	enrage = "Исступление",
	enrage_warning = "Скоро Исступление!",
	enrage_message = "Исступление!",
} end )

L:RegisterTranslations("deDE", function() return {
	tsunami = "Flammentsunami",
	tsunami_desc = "Warnungen und Timer für Flammentsunami.",
	tsunami_warning = "Flammentsunami in ~5 Sekunden!",
	tsunami_message = "Flammentsunami!",
	tsunami_cooldown = "Flammentsunami Cooldown",
	tsunami_trigger = "Die Lava um %s brodelt!",

	breath = "Flammenatem",
	breath_desc = "Warnungen und Timer für Flammenatem.",
	breath_warning = "Flammenatem in ~5 Sekunden!",
	breath_message = "Flammenatem!",
	breath_cooldown = "Flammenatem Cooldown",

	drakes = "Drachen Adds",
	drakes_desc = "Warnungen und Timer für den Kampfbeitritt eines Drachen.",
	drakes_incomingbar = "%s kommt",
	drakes_incomingsoon = "%s kommt in ~5 Sekunden!",

	enrage = "Wutanfall",
	enrage_warning = "Wutanfall in Kürze!",
	enrage_message = "Wutanfall!",
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
	-- XXX We need to warn about portals and disciples

	self:AddCombatListener("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 61632)
	self:AddCombatListener("SPELL_CAST_START", "Breath", 56908, 58956)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	started = nil
	db = self.db.profile
	enrage_warned = false
	shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:DrakeCheck(_, spellID)
	-- Tenebron (61248) called in roughly 15s after engage
	-- Shadron (58105) called in roughly 60s after engage
	-- Vesperon (61251) called in roughly 105s after engage
	-- Each drake takes around 12 seconds to land
	if not db.drakes then return end
	if spellID == 58105 and not shadronStarted then
		self:Bar(shadron, 72, 58105)
		self:DelayedMessage(67, fmt(L["drakes_incomingsoon"], shadron), "Attention")
		shadronStarted = true
	elseif spellID == 61248 and not tenebronStarted then
		self:Bar(tenebron, 30, 61248)
		self:DelayedMessage(22, fmt(L["drakes_incomingsoon"], tenebron), "Attention")
		tenebronStarted = true
	elseif spellID == 61251 and not vesperonStarted then
		self:Bar(vesperon, 117, 61251)
		self:DelayedMessage(100, fmt(L["drakes_incomingsoon"], vesperon), "Attention")
		vesperonStarted = true
	end
end

function mod:Enraged(_, spellID)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellID, "Alarm")
	end
end

function mod:Breath(_, spellID)
	if db.breath then
		self:Bar(L["breath_cooldown"], 12, 57491)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["tsunami_trigger"] and db.tsunami then
		self:Message(L["tsunami_message"], "Important", 57491, "Alert")
		self:Bar(L["tsunami_cooldown"], 30, 57491)
		self:DelayedMessage(25, L["tsunami_warning"], "Attention")
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
			self:Bar(L["tsunami_cooldown"], 30, 57491)
			self:DelayedMessage(25, L["tsunami_warning"], "Attention")
		end
	end
end

