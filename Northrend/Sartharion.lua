----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Sartharion"]
local shadron, tenebron, vesperon = BB["Shadron"], BB["Tenebron"], BB["Vesperon"]
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.zoneName = BZ["The Obsidian Sanctum"]
mod.otherMenu = "Northrend"
mod.enabletrigger = {boss, shadron, tenebron, vesperon}
mod.guid = 28860
mod.toggleOptions = {"tsunami", 56908, -1, "drakes", "twilight", "berserk", "bosskill"}
mod.consoleCmd = "Sartharion"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local fmt = string.format
local shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "It is my charge to watch over these eggs. I will see you burn before any harm comes to them!",

	tsunami = "Flame Wave",
	tsunami_desc = "Warn for churning lava and show a bar.",
	tsunami_warning = "Wave in ~5sec!",
	tsunami_message = "Flame Wave!",
	tsunami_cooldown = "Wave Cooldown",
	tsunami_trigger = "The lava surrounding %s churns!",

	breath_cooldown = "~Breath Cooldown",

	drakes = "Drake Adds",
	drakes_desc = "Warn when each drake add will join the fight.",
	drakes_incomingsoon = "%s landing in ~5sec!",

	twilight = "Twilight Events",
	twilight_desc = "Warn what happens in the Twilight.",
	twilight_trigger_tenebron = "Tenebron begins to hatch eggs in the Twilight!",
	twilight_trigger_vesperon = "A Vesperon Disciple appears in the Twilight!",
	twilight_trigger_shadron = "A Shadron Acolyte appears in the Twilight!",
	twilight_message_tenebron = "Eggs hatching",
	twilight_message = "%s add up!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "내 임무는 알을 보호하는 것. 알에 손대지 못하게 모두 불태워 주마.",

	tsunami = "용암 파도",
	tsunami_desc = "용암파도에 바와 알림입니다.",
	tsunami_warning = "약 5초 후 용암 파도!",
	tsunami_message = "용암 파도!",
	tsunami_cooldown = "용암 파도 대기시간",
	tsunami_trigger = "%s|1을;를; 둘러싼 용암이 끓어오릅니다!",

	breath_cooldown = "화염 숨결 대기시간",

	drakes = "비룡 추가",
	drakes_desc = "각 비룡이 전투에 추가되는 것을 알립니다.",
	drakes_incomingsoon = "약 5초 후 %s 착지!",

	twilight = "황혼 이벤트",
	twilight_desc = "황혼의 안에서 무엇이 일어나는지 알립니다.",
	twilight_trigger_tenebron = "테네브론이 황혼에서 알을 부화하기 시작합니다!",
	twilight_trigger_vesperon = "베스페론의 신도가 황혼에서 나타납니다!",
	twilight_trigger_shadron = "샤드론의 신도가 황혼에서 나타납니다!",
	twilight_message_tenebron = "알 부화중",
	twilight_message = "%s 신도 추가!",
} end )

