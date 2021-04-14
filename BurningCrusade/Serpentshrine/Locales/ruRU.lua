local L = BigWigs:NewBossLocale("Hydross the Unstable", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Leotheras the Blind", "ruRU")
if L then
	L.enrage_trigger = "Наконец-то завершается мое изгнание!"

	L.phase = "Фаза Демона"
	L.phase_desc = "Примерные таймеры Фазы Демона."
	L.phase_trigger = "Уйди, эльфийская мелюзга. Я теперь контролирую ситуацию!"
	L.phase_demon = "Фаза демона в течении 60 сек"
	L.phase_demonsoon = "Фаза демона через 5 сек!"
	L.phase_normalsoon = "Нормальная Фаза через 5 сек"
	L.phase_normal = "Нормальная Фаза!"
	L.demon_bar = "Фаза Демона"
	L.demon_nextbar = "След. Фаза Демона"

	L.mindcontrol = "Контроль над разумом"
	L.mindcontrol_desc = "Предупреждать о том у кого законтролирован разум."
	L.mindcontrol_warning = "Контроль разума"

	L.image = "Изображение"
	L.image_desc = "Тревога на 15%  при расколе изображения."
	L.image_trigger = "Нет… нет! Что ты делаешь? Я господин! Ты меня слышишь? Я… а! Не могу… его сдержать."
	L.image_message = "15% - Изображение Создано!"
	L.image_warning = "Скоро Изображение!"

	L.whisper = "Коварный шепот"
	L.whisper_desc = "Предупреждать когда игрок получает Коварный шепот."
	L.whisper_message = "Демон"
	L.whisper_bar = "Исчезновение Демонов"
	L.whisper_soon = "~перезарядка Демона"
end

L = BigWigs:NewBossLocale("The Lurker Below", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Lady Vashj", "ruRU")
if L then
	L.engage_trigger1 = "I did not wish to lower myself by engaging your kind, but you leave me little choice..."
	L.engage_trigger2 = "Да плевать я на тебя хотела, мразь!"
	L.engage_trigger3 = "Победа владыки Иллидана! "
	L.engage_trigger4 = "Да я тебя развалю от носа до кормы!"
	L.engage_trigger5 = "Смерть непосвященным!"
	L.engage_message = "Начинается фаза 1"

	L.phase = "Предупреждение о фазах"
	L.phase_desc = "Предупреждать о переходе Вайш в различные фазы."
	L.phase2_trigger = "Время пришло! Не оставляйте никого в живых!"
	L.phase2_soon_message = "Скоро фаза 2!"
	L.phase2_message = "Фаза 2, спавн мобов!"
	L.phase3_trigger = "Вам может потребоваться укрытие. "
	L.phase3_message = "Фаза 3 - исступление через 4 мин!"

	L.elemental = "Появление нечистого элементаля"
	L.elemental_desc = "Предупреждать о появлении нечистого элементаля во время фазы 2."
	L.elemental_bar = "Нечистый элементаль появляется"
	L.elemental_soon_message = "Скоро Нечистый элементаль!"

	L.strider = "Появление страйдеров"
	L.strider_desc = "Предупреждать о появлении Страйдеров в фазе 2."
	L.strider_bar = "Страйдер появляется"
	L.strider_soon_message = "Скоро Страйдер!"

	L.naga = "Появление элитных Наг"
	L.naga_desc = "Предупреждать о появлении элитных Наг в фазе 2."
	L.naga_bar = "Нага появляется"
	L.naga_soon_message = "Скоро Нага!"

	L.barrier_desc = "Предупреждать о разрушении барьеров."
	L.barrier_down_message = "Барьер %d/4 разрушен!"
end

