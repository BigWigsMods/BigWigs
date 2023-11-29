local L = BigWigs:NewBossLocale("Gnarlroot", "ruRU")
if not L then return end
if L then
	L.shadowflame_cleave = "Фронтал"
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
	L.flood_of_the_firelands = "Соки"
	L.scorchtail_crash = "Хвост"
	L.serpents_fury = "Дебаффы"
	L.coiling_flames_single = "Дебафф"
end

L = BigWigs:NewBossLocale("Council of Dreams", "ruRU")
if L then
	L.ultimate_boss = "Ульта (%s)"
	L.special_bar = "Ульта [%s] (%d)"
	L.special_mythic_bar = "Ульта [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [Ульта] (%d)"

	L.barreling_charge = "Чардж"
	L.poisonous_javelin = "Отравленное копьё"
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
	L.smoldering_backdraft = "Фронтал"
	L.fire_whirl = "Торнадо"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "ruRU")
if L then
	L.continuum = "Новые Узоры"
	L.impending_loom = "Доджи"
	L.viridian_rain = "Урон + Бомбы"
	L.lumbering_slam = "Фронтал"
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
	L.suppressive_ember = "Абсорб"
	L.suppressive_ember_single = "Абсорб"
	L.flare_bomb = "Перья"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "ruRU")
if L then
	L.spirit_trigger = "Дух калдорай"

	L.fyralaths_bite = "Фронтал"
	L.fyralaths_bite_mythic = "Фронталы"
	L.fyralaths_mark = "Метка"
	L.darkflame_shades = "Тени"
	L.darkflame_cleave = "Соаки"
	L.incarnate_intermission = "Подкидывание"
	L.incarnate = "Улетает"
	L.spirits_of_the_kaldorei = "Духи"
	L.molten_gauntlet = "Танкбастер"

	L.greater_firestorm_shortened_bar = "Метеоры" -- Same letter in ru
	L.greater_firestorm_message_full = "Метеоры [Великая]"
	L.eternal_firestorm_shortened_bar = "Метеоры" --  Same letter in ru
	L.eternal_firestorm_message_full = "Метеоры [Вечная]"
end
