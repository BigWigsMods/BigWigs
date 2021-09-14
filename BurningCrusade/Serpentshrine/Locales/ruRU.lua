local L = BigWigs:NewBossLocale("Hydross the Unstable", "ruRU")
if not L then return end
if L then
	L.start_trigger = "Я не позволю вам вмешиваться!"

	L.mark = "Метка"
	L.mark_desc = "Показывает предупреждения для меток и их счетчик."

	L.stance = "Смена стойки"
	L.stance_desc = "Предупреждение когда Гидросс меняет стойку."
	L.poison_stance = "Гидросс - ядовитая фаза!"
	L.water_stance = "Гидросс - ледяная фаза!"

	L.debuff_warn = "Mark at %s%%!"
end

L = BigWigs:NewBossLocale("The Lurker Below", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Leotheras the Blind", "ruRU")
if L then
	L.enrage_trigger = "Наконец-то мое заточение окончено!"

	L.phase = "Фаза Демона"
	L.phase_desc = "Примерные таймеры Фазы Демона."
	L.phase_trigger = "Прочь, жалкий эльф. Настало мое время!"
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
	L.image_trigger = "Нет... нет! Что вы наделали? Я – главный! Слышишь меня? Я... Ааааах! Мне его... не удержать."
	L.image_message = "15% - Изображение Создано!"
	L.image_warning = "Скоро Изображение!"

	L.whisper = "Коварный шепот"
	L.whisper_desc = "Предупреждать когда игрок получает Коварный шепот."
	L.whisper_message = "Демон"
	L.whisper_bar = "Исчезновение Демонов"
	L.whisper_soon = "~перезарядка Демона"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "ruRU")
if L then
	L.enrage_trigger = "Стража, к бою! У нас гости..."

	L.totem = "Тотем огненного всполоха"
	L.totem_desc = "Предупреждает о тотеме огненного всполоха и кто его применяет."
	L.totem_icon = 38236
	L.totem_message1 = "Волниис: Тотем огненного всполоха"
	L.totem_message2 = "Каратресс: Тотем огненного всполоха"
	L.heal_message = "Карибдис применяет Исцеление!"

	L.priest = "Хранительница глубин Карибдис"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "ruRU")
if L then
	L.grave_bar = "<Watery Graves>"
	L.grave_nextbar = "~гробницы"

	L.murloc = "Мурлоки"
	L.murloc_desc = "Предупреждение о появлении мурлоков."
	L.murloc_icon = 42365
	L.murloc_bar = "~Мурлоки"
	L.murloc_message = "Incoming Murlocs!"
	L.murloc_soon_message = "Появление мурлоков скоро!"
	L.murloc_engaged = "Начался бой с %s, появление мурлоков через ~40 сек"

	L.globules = "Водяные гранулы"
	L.globules_desc = "Предупреждение о появлении водяных гранул."
	L.globules_icon = "INV_Elemental_Primal_Water"
	L.globules_trigger1 = "Soon it will be finished!"
	L.globules_trigger2 = "There is nowhere to hide!"
	L.globules_message = "Водяные гранулы!"
	L.globules_warning = "Водяные гранулы скоро!"
	L.globules_bar = "Водяные гранулы пропадают"
end

L = BigWigs:NewBossLocale("Lady Vashj", "ruRU")
if L then
	L.engage_trigger1 = "Я не желаю унижаться, связываясь с вашим родом, но вы не оставляете мне выбора..."
	L.engage_trigger2 = "Я уничтожу вас, земная грязь!"
	L.engage_trigger3 = "Слава владыке Иллидану!"
	L.engage_trigger4 = "Я уничтожу вас!"
	L.engage_trigger5 = "Смерть непосвященным!"
	L.engage_message = "Начинается фаза 1"

	L.phase = "Предупреждение о фазах"
	L.phase_desc = "Предупреждать о переходе Вайш в различные фазы."
	L.phase2_trigger = "Время пришло! Не щадите никого!"
	L.phase2_soon_message = "Скоро фаза 2!"
	L.phase2_message = "Фаза 2, спавн мобов!"
	L.phase3_trigger = "Вам не пора прятаться?"
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

