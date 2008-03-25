------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Shade of Aran"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local drinkannounced = nil
local addsannounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Aran",

	engage_trigger1 = "I'll not be tortured again!",
	engage_trigger2 = "Who are you? What do you want? Stay away from me!",
	engage_trigger3 = "Please, no more! My son... he's gone mad!",
	engage_message = "%s Engaged",

	adds = "Elementals",
	adds_desc = "Warn about the water elemental adds spawning.",
	adds_message = "Elementals Incoming!",
	adds_warning = "Elementals Soon",
	adds_trigger = "I'm not finished yet! No, I have a few more tricks up my sleeve...",
	adds_bar = "Elementals despawn",

	drink = "Drinking",
	drink_desc = "Warn when Aran starts to drink.",
	drink_trigger = "Surely you wouldn't deny an old man a replenishing drink? No, no, I thought not.",
	drink_warning = "Low Mana - Drinking Soon!",
	drink_message = "Drinking - AoE Polymorph!",
	drink_bar = "Super Pyroblast Incoming",

	blizzard = "Blizzard",
	blizzard_desc = "Warn when Blizzard is being cast.",
	blizzard_trigger1 = "Back to the cold dark with you!",
	blizzard_trigger2 = "I'll freeze you all!",
	blizzard_message = "Blizzard!",

	pull = "Pull/Super AE",
	pull_desc = "Warn for the magnetic pull and Super Arcane Explosion.",
	pull_message = "Arcane Explosion!",
	pull_trigger1 = "Yes, yes my son is quite powerful... but I have powers of my own!",
	pull_trigger2 = "I am not some simple jester! I am Nielas Aran!",
	pull_bar = "Arcane Explosion",

	flame = "Flame Wreath",
	flame_desc = "Warn when Flame Wreath is being cast.",
	flame_warning = "Casting: Flame Wreath!",
	flame_trigger1 = "I'll show you: this beaten dog still has some teeth!",
	flame_trigger2 = "Burn, you hellish fiends!",
	flame_message = "Flame Wreath!",
	flame_bar = "Flame Wreath",
	flame_trigger = "casts Flame Wreath%.$",
} end )

