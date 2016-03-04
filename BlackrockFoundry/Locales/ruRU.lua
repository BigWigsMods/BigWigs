local L = BigWigs:NewBossLocale("Gruul", "ruRU")
if not L then return end
if L then
	L.first_ability = "Окаменение или С размаха"
end

L = BigWigs:NewBossLocale("Oregorger", "ruRU")
if L then
	L.roll_message = "Перекат %d - Осталось %d руды!"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "ruRU")
if L then
	L.custom_on_shieldsdown_marker = "Маркировка спадения щита"
	L.custom_on_shieldsdown_marker_desc = "Отмечать уязвимость Повелительниц изначальных стихий меткой {rt8}, требуется быть помощником или лидером рейда."

	L.custom_off_firecaller_marker = "Маркировка Призывателя огня"
	L.custom_off_firecaller_marker_desc = "Отмечать Призывателей огня метками {rt7}{rt6}, требуется быть помощником или лидером рейда.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСовет: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.heat_increased_message = "Жар увеличен! Взрыв каждые %s сек."

	L.bombs_dropped = "Бомб упало! (%d)"
	L.bombs_dropped_p2 = "Инженер убит, бомбы упали!"

	L.operator = "Появление Управляющегося с мехами работника кузни"
	L.operator_desc = "В течение первой фазы будут периодически появляться 2 Управляющихся с мехами работника кузни, по 1 с каждой стороны комнаты."

	L.engineer = "Появление Инженера Горнила"
	L.engineer_desc = "В течении первой фазы будут периодически появляться 2 Инженера Горнила, по 1 с каждой стороны комнаты."

	L.guard = "Появление Охранника"
	L.guard_desc = "В течении первой фазы будут периодически появляться 2 Охранника, по 1 с каждой стороны комнаты. В течении второй фазы 1 Охранник будет периодически появляться у входа в комнату босса."

	L.firecaller = "Появление Призывателя огня"
	L.firecaller_desc = "В течении второй фазы будут периодически появляться 2 Призывателя огня, по 1 с каждой стороны комнаты."
end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "ruRU")
if L then
	L.molten_torrent_self = "Лавовый поток на ТЕБЕ"
	L.molten_torrent_self_desc = "Специальный отсчет, когда Лавовый поток на тебе."
	L.molten_torrent_self_bar = "Ты взорвешься!"

	L.custom_off_wolves_marker = "Маркировка Магматических волков"
	L.custom_off_wolves_marker_desc = "Отмечать Магматических волков метками {rt3}{rt4}{rt5}{rt6}, требуется быть помощником или лидером рейда."
end

L = BigWigs:NewBossLocale("Kromog", "ruRU")
if L then
	L.custom_off_hands_marker = "Маркировка Удерживающей Земли"
	L.custom_off_hands_marker_desc = "Отмечать руны, захватившие танков, метками {rt7}{rt8}, требуется быть помощником или лидером рейда."

	L.prox = "Индикатор дальности танков"
	L.prox_desc = "Установка индикатора дальности на значение 15 метров с отображением других танков, чтобы помочь делить урон от способности Каменные кулаки."

	L.destroy_pillars = "Уничтожение столпов"
end

L = BigWigs:NewBossLocale("Beastlord Darmac", "ruRU")
if L then
	L.next_mount = "Скоро прыжок на зверя!"

	L.custom_off_pinned_marker = "Маркировка Пригвождения к земле"
	L.custom_off_pinned_marker_desc = "На Пригвожденных к земле будут поставлены метки {rt8}{rt7}{rt6}{rt5}{rt4}, требуется быть помощником или лидером рейда.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСовет: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.custom_off_conflag_marker = "Маркировка Воспламенения"
	L.custom_off_conflag_marker_desc = "На цели Воспламенения будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "ruRU")
if L then
	L.custom_on_firemender_marker = "Маркировка Гром'карской повелительницы огня"
	L.custom_on_firemender_marker_desc = "Отмечать Гром'карскую повелительницу огня меткой {rt7}, требуется быть помощником или лидером рейда."

	L.custom_on_manatarms_marker = "Маркировка Гром'карского воителя"
	L.custom_on_manatarms_marker_desc = "Отмечать Гром'карского воителя меткой {rt8}, требуется быть помощником или лидером рейда."

	L.trains = "Предупреждения о поездах"
	L.trains_desc = "Показывать таймеры и сообщения для каждого пути, когда прибывает новый поезд. Пути пронумерованы от босса и до выхода(Босс, 1, 2, 3, 4, выход)."

	L.lane = "Путь %s: %s"
	L.train = "Поезд"
	L.adds_train = "Поезд с мобами"
	L.big_add_train = "Поезд с большими мобами"
	L.cannon_train = "Поезд с пушкой"
	L.deforester = "Лесоуничтожитель"
	L.random = "Случайные поезда"

	L.train_you = "Поезд на вашем пути! (%d)"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "ruRU")
if L then
	L.ship_trigger = "готовится занять позицию у главного орудия дредноута!"
	L.ship = "Прыжок на корабль"

	L.custom_off_heartseeker_marker = "Маркировка Окровавленных пронзателей сердец"
	L.custom_off_heartseeker_marker_desc = "На Окровавленных пронзателей сердец будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда."

	L.power_message = "%d железной ярости!"
end

L = BigWigs:NewBossLocale("Blackhand", "ruRU")
if L then
	L.custom_off_markedfordeath_marker = "Маркировка Метки смерти"
	L.custom_off_markedfordeath_marker_desc = "Отмечать людей с Меткой смерти {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда."

	L.custom_off_massivesmash_marker = "Маркировка Мощного крушащего удара"
	L.custom_off_massivesmash_marker_desc = "Отмечать танка, который получит Мощный крушащий удар меткой {rt6}, требуется быть помощником или лидером рейда."
end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "ruRU")
if L then
	L.beasttender = "Звериный сторож Громоборцев"
	L.brute = "Громила шлакового цеха"
	L.earthbinder = "Железный землепряд"
	L.enforcer = "Головорез из клана Черной горы"
	L.gnasher = "Темноскол-костеглод"
	L.gronnling = "Малый гронн – рабочий"
	L.guardian = "Страж мастерской"
	L.hauler = "Огрон-грузчик"
	L.mistress = "Начальница кузни Огненная Рука"
	L.taskmaster = "Железный надсмотрщик"
	L.furnace = "Выхлопное отверстие Горнила"

	L.furnace_msg1 = "Хмм, ты поджаренный на вид, не?"
	L.furnace_msg2 = "Пришло время для шашлычка!"
	L.furnace_msg3 = "Это не к добру..."
end