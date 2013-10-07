local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "ruRU")
if not L then return end
if L then
	L.engage_yell = "Богиня избрала нас для выражения своей божественной воли нашими голосами смертных. Мы лишь орудия в ее руках."

	L.force_message = "AoE импульс"

	L.attenuation = EJ_GetSectionInfo(6426)
	L.attenuation_bar = "Кольца... танцуем!"
	L.attenuation_message = "%s Танцуем %s"
	L.echo = "|c001cc986Эхо|r"
	L.zorlok = "|c00ed1ffaЗор'лок|r"
	L.left = "|c00008000<- Влево <-|r"
	L.right = "|c00FF0000-> Направо ->|r"

	L.platform_emote = "платформ"
	L.platform_emote_final = "вдыхает"
	L.platform_message = "Смена платформы"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "ruRU")
if L then
	L.engage_yell = "К бою, чужаки. Вам предстоит сразиться со мной, повелителем клинков Та'яком."

	L.unseenstrike_soon = "Удар (%d) через ~5-10 сек!"
	L.assault_message = "Выпад"
	L.side_swap = "Смена стороны"

	L.custom_off_windstep = "Маркировка Шага ветра"
	L.custom_off_windstep_desc = "Чтобы помочь лекарям, на людей с Шагом ветра будут поставлены метки {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Garalon", "ruRU")
if L then
	L.phase2_trigger = "Тяжелый доспех Гаралона начинает трескаться и расползаться!"

	L.removed = "%s снялись!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "ruRU")
if L then
	L.spear_removed = "Ваше Пронзающее копье снялось!"

	L.mending_desc = "|cFFFF0000ВНИМАНИЕ: Будет показываться таймер только для вашего 'фокуса', так как все Зар'тики - боевые лекари имеют разное время восстановления способности.|r "
	L.mending_warning = "Ваш фокус произносит Лечение!"
	L.mending_bar = "Фокус: Лечение"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "ruRU")
if L then
	L.explosion_by_other = "Восстановление Янтарного взрыва Чудовища/Фокуса"
	L.explosion_by_other_desc = "Предупреждение о восстановлении Янтарного взрыва Чудовища или вашего фокуса."

	L.explosion_casting_by_other = "Полоса чтения Янтарного взрыва от Чудовища/Фокуса"
	L.explosion_casting_by_other_desc = "Предупреждение о чтении Янтарного взрыва Чудовищем или вашем фокусом. Крайне рекомендуется включить Увеличение!"

	L.explosion_by_you = "Восстановление вашего Янтарного взрыва"
	L.explosion_by_you_desc = "Предупреждение о восстановлении вашего Янтарного взрыва."
	L.explosion_by_you_bar = "Вы начинаете чтение..."

	L.explosion_casting_by_you = "Ваша полоса чтения Янтарного взрыва"
	L.explosion_casting_by_you_desc = "Предупреждение о вашем чтении Янтарного взрыва. Крайне рекомендуется включить Увеличение!"

	L.willpower = "Сила воли"
	L.willpower_message = "Ваша сила воли %d"

	L.break_free_message = "Здоровье %d%%!"
	L.fling_message = "Бросок!"
	L.parasite = "Паразит"

	L.monstrosity_is_casting = "Чудовище: Взрыв"
	L.you_are_casting = "ВЫ произносите!"

	L.unsok_short = "Босс"
	L.monstrosity_short = "Чудище"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "ruRU")
if L then
	L.engage_trigger = "Смерть каждому, кто осмелился бросить вызов моей Империи!"
	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз."

	L.eyes = "Взгляд императрицы"
	L.eyes_desc = "Считает стаки Взгляда императрицы и показывает таймер."
	L.eyes_message = "Взгляд"

	L.visions_message = "Видения"
	L.visions_dispel = "Игроки испуганы!"
	L.fumes_bar = "Ваш эффект паров"
end

