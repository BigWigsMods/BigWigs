----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Ignis the Furnace Master"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33118
mod.toggleoptions = {"construct", "brittle", "flame", "scorch", "slagpot", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local pName = UnitName("player")
local spwanTime = 30

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Ignis",

	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	construct = "Activate Construct",
	construct_desc = "Warn for Activate Construct.",
	construct_message = "Activate Construct!",
	construct_warning = "Construct in 5sec!",
	construct_bar = "Next Construct",

	brittle = "Brittle",
	brittle_desc = "Warn when Iron Construct gains Brittle.",
	brittle_message = "Construct gained Brittle!",

	flame = "Flame Jets",
	flame_desc = "Warn when Ignis casts a Flame Jets.",
	flame_message = "Flame Jets!",
	flame_warning = "Flame Jets soon!",
	flame_bar = "~Jets cooldown",

	scorch = "Scorch",
	scorch_desc = "Warn when you are in a Scorch and Scorch is casting.",
	scorch_message = "Scorch: %s",
	scorch_warning = "Casting Scorch!",
	scorch_soon = "Scorch in ~5sec!",
	scorch_bar = "Next Scorch",

	slagpot = "Slag Pot",
	slagpot_desc = "Warn who has Slag Pot.",
	slagpot_message = "Slag Pot: %s",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Дерзкие глупцы! Ваша кровь закалит оружие, которым был завоеван этот мир!",

	construct = "Задействовать создание",
	construct_desc = "Сообщать о Задействовании создания.",
	construct_message = "Задействовать создание!",
	construct_warning = "Создание через 5сек!",
	construct_bar = "Следующее создание",

	brittle = "Ломкость",
	brittle_desc = "Сообщать когда Железное создание подвергается воздействию Ломкости.",
	brittle_message = "Создание подверглось Ломкости!",

	flame = "Огненная струя",
	flame_desc = "Сообщать когда Игнус применяет Огненную струю.",
	flame_message = "Огненная струя!",
	flame_warning = "Скоро Огненная струя!",
	flame_bar = "~перезарядка струи",

	scorch = "Ожог",
	scorch_desc = "Сообщать когда вас обжигает и когда применяется Ожог.",
	scorch_message = "Ожог: %s",
	scorch_warning = "Применение Ожога!",
	scorch_soon = "Ожог через ~5сек!",
	scorch_bar = "Следующий Ожог",

	slagpot = "Шлаковый ковш",
	slagpot_desc = "Сообщает кого захватывает в Шлаковый ковш.",
	slagpot_message = "Захвачен в ковш: %s",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "건방진 젖먹이들이! 세상을 되찾는데 쓸 무기를 네놈들의 피로 담금질하겠다!",	--check

	construct = "피조물 활성화",
	construct_desc = "피조물 활성화를 알립니다.",
	construct_message = "피조물 활성화!",
	construct_warning = "5초 이내 피조물!",
	construct_bar = "다음 피조물",

	brittle = "Brittle",
	brittle_desc = "Warn when Iron Construct gains Brittle.",
	brittle_message = "Construct gained Brittle!",

	flame = "화염 분출",
	flame_desc = "이그니스의 화염 분출를 알립니다.",
	flame_message = "화염 분출!",
	flame_warning = "잠시후 화염 분출!",
	flame_bar = "~분출 대기시간",

	scorch = "불태우기",
	scorch_desc = "자신의 불태우기와 불태우기 시전을 알립니다.",
	scorch_message = "불태우기: %s",
	scorch_warning = "불태우기 시전!",
	scorch_soon = "약 5초 후 불태우기!",
	scorch_bar = "다음 불태우기",

	slagpot = "용암재 단지",
	slagpot_desc = "용암재 단지의 플레이어를 알립니다.",
	slagpot_message = "용암재 단지: %s",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Chiots insolents ! Les lames qui serviront à reconquérir ce monde seront trempées dans votre sang !",

	construct = "Activer l'assemblage",
	construct_desc = "Prévient de l'arrivée des Assemblages.",
	construct_message = "Assemblage activé !",
	construct_warning = "Assemblage dans 5 sec. !",
	construct_bar = "Prochain Assemblage",

	brittle = "Fragile",
	brittle_desc = "Prévient quand un Assemblage de fer gagne Fragile.",
	brittle_message = "Un Assemblage est devenu Fragile !",

	flame = "Flots de flammes",
	flame_desc = "Prévient quand Ignis incante des Flots de flammes.",
	flame_message = "Flots de flammes !",
	flame_warning = "Flots de flammes imminent !",
	flame_bar = "~Recharge Flots",

	scorch = "Brûlure",
	scorch_desc = "Prévient quand vous vous trouvez dans une Brûlure et quand cette dernière est incantée.",
	scorch_message = "Brûlure : %s",
	scorch_warning = "Brûlure en incantation !",
	scorch_soon = "Brûlure dans ~5 sec. !",
	scorch_bar = "Prochaine Brûlure",

	slagpot = "Marmite de scories",
	slagpot_desc = "Prévient quand un joueur est envoyé dans la Marmite de scories.",
	slagpot_message = "Marmite de scories : %s",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr anmaßenden Wichte! Euer Blut wird die Waffen härten, mit denen diese Welt erobert wird!",

	construct = "Konstrukt aktivieren",
	construct_desc = "Warnung und Timer für Konstrukt aktivieren.",
	construct_message = "Konstrukt aktiviert!",
	construct_warning = "Konstrukt in 5 sek!",
	construct_bar = "Nächstes Konstrukt",

	brittle = "Spröde",
	brittle_desc = "Warnt, wenn ein Eisenkonstrukte spröde wird.",
	brittle_message = "Konstrukt wird spröde!",

	flame = "Flammenstrahlen",
	flame_desc = "Warnt, wenn Flammenstrahlen gewirkt werden.",
	flame_message = "Flammenstrahlen!",
	flame_warning = "Flammenstrahlen bald!",
	flame_bar = "~Flammenstrahlen",

	scorch = "Versengen",
	scorch_desc = "Warnt, wenn Versengen gewirkt wird und wer davon betroffen ist.",
	scorch_message = "Versengen: %s!",
	scorch_warning = "Versengen!",
	scorch_soon = "Versengen in ~5 sek!",
	scorch_bar = "Nächstes Versengen",

	slagpot = "Schlackentopf",
	slagpot_desc = "Warnt, wer von Schlackentopf betroffen ist.",
	slagpot_message = "Schlackentopf: %s!",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	--construct = "Activate Construct",
	--construct_desc = "Warn for Activate Construct.",
	--construct_message = "Activate Construct!",
	--construct_warning = "Construct in 5sec!",
	--construct_bar = "Next Construct",

	--brittle = "Brittle",
	--brittle_desc = "Warn when Iron Construct gains Brittle.",
	--brittle_message = "Construct gained Brittle!",

	flame = "Flame Jets",
	flame_desc = "当伊格尼斯施放Flame Jets时发出警报。",
	flame_message = "Flame Jets！",
	flame_warning = "即将 Flame Jets！",
	flame_bar = "<Jets 冷却>",

	scorch = "灼烧",
	scorch_desc = "当正在施放灼烧和你中了灼烧时发出警报。",
	scorch_message = "灼烧：>%s<！",
	scorch_warning = "正在施放 灼烧！",
	scorch_soon = "约5秒后，灼烧！",
	scorch_bar = "<下一灼烧>",

	slagpot = "熔渣炉",
	slagpot_desc = "当玩家中了熔渣炉时发出警报。",
	slagpot_message = "熔渣炉：>%s<！",
} end )

