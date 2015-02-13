local L = BigWigs:NewBossLocale("Gruul", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Oregorger", "ruRU")
if L then
	--L.berserk_trigger = "Рудожуй обезумел от голода!"

	L.shard_explosion = "Подрыв Взрывчатого осколка"
	L.shard_explosion_desc = "Отдельный увеличенный таймер для взрыва."

	L.hunger_drive_power = "%dx %s - %d руды осталось!"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "ruRU")
if L then
	L.custom_on_shieldsdown_marker = "Метка спадения щита"
	L.custom_on_shieldsdown_marker_desc = "Отмечать уязвимость Повелительниц изначальных стихий меткой {rt8}, требуется быть лидером или помощником."

	L.heat_increased_message = "Жар увеличен! Взрыв каждые %s сек."

	L.bombs_dropped = "Бомб упало! (%d)"
end

L = BigWigs:NewBossLocale("Hans'gar and Franzok", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "ruRU")
if L then
	L.molten_torrent_self = "Лавовый поток на ТЕБЕ"
	L.molten_torrent_self_desc = "Специальный отсчет, когда Лавовый поток на тебе."
	L.molten_torrent_self_bar = "Ты взорвешься!"
end

L = BigWigs:NewBossLocale("Kromog", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "ruRU")
if L then
	L.next_mount = "Скоро прыжок на зверя!"

	L.custom_off_pinned_marker = "Маркировка Пригвождения к земле"
	L.custom_off_pinned_marker_desc = "На Пригвожденных к земле будут поставлены метки {rt8}{rt7}{rt6}{rt5}{rt4}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСОВЕТ: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.custom_off_conflag_marker = "Маркировка Воспламенения"
	L.custom_off_conflag_marker_desc = "На цели Воспламенения будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "ruRU")
if L then
	L.custom_off_firemender_marker = "Метка Гром'карской повелительницы огня"
	L.custom_off_firemender_marker_desc = "Отмечать Гром'карских повелительниц огня метками {rt1}{rt2}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FTIP: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.trains = "Предупреждения о поездах"
	L.trains_desc = "Показывать таймеры и сообщения для каждого пути, когда прибывает новый поезд. Пути пронумерованы от босса и до выхода(Босс, 1, 2, 3, 4, выход)."

	L.lane = "Путь %s: %s"
	L.train = "Поезд"
	L.adds_train = "Поезд с мобами"
	L.big_add_train = "Большой поезд с мобами"
	L.cannon_train = "Поезд с пушкой"
	L.deforester = "Лесоуничтожитель" -- /dump (EJ_GetSectionInfo(10329))
	L.random = "Случайные поезда"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "ruRU")
if L then
	--L.ship_trigger = "prepares to man the Dreadnaught's Main Cannon!"

	L.ship = "Прыжок на корабль"

	L.custom_off_heartseeker_marker = "Маркировка Окровавленных пронзателей сердец"
	L.custom_off_heartseeker_marker_desc = "На Окровавленных пронзателей сердец будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером."

	L.power_message = "%d железной ярости!"
end

L = BigWigs:NewBossLocale("Blackhand", "ruRU")
if L then
	L.custom_off_markedfordeath_marker = "Маркировка Метки смерти"
	L.custom_off_markedfordeath_marker_desc = "Отмечать людей с Меткой смерти {rt1}{rt2}, требуется быть помощником или лидером."
end

