local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "ruRU")
if L then
	L.engage_message = "Ануб'арак вступил в бой, зарывание в землю через 80сек!"
	L.engage_trigger = "Это место станет вашей могилой!"

	L.unburrow_trigger = "вылезает на поверхность!"
	L.burrow_trigger = "зарывается в землю!"
	L.burrow = "Червоточина"
	L.burrow_desc = "Отображать таймер способности Ануб'арака зарывается в землю"
	L.burrow_cooldown = "Следующее зарывание"
	L.burrow_soon = "Скоро зарывание"

	L.nerubian_burrower = "Нерубский землеглот"

	L.freeze_bar = "~Замораживающий выпад"
	L.pcold_bar = "~Пронизывающий холод"

	L.icon = "Помечать иконкой"
	L.icon_desc = "Помечать рейдовой иконкой игрока которого приследуют шипы Ануб'арака в фазе когда он под землёй. (необходимо быть лидером группы или рейда)"

	L.chase = "Преследование"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "ruRU")
if L then
	--L.enable_trigger = "You have heard the call of the Argent Crusade and you have boldly answered" --need

	L.engage_trigger = "Из самых глубоких и темных пещер Грозовой Гряды был призван Гормок Пронзающий Бивень! В бой, герои!"
	L.jormungars_trigger = "Приготовьтесь к схватке с близнецами-чудовищами, Кислотной Утробой и Жуткой Чешуей!"
	L.icehowl_trigger = "В воздухе повеяло ледяным дыханием следующего бойца: на арену выходит Ледяной Рев! Сражайтесь или погибните, чемпионы!"
	L.boss_incoming = "На подходе %s"

	-- Gormok
	L.snobold = "Снобольд"
	L.snobold_desc = "Сообщить кто получил Снобольд на свою голову."
	L.snobold_message = "Снобольд на:"
	L.impale_message = "%2$dx Прокалывания на %1$s"
	L.firebomb_message = "Огненная бомба на ВАС!"

	-- Jormungars
	L.submerge = "Погружение"
	L.submerge_desc = "Показывать таймеры Погружений."
	L.spew = "Кислотная/Жгучая рвота"
	L.spew_desc = "Сообщать о Кислотной/Жгучей рвоте."
	L.sprays = "Брызги"
	L.sprays_desc = "Показывать таймеры для следующих применений Парализующих и Горящих брызгов."
	L.slime_message = "Вы в Луже жижи!"
	L.burn_spell = "Горящая желчь"
	L.toxin_spell = "Токсин"
	L.spray = "~Next Spray"

	-- Icehowl
	L.butt_bar = "~Свирепое бодание"
	L.charge = "Яростный рывок" --Furious Charge - судя по транскриптору нет русского перевода :(
	L.charge_desc = "Сообщать о яростном рывке."
	L.charge_trigger = "глядит на"	--check
	
	L.bosses = "Боссы"
	L.bosses_desc = "Сообщать о наступлении боссов"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "ruRU")
if L then
	L.enable_trigger = "В следующем бою вы встретитесь с могучими рыцарями Серебряного Авангарда! Лишь победив их, вы заслужите достойную награду."
	L.defeat_trigger = "Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто еще, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность еще впереди – нас ждет битва с  Королем-личом."

	L["Shield on %s!"] = "Щит на %s"
	L["Bladestorming!"] = "Вихрь клинков!"
	L["Hunter pet up!"] = "Охотник воскресил питомца!"
	L["Felhunter up!"] = "Чернокнижник воскресил питомца!"
	L["Heroism on champions!"] = "Героизм на чемпионах!"
	L["Bloodlust on champions!"] = "Жажда крови на чемпионах!"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "ruRU")
if L then
	L.enable_trigger = "Ничтожный гном! Тебя погубит твоя самоуверенность!"

	L.engage = "Начало битвы"
	L.engage_trigger = "Перед вами Джараксус, эредарский повелитель Пылающего Легиона!"
	L.engage_trigger1 = "Отправляйся в Пустоту!"

	L.adds = "Врата и вулкан"
	L.adds_desc = "Показывать таймер и сообщать о создании порталов и вулканов."

	L.incinerate_message = "Испепеление"
	L.incinerate_other = "Испепеление плоти на |3-5(%s)"
	L.incinerate_bar = "~Следующее Испепеление"
	L.incinerate_safe = "%s в безопасности"

	L.legionflame_message = "Пламя"
	L.legionflame_other = "Пламя Легиона на |3-5(%s)!"
	L.legionflame_bar = "~Следующее Пламя"

	L.icon = "Помечать иконкой"
	L.icon_desc = "Помечать иконкой игрока с Пламенем Легиона. (Необходимо быть рейд лидером или иметь промоут)"

	L.infernal_bar = "~следующий вулкан"
	L.netherportal_bar = "~cледующие врата"
	L.netherpower_bar = "~сила пустоты"
end

L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "ruRU")
if L then
	L.engage_trigger1 = "Во имя темного повелителя. Во имя Короля-лича. Вы. Умрете."

	L.vortex_or_shield_cd = "Воронка или Щит"
	L.next = "Следующая Воронка или Щит"
	L.next_desc = "Сообщать о следующей Воронке или Щите"

	L.vortex = "Воронка"
	L.vortex_desc = "Сообщать когда близнецы начинают применять воронку."

	L.shield = "Щит Тьмы/Света"
	L.shield_desc = "Сообщать о Щите Тьмы/Света."

	L.touch = "Касание тьмы/Света"
	L.touch_desc = "Сообщать о Касании тьмы/Света"
end