L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	--construct = "Activate Construct",
	--construct_desc = "Warn for Activate Construct.",
	--construct_message = "Activate Construct!",
	--construct_warning = "Construct in 5sec!",
	--construct_bar = "Next Construct",

	--brittle = "Brittle",
	--brittle_desc = "Warn when Iron Construct gains Brittle.",
	--brittle_message = "Construct gained Brittle!",

	flame = "烈焰噴洩",
	flame_desc = "當伊格尼司施放烈焰噴洩時發出警報。",
	flame_message = "烈焰噴洩！",
	flame_warning = "即將 烈焰噴洩！",
	flame_bar = "<烈焰噴洩 冷卻>",

	scorch = "灼燒",
	scorch_desc = "當正在施放灼燒和你中了灼燒時發出警報。",
	scorch_message = "灼燒：>%s<！",
	scorch_warning = "正在施放 灼燒！",
	scorch_soon = "約5秒后，灼燒！",
	scorch_bar = "<下一灼燒>",

	slagpot = "熔渣之盆",
	slagpot_desc = "當玩家中了熔渣之盆時發出警報。",
	slagpot_message = "熔渣之盆：>%s<！",
} end )


------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Construct", 62488)
	self:AddCombatListener("SPELL_CAST_START", "ScorchCast", 62546, 63474)
	self:AddCombatListener("SPELL_CAST_START", "Jets", 62680, 63472)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Scorch", 62548, 63476)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SlagPot", 62717, 63477)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Brittle", 62382)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Brittle(_, spellID)
	if db.brittle then
		self:IfMessage(L["brittle_message"], "Important", spellID)
	end
end

function mod:Construct()
	if db.construct then
		self:IfMessage(L["construct_message"], "Attention", "INV_Misc_Statue_07") --Views like this icon. :)
		self:Bar(L["construct_bar"], spwanTime, "INV_Misc_Statue_07") --Views like this icon. :)
		self:DelayedMessage(spwanTime - 5, L["construct_warning"], "Attention")
	end
end

function mod:ScorchCast(_, spellID)
	if db.scorch then
		self:IfMessage(L["scorch_warning"], "Attention", spellID)
		self:Bar(L["scorch_bar"], 25, spellID)
		self:DelayedMessage(20, L["scorch_soon"], "Attention")
	end
end

function mod:Scorch(player, spellID)
	if player == pName and db.scorch then
		self:LocalMessage(L["scorch_message"], "Personal", spellID, "Alarm")
	end
end

function mod:SlagPot(player, spellID)
	if db.slagpot then
		self:IfMessage(L["slagpot_message"]:format(player), "Attention", spellID)
		self:Bar(L["slagpot_message"]:format(player), 10, spellID)
	end
end

function mod:Jets(_, spellID)
	if db.flame then
		self:IfMessage(L["flame_message"], "Personal", spellID, "Alert")
		self:Bar(L["flame_bar"], 25, spellID)
		self:Bar(L["flame_bar"], 2.7, spellID)
		self:DelayedMessage(25, L["flame_warning"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		spwanTime = GetCurrentDungeonDifficulty() == 1 and 40 or 30
		if db.flame then
			self:Bar(L["flame_bar"], 21, 62680)
			self:DelayedMessage(21, L["flame_warning"], "Attention")
		end
		if db.construct then
			self:Bar(L["construct_bar"], 10, "INV_Misc_Statue_07")
		end
	end
end

