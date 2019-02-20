local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "ruRU")
if not L then return end
if L then
	L.flamespeaker = "Растарский заклинатель огня"
	L.enforcer = "Вечный каратель"
	L.punisher = "Растарский каратель"
	L.vessel = "Сосуд Бвонсамди"

	L.victim = "%s проткнул ВАС %s!"
	L.witness = "%s проткнул %s %s!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "ruRU")
if L then
	L.disorient_desc = "Полоса для |cff71d5ff[Слепящей веры]|r.\nВозможно, это полоса, которую вы хотите отслеживать." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "ruRU")
if L then
	L.disorient_desc = "Полоса для |cff71d5ff[Слепящей веры]|r.\nВозможно, это полоса, которую вы хотите отслеживать." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "ruRU")
if L then
	L.custom_on_fixate_plates = "Иконка Преследования на Полосах Здоровья противников"
	L.custom_on_fixate_plates_desc = "Отображать иконку на Полосе Здоровья противника, что преследует Вас.\nНеобходимо включить Полосы Здоровья противников. Только KuiNameplates поддерживает данную опцию."

	L.absorb = "Щит"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Произнесение"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s прерван %s (%.1f секунд осталось)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "ruRU")
if L then
	L.custom_on_fixate_plates = "Иконка Преследования на Полосах Здоровья противников"
	L.custom_on_fixate_plates_desc = "Отображать иконку на Полосе Здоровья противника, что преследует Вас.\nНеобходимо включить Полосы Здоровья противников. Только KuiNameplates поддерживает данную опция."

	L.absorb = "Щит"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Произнесение"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s прерван %s (%.1f секунд осталось)"
end

L = BigWigs:NewBossLocale("Opulence", "ruRU")
if L then
	L.room = "Комната (%d/8)"
	L.no_jewel = "Нет Камня:"

	L.custom_on_fade_out_bars = "Скрыть полосы 1-ой фазы"
	L.custom_on_fade_out_bars_desc = "Скрыть полосы, которые не принадлежат голему в вашей комнате на 1-ой фазе."

	L.custom_on_hand_timers = "Десница Ин'заши"
	L.custom_on_hand_timers_desc = "Отображать объявления и полосы для способностей Десницы Ин'заши."
	L.hand_cast = "Десница: %s"

	L.custom_on_bulwark_timers = "Защитник Ялата"
	L.custom_on_bulwark_timers_desc = "Отображать объявления и полосы для способностей Защитника Ялаты."
	L.bulwark_cast = "Защитник: %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "ruRU")
if L then
	L.killed = "%s убит!"
	--L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "ruRU")
if L then
	L.gigavolt_alt_text = "Бомба"

	L.custom_off_sparkbot_marker = "Метки на Раздражаторов"
	L.custom_off_sparkbot_marker_desc = "Отмечает Раздражаторов {rt4}{rt5}{rt6}{rt7}{rt8}."

	L.custom_off_repeating_shrunk_say = "Повторяющееся сообщение об Уменьшении" -- Shrunk = 284168
	L.custom_off_repeating_shrunk_say_desc = "Спамить Уменьшение, когда Вы |cff71d5ff[Уменьшены]|r. Может тогда по Вам перестанут бегать."

	L.custom_off_repeating_tampering_say = "Повторяющееся сообщение во время Взлома" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "Спамить Ваще имя, когда Вы управляете Раздражатором."
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "ruRU")
if L then
	L.killed = "%s убит!"

	L.custom_on_fade_out_bars = "Скрыть полосы 1-ой фазы"
	L.custom_on_fade_out_bars_desc = "Скрыть полосы, которые не принадлежат боссу на Вашем корабле на 1-ой фазе."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "ruRU")
if L then
	L.starbord_ship_emote = "Кул-тирасский фрегат приближается по правому борту!"
	L.port_side_ship_emote = "Кул-тирасский фрегат приближается по левому борту!"

	L.starbord_txt = "Правый Корабль" -- starboard
	L.port_side_txt = "Левый Корабль" -- port

	L.custom_on_stop_timers = "Всегда отображать полосы способностей"
	L.custom_on_stop_timers_desc = "Джайна использует восстановившиеся способности случайно. С этой опцией полосы с готовыми способностями будут оставаться на экране."

	L.frozenblood_player = "%s (%d игроков)"

	L.intermission_stage2 = "Фаза 2 - %.1f сек"
end
