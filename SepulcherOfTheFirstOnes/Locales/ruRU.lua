local L = BigWigs:NewBossLocale("Vigilant Guardian", "ruRU")
if not L then return end
if L then
	-- L.sentry = "Tank Add"
	-- L.materium = "Small Adds"
	-- L.shield = "Shield" -- Global locale canidate?
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

	--L.custom_on_ring_timers = "Individual Halo Timers"
	--L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."

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
	--L.cosmic_shift_mythic = "Shift: %s"
	L.unstable_mote = "Частицы"
	L.mote = "Частица"
	L.custom_on_nameplate_fixate = "Метка для автома-собирателя"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на автоме, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
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
