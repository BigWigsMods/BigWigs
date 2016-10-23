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
	--L.remaining = "Remaining"
	--L.missed = "Missed"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "ruRU")
if L then
	L.gelatinizedDecay = "Сгустившаяся гниль"
	L.befouler = "Скверносерд-осквернитель"
	L.shaman = "Дикий шаман"
end

L = BigWigs:NewBossLocale("Ursoc", "ruRU")
if L then
	L.custom_on_gaze_assist = "Помощник Пристального взгляда"
	L.custom_on_gaze_assist_desc = "Отображать рейдовые метки на полосах таймера и сообщениях для Пристального взгляда. Используются {rt4} для нечетных и {rt6} для четных взглядов. Требуется быть помощником или лидером рейда."
end

L = BigWigs:NewBossLocale("Xavius", "ruRU")
if L then
	L.linked = "Узы ужаса на ВАС! - Связаны с %s!"
end
