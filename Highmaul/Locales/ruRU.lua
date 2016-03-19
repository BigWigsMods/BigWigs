local L = BigWigs:NewBossLocale("Kargath Bladefist", "ruRU")
if not L then return end
if L then
	L.blade_dance_bar = "Танцуем"

	L.arena_sweeper = "Чистка арены"
	L.arena_sweeper_desc = "Время, через которое вас выкинут с трибун после Удара Цепью."
end

L = BigWigs:NewBossLocale("The Butcher", "ruRU")
if L then
	L.adds_multiple = "Помощники x%d"

	L.tank_proximity = "Радар танков"
	L.tank_proximity_desc = "Открывает радар близости 5м, показывающий других танков, чтобы делить урон от способности Тяжелая рука."
end

L = BigWigs:NewBossLocale("Tectus", "ruRU")
if L then
	L.adds_desc = "Таймеры, когда новые помощники вступят в бой."

	L.custom_off_barrage_marker = "Маркировка Кристаллического залпа"
	L.custom_off_barrage_marker_desc = "Отмечать людей с Кристаллическим залпом {rt1}{rt2}{rt3}{rt4}{rt5}, требуется быть помощником или лидером."

	L.custom_on_shard_marker = "Метка Осколка Тектоника"
	L.custom_on_shard_marker_desc = "Отмечать 2 Осколка Тектоника метками {rt8}{rt7}, требует быть лидером рейда или иметь права помощника."

	L.shard = "Осколок"
	L.motes = "Частица"
end

L = BigWigs:NewBossLocale("Brackenspore", "ruRU")
if L then
	L.mythic_ability = "Особая способность"
	L.mythic_ability_desc = "Показать таймер следующего Зова прилива или Взрывных поганок."
	L.mythic_ability_wave = "Приближается Волна!"

	L.custom_off_spore_shooter_marker = "Метка Спорострела"
	L.custom_off_spore_shooter_marker_desc = "Отмечать Спорострелы метками {rt1}{rt2}{rt3}{rt4}, требует быть лидером рейда или иметь права помощника.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСовет: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.creeping_moss_boss_heal = "Мох под БОССОМ (исцеление)"
	L.creeping_moss_add_heal = "Мох под БОЛЬШИМ АДДОМ (исцеляется)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "ruRU")
if L then
	L.volatility_self_desc = "Опции, когда на вас дебаф Непостоянной тайной магии."

	L.custom_off_volatility_marker = "Маркировка Непостоянной тайной магии"
	L.custom_off_volatility_marker_desc = "Отмечать людей с Непостоянной тайной магии {rt1}{rt2}{rt3}{rt4}, требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Ko'ragh", "ruRU")
if L then
	L.fire_bar = "Все взорвутся!"

	L.overwhelming_energy_bar = "Шаров упало (%d)"
	L.dominating_power_bar = "Шаров КР упало (%d)"

	L.custom_off_fel_marker = "Маркировка Исторжение магии: Скверна"
	L.custom_off_fel_marker_desc = "Отмечать цели исторжения метками {rt1}{rt2}{rt3}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "ruRU")
if L then
	L.branded_say = "%s (%d) %dм"
	L.add_death_soon = "Прислужник скоро умрет!"
	L.slow_fixate = "Замедление+Фиксация"

	L.adds = "Поддавшийся ночи верный служитель"
	L.adds_desc = "Отсчёт времени до выхода Поддавшегося ночи верного служителя."

	L.custom_off_fixate_marker = "Маркировка Сосредоточение внимания"
	L.custom_off_fixate_marker_desc = "Отмечать цели Горианских боевых магов метками {rt1}{rt2}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"

	L.custom_off_branded_marker = "Маркировка Клейма."
	L.custom_off_branded_marker_desc = "Отмечать цели Клейма метками {rt3}{rt4}, требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Highmaul Trash", "ruRU")
if L then
	L.oro = "Оро"
	L.runemaster = "Горианский мастер рун"
	L.arcanist = "Горианский чародей"
	L.ritualist = "Ритуалист-сокрушитель"
end