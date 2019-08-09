local L = BigWigs:NewBossLocale("Lucifron", "ruRU")
if not L then return end
if L then
	L.mc_bar = "КР: %s"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "ruRU")
if L then
	--L.disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!"
	--L.power_next = "Next Power"
end

L = BigWigs:NewBossLocale("Ragnaros ", "ruRU")
if L then
	L.submerge_trigger = "ПРИБЫВАЙТЕ ЕЩЕ"
	L.engage_trigger = "Тогда получите ещё!"

	L.knockback_message = "Сбивание с ног!"
	L.knockback_bar = "Массовое cбивание с ног"

	L.submerge = "Погружение Рагнароса"
	L.submerge_desc = "Предупреждать о погружении Рагнароса и появлении сыновей пламени"
	L.submerge_message = "Раграрос погрузился на 90 секунд. Появляются сыновья пламени!"
	L.submerge_bar = "Рагнарос появляется"

	L.emerge = "Всплытие Рагнароса"
	L.emerge_desc = "Предупреждать о всплытии Рагнароса"
	L.emerge_message = "Рагнарос появился, 3 минуты до погружения!"
	L.emerge_bar = "Рагнарос погрузился"
end

