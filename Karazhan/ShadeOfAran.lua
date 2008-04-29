------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Shade of Aran"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local drinkannounced = nil
local addsannounced = nil
local inWreath = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Aran",

	adds = "Elementals",
	adds_desc = "Warn about the water elemental adds spawning.",
	adds_message = "Elementals Incoming!",
	adds_warning = "Elementals Soon",
	adds_bar = "Elementals despawn",

	drink = "Drinking",
	drink_desc = "Warn when Aran starts to drink.",
	drink_warning = "Low Mana - Drinking Soon!",
	drink_message = "Drinking - AoE Polymorph!",
	drink_bar = "Super Pyroblast Incoming",

	blizzard = "Blizzard",
	blizzard_desc = "Warn when Blizzard is being cast.",
	blizzard_message = "Blizzard!",

	pull = "Pull/Super AE",
	pull_desc = "Warn for the magnetic pull and Super Arcane Explosion.",
	pull_message = "Arcane Explosion!",
	pull_bar = "Arcane Explosion",

	flame = "Flame Wreath",
	flame_desc = "Warn when Flame Wreath is being cast.",
	flame_warning = "Casting: Flame Wreath!",
	flame_message = "Flame Wreath! %s",
	flame_bar = "Flame Wreath",
} end )

L:RegisterTranslations("deDE", function() return {
	adds = "Wasserelementare",
	adds_desc = "Warnt vor den Wasserelementaren bei 40%.",
	adds_message = "Elementare!",
	adds_warning = "Elementare in K\195\188rze!",
	adds_bar = "Elementare verschwinden",

	drink = "Trinken",
	drink_desc = "Warnt, wenn Arans Schemen zu trinken beginnt.",
	drink_warning = "Wenig Mana - trinkt gleich!",
	drink_message = "Trinkt - AoE Polymorph!",
	drink_bar = "Super-Pyroblast kommt!",

	blizzard = "Blizzard",
	blizzard_desc = "Warnt vor dem Blizzard.",
	blizzard_message = "Wirkt Blizzard!",

	pull = "Magnet/Super-AE",
	pull_desc = "Warnt vor dem Magnetpull und der Arkanen Explosion.",
	pull_message = "Arkane Explosion wird gewirkt!",
	pull_bar = "Arkane Explosion",

	flame = "Flammenkranz",
	flame_desc = "Warnt, wenn jemand vom Flammenkranz betroffen ist.",
	flame_warning = "Wirkt Flammenkranz!",
	flame_message = "Flammenkranz! %s",
	flame_bar = "Flammenkranz",
} end )

L:RegisterTranslations("frFR", function() return {
	adds = "Elémentaires",
	adds_desc = "Prévient quand les élémentaires d'eau apparaissent.",
	adds_message = "Arrivée des élémentaires !",
	adds_warning = "Elémentaires imminent",
	adds_bar = "Fin des élémentaires",

	drink = "Boisson",
	drink_desc = "Prévient quand l'Ombre d'Aran commence à boire.",
	drink_warning = "Mana faible - Boisson imminente !",
	drink_message = "Boisson - Polymorphisme de zone !",
	drink_bar = "Super Explosion pyro.",

	blizzard = "Blizzard",
	blizzard_desc = "Prévient quand Blizzard est incanté.",
	blizzard_message = "Blizzard !",

	pull = "Attraction/Sort de zone",
	pull_desc = "Prévient de l'attraction magnétique et de l'explosion des arcanes.",
	pull_message = "Explosion des arcanes !",
	pull_bar = "Explosion des arcanes",

	flame = "Couronne de flammes",
	flame_desc = "Prévient quand Couronne de flammes est incanté.",
	flame_warning = "Incante : Couronne de flammes !",
	flame_message = "Couronne de flammes ! %s",
	flame_bar = "Couronne de flammes",
} end )

