local L = BigWigs:NewBossLocale("Doomwalker", "ruRU")
if not L then return end
if L then
	L.name = "Судьболом"

	L.engage_trigger = "Не продолжайте. Вы будете уничтожены."
	L.engage_message = "Doomwalker engaged, Earthquake in ~30sec!"

	L.overrun_desc = "Alert when Doomwalker uses his Overrun ability."

	L.earthquake_desc = "Alert when Doomwalker uses his Earthquake ability."
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "ruRU")
if L then
	L.name = "Владыка Судеб Каззак"

	--L.engage_trigger1 = "The Legion will conquer all!"
	--L.engage_trigger2 = "All mortals will perish!"

	--L.enrage_warning1 = "%s Engaged - Enrage in 50-60sec"
	--L.enrage_warning2 = "Enrage soon!"
	--L.enrage_message = "Enraged for 10sec!"
	--L.enrage_finished = "Enrage over - Next in 50-60sec"
	--L.enrage_bar = "~Enrage"
	--L.enraged_bar = "<Enraged>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "ruRU")
if L then
	L.engage_trigger = "Иди… и умри."
	L.engage_message = "Контакт с %s!"

	L.grow = "Расти!"
	L.grow_desc = "Count and warn for Grull's grow."
	L.grow_message = "Раста: (%d)"
	L.grow_bar = "Расти! (%d)"

	L.grasp = "Хватка"
	L.grasp_desc = "Grasp warnings and timers."
	L.grasp_message = "Прах земной - Раскалывание через ~10сек!"
	L.grasp_warning = "Скоро Прах земной"

	L.silence_message = "Массовое Молчание"
	L.silence_warning = "Скоро Массовое Молчание!"
	L.silence_bar = "~Молчание"
end

L = BigWigs:NewBossLocale("High King Maulgar", "ruRU")
if L then
	L.engage_trigger = "Гронны – настоящая сила в Запределье!"

	L.heal_message = "Слепоглаз выполняет Молитву исцеления!"
	L.heal_bar = "Исцеление"

	L.shield_message = "Щит на Слепоглазе!"

	L.spellshield_message = "Щит заклятий на Кроше!"

	L.summon_message = "Призван Охотник Скверны!"
	L.summon_bar = "~Охотник Скверны"

	L.whirlwind_message = "Молгар - Вихрь через 15сек!"
	L.whirlwind_warning = "Контакт с Молгаром - Вихрь через ~60сек!"

	L.mage = "Крош Огненная Рука (Маг)"
	L.warlock = "Олм Созывающий (Чернокнижник)"
	L.priest = "Слепоглаз Ясновидец (Жрец)"
end

L = BigWigs:NewBossLocale("Magtheridon", "ruRU")
if L then
	L.escape = "Бегство"
	L.escape_desc = "Отсчёт времени до освобождения Магтеридона."
	L.escape_trigger1 = "начинает ослабевать!"
	L.escape_trigger2 = "Я… освобожден!"
	L.escape_warning1 = "Контакт с %sом - Освободится через 2мин!"
	L.escape_warning2 = "Освободится через 1мин!"
	L.escape_warning3 = "Освободится через 30сек!"
	L.escape_warning4 = "Освободится через 10сек!"
	L.escape_warning5 = "Освободится через 3сек!"
	L.escape_bar = "Освободился..."
	L.escape_message = "%s освободился!"

	L.abyssal = "Горящий дух Бездны"
	L.abyssal_desc = "Предупреждать о создании Горящего духа Бездны."
	L.abyssal_message = "Горящий дух Бездны (%d)"

	L.heal = "Исцеление"
	L.heal_desc = "Предупреждать когда Чаротворцы начинают Исцелять."
	L.heal_message = "Исцеление!"

	L.banish = "Изгнание"
	L.banish_desc = "Предупреждать о Изгнании Магтеридона."
	L.banish_message = "Изгнан на ~10сек"
	L.banish_over_message = "Изгнание рассеялось!"
	L.banish_bar = "<Изгнан>"

	L.exhaust_desc = "Таймеры для Изнурение разума на игроках."
	L.exhaust_bar = "[%s] изнурённый"

	L.debris_trigger = "Пусть стены темницы содрогнутся"
	L.debris_message = "30% - надвигается Обломок!"
end

