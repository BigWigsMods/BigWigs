if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_message = "Ануб'арак вступил в бой, зарывание в землю через 80сек!",
	engage_trigger = "Это место станет вашей могилой!",

	unburrow_trigger = "вылезает на поверхность!",
	burrow_trigger = "зарывается в землю!",
	burrow = "Червоточина",
	burrow_desc = "Отображать таймер способности Ануб'арака зарывается в землю",
	burrow_cooldown = "Следующее зарывание",
	burrow_soon = "Скоро зарывание",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока которого приследуют шипы Ануб'арака в фазе когда он под землёй. (необходимо быть лидером группы или рейда)",
	
	chase = "Шипы",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Из самых глубоких и темных пещер Грозовой Гряды был призван Гормок Пронзающий Бивень! В бой, герои!",
	jormungars_trigger = "Приготовьтесь к схватке с близнецами-чудовищами, Кислотной Утробой и Жуткой Чешуей!",
	icehowl_trigger = "В воздухе повеяло ледяным дыханием следующего бойца: на арену выходит Ледяной Рев! Сражайтесь или погибните, чемпионы!",
	boss_incoming = "На подходе %s",

	-- Gormok
	impale_message = "%2$dx Прокалывания на %1$s",
	firebomb_message = "Огненная бомба на ВАС!",

	-- Jormungars
	spew = "Кислотная/Жгучая рвота",
	spew_desc = "Сообщать о Кислотной/Жгучей рвоте.",

	-- Icehowl
	butt_bar = "~Свирепое бодание",

	--Furious Charge - судя по транскриптору нет русского перевода :(
	charge = "Furious Charge",
	charge_desc = "Сообщать о Furious Charge.",
	--charge_trigger = "^%%s",	--check
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	enable_trigger = "В следующем бою вы встретитесь с могучими рыцарями Серебряного Авангарда! Лишь победив их, вы заслужите достойную награду.",
	defeat_trigger = "Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто еще, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность еще впереди – нас ждет битва с  Королем-личом.",

	["Shield on %s!"] = "Щит на %s",
	["Bladestorming!"] = "Вихрь клинков!",
	["Hunter pet up!"] = "Охотник воскресил питомца!",
	["Felhunter up!"] = "Чернокнижник воскресил питомца!",
	["Heroism on champions!"] = "Героизм на чемпионах!",
	["Bloodlust on champions!"] = "Жажда крови на чемпионах!",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	engage = "Начало битвы",

	engage_trigger = "Перед вами Джараксус, эредарский повелитель Пылающего Легиона!",
	engage_trigger1 = "Отправляйся в Пустоту!",

	incinerate_message = "Испепеление",
	incinerate_other = "Испепеление плоти на |3-5(%s)",
	incinerate_bar = "~Следующее Испепеление",

	legionflame_message = "Пламя",
	legionflame_other = "Пламя Легиона на |3-5(%s)!",
	legionflame_bar = "~Следующее Пламя",

	icon = "Помечать иконкой",
	icon_desc = "Помечать иконкой игрока с Пламенем Легиона. (Необходимо быть рейд лидером или иметь промоут)",

	netherportal_bar = "~Следующие врата",
	netherpower_bar = "~Следующая Сила Пустоты",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
L:RegisterTranslations("ruRU", function() return {
	--engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",

	vortex_or_shield_cd = "Воронка или Щит",

	vortex = "Воронка",
	vortex_desc = "Сообщать когда близнецы начинают применять воронку.",

	shield = "Щит Тьмы/Света",
	shield_desc = "Сообщать о Щите Тьмы/Света.",

	touch = "Касание тьмы/Света",
	touch_desc = "Сообщать о Касании тьмы/Света",
} end)