L:RegisterTranslations("zhCN", function() return {
	--engage_trigger = "It is my charge to watch over these eggs. I will see you burn before any harm comes to them!",

	tsunami = "烈焰之啸",
	tsunami_desc = "当熔岩搅动时显示计时条。",
	tsunami_warning = "约5秒，烈焰之啸！",
	tsunami_message = "烈焰之啸！",
	tsunami_cooldown = "烈焰之啸冷却！",
	tsunami_trigger = "The lava surrounding %s churns!", --check

	breath_cooldown = "烈焰吐息冷却！",

	drakes = "幼龙增援",
	drakes_desc = "当每只幼龙增援加入战斗时发出警报。",
	drakes_incomingsoon = "约5秒后，%s即将到来！",

	twilight = "暮光召唤",
	twilight_desc = "当暮光召唤时发出警报。",
	twilight_trigger_tenebron = "塔尼布隆在暮光中孵化龙蛋！", --check
	twilight_trigger_vesperon = "一个维斯匹隆的信徒从暮光中出现！", --check
	twilight_trigger_shadron = "一个沙德隆的信徒从暮光中出现！", --check
	twilight_message_tenebron = "正在孵卵！",
	twilight_message = "%s到来！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "我的職責就是要看守這些龍蛋。在他們受到任何傷害之前，我將會看著你陷入火焰之中!",

	tsunami = "炎嘯",
	tsunami_desc = "當熔岩攪動時發出警報及顯示計時條。",
	tsunami_warning = "約5秒，炎嘯！",
	tsunami_message = "炎嘯！",
	tsunami_cooldown = "炎嘯冷卻！",
	tsunami_trigger = "圍繞著%s的熔岩開始劇烈地翻騰!",

	breath_cooldown = "火息術冷卻！",

	drakes = "飛龍增援",
	drakes_desc = "當每只飛龍增援加入戰鬥時發出警報。",
	drakes_incomingsoon = "約5秒後。%s即將到來！",

	twilight = "暮光召喚",
	twilight_desc = "當暮光召喚時發出警報。",
	twilight_trigger_tenebron = "坦納伯朗在暮光中孵化龍蛋!",
	twilight_trigger_vesperon = "一個維斯佩朗信徒從暮光中出現!",
	twilight_trigger_shadron = "一個夏德朗信徒從暮光中出現!",
	twilight_message_tenebron = "正在孵卵！",
	twilight_message = "%s到來！",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Ces oeufs sont sous ma responsabilité. Je vous ferai brûler avant de vous laisser y toucher !",

	tsunami = "Vague de flammes",
	tsunami_desc = "Prévient quand la lave bouillonne et affiche une barre.",
	tsunami_warning = "Vague dans ~5 sec. !",
	tsunami_message = "Vague de flammes !",
	tsunami_cooldown = "Recharge Vague",
	tsunami_trigger = "La lave qui entoure %s bouillonne !",

	breath_cooldown = "Recharge Souffle",

	drakes = "Arrivée des drakes",
	drakes_desc = "Prévient quand chaque drake se joint au combat.",
	drakes_incomingsoon = "%s atterrit dans ~5 sec. !",

	twilight = "Évènements du crépuscule",
	twilight_desc = "Prévient quand quelque chose se passe dans le crépuscule.",
	twilight_trigger_tenebron = "Ténébron se met à poser des œufs dans le crépuscule !",
	twilight_trigger_vesperon = "Un disciple de Vespéron apparaît dans le crépuscule !",
	twilight_trigger_shadron = "Un disciple d'Obscuron apparaît dans le crépuscule !",
	twilight_message_tenebron = "Éclosion des œufs",
	twilight_message = "Disciple |2 %s actif !",
} end )

