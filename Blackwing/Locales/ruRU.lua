local L = BigWigs:NewBossLocale("Atramedes", "ruRU")
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

	L.next_system_failure = "~Системная ошибка"
	L.break_message = "%2$dx Разлом на |3-3(%1$s)"

	L.mortality_report = "%s осталось %d%% здоровья, скоро %s!"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end

L = BigWigs:NewBossLocale("Magmaw", "ruRU")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Призывает Blazing Bone Construct."

	L.pillar_of_flame_cd = "~Огненный столп"

	L.slump = "Падение"
	L.slump_desc = "Магмарь падает вперед открывая себя."

	L.slump_trigger = "%s внезапно падает, выставляя клешки!"

	L.expose_trigger = "голову"
	L.expose_message = "Голова обнажена!"
end

L = BigWigs:NewBossLocale("Maloriak", "ruRU")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Сообщает если вы вставли в %s."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Финальная фаза"

	L.release_aberration_message = "%s осталось аберрации!"
	L.release_all = "%s аберрации!"

	L.bitingchill_say = "На МНЕ - Жгучий холод!"

	L.flashfreeze = "~Ледяная вспышка"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."
	L.next_phase = "След. фаза"

	L.you = "На ВАС - %s!"

	L.red_phase_trigger = "красный|r пузырек в котел!"
	L.red_phase = "|cFFFF0000Красная|r фаза"
	L.blue_phase_trigger = "синий|r пузырек в котел!"
	L.blue_phase = "|cFF809FFEСиняя|r фаза"
	L.green_phase_trigger = "зеленый|r пузырек в котел!"
	L.green_phase = "|cFF33FF00Зеленая|r фаза"
	L.dark_phase = "|cFF660099Темная|r фаза"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!" -- темный|r пузырек в котел!
end

L = BigWigs:NewBossLocale("Nefarian", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Сообщать о смене фаз."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.shadowblaze_trigger = "Flesh turns to ash!"

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

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~След. Вливание Тьмы"

	L.acquiring_target = "Выбор цели"

	L.cloud_message = "Вы в Облаке!"
	L.protocol_message = "Химическая бомба!"

	L.iconomnotron = "Иконка на активного босса"
	L.iconomnotron_desc = "Помечает активного босса основной иконкой (требуется быть лидером или уполномоченным)."
end

