if not BigWigsAPI.IsLocale("ruRU") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	infused_quills = "Перья",
	voidlight_convergence = "Смена цветов",
	light_void_dive = "Прыжок Свет/Бездна",
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
