-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Смена цветов",
	["1241292"] = "Прыжок Свет/Бездна",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Игра на запоминание",
	heavens_glaives = "Глефы",
	heavens_lance = "Копьё",
	the_dark_archangel = "Большой взрыв",
	prism_kicks = "Прерывания",
	dark_constellation = "Звёзды",
	dark_rune_bar = "Решить игру",

	left = "[Л] %s", -- left/west group bars in p3
	right = "[П] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Эпохальный] Ограничить предупреждения 3-й фазы",
	custom_select_limit_warnings_desc = "Показывать предупреждения только для способностей на вашей стороне.",
	custom_select_limit_warnings_value1 = "Группы 1 и 2 идут налево, группы 3 и 4 направо.",
	custom_select_limit_warnings_value2 = "Нечётные группы налево, чётные направо.",
	custom_select_limit_warnings_value3 = "Показывать предупреждения для обеих сторон.",
	custom_select_limit_warnings_value4 = "Показывать предупреждения только для левой стороны.",
	custom_select_limit_warnings_value5 = "Показывать предупреждения только для правой стороны.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball = "Шар",
	ball_incoming = "Шар скоро - не дайте ему коснуться земли",
	ball_fail = "ПРОВАЛ - шар коснулся земли",
	tendrils = "Усики",
	tendrils_incoming = "УБЕГАЙТЕ, чтобы разорвать усики",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Удары",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Гнев", -- Short for Aura of Wrath
	execution_sentence = "Приговоры", -- Short for Execution Sentence
	executes_mythic = "Приговоры + уклонение",
	judgement_red = "Правосудие [К]", -- R for the Red icon.
	aura_of_devotion = "Благочестие", -- Short for Aura of Devotion
	judgement_blue = "Правосудие [С]", -- B for the Blue icon.
	aura_of_peace = "Мир", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Поглощения + приговоры",
	divine_toll_mythic = "Уклонение + поглощения",

	empowered_searing_radiance = "Усиленное обжигающее сияние",
	empowered_searing_radiance_desc = "Показывать таймер усиленного обжигающего сияния.",

	empowered_avengers_shield = "Усиленный щит мстителя",
	empowered_avengers_shield_desc = "Показывать таймер усиленного щита мстителя.",

	empowered_divine_storm = "Усиленная божественная буря",
	empowered_divine_storm_desc = "Показывать таймер усиленной божественной бури.",
	tornadoes = "Шторм", -- The renamed empowered Divine Storm

	empowered = "[У] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Обелиски",
	interrupting_tremor = "Прерывание",
	ravenous_abyss = "Выбежать",
	silverstrike_barrage = "Линии",
	cosmic_barrier = "Барьер",
	voidstalker_sting = "Жала",
	aspect_of_the_end = "Связи",
	devouring_cosmos = "След. платформа",
})
