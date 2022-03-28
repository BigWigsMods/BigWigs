local L = BigWigs:NewBossLocale("Vigilant Guardian", "ruRU")
if not L then return end
if L then
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 507cd00d5 (Update ruRU (#1167))
	L.sentry = "Танк моб"
	L.materium = "Кастер моб"
	L.shield = "Защитное поле" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ruRU")
if L then
	L.tank_combo_desc = "При применении Сколексом комбо из трёх ударов на 100 энергии танки должны сблизиться, чтобы по очереди принимать на себя урон от атак."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "ruRU")
if L then
=======
>>>>>>> dc9a17263 (uncomment)
	L.traps = "Ловушки" -- Stasis Trap
	L.sparknova = "Вспышка гиперсвета" -- Hyperlight Sparknova
	L.relocation = "Стяжка" -- Glyph of Relocation
	L.relocation_count = "%s Ф%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Телепорты" -- Interdimensional Wormholes
	L.wormhole = "Телепорт" -- Interdimensional Wormhole
	L.rings = "Кольца Ф%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "ruRU")
if L then
	L.staggering_barrage = "Обстрел" -- Staggering Barrage
	L.domination_core = "Ад" -- Domination Core
	L.obliteration_arc = "Дуга" -- Obliteration Arc

	L.disintergration_halo = "Кольца" -- Disintegration Halo
	L.rings_x = "Кольца x%d"
	L.rings_enrage = "Кольца (Исступление)"
	L.ring_count = "Кольцо (%d/%d)"

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 507cd00d5 (Update ruRU (#1167))
	L.custom_on_ring_timers = "Индивидуальные таймеры для колец"
	L.custom_on_ring_timers_desc = "\"Ореол дезинтеграции\" создаёт набор колец. Выбрав эту настройку, вам будет показаны полосы для каждой полосы индивидуально. Использует настройки \"Ореол дезинтеграции\"."

<<<<<<< HEAD
=======
>>>>>>> dc9a17263 (uncomment)
	L.shield_removed = "%s убран спустя %.1fs" -- "Shield removed after 1.1s" s = seconds
=======
	L.shield_removed = "%s убран спустя %.1fс" -- "Shield removed after 1.1s" s = seconds
>>>>>>> 93296c654 (Update ruRU (#1178))
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "ruRU")
if L then
	L.necrotic_ritual = "Ритуал"
	L.runecarvers_deathtouch = "ДОТ"
	L.windswept_wings = "Ветерки"
	L.wild_stampede = "Звери"
	L.withering_seeds = "Семена"
	L.hand_of_destruction = "Длань разрушения"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "ruRU")
if L then
	L.protoform_cascade = "Фронтал"
	L.cosmic_shift = "Отталкивание"
<<<<<<< HEAD
<<<<<<< HEAD
	L.cosmic_shift_mythic = "Сдвиг: %s"
=======
>>>>>>> dc9a17263 (uncomment)
=======
	L.cosmic_shift_mythic = "Сдвиг: %s"
>>>>>>> 507cd00d5 (Update ruRU (#1167))
	L.unstable_mote = "Частицы"
	L.mote = "Частица"
	L.custom_on_nameplate_fixate = "Метка для автома-собирателя"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на автоме, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."
<<<<<<< HEAD

	L.harmonic = "Отталкивание"
	L.melodic = "Притягивание"
<<<<<<< HEAD
=======
>>>>>>> dc9a17263 (uncomment)
=======
>>>>>>> 507cd00d5 (Update ruRU (#1167))
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "ruRU")
if L then
	L.custom_off_repeating_blasphemy = "Метки кощунства"
	L.custom_off_repeating_blasphemy_desc = "Повторять метки {rt1} и {rt3} в чат, что бы найти партнёра."
<<<<<<< HEAD

	L.kingsmourne_hungers = "Клив"
	L.blasphemy = "Метки"
	L.befouled_barrier = "Барьер"
	L.wicked_star = "Звезда"
	L.domination_word_pain = "ДОТ"
	L.army_of_the_dead = "Армия"
	L.grim_reflections = "Кик ады"
	L.march_of_the_damned = "Стенки"
	L.dire_blasphemy = "Метки"

	L.remnant_active = "Тень активна"
=======

	L.kingsmourne_hungers = "Клив"
	L.blasphemy = "Метки"
	L.befouled_barrier = "Барьер"
	L.wicked_star = "Звезда"
	L.domination_word_pain = "ДОТ"
	L.army_of_the_dead = "Армия"
	L.grim_reflections = "Кик ады"
	L.march_of_the_damned = "Стенки"
	L.dire_blasphemy = "Метки"
	L.beacon_of_hope = "Маяк"

	L.remnant_active = "Тень активна"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ruRU")
if L then
	L.tank_combo_desc = "Таймер для танковской комбы на 100 энергии."
>>>>>>> dc9a17263 (uncomment)
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ruRU")
if L then
	L.tank_combo_desc = "Таймер для танковской комбы на 100 энергии."
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "ruRU")
if L then
	L.seismic_tremors = "Частицы + Толчки"
	L.earthbreaker_missiles = "Снаряды"
	L.crushing_prism = "Призмы"
	L.prism = "Призма"

	L.bomb_dropped = "Бомба брошена"

	L.custom_on_stop_timers = "Всегда показывать полосы заклинаний"
	L.custom_on_stop_timers_desc = "Галондрий может откладывать свои способности. Когда эта опция включена, полосы этих способностей будут оставаться на экране."
end

L = BigWigs:NewBossLocale("Lords of Dread", "ruRU")
if L then
	L.unto_darkness = "АОЕ Фаза"
	L.cloud_of_carrion = "Рой"
	L.empowered_cloud_of_carrion = "Усиленный рой" -- Empowered Cloud of Carrion
	L.manifest_shadows = "Ады"
	L.leeching_claws = "Фронтал (M)"
	L.infiltration_of_dread = "Амогус"
	L.infiltration_removed = "Импостер найден спустя %.1fс" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Фир"
	L.slumber_cloud = "Слип"
	L.anguishing_strike = "Фронтал (K)"

	L.custom_on_repeating_biting_wound_desc = "Повторять сообщение о дебафе с иконкой {rt7}, ради большей видимости других игроков."
	L.custom_on_repeating_biting_wound = "Сообщение ран от укусов"
end

L = BigWigs:NewBossLocale("Rygelon", "ruRU")
if L then
	L.celestial_collapse = "Квазары"
	L.manifest_cosmos = "Сердечники"
	L.stellar_shroud = "Абсорб хила"
	L.knock = "Отталкивание" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "ruRU")
if L then
	L.rune_of_damnation_countdown = "Отсчёт"
	L.rune_of_damnation_countdown_desc = "Отсчёт для игроков, поражённых Руной проклятия"
	L.jump = "ПРЫГАЙ"

	--L.relentless_domination = "Domination"
	L.chains_of_oppression = "Цепи страдания"
	L.unholy_attunement = "Пилоны"
	--L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "Подчинение"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Цепи"
	L.chain = "Цепи"
	L.chain_target = "Цепь с %s!"
	L.chains_remaining = "%d/%d цепей разорвано"
	L.rune_of_domination = "Делёжка"

	--L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	-- L.azeroth_health = "Azeroth Health"
	-- L.azeroth_health_desc = "Azeroth Health Warnings"

	-- L.azeroth_new_health_plus = "Azeroth Health: +%.1f%% (%d)"
	-- L.azeroth_new_health_minus = "Azeroth Health: -%.1f%%  (%d)"

	-- L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	-- L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	-- L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	-- L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	-- L.mythic_blood_soak_bar = "Heal Azeroth"

	-- L.floors_open = "Floors Open"
	-- L.floors_open_desc = "Time until the floors opens up and you can fall into opened holes."

	-- L.mythic_dispel_stage_4 = "Dispel Timers"
	-- L.mythic_dispel_stage_4_desc = "Timers for when to do dispels in the last stage, used by Echo on their first kill"
	-- L.mythic_dispel_bar = "Dispels"
end
