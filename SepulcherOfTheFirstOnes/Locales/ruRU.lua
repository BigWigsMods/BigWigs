local L = BigWigs:NewBossLocale("Vigilant Guardian", "ruRU")
if not L then return end
if L then
	L.sentry = "Танк моб"
	L.materium = "Кастер моб"
	L.shield = "Защитное поле" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ruRU")
if L then
	L.tank_combo_desc = "Таймер для танковской комбы на 100 энергии."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "ruRU")
if L then
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

	L.custom_on_ring_timers = "Индивидуальные таймеры для колец"
	L.custom_on_ring_timers_desc = "\"Ореол дезинтеграции\" создаёт набор колец. Выбрав эту настройку, вам будет показаны полосы для каждой полосы индивидуально. Использует настройки \"Ореол дезинтеграции\"."

	L.shield_removed = "%s убран спустя %.1fs" -- "Shield removed after 1.1s" s = seconds
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
	L.cosmic_shift_mythic = "Сдвиг: %s"
	L.unstable_mote = "Частицы"
	L.mote = "Частица"
	L.custom_on_nameplate_fixate = "Метка для автома-собирателя"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на автоме, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.harmonic = "Отталкивание"
	L.melodic = "Притягивание"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "ruRU")
if L then
	L.custom_off_repeating_blasphemy = "Метки кощунства"
	L.custom_off_repeating_blasphemy_desc = "Повторять метки {rt1} и {rt3} в чат, что бы найти партнёра."

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
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "ruRU")
if L then
	--L.seismic_tremors = "Motes + Tremors"
	--L.earthbreaker_missiles = "Missiles"
	--L.crushing_prism = "Prisms"
	--L.prism = "Prism"

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Halondrus can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."
end

L = BigWigs:NewBossLocale("Lords of Dread", "ruRU")
if L then
	--L.unto_darkness = "AoE Phase"
	--L.cloud_of_carrion = "Carrion"
	--L.manifest_shadows = "Adds"
	--L.leeching_claws = "Frontal (M)"
	--L.infiltration_of_dread = "Among Us"
	--L.fearful_trepidation = "Fears"
	--L.slumber_cloud = "Clouds"
	--L.anguishing_strike = "Frontal (K)"
end

L = BigWigs:NewBossLocale("Rygelon", "ruRU")
if L then
	--L.celestial_collapse = "Quasars"
	--L.manifest_cosmos = "Cores"
	--L.stellar_shroud = "Heal Absorb"
end

L = BigWigs:NewBossLocale("The Jailer", "ruRU")
if L then
	--L.rune_of_damnation_countdown = "Countdown"
	--L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	--L.jump = "Jump In"

	--L.chain = "Chain"
	--L.rune = "Rune"

	--L.chain_target = "Chaining %s!"
	--L.chains_remaining = "%d/%d Chains Broken"

	--L.chains_of_oppression = "Pull Chains"
	--L.unholy_attunement = "Pylons"
	--L.chains_of_anguish = "Spread Chains"
	--L.rune_of_compulsion = "Charms"
	--L.rune_of_domination = "Group Soaks"
end
