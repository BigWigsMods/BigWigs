local L = BigWigs:NewBossLocale("Anub'arak", "ruRU")
if L then
	L.engage_message = "Ануб'арак вступил в бой, зарывание в землю через 80сек!"
	L.engage_trigger = "Это место станет вашей могилой!"

	L.unburrow_trigger = "вылезает на поверхность!"
	L.burrow_trigger = "зарывается в землю!"
	L.burrow = "Зарывание в землю"
	L.burrow_desc = "Отображать таймер до закапывания Ануб'арака"
	L.burrow_cooldown = "Следующее зарывание"
	L.burrow_soon = "Скоро зарывание"

	L.nerubian_message = "Жуки наступают!"
	L.nerubian_burrower = "Ещё жуки"

	L.shadow_soon = "Теневой удар через ~5сек!"

	L.freeze_bar = "~Замораживающий выпад"
	L.pcold_bar = "~Пронизывающий холод"

	L.chase = "Преследование"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "ruRU")
if L then
	L.enable_trigger = "Вы услышали призыв Серебряного Авангарда и без колебаний откликнулись"
	L.wipe_trigger = "Трагично..."

	L.engage_trigger = "Из самых глубоких и темных пещер Грозовой Гряды был призван Гормок Пронзающий Бивень! В бой, герои!"
	L.jormungars_trigger = "Приготовьтесь к схватке с близнецами-чудовищами, Кислотной Утробой и Жуткой Чешуей!"
	L.icehowl_trigger = "В воздухе повеяло ледяным дыханием следующего бойца: на арену выходит Ледяной Рев! Сражайтесь или погибните, чемпионы!"
	L.boss_incoming = "На подходе %s"

	-- Gormok
	L.snobold = "Снобольд"
	L.snobold_desc = "Сообщать о том, на кого прыгнул снобольд."
	L.snobold_message = "Снобольд на:"
	L.impale_message = "%2$dx Прокалывания на %1$s"
	L.firebomb_message = "Огненная бомба на ВАС!"

	-- Jormungars
	L.submerge = "Погружение"
	L.submerge_desc = "Показывать таймеры погружений."
	L.spew = "Кислотная/Жгучая рвота"
	L.spew_desc = "Сообщать о кислотной/жгучей рвоте."
	L.sprays = "Брызги"
	L.sprays_desc = "Показывать таймеры для следующих применений парализующих и горящих брызгов."
	L.slime_message = "Вы в луже жижи!"
	L.burn_spell = "Горящая желчь"
	L.toxin_spell = "Паралитический токсин"
	L.spray = "~Брызги"

	-- Icehowl
	L.butt_bar = "~Свирепое бодание"
	L.charge = "Отчаянный рывок" --Furious Charge - судя по транскриптору нет русского перевода :(
	L.charge_desc = "Сообщать об отчаянном рывке."
	L.charge_trigger = "глядит на"	--check
	L.charge_say = "Бежит на меня!"

	L.bosses = "Боссы"
	L.bosses_desc = "Сообщать о появлении следующего босса."
end

L = LibStub("AceLocale-3.0"):NewLocale("Faction Champions", "ruRU")
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

L = LibStub("AceLocale-3.0"):NewLocale("Lord Jaraxxus", "ruRU")
if L then
	L.enable_trigger = "Ничтожный гном! Тебя погубит твоя самоуверенность!"

	L.engage = "Начало битвы"
	L.engage_trigger = "Перед вами Джараксус, эредарский повелитель Пылающего Легиона!"
	L.engage_trigger1 = "Отправляйся в Пустоту!"

	L.adds = "Врата и вулкан"
	L.adds_desc = "Показывать таймер и сообщать о создании порталов и вулканов."

	L.incinerate_message = "Испепеление"
	L.incinerate_other = "Испепеление плоти на |3-5(%s)! Хил!"
	L.incinerate_bar = "~Следующее испепеление"
	L.incinerate_safe = "%s в безопасности!"

	L.legionflame_message = "Пламя"
	L.legionflame_other = "Пламя Легиона на |3-5(%s)!"
	L.legionflame_bar = "~Следующее пламя"

	L.infernal_bar = "~появление вулкана"
	L.netherportal_bar = "~появление врат"
	L.netherpower_bar = "~сила пустоты"
	
	L.kiss_message = "Поцелуй на ВАС!"
	L.kiss_interrupted = "Прерывание!"
end

L = LibStub("AceLocale-3.0"):NewLocale("The Twin Val'kyr", "ruRU")
if L then
	L.engage_trigger1 = "Во имя темного повелителя. Во имя Короля-лича. Вы. Умрете."

	L.vortex_or_shield_cd = "Воронка или Щит"
	L.next = "Следующая воронка или щит"
	L.next_desc = "Сообщать о следующей воронке или щите"

	L.vortex = "Воронка"
	L.vortex_desc = "Сообщать, когда близнецы начинают применять воронку."

	L.shield = "Щит Тьмы/Света"
	L.shield_desc = "Сообщать о щите тьмы/света."
	L.shield_half_message = "Эффективность щита 50%!"
	L.shield_left_message = "%d%% щит утратил эффективность"

	L.touch = "Касание тьмы/света"
	L.touch_desc = "Сообщать о касании тьмы/света"
end
