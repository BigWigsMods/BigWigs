
local L = BigWigs:NewBossLocale("Atramedes", "ruRU")
if not L then return end
if L then
	L.ground_phase = "Наземная фаза"
	L.ground_phase_desc = "Сообщать о приземлении Атрамеда."
	L.air_phase = "Воздушная фаза"
	L.air_phase_desc = "Сообщать о взлете Атрамеда."

	L.air_phase_trigger = "Да, беги! С каждым шагом твое сердце бьется все быстрее. Эти громкие, оглушительные удары... Тебе некуда бежать!"

	L.sonicbreath_cooldown = "~Волновое дыхание"
end

L = BigWigs:NewBossLocale("Chimaeron", "ruRU")
if L then
	L.bileotron_engage = "Желче-трон оживает и начинает извергать из себя некое вонючее вещество."
	L.win_trigger = "A shame to lose that experiment..."

	L.next_system_failure = "~Системная ошибка"
	L.break_message = "%2$dx Разлом на |3-3(%1$s)"

	L.phase2_message = "Скоро фаза Смертности!"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end

L = BigWigs:NewBossLocale("Magmaw", "ruRU")
if L then
	-- heroic
	L.blazing = "Помощник - скелет"
	L.blazing_desc = "Призывает Пыляющее костяное создание."
	L.blazing_message = "Надвигается помощник!"
	L.blazing_bar = "След. скелет"

	L.phase2 = "2-ая фаза"
	L.phase2_desc = "Сообщить о переходе во 2-ую фазу и показать проверку близости."
	L.phase2_message = "2-ая фаза!"
	L.phase2_yell = "Непостижимо! Вы, кажется, можете уничтожить моего лавового червяка! Пожалуй, я помогу ему."

	-- normal
	L.pillar_of_flame_cd = "~Огненный столп"

	L.slump = "Падение (Родео)"
	L.slump_desc = "Магмарь падает вперед открывая себя, позволяя начать родео."
	L.slump_bar = "След. родео"
	L.slump_message = "Йихо, погнали!"
	L.slump_trigger = "%s внезапно падает, выставляя клешки!"

	L.infection_message = "Вы заражены!"

	L.expose_trigger = "голову"
	L.expose_message = "Голова обнажена!"

	L.spew_bar = "~Изрыгание лавы"
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

	L.release_aberration_message = "%s осталось аберрации!"
	L.release_all = "%s аберрации!"

	L.flashfreeze = "~Ледяная вспышка"
	L.next_blast = "~Обжигающий поток"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.next_phase = "След. фаза"
	L.green_phase_bar = "Зеленая фаза"

	L.red_phase_trigger = "Помешивая, довести до кипения..."
	L.red_phase_emote_trigger = "красный" --проверить
	L.red_phase = "|cFFFF0000Красная|r фаза"
	L.blue_phase_trigger = "синий|r пузырек в котел!" --How well does the mortal shell handle extreme temperature change? Must find out! For science!
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

	L.phase_two_trigger = "Дерзкие смертные! Неуважение к чужой собственности нужно пресекать самым жестоким образом!"

	L.phase_three_trigger = "Я пытался следовать законам гостеприимства, но вы все никак не умрете! Придется отбросить условности и просто... УБИТЬ ВАС ВСЕХ!"

	L.crackle_trigger = "В воздухе трещат электрические разряды!"
	L.crackle_message = "Скоро Электрический удар!"
	
	L.shadowblaze_message = "Пламя тени"

	L.onyxia_power_message = "Скоро Взрыв!"

	L.chromatic_prototype = "Хроматический прообраз" -- 3 adds name
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

	-- not using these but lets not just remove them yet who knows what will 4.0.6 break
	--L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	--L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~След. Вливание Тьмы"

	L.acquiring_target = "Выбор цели"

	L.bomb_message = "ВАС преследует Слизнюк!"
	L.cloud_message = "Вы в Облаке!"
	L.protocol_message = "Химическая бомба!"

	L.iconomnotron = "Иконка на активного босса"
	L.iconomnotron_desc = "Помечает активного босса основной иконкой (требуется быть лидером или уполномоченным)."
end

