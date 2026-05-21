if not BigWigsAPI.IsLocale("frFR") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	quills = "Pennes",
	color_swaps = "Changements de couleur",
	["1241292"] = "Plongeon Lumineux / Vide",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Jeu de mémoire",
	heavens_glaives = "Glaives",
	heavens_lance = "Lance",
	the_dark_archangel = "Gros Boom",
	prism_kicks = "Kicks",
	dark_constellation = "Étoiles",
	dark_rune_bar = "Résoudre le Jeu",

	left = "[G] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mythique] Restreindre les avertissements de P3",
	custom_select_limit_warnings_desc = "N'afficher que les avertissements de sorts de votre côté.",
	custom_select_limit_warnings_value1 = "Groupes 1 & 2 à gauche, groupes 3 & 4 à droite.",
	custom_select_limit_warnings_value2 = "Groupes impaires à gauche, groupes paires à droite.",
	custom_select_limit_warnings_value3 = "Afficher les avertissements des deux côtés.",
	custom_select_limit_warnings_value4 = "N'afficher que les avertissements du côté gauche.",
	custom_select_limit_warnings_value5 = "N'afficher que les avertissements du côté droit.",
})
