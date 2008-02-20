------------------------------
--      Are you local?      --
------------------------------

local boss = BB["The Crone"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local roar = BB["Roar"]
local tinhead = BB["Tinhead"]
local strawman = BB["Strawman"]
local dorothee = BB["Dorothee"]
local tito = BB["Tito"]
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "WizardofOz",

	engage_trigger = "^Oh Tito, we simply must find a way home!",

	spawns = "Spawn Timers",
	spawns_desc = "Timers for when the characters become active.",
	spawns_bar = "%s attacks!",
	spawns_warning = "%s in 5 sec",

	light = "Chain Lightning",
	light_desc = "Warn for Chain Lightning being cast.",
	light_trigger = "The Crone begins to cast Chain Lightning.",
	light_message = "Chain Lightning!",
} end)

L:RegisterTranslations("deDE", function() return {
	spawns = "Spawn Timer",
	spawns_desc = "Zeitanzeige bis die Charaktere Aktiv werden",

	light = "Kettenblitzschlag",
	light_desc = "Warnt wenn Kettenblitzschlag gewirkt wird",

	spawns_bar = "%s greift an!",
	spawns_warning = "%s in 5 sek",

	light_trigger = "Die b\195\182se Hexe beginnt Kettenblitzschlag zu wirken.",
	light_message = "Kettenblitzschlag!",

	engage_trigger = "^Oh Tito, wir m\195\188ssen einfach einen Weg nach Hause finden!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Oh, Tito, nous devons trouver le moyen de rentrer à la maison !",

	spawns = "Délais d'activité",
	spawns_desc = "Affiche plusieurs barres indiquant quand les différents personnages passent à l'action.",
	spawns_bar = "%s attaque !",
	spawns_warning = "%s dans 5 sec.",

	light = "Chaîne d'éclairs",
	light_desc = "Préviens quand la Chaîne d'éclairs est incantée.",
	light_trigger = "La Mégère commence à lancer Chaîne d'éclairs.",
	light_message = "Chaîne d'éclairs !",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^티토야, 우린 집으로 갈 방법을 찾아야 해!",

	spawns = "등장 타이머",
	spawns_desc = "피조물 활동 시작에 대한 타이머입니다.",
	spawns_bar = "%s 공격!",
	spawns_warning = "5초 이내 %s",

	light = "연쇄 번개",
	light_desc = "연쇄 번개 시전 시 경고합니다.",
	light_trigger = "연쇄 번개 시전을 시작합니다.", -- check
	light_message = "연쇄 번개!",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "^啊，托托，我们必须找到回家的路！",

	spawns = "启动时间",
	spawns_desc = "每个角色激活时间计时。",
	spawns_bar = "%s 开始攻击！",
	spawns_warning = "%s 将在 5秒后 开始攻击",

	light = "闪电链",
	light_desc = "老巫婆施放闪电链时发出警报。",
	light_trigger = "巫婆开始施放闪电链。",
	light_message = "闪电链！",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "喔多多，我們一定要找到回家的路!",

	spawns = "啟動時間",
	spawns_desc = "設定各角色啟動時間計時",
	spawns_bar = "%s 開始攻擊",
	spawns_warning = "%s 將在 5 秒後開始攻擊",

	light = "閃電鏈警告",
	light_desc = "當施放悶電鏈時發送警告",
	light_trigger = "老巫婆開始施放閃電鏈。",
	light_message = "即將施放閃電鏈",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "^Oh, Tito, tenemos que encontrar la forma de volver a casa!",

	spawns = "Timers de Activacion",
	spawns_desc = "Timers para cuando los persoanjes se activan.",
	spawns_bar = "%s attacks!",
	spawns_warning = "%s en 5 sec",

	light = "Cadena de Relampagos",
	light_desc = "Avisa del casteo de Cadena de Relampagos.",
	light_trigger = "La Vieja Bruja comienza a lanzar Cadena de relámpagos.",
	light_message = "Cadena de Relampagos!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = {roar, tinhead, strawman, dorothee}
mod.toggleoptions = {"spawns", "light", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:AddCombatListener("SPELL_CAST_START", "ChainLightning", 32337)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

--Need to make some hack to enable for this addon someday, latency sometimes means they yell before the f* curtains are up >.<
--Probably use GetSubZoneText()
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) and self.db.profile.spawns then
		local swarn = L["spawns_warning"]
		local sbar = L["spawns_bar"]
		self:Bar(fmt(sbar, roar), 15, "INV_Staff_08")
		self:DelayedMessage(10, fmt(swarn, roar), "Attention")
		self:Bar(fmt(sbar, strawman), 25, "Ability_Druid_ChallangingRoar")
		self:DelayedMessage(20, fmt(swarn, strawman), "Attention")
		self:Bar(fmt(sbar, tinhead), 35, "INV_Chest_Plate06")
		self:DelayedMessage(30, fmt(swarn, tinhead), "Attention")
		self:Bar(fmt(sbar, tito), 48, "Ability_Hunter_Pet_Wolf")
		self:DelayedMessage(43, fmt(swarn, tito), "Attention")
	end
end

function mod:ChainLightning(player)
	if self.db.profile.light then
		self:Message(L["light_message"], "Urgent")
		self:Bar(L["light_message"], 2, "Spell_Nature_ChainLightning")	
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["light_trigger"] and self.db.profile.light then
		self:Message(L["light_message"], "Urgent")
		self:Bar(L["light_message"], 2, "Spell_Nature_ChainLightning")
	end
end

