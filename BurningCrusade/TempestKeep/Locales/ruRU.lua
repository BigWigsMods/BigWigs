local L = BigWigs:NewBossLocale("Void Reaver", "ruRU")
if not L then return end
if L then
	L.engage_trigger = "Внимание! Вы подлежите уничтожению!"
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "ruRU")
if L then
	L.engage_trigger = "Тал ану-мен но син-дорай!"

	L.phase = "Фаза"
	L.phase_desc = "Предупреждение о смене фаз"
	L.phase1_message = "Фаза 1 - исчезновение через ~50 сек"
	L.phase2_warning = "Фаза 2 Скоро!"
	L.phase2_trigger = "^Я сольюсь"
	L.phase2_message = "20% - Фаза 2"

	L.split = "Исчезновение"
	L.split_desc = "Предупреждение о исчезновении и появлении аддов"
	L.split_trigger1 = "Я навсегда избавлю вас от мании величия!"
	L.split_trigger2 = "Вы безнадежно слабы!"


	L.agent_warning = "Исчезновение! - Посланники через 6 сек"
	L.agent_bar = "Посланники"
	L.priest_warning = "Жрецы/Солариан через 3 сек"
	L.priest_bar = "Жрецы/Солариан"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "ruRU")
if L then
	L.engage_trigger = "^Энергия. Сила."
	L.engage_message = "Фаза 1"

	L.gaze = "Взгляд"
	L.gaze_desc = "Предупреждение когда Таладред фокусируется на игроке"
	L.gaze_trigger = "смотрит на"

	L.fear_soon_message = "Страх скоро!"
	L.fear_message = "Страх!"
	L.fear_bar = "~Страх откат"

	L.rebirth = "Перерождение феникса"
	L.rebirth_desc = "примерный таймер перерождения феникса"
	L.rebirth_warning = "возможное перерождение через ~5 сек!"
	L.rebirth_bar = "~возможное перерождение"

	L.pyro = "Пиробласт"
	L.pyro_desc = "Показывает 60 секундный таймер для пиробласта"
	L.pyro_trigger = "%s начинает применять заклинание Огненной глыбы!"
	L.pyro_warning = "Пиробласт через 5 сек!"
	L.pyro_message = "Применяет Пиробласт!"

	L.phase = "Phase warnings"
	L.phase_desc = "Warn about the various phases of the encounter."
	L.thaladred_inc_trigger = "Впечатляет. Посмотрим, хватит ли у вас смелости выступить против Таладреда Светокрада!"
	L.sanguinar_inc_trigger = "Вы справились с моими лучшими советниками... Но перед мощью Кровавого Молота не устоит никто. Узрите лорда Сангвинара!"
	L.capernian_inc_trigger = "Каперниан проследит, чтобы вы не задержались здесь надолго."
	L.telonicus_inc_trigger = "Неплохо, теперь вы можете потягаться с моим главным инженером Телоникусом."
	L.weapons_inc_trigger = "Как видите, оружия у меня предостаточно..."
	L.phase3_trigger = "^Возможно, я недооценил вас. Было бы нечестно"
	L.phase4_trigger = "Увы, иногда приходится брать все в свои руки. Баламоре шаналь!"

	L.flying_trigger = "Я не затем ступил на этот путь, чтобы остановиться на полдороги! Мои планы должны сбыться – и они сбудутся! Узрите же истинную мощь!"
	L.flying_message = "Фаза 5 - Искажение гравитации через 1 мин"

	L.weapons_inc_message = "Фаза 2 - Оружие!"
	L.phase3_message = "Фаза 3 - Советники и оружие!"
	L.phase4_message = "Фаза 4 - Кель'Тас вступает в бой!"
	L.phase4_bar = "Кель'Тас активнен"

	L.mc = "Контроль разума"
	L.mc_desc = "Предупреждение кто под эффектом контроля разума."

	L.revive_bar = "Воскрешение советников"
	L.revive_warning = "Воскрешение советников через 5 сек!"

	L.dead_message = "%s умирает"

	L.capernian = "Верховный звездочет Каперниан"
	L.sanguinar = "Лорд Сангвинар"
	L.telonicus = "Старший инженер Телоникус"
	L.thaladred = "Таладред Светокрад"
end