L:RegisterTranslations("deDE", function() return {
	adds = "Wasserelementare",
	adds_desc = "Warnt vor den Wasserelementaren bei 40%.",

	drink = "Trinken",
	drink_desc = "Warnt, wenn Arans Schemen zu trinken beginnt.",

	blizzard = "Blizzard",
	blizzard_desc = "Warnt vor dem Blizzard.",

	pull = "Magnet/Super-AE",
	pull_desc = "Warnt vor dem Magnetpull und der Arkanen Explosion.",

	flame = "Flammenkranz",
	flame_desc = "Warnt, wenn jemand vom Flammenkranz betroffen ist.",

	adds_message = "Elementare!",
	adds_warning = "Elementare in K\195\188rze!",
	adds_trigger = "Ich bin noch nicht fertig! Nein, ich habe noch ein paar Tricks auf Lager…",
	adds_bar = "Elementare verschwinden",

	drink_trigger = "Ihr w\195\188rdet einem alten Mann doch nicht ein erfrischendes Getr\195\164nk verweigern? Nein nein, das h\195\164tte ich auch nicht gedacht.",
	drink_warning = "Wenig Mana - trinkt gleich!",
	drink_message = "Trinkt - AoE Polymorph!",
	drink_bar = "Super-Pyroblast kommt!",

	engage_trigger1 = "Qu\195\164lt mich nicht l\195\164nger!",
	engage_trigger2 = "Wer seid Ihr? Was wollt Ihr? Bleibt fern von mir!",
	engage_message = "%s angegriffen.",

	blizzard_trigger1 = "Zur\195\188ck in die eisige Finsternis mit Euch!",
	blizzard_trigger2 = "Ich werde Euch alle einfrieren!",
	blizzard_message = "Wirkt Blizzard!",

	pull_message = "Arkane Explosion wird gewirkt!",
	pull_trigger1 = "Ja, ja, mein Sohn ist sehr m\195\164chtig... aber ich habe meine eigenen Kr\195\164fte!",
	pull_trigger2 = "Ich bin kein einfacher Hofnarr! Ich bin Nielas Aran!",
	pull_bar = "Arkane Explosion",

	flame_warning = "Wirkt Flammenkranz!",
	flame_trigger1 = "Ich werde Euch zeigen: dieser gepr\195\188gelte Hund hat immer noch Z\195\164hne!",
	flame_trigger2 = "Brennt, Ihr herzlosen Teufel!",

	flame_message = "Flammenkranz!",
	flame_bar = "Flammenkranz",
	flame_trigger = "wirkt Flammenkranz",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Je refuse d'être à nouveau torturé !",
	engage_trigger2 = "Qui êtes-vous ? Qu’est-ce que vous voulez ? Ne m’approchez pas !",
	engage_trigger3 = "Je vous en supplie, arrêtez ! Mon fils… est devenu fou !",
	engage_message = "%s engagé",

	adds = "Elémentaires",
	adds_desc = "Préviens quand les élémentaires d'eau apparaissent.",
	adds_message = "Arrivée des élémentaires !",
	adds_warning = "Elémentaires imminent",
	adds_trigger = "Je ne suis pas encore vaincu ! Non, j’ai encore quelques tours dans mon sac…",
	adds_bar = "Fin des élémentaires",

	drink = "Boisson",
	drink_desc = "Préviens quand l'Ombre d'Aran commence à boire.",
	drink_trigger = "Vous ne refuseriez pas à un vieil homme une boisson revigorante ? Non, c’est bien ce que je pensais.",
	drink_warning = "Mana faible - Boisson imminente !",
	drink_message = "Boisson - Polymorphisme de zone !",
	drink_bar = "Super Explosion pyro.",

	blizzard = "Blizzard",
	blizzard_desc = "Préviens quand Blizzard est incanté.",
	blizzard_trigger1 = "Retournez dans les ténèbres glaciales !",
	blizzard_trigger2 = "Je vais tous vous congeler !",
	blizzard_message = "Blizzard !",

	pull = "Attraction/Sort de zone",
	pull_desc = "Préviens de l'attraction magnétique et de l'explosion des arcanes.",
	pull_message = "Explosion des arcanes !",
	pull_trigger1 = "Oui, oui, mon fils est assez puissant… mais moi aussi je possède quelques pouvoirs !",
	pull_trigger2 = "Je ne suis pas un simple bouffon ! Je suis Nielas Aran !",
	pull_bar = "Explosion des arcanes",

	flame = "Couronne de flammes",
	flame_desc = "Préviens quand Couronne de flammes est incanté.",
	flame_warning = "Incante : Couronne de flammes !",
	flame_trigger1 = "Je vais vous montrer que ce chien battu a encore de bons crocs !",
	flame_trigger2 = "Brûlez, démons de l’enfer !",
	flame_message = "Couronne de flammes !",
	flame_bar = "Couronne de flammes",
	flame_trigger = "lance Couronne de flammes%.$",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "똑같은 고통을 겪진 않겠다.",
	engage_trigger2 = "너흰 누구냐? 원하는 게 뭐야? 가까이 오지 마!",
	engage_trigger3 = "제발 그만! 내 아들... 그 아이는 미쳤어!",
	engage_message = "%s 전투 개시",

	adds = "물의 정령",
	adds_desc = "물의 정령 소환에 대한 경고입니다.",
	adds_message = "정령 소환!",
	adds_warning = "곧 정령 소환",
	adds_trigger = "아직 끝나지 않았어! 몇 가지 계략을 준비해 두었지...",
	adds_bar = "물의 정령",

	drink = "음료 마시기",
	drink_desc = "아란의 망령의 음료 마시기 시작 시 알립니다.",
	drink_trigger = "목 좀 축이게 해달라는 이 늙은이의 청을 뿌리칠 텐가? 아... 별로 기대도 안 했어.",
	drink_warning = "마나 낮음 - 잠시 후 음료 마시기!",
	drink_message = "음료 마시기 - 광역 변이!",
	drink_bar = "불덩이 작열 시전",

	blizzard = "눈보라",
	blizzard_desc = "눈보라 시전 시 경고합니다.",
	blizzard_trigger1 = "차가운 암흑으로 돌아가라!",
	blizzard_trigger2 = "모두 얼려 버리겠다!",
	blizzard_message = "눈보라!",

	pull = "전체 광역",
	pull_desc = "전체 광역 신비한 폭발에 대한 경고입니다.",
	pull_message = "신비한 폭발!",
	pull_trigger1 = "그래, 내 아들은 아주 강하지... 하지만, 내게도 힘은 있다!",
	pull_trigger2 = "난 어릿광대 따위가 아니다! 나는 니엘라스 아란이다!",
	pull_bar = "신비한 폭발",

	flame = "화염의 고리",
	flame_desc = "화염의 고리 시전 시 경고합니다.",
	flame_warning = "시전: 화염의 고리!",
	flame_trigger1 = "너희에게 보여주마! 아무리 지친 개라도 송곳니는 있는 법!",
	flame_trigger2 = "불타라, 지옥의 악마들아!",
	flame_message = "화염의 고리!",
	flame_bar = "화염의 고리",
	flame_trigger = "화염의 고리|1을;를; 시전합니다%.$",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger1 = "我不会再次受到折磨的！",
	engage_trigger2 = "你们是谁？你们想要什么？离我远点！",
	engage_trigger3 = "求求你们，不要这样！我的儿子……已经疯了！",
	engage_message = "%s 战斗开始",

	adds = "水元素",
	adds_desc = "当召唤水元素时发出警报。",
	adds_message = "水元素 来临",
	adds_warning = "水元素即将召唤",
	adds_trigger = "还没完呢！我还有几招没有用呢……",
	adds_bar = "<召唤水元素>",

	drink = "群体变形",
	drink_desc = "当埃兰回魔时发出警报。",
	drink_trigger = "你们应该不会不让一个可怜的老人喝点东西吧？不，不，当然不会。",
	drink_warning = "低法力 - 即将回魔！",
	drink_message = "回魔 - 群体变形！",
	drink_bar = "<群体变形术>",

	blizzard = "暴风雪",
	blizzard_desc = "当暴风雪开始施放发出警报。",
	blizzard_trigger1 = "回到寒冷的黑暗中去吧！",
	blizzard_trigger2 = "我要把你们全都冻住！",
	blizzard_message = "暴风雪",

	pull = "磁力/魔爆术",
	pull_desc = "磁力/魔爆术时发出警报。",
	pull_message = "魔爆术！",
	pull_trigger1 = "没错，我的儿子非常强大……但我也有自己的力量！",
	pull_trigger2 = "我不是某个可笑的小丑，我是聂拉斯·埃兰！",
	pull_bar = "<魔爆术>",

	flame = "烈焰花环",
	flame_desc = "当烈焰花环开始施放时发出警报。",
	flame_warning = "施放 烈焰花环！",
	flame_trigger1 = "我要让你们知道，老狗也有几颗牙！",
	flame_trigger2 = "燃烧吧，地狱的恶魔！",
	flame_message = "烈焰花环！",
	flame_bar = "<烈焰花环>",
	flame_trigger = "施放烈焰花环。$",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "我不會再被折磨了!",
	engage_trigger2 = "你是誰?你想要什麼?離我遠一點!",
	engage_trigger3 = "拜託，不要了!我的兒子……他已經瘋了!",
	engage_message = "%s 戰鬥開始",

	adds = "召喚水元素",
	adds_desc = "當埃蘭之影召喚水元素時發送警告",
	adds_message = "召喚水元素",
	adds_warning = "埃蘭之影即將召喚水元素",
	adds_trigger = "我還沒結束!不，我還有一些小伎倆沒施展出來",
	adds_bar = "召喚水元素",

	drink = "群體變羊",
	drink_desc = "當 埃蘭之影 開始回魔時發送警告",
	drink_trigger = "想必你不會拒絕給一個老人補充飲品吧?不，不，我想不會。",
	drink_warning = "埃蘭之影魔力太低",
	drink_message = "群體變羊術 - 埃蘭之影開始回魔",
	drink_bar = "群體變羊術",

	blizzard = "暴風雪警告",
	blizzard_desc = "當埃蘭之影施放暴風雪時發送警告",
	blizzard_trigger1 = "滾回你那冰冷的黑暗之中!",
	blizzard_trigger2 = "我會把你們全都凍死!",
	blizzard_message = "暴風雪 - 順時針方向走避",

	pull = "巨力磁力/魔爆術警告",
	pull_desc = "當埃蘭之影施放巨力磁力及魔爆術時發送警告",
	pull_message = "魔爆術 - 立刻向外圍跑",
	pull_trigger1 = "是的，沒錯，我兒子的力量相當強大……但我有我自己的力量!",
	pull_trigger2 = "我不是什麼普通的的小丑!我是聶拉斯·埃蘭!",
	pull_bar = "魔爆術",

	flame = "烈焰火圈警告",
	flame_desc = "當埃蘭之影施放烈焰火圈時發送警告",
	flame_warning = "烈焰火圈 - 全部都別動",
	flame_trigger1 = "我會讓你們看到：被打的狗也是會反擊的!",
	flame_trigger2 = "燃燒吧，你這地獄的惡魔!",
	flame_message = "埃蘭之影施放烈焰火圈",
	flame_bar = "烈焰火圈",
	flame_trigger = "施放烈焰火圈",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger1 = "I'll not be tortured again!",
	engage_trigger2 = "\194\191Qui\195\169nes sois? \194\191Qu\195\169 quer\195\169is? \194\161Alejaos de m\195\173!",
	engage_trigger3 = "\194\161Por favor, basta! \194\161Mi hijo... se ha vuelto loco!",
	engage_message = "%s Activado",

	adds = "Elementales",
	adds_desc = "Avisa de la aparaci\195\179n de los elementales de agua.",
	adds_message = "\194\161Llegada de Elementales!",
	adds_warning = "Elementales Pronto",
	adds_trigger = "\194\161No he acabado a\195\186n! No, me guardo un par de ases en la manga...",
	adds_bar = "Duraci\195\179n Elementales",

	drink = "Beber",
	drink_desc = "Avisa de cuando comienza a beber Aran.",
	drink_trigger = "\194\191Seguro que no le negar\195\169is a un viejo una bebida reconstituyente? No, no, ya lo sab\195\173a.",
	drink_warning = "Man\195\161 bajo - Beber pronto!",
	drink_message = "Bebiendo - Polimorfia de \195\161rea!",
	drink_bar = "Super Pyroblast Incoming",

	blizzard = "Ventisca",
	blizzard_desc = "Avisa de cuando ventisca est\195\161 siendo lanzada.",
	blizzard_trigger1 = "\194\161A la fr\195\173a oscuridad con vosotros!",
	blizzard_trigger2 = "\194\161Os congelar\195\169 a todos!",
	blizzard_message = "\194\161Ventisca!",

	pull = "Pull/Super AE",
	pull_desc = "Warn for the magnetic pull and Super Arcane Explosion.",
	pull_message = "Arcane Explosion!",
	pull_trigger1 = "S\195\173, s\195\173, mi primog\195\169nito es bastante poderoso... \194\161pero yo tengo mis propios poderes!",
	pull_trigger2 = "\194\161No soy un simple juglar! \194\161Soy Nielas Aran!",
	pull_bar = "Deflagraci\195\179n Arcana",

	flame = "Corona de llamas",
	flame_desc = "Avisa de cuando Coronna de llamas est\195\161 siendo lanzada.",
	flame_warning = "\194\161Lanzando: Corona de llamas!",
	flame_trigger1 = "\194\161Mirad: este perro apaleado a\195\186n tiene dientes!",
	flame_trigger2 = "\194\161Arded, demonios infernales!",
	flame_message = "\194\161Corona de Llamas!",
	flame_bar = "Corona de Llamas",
	flame_trigger = "lanzar Corona de llamas%.$",
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:AddCombatListener("SPELL_CAST_START", "FlameWreath", 30004)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.drink and msg == L["drink_trigger"] then
		self:Message(L["drink_message"], "Positive")
		self:Bar(L["drink_bar"], 15, "Spell_Fire_Fireball02")
	elseif self.db.profile.pull and (msg == L["pull_trigger1"] or msg == L["pull_trigger2"]) then
		self:Message(L["pull_message"], "Attention")
		self:Bar(L["pull_bar"], 12, "Spell_Nature_GroundingTotem")
	elseif self.db.profile.flame and (msg == L["flame_trigger1"] or msg == L["flame_trigger2"]) then
		self:Message(L["flame_warning"], "Important", nil, "Alarm")
		self:Bar(L["flame_bar"], 5, "Spell_Fire_Fire")
	elseif self.db.profile.blizzard and (msg == L["blizzard_trigger1"] or msg == L["blizzard_trigger2"]) then
		self:Message(L["blizzard_message"], "Attention")
		self:Bar(L["blizzard_message"], 36, "Spell_Frost_IceStorm")
	elseif msg == L["engage_trigger1"] or msg == L["engage_trigger2"] or msg == L["engage_trigger3"] then
		drinkannounced = nil
		addsannounced = nil
		self:Message(L["engage_message"]:format(boss), "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if self.db.profile.adds and msg == L["adds_trigger"] then
		self:Message(L["adds_message"], "Important")
		self:Bar(L["adds_bar"], 90, "Spell_Frost_SummonWaterElemental_2")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.flame and msg:find(L["flame_trigger"]) then
		self:Message(L["flame_message"], "Important")
		self:Bar(L["flame_bar"], 21, "Spell_Fire_Fire")
	end
end

function mod:FlameWreath()
	if self.db.profile.flame then
		self:Message(L["flame_message"], "Important")
		self:Bar(L["flame_bar"], 21, "Spell_Fire_Fire")
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
			addsannounced = false
		end
	end
end

