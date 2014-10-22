local L = BigWigs:NewBossLocale("Gruul", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Oregorger", "ruRU")
if L then
	--L.berserk_trigger = "Oregorger has gone insane from hunger!"

	L.shard_explosion = "Подрыв Взрывчатого осколка"
	L.shard_explosion_desc = "Отдельный увеличенный таймер для взрыва."

	--L.hunger_drive_power = "%dx %s - %d ore to go!"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "ruRU")
if L then
	--L.heat_increased_message = "Heat increased! Blast every %ss"
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
	--L.next_mount = "Mounting soon!"

	L.custom_off_pinned_marker = "Маркировка Пригвождения к земле"
	L.custom_off_pinned_marker_desc = "На Пригвожденных к земле будут поставлены метки {rt8}{rt7}{rt6}{rt5}{rt4}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r\n|cFFADFF2FСОВЕТ: Если вы выбраны для этой задачи, быстро проведите указателем мыши по целям, метки сразу же поставятся.|r"

	L.custom_off_conflag_marker = "Маркировка Воспламенения"
	L.custom_off_conflag_marker_desc = "На цели Воспламенения будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "ruRU")
if L then
	-- L.custom_off_firemender_marker = "Grom'kar Firemender marker"
	-- L.custom_off_firemender_marker_desc = "Marks Firemenders with {rt1}{rt2}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the mobs is the fastest way to mark them.|r"

	--L.trains = "Train warnings"
	--L.trains_desc = "Shows timers and messages for each lane for when the next train is coming. Lanes are numbered from the boss to the entrace, ie, Boss 1 2 3 4 Entrance."

	--L.lane = "Lane %s: %s"
	--L.train = "Train"
	--L.adds_train = "Adds train"
	--L.big_add_train = "Big add train"
	--L.cannon_train = "Cannon train"
	--L.random = "Random trains"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "ruRU")
if L then
	--L.ship_trigger = "prepares to man the Dreadnaught's Main Cannon!"

	--L.ship = "Jump to Ship: %s"

	L.custom_off_heartseeker_marker = "Маркировка Окровавленных пронзателей сердец"
	L.custom_off_heartseeker_marker_desc = "На Окровавленных пронзателей сердец будут поставлены метки {rt1}{rt2}{rt3}, требуется быть помощником или лидером."

	--L.power_message = "%d Iron Fury!"
end

L = BigWigs:NewBossLocale("Blackhand", "ruRU")
if L then
	L.custom_off_markedfordeath_marker = "Маркировка Метки смерти"
	L.custom_off_markedfordeath_marker_desc = "Отмечать людей с Меткой смерти {rt1}{rt2}, требуется быть помощником или лидером."
end

