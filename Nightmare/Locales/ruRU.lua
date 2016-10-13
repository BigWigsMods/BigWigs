local L = BigWigs:NewBossLocale("Cenarius", "ruRU")
if not L then return end
if L then
	L.forces = "Силы кошмара"
	L.bramblesSay = "Колючки рядом с %s"
	--L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	--L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "ruRU")
if L then
	L.isLinkedWith = "%s связан(а) с %s"
	L.yourLink = "Вы связаны с %s"
	L.yourLinkShort = "Связаны с %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "ruRU")
if L then
	L.custom_off_deathglare_marker = "Маркировка Щупалец смертоносного взгляда"
	L.custom_off_deathglare_marker_desc = "Помечать Щупальца смертоносного взгляда метками {rt6}{rt5}{rt4}{rt3}, требуется быть помощником или лидером рейда.\n|cFFFF0000Только один человек в рейде должен включить данную опцию чтобы избежать конфликтов.|r\n|cFFADFF2FПодсказка: Проведите мышкой над щупальцами, чтобы быстрее отметить их.|r"

	L.bloods_remaining = "Крови осталось: %d"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "ruRU")
if L then
	L.gelatinizedDecay = "Сгустившаяся гниль"
	L.befouler = "Скверносерд-осквернитель"
	L.shaman = "Дикий шаман"
	--L.custom_on_mark_totem = "Mark the Totems"
	--L.custom_on_mark_totem_desc = "Mark the Totems with {rt8}{rt7}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Ursoc", "ruRU")
if L then
	L.custom_on_gaze_assist = "Помощник Пристального взгляда"
	L.custom_on_gaze_assist_desc = "Отображать рейдовые метки на полосах таймера и сообщениях для Пристального взгляда. Используются {rt4} для нечетных и {rt6} для четных взглядов. Требуется быть помощником или лидером рейда."
end

L = BigWigs:NewBossLocale("Xavius", "ruRU")
if L then
	L.custom_off_blade_marker = "Маркер Клинков кошмара"
	L.custom_off_blade_marker_desc = "Отмечать цели Клинков Кошмара метками {rt1}{rt2}. Требуется быть помощником или лидером рейда."

	L.linked = "Узы ужаса на ВАС! - Связаны с %s!"
end
