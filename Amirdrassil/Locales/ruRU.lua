local L = BigWigs:NewBossLocale("Gnarlroot", "ruRU")
if not L then return end
if L then
	L.tortured_scream = "Крик"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "ruRU")
if L then
	L.blistering_spear = "Копья"
	L.blistering_spear_single = "Копьё"
	L.blistering_torment = "Цепь"
	L.twisting_blade = "Фронтал"
	L.marked_for_torment = "Переходка"
	L.umbral_destruction = "Соак"
	L.heart_stopper = "Абсорб"
	L.heart_stopper_single = "Абсорб"
end

L = BigWigs:NewBossLocale("Volcoross", "ruRU")
if L then
	--L.custom_off_all_scorchtail_crash = "Show All Casts"
	--L.custom_off_all_scorchtail_crash_desc = "Show timers and messages for all Scorchtail Crash casts instead of just for your side."

	L.flood_of_the_firelands = "Соки"
	--L.flood_of_the_firelands_single_wait = "Wait" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	--L.flood_of_the_firelands_single = "Soak"
	L.scorchtail_crash = "Хвост"
	L.serpents_fury = "Дебаффы"
	L.coiling_flames_single = "Дебафф"
end

L = BigWigs:NewBossLocale("Council of Dreams", "ruRU")
if L then
	--L.agonizing_claws_debuff = "{421022} (Debuff)"

	L.ultimate_boss = "Ульта (%s)"
	L.special_bar = "Ульта [%s] (%d)"
	L.special_mythic_bar = "Ульта [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [Ульта] (%d)"

	L.barreling_charge = "Чардж"
	L.poisonous_javelin = "Отравленное копьё"
	--L.song_of_the_dragon = "Song"
	L.polymorph_bomb = "Утки"
	L.polymorph_bomb_single = "Утка"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "ruRU")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Крик при низком здоровье на Тлеющем Удульше"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Повторяющиеся крики при здоровье < 75% для игроков с Тлеющем Удушье для координации с другими игроками."

	L.blazing_coalescence_on_player_note = "Когда на тебе"
	L.blazing_coalescence_on_boss_note = "Когда на боссе"

	L.scorching_roots = "Корень"
	L.furious_charge = "Чардж"
	L.blazing_thorns = "Спирали"
	L.falling_embers = "Соки"
	L.fire_whirl = "Торнадо"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "ruRU")
if L then
	--L.mythic_add_death = "%s Killed"

	L.continuum = "Новые Узоры"
	--L.surging_growth = "New Soaks"
	--L.ephemeral_flora = "Red Soak"
	L.viridian_rain = "Урон + Бомбы"
	--L.threads = "Threads" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "ruRU")
if L then
	L.brand_of_damnation = "Танк Соак"
	L.lava_geysers = "Гейзеры"
	L.flame_waves = "Торнадо"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "ruRU")
if L then
	L.seed_soaked = "Семечко засокано"
	L.all_seeds_soaked = "Семечки кончились!"
	L.blazing_mushroom = "Грибы"
	L.fiery_growth = "Диспеллы"
	L.mass_entanglement = "Корни"
	L.incarnation_moonkin = "Совиная форма "
	L.incarnation_tree_of_flame = "Древоформа"
	L.flaming_germination = "Семена"
	L.suppressive_ember = "Абсорб"
	L.suppressive_ember_single = "Абсорб"
	L.flare_bomb = "Перья"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "ruRU")
if L then
	L.spirits_trigger = "Дух калдорай"

	L.fyralaths_bite = "Фронтал"
	L.fyralaths_bite_mythic = "Фронталы"
	L.fyralaths_mark = "Метка"
	L.darkflame_shades = "Тени"
	L.darkflame_cleave = "Соаки"

	L.incarnate_intermission = "Подкидывание"
	--L.corrupt_removed = "Corrupt Over (%.1fs remaining)" -- eg: Corrupt Over (5.0s remaining)

	L.incarnate = "Улетает"
	L.spirits_of_the_kaldorei = "Духи"
	L.molten_gauntlet = "Танкбастер"
	--L.mythic_debuffs = "Cages" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Метеоры" -- Same letter in ru
	L.greater_firestorm_message_full = "Метеоры [Великая]"
	L.eternal_firestorm_shortened_bar = "Метеоры" --  Same letter in ru
	L.eternal_firestorm_message_full = "Метеоры [Вечная]"

	-- L.eternal_firestorm_swirl = "Eternal Firestorm Swirls"
	-- L.eternal_firestorm_swirl_desc = "Timers for Eternal Firestorm Swirls."
	-- L.eternal_firestorm_swirl_bartext = "Swirls"
end