L:RegisterTranslations("ruRU", function() return {
	--engage_trigger = "It is my charge to watch over these eggs. I will see you burn before any harm comes to them!",

	tsunami = "Огненное цунами",
	tsunami_desc = "Предупреждать о взбалтывании лавы и отображать полосу.",
	tsunami_warning = "Огненное цунами через ~5сек!",
	tsunami_message = "Огненное цунами!",
	tsunami_cooldown = "Перезарядка цунами",
	tsunami_trigger = "Лава вокруг |3-1(%s) начинает бурлить!",

	breath_cooldown = "Перезарядка дыхания",

	drakes = "Драконы",
	drakes_desc = "Предупреждать когда драконы вступят в бой.",
	drakes_incomingsoon = "%s прилетит через ~5сек!",

	twilight = "События в Зоне сумерек",
	twilight_desc = "Сообщать что происходит с Сумеречным порталом.",
	twilight_trigger_tenebron = "Тенеброн начинает высиживать кладку в Зоне сумерек!",
	twilight_trigger_vesperon = "В Сумраке появляется ученик Весперона!",
	twilight_trigger_shadron = "Ученик Шадрона появляется в Зоне сумерек!",
	twilight_message_tenebron = "Вылупление яиц",
	twilight_message = "Появился Ученик |3-1(%s)!",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Meine Aufgabe ist es, über diese Eier zu wachen. Kommt ihnen zu nahe und von euch bleibt nur ein Häuflein Asche.",

	tsunami = "Flammentsunami",
	tsunami_desc = "Warnungen und Timer für Flammentsunami.",
	tsunami_warning = "Flammentsunami in ~5 sek!",
	tsunami_message = "Flammentsunami!",
	tsunami_cooldown = "~Flammentsunami",
	tsunami_trigger = "Die Lava um %s brodelt!",

	breath_cooldown = "~Flammenatem",

	drakes = "Drachen",
	drakes_desc = "Warnungen und Timer für den Kampfbeitritt der Drachen.",
	drakes_incomingsoon = "%s kommt in ~5 sek!",

	twilight = "Zwielicht Ereignisse",
	twilight_desc = "Warnungen und Timer für Ereignisse in der Zwielichtzone.",
	twilight_trigger_tenebron = "Tenebron beginnt im Zwielicht Eier auszubrüten!",
	twilight_trigger_vesperon = "Ein Vesperonjünger erscheint im Zwielicht!",
	twilight_trigger_shadron = "Ein Shadronjünger erscheint im Zwielicht!",
	twilight_message_tenebron = "Eier schlüpfen",
	twilight_message = "%s kommt dazu!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "DrakeCheck", 58105, 61248, 61251)
	self:AddCombatListener("SPELL_CAST_START", "Breath", 56908, 58956)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	shadronStarted, tenebronStarted, vesperonStarted = nil, nil, nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:DrakeCheck(_, spellId)
	-- Tenebron (61248) called in roughly 15s after engage
	-- Shadron (58105) called in roughly 60s after engage
	-- Vesperon (61251) called in roughly 105s after engage
	-- Each drake takes around 12 seconds to land
	if not db.drakes then return end
	if spellId == 58105 and not shadronStarted then
		self:Bar(shadron, 80, 58105)
		self:DelayedMessage(75, fmt(L["drakes_incomingsoon"], shadron), "Attention")
		shadronStarted = true
	elseif spellId == 61248 and not tenebronStarted then
		self:Bar(tenebron, 30, 61248)
		self:DelayedMessage(25, fmt(L["drakes_incomingsoon"], tenebron), "Attention")
		tenebronStarted = true
	elseif spellId == 61251 and not vesperonStarted then
		self:Bar(vesperon, 120, 61251)
		self:DelayedMessage(115, fmt(L["drakes_incomingsoon"], vesperon), "Attention")
		vesperonStarted = true
	end
end

function mod:Breath(_, spellId)
	self:Bar(L["breath_cooldown"], 12, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if msg == L["tsunami_trigger"] and db.tsunami then
		self:Message(L["tsunami_message"], "Important", 57491, "Alert")
		self:Bar(L["tsunami_cooldown"], 30, 57491)
		self:DelayedMessage(25, L["tsunami_warning"], "Attention")
	elseif db.twilight then
		if mob == tenebron and msg == L["twilight_trigger_tenebron"] then
			self:Bar(L["twilight_message_tenebron"], 20, 23851)
			self:Message(L["twilight_message_tenebron"], "Attention", 23851)
		elseif mob == shadron and msg == L["twilight_trigger_shadron"] then
			self:Message(L["twilight_message"]:format(mob), "Urgent", 59570)
		elseif mob == vesperon and msg == L["twilight_trigger_vesperon"] then
			self:Message(L["twilight_message"]:format(mob), "Personal", 59569, "Alarm")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.tsunami then
			self:Bar(L["tsunami_cooldown"], 30, 57491)
			self:DelayedMessage(25, L["tsunami_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(900, true)
		end
	end
end

