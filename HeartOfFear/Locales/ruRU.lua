local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "ruRU")
if not L then return end
if L then
	L.engage_yell = "Богиня избрала нас для выражения своей божественной воли нашими голосами смертных. Мы лишь орудия в ее руках."

	L.force_message = "AoE импульс"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (кольца)"
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

	L.unseenstrike_inc = "Близится Удар!"
	L.unseenstrike_soon = "Удар через ~5-10 сек!"

	L.assault_message = "Выпад"
	L.side_swap = "Смена стороны"
end

L = BigWigs:NewBossLocale("Garalon", "ruRU")
if L then
	L.removed = "%s снято!"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "ruRU")
if L then
	L.next_pack = "Следующая группа"
	L.next_pack_desc = "Предупреждать, когда появится новая группа после убийства предыдущей."

	L.spear_removed = "Ваше Пронзающее копье снялось!"
	L.residue_removed = "%s снято!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "ruRU")
if L then
	L.explosion_by_other = "Янтарный взрыв на других"
	L.explosion_by_other_desc = "Предупреждение о восстановлении Янтарного взрыва, используемого Янтарным чудовищем или целью вашего фокуса."

	L.explosion_casting_by_other = "Чужое чтение Янтарного взрыва"
	L.explosion_casting_by_other_desc = "Предупреждение о чтении Янтарного взрыва чудовищем или целью вашего фокуса. Крайне рекомендуется включить Увеличение.!"

	L.explosion_by_you = "Янтарный взрыв на вас"
	L.explosion_by_you_desc = "Предупреждение о восстановлении вашего Янтарного взрыва."

	L.explosion_casting_by_you = "Ваше чтение Янтарного взрыва"
	L.explosion_casting_by_you_desc = "Предупреждение о вашем чтении Янтарного взрыва. Крайне рекомендуется включить Увеличение!"

	L.willpower = "Сила воли"
	L.willpower_message = "Ваша сила воли %d"

	L.break_free_message = "Здоровье у %d%%!"
	L.fling_message = "Бросок!"
	L.parasite = "Паразит"

	L.boss_is_casting = "БОСС произносит!"
	L.you_are_casting = "ВЫ произносите!"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "ruRU")
if L then
	L.engage_trigger = "Смерть каждому, кто осмелился бросить вызов моей Империи!"
	L.phases = "Фазы"
	L.phases_desc = "Предупредать о смене фаз."

	L.eyes = "Взгляд императрицы"
	L.eyes_desc = "Считает стаки Взгляда императрицы и показывает таймер."
	L.eyes_message = "%2$dx Взгляд на |3-5(%1$s)"

	L.fumes_bar = "Ваш эффект паров"
end

