
do
	local L = BigWigs:NewBossLocale("Atramedes", "ruRU")
	if not L then return end
	if L then
		L.tracking_me = "На МНЕ - Выслеживание!"

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
		L.blazing = "Skeleton Ads"
		L.blazing_desc = "Призывает Blazing Bone Construct."
		L.blazing_message = "Надвигается помощник!"
		L.blazing_bar = "След. скелет"

		L.phase2 = "Phase 2"
		L.phase2_desc = "Warn for Phase 2 transition and display range check."
		L.phase2_message = "Phase 2!"
		L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

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

		L.spew_bar = "~Next Spew"
		L.spew_warning = "Lava Spew Soon!"
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

		L.bitingchill_say = "На МНЕ - Жгучий холод!"

		L.flashfreeze = "~Ледяная вспышка"
		L.next_blast = "~Обжигающий поток"

		L.phase = "Фазы"
		L.phase_desc = "Сообщать о смене фаз."
		L.next_phase = "След. фаза"
		L.green_phase_bar = "Зеленая фаза"

		L.red_phase_trigger = "красный" --проверить
		L.red_phase = "|cFFFF0000Красная|r фаза"
		L.blue_phase_trigger = "синий" --проверить
		L.blue_phase = "|cFF809FFEСиняя|r фаза"
		L.green_phase_trigger = "Зеленая" --проверить
		L.green_phase = "|cFF33FF00Зеленая|r фаза"
		L.dark_phase_trigger = "Темная" --проверить
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

		L.onyxia_power_message = "Скоро Взрыв!"

		L.cinder_say = "На МНЕ - Взрывчатый пепел!"

		L.chromatic_prototype = "Хроматический прообраз" -- 3 adds name
	end

	L = BigWigs:NewBossLocale("Omnotron Defense System", "ruRU")
	if L then
		L.nef = "Лорд Виктор Нефарий"
		L.nef_desc = "Сообщать о способностях Лорда Виктора Нефария."
		L.switch = "Смена"
		L.switch_desc = "Сообщать о сменах."
		L.switch_message = "%s %s"

		L.next_switch = "След. Смена"

		L.nef_next = "~След. Вливание Тьмы"

		L.acquiring_target = "Выбор цели"

		L.bomb_message = "ВАС преследует Слизнюк!"
		L.cloud_say = "Облако на МНЕ!"
		L.cloud_message = "Вы в Облаке!"
		L.protocol_message = "Химическая бомба!"

		L.iconomnotron = "Иконка на активного босса"
		L.iconomnotron_desc = "Помечает активного босса основной иконкой (требуется быть лидером или уполномоченным)."
	end
end

