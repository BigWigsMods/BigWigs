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

	L.assault_message = "%2$dx Выпад на |3-5(%1$s)"
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
	L.explosion_casting = "Янтарный взрыв"
	L.explosion_casting_desc = "Предупреждать о начале применения Янтарного взрыва. Крайне рекомендуется включить 'Увеличение'!"

	L.willpower = "Сила воли"
	L.willpower_desc = "Когда иссякнет Сила воли - игрок умрет, а Мутировавший организм продолжит бесконтрольное существовавание."
	L.willpower_message = "Ваша сила воли: %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "ruRU")
if L then
	L.engage_trigger = "Смерть каждому, кто осмелился бросить вызов моей Империи!"
	L.phases = "Фазы"
	L.phases_desc = "Предупредать о смене фаз."

	L.eyes = "Взгляд императрицы"
	L.eyes_desc = "Считает стаки взгляда императрицы и показывает таймер."
	L.eyes_message = "%2$dx Взгляд на |3-5(%1$s)"
end