L:RegisterTranslations("koKR", function() return {
	adds = "물의 정령",
	adds_desc = "물의 정령 소환에 대한 경고입니다.",
	adds_message = "정령 소환!",
	adds_warning = "곧 정령 소환",
	adds_bar = "물의 정령",

	drink = "음료 마시기",
	drink_desc = "아란의 망령의 음료 마시기 시작 시 알립니다.",
	drink_warning = "마나 낮음 - 잠시 후 음료 마시기!",
	drink_message = "음료 마시기 - 광역 변이!",
	drink_bar = "불덩이 작열 시전",

	blizzard = "눈보라",
	blizzard_desc = "눈보라 시전 시 경고합니다.",
	blizzard_message = "눈보라!",

	pull = "전체 광역",
	pull_desc = "전체 광역 신비한 폭발에 대한 경고입니다.",
	pull_message = "신비한 폭발!",
	pull_bar = "신비한 폭발",

	flame = "화염의 고리",
	flame_desc = "화염의 고리 시전 시 경고합니다.",
	flame_warning = "시전: 화염의 고리!",
	flame_message = "화염의 고리! %s",
	flame_bar = "화염의 고리",
} end )

L:RegisterTranslations("zhCN", function() return {
	adds = "水元素",
	adds_desc = "当召唤水元素时发出警报。",
	adds_message = "水元素 来临！",
	adds_warning = "即将召唤 水元素！",
	adds_bar = "<召唤水元素>",

	drink = "群体变形",
	drink_desc = "当即将施放回魔时发出警报。",
	drink_warning = "低法力 - 即将回魔！",
	drink_message = "回魔 - 群体变形！",
	drink_bar = "<群体变形术>",

	blizzard = "暴风雪",
	blizzard_desc = "当暴风雪开始施放发出警报。",
	blizzard_message = "暴风雪！",

	pull = "磁力/魔爆术",
	pull_desc = "当释放磁力/魔爆术时发出警报。",
	pull_message = "魔爆术！",
	pull_bar = "<魔爆术>",

	flame = "烈焰花环",
	flame_desc = "当开始施放烈焰花环时发出警报。",
	flame_warning = "施放 烈焰花环！",
	flame_message = "烈焰花环：>%s<！",
	flame_bar = "<烈焰花环>",
} end )

L:RegisterTranslations("zhTW", function() return {
	adds = "召喚水元素",
	adds_desc = "當埃蘭之影召喚水元素時發送警告",
	adds_message = "召喚水元素",
	adds_warning = "埃蘭之影即將召喚水元素",
	adds_bar = "召喚水元素",

	drink = "群體變羊",
	drink_desc = "當 埃蘭之影 開始回魔時發送警告",
	drink_warning = "埃蘭之影魔力太低",
	drink_message = "群體變羊術 - 埃蘭之影開始回魔",
	drink_bar = "群體變羊術",

	blizzard = "暴風雪警告",
	blizzard_desc = "當埃蘭之影施放暴風雪時發送警告",
	blizzard_message = "暴風雪 - 順時針方向走避",

	pull = "巨力磁力/魔爆術警告",
	pull_desc = "當埃蘭之影施放巨力磁力及魔爆術時發送警告",
	pull_message = "魔爆術 - 立刻向外圍跑",
	pull_bar = "魔爆術",

	flame = "烈焰火圈警告",
	flame_desc = "當埃蘭之影施放烈焰火圈時發送警告",
	flame_warning = "烈焰火圈 - 全部都別動",
	flame_message = "埃蘭之影施放烈焰火圈 %s",
	flame_bar = "烈焰火圈",
} end )

