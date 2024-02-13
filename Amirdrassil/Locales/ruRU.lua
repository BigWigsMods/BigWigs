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
end

L = BigWigs:NewBossLocale("Volcoross", "ruRU")
if L then
	L.custom_off_all_scorchtail_crash = "Показывать все касты"
	L.custom_off_all_scorchtail_crash_desc = "Показывать таймеры и уведомления о всех применениях Удара Жгучехвоста, а не только для своей стороны."

	L.flood_of_the_firelands_single_wait = "Жди" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Хвост"
	L.serpents_fury = "Дебаффы"
	L.coiling_flames_single = "Дебафф"
end

L = BigWigs:NewBossLocale("Council of Dreams", "ruRU")
if L then
	L.agonizing_claws_debuff = "{421022} (Дебафф)"

	L.custom_off_combined_full_energy = "Объединённые полоски максимальной энергии (Мифический режим)"
	L.custom_off_combined_full_energy_desc = "Объединяет полоски способностей боссов, что бы показывалась только одна полоска для обоих способностей."

	L.special_mechanic_bar = "%s [Ульта] (%d)"

	L.constricting_thicket = "Лозы"
	L.poisonous_javelin = "Отравленное копьё"
	L.song_of_the_dragon = "Песня"
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
	L.charred_brambles = "Корень хилить"
	L.blazing_thorns = "Спирали"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "ruRU")
if L then
	L.mythic_add_death = "%s убит"

	L.continuum = "Новые Узоры"
	L.surging_growth = "Новые Соки"
	L.ephemeral_flora = "Мили Соак"
	L.viridian_rain = "Урон + Бомбы"
	L.threads = "Станки" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "ruRU")
if L then
	L.brand_of_damnation = "Танк Соак"
	L.lava_geysers = "Гейзеры"
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
	L.flare_bomb = "Перья"
	L.too_close_to_edge = "Слишком близко к краю"
	L.taking_damage_from_edge = "Получаешь урон от края платформы"
	L.flying_available = "Можешь лететь"

	L.fly_time = "Полёт"
	L.fly_time_desc = "Показывает сообщение с длительностью полёта между платформами на переходке."
	L.fly_time_msg = "Время полёта: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "ruRU")
if L then
	L.spirits_trigger = "Дух калдорай"

	L.fyralaths_bite = "Фронтал"
	L.fyralaths_bite_mythic = "Фронталы"
	L.darkflame_shades = "Тени"
	L.darkflame_cleave = "Соаки"

	L.incarnate_intermission = "Подкидывание"

	L.incarnate = "Улетает"
	L.molten_gauntlet = "Танкбастер"
	L.mythic_debuffs = "Клетка" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Метеоры" -- Same letter in ru
	L.greater_firestorm_message_full = "Метеоры [Великие]"
	L.eternal_firestorm_shortened_bar = "Метеоры" --  Same letter in ru
	L.eternal_firestorm_message_full = "Метеоры [Вечные]"

	L.eternal_firestorm_swirl = "Лужи Огненной Бури"
	L.eternal_firestorm_swirl_desc = "Показывает таймеры появления дамажущих луж после каста Огненной Бури."

	L.flame_orb = "Огненный Шар"
	L.shadow_orb = "Теневой Шар"
	L.orb_message_flame = "Ты Огонь"
	L.orb_message_shadow = "Ты Тьма"
end
