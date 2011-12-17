
local L = BigWigs:NewBossLocale("Atramedes", "ruRU")
if not L then return end
if L then
	L.ground_phase = "Наземная фаза"
	L.ground_phase_desc = "Сообщать о приземлении Атрамеда."
	L.air_phase = "Воздушная фаза"
	L.air_phase_desc = "Сообщать о взлете Атрамеда."

	L.air_phase_trigger = "Да, беги! С каждым шагом твое сердце бьется все быстрее. Эти громкие, оглушительные удары... Тебе некуда бежать!"

	L.obnoxious_soon = "Скоро Несносность Беса!"

	L.searing_soon = "Жгучее пламя через 10сек!"
end

L = BigWigs:NewBossLocale("Chimaeron", "ruRU")
if L then
	L.bileotron_engage = "Желче-трон оживает и начинает извергать из себя некое вонючее вещество."

	L.next_system_failure = "~Системная ошибка"
	L.break_message = "%2$dx Разлом(а) на %1$s"

	L.phase2_message = "Скоро фаза Смертности!"

	L.warmup = "Начало боя"
	L.warmup_desc = "Время до начала боя с боссом"
end

L = BigWigs:NewBossLocale("Magmaw", "ruRU")
if L then
	-- heroic
	L.blazing = "Помощник - скелет"
	L.blazing_desc = "Призывает Пыляющее костяное создание."
	L.blazing_message = "Надвигается помощник!"
	L.blazing_bar = "Скелет"

	L.armageddon = "Армагеддон"
	L.armageddon_desc = "Предупреждать, если Армагеддон начинается на фазе головы."

	L.phase2 = "2-ая фаза"
	L.phase2_desc = "Сообщить о переходе во 2-ую фазу и показать проверку близости."
	L.phase2_message = "2-ая фаза!"
	L.phase2_yell = "Непостижимо! Вы, кажется, можете уничтожить моего лавового червяка! Пожалуй, я помогу ему."

	-- normal
	L.slump = "Падение (Родео)"
	L.slump_desc = "Магмарь падает вперед открывая себя, позволяя начать родео."
	L.slump_bar = "Родео"
	L.slump_message = "Йихо, погнали!"
	L.slump_trigger = "%s внезапно падает, выставляя клешки!"

	L.infection_message = "Вы заражены!"

	L.expose_trigger = "голову"
	L.expose_message = "Голова обнажена!"

	L.spew_warning = "Скоро Изрыгание лавы!"
end

L = BigWigs:NewBossLocale("Maloriak", "ruRU")
if L then
	--heroic
	L.sludge = "Темная жижа"
	L.sludge_desc = "Сообщает если вы вставли в Темную жижу."
	L.sludge_message = "Темная жижа на ВАС!"

	--normal
	L.final_phase = "Финальная фаза"
	L.final_phase_soon = "Скоро Финальная фаза!"

	L.release_aberration_message = "%s осталось аберрации!"
	L.release_all = "%s аберрации!"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.next_phase = "След. фаза"
	L.green_phase_bar = "Зеленая фаза"

	L.red_phase_trigger = "Помешивая, довести до кипения..."
	L.red_phase_emote_trigger = "красный" --проверить
	L.red_phase = "|cFFFF0000Красная|r фаза"
	L.blue_phase_trigger = "синий|r пузырек в котел!"
	L.blue_phase_emote_trigger = "синий" --проверить
	L.blue_phase = "|cFF809FFEСиняя|r фаза"
	L.green_phase_trigger = "Некак не удается стабилизировать, но без ошибок нет прогресса!"
	L.green_phase_emote_trigger = "Зеленая" --проверить
	L.green_phase = "|cFF33FF00Зеленая|r фаза"
	L.dark_phase_trigger = "Слабоваты твои настои, Малориак! Подбавить бы к ним... специй!" -- темную|r магию на котле!
	L.dark_phase_emote_trigger = "Темная" --проверить
	L.dark_phase = "|cFF660099Темная|r фаза"
end

L = BigWigs:NewBossLocale("Nefarian", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."

	L.discharge_bar = "~Искровой разряд"

	L.phase_two_trigger = "Дерзкие смертные! Неуважение к чужой собственности нужно пресекать самым жестоким образом!"

	L.phase_three_trigger = "Я пытался следовать законам гостеприимства"

	L.crackle_trigger = "В воздухе трещат электрические разряды!"
	L.crackle_message = "Скоро Электрический удар!"

	L.shadowblaze_message = "Пламя тени"

	L.onyxia_power_message = "Скоро Взрыв!"

	L.chromatic_prototype = "Хроматический прообраз"
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "ruRU")
if L then
	L.nef = "Лорд Виктор Нефарий"
	L.nef_desc = "Сообщать о способностях Лорда Виктора Нефария."

	L.pool = "Обратная вспышка"

	L.switch = "Смена"
	L.switch_desc = "Сообщать о сменах."
	L.switch_message = "%s %s"

	L.next_switch = "След. Смена"

	L.nef_next = "~Вливание Тьмы"

	L.acquiring_target = "Выбор цели"

	L.bomb_message = "ВАС преследует Слизнюк!"
	L.cloud_message = "ВЫ в Облаке!"
	L.protocol_message = "Химическая бомба!"

	L.iconomnotron = "Иконка на активного босса"
	L.iconomnotron_desc = "Помечает активного босса основной иконкой (требуется быть лидером или помощником)."
end