L:RegisterTranslations("esES", function() return {
	adds = "Elementales",
	adds_desc = "Avisa de la aparación de los elementales de agua.",
	adds_message = "¡Llegada de Elementales!",
	adds_warning = "Elementales Pronto",
	adds_bar = "<Elementales>",

	drink = "Beber",
	drink_desc = "Avisa de cuando Aran comienza a beber.",
	drink_warning = "¡Maná bajo - Beber pronto!",
	drink_message = "¡Bebiendo - Polimorfia de área!",
	drink_bar = "~Piroexplosión",

	blizzard = "Ventisca",
	blizzard_desc = "Avisa de cuando ventisca está siendo lanzada.",
	blizzard_message = "¡Ventisca!",

	pull = "Atracción/Deflagración Arcana",
	pull_desc = "Avisar de la atracción y la Deflagración Arcana.",
	pull_message = "¡Deflagración Arcana!",
	pull_bar = "<Deflagración Arcana>",

	flame = "Corona de llamas",
	flame_desc = "Avisa de cuando Coronna de llamas está siendo lanzada.",
	flame_warning = "¡Lanzando: Corona de llamas!",
	flame_message = "¡Corona de Llamas! %s",
	flame_bar = "<Corona de Llamas>",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"adds", "drink", -1, "blizzard", "pull", "flame", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "FlameWreathStart", 30004)
	self:AddCombatListener("SPELL_AURA_APPLIED", "FlameWreath", 29946)
	self:AddCombatListener("SPELL_CAST_START", "Blizzard", 29969)
	self:AddCombatListener("SPELL_CAST_START", "Drinking", 29963) --Mass Polymorph
	self:AddCombatListener("SPELL_SUMMON", "Elementals", 29962)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Pull", 29979) --Arcane Explosion
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UNIT_HEALTH")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:FlameWreathStart(_, spellID)
	if self.db.profile.flame then
		self:IfMessage(L["flame_warning"], "Important", spellID, "Alarm")
		self:Bar(L["flame_bar"], 5, spellID)
	end
end

function mod:FlameWreath(player)
	if self.db.profile.flame then
		inWreath[player] = true
		self:ScheduleEvent("BWAranWreath", self.WreathWarn, 0.4, self)
	end
end

function mod:Blizzard(_, spellID)
	if self.db.profile.blizzard then
		self:IfMessage(L["blizzard_message"], "Attention", spellID)
		self:Bar(L["blizzard_message"], 36, spellID)
	end
end

function mod:Drinking()
	if self.db.profile.drink then
		self:IfMessage(L["drink_message"], "Positive", 29963) --Polymorph ID
		self:Bar(L["drink_bar"], 15, 29978) --Pyroblast ID
	end
end

function mod:Elementals()
	if self.db.profile.adds then
		--Custom ID, original one is ugly
		self:IfMessage(L["adds_message"], "Important", 31687)
		self:Bar(L["adds_bar"], 90, 31687)
	end
end

local last = 0
function mod:Pull(_, spellID)
	local time = GetTime()
	if (time - last) > 5 then
		last = time
		if self.db.profile.pull then
			self:IfMessage(L["pull_message"], "Attention", spellID)
			self:Bar(L["pull_bar"], 12, spellID)
		end
	end
end

function mod:UNIT_MANA(msg)
	if not self.db.profile.drink then return end
	if UnitName(msg) == boss then
		local mana = UnitMana(msg)
		if mana > 33000 and mana <= 37000 and not drinkannounced then
			self:Message(L["drink_warning"], "Urgent", nil, "Alert")
			drinkannounced = true
		elseif mana > 50000 and drinkannounced then
			drinkannounced = nil
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.adds then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 43 and health <= 46 and not addsannounced then
			self:Message(L["adds_warning"], "Urgent", nil, "Alert")
			addsannounced = true
		elseif health > 50 and addsannounced then
			addsannounced = nil
		end
	end
end

function mod:WreathWarn()
	local msg = nil
	for k in pairs(inWreath) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["flame_message"]:format(msg), "Important", 29946)
	self:Bar(L["flame_bar"], 21, 29946)
	for k in pairs(inWreath) do inWreath[k] = nil end
end

