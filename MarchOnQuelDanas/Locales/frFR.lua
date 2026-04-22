local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "frFR")
if not L then return end
if L then
	L.infused_quills = "Pennes"
	L.voidlight_convergence = "Changements de couleur"
	L.light_void_dive = "Plongeon Lumineux / Vide"
end

L = BigWigs:NewBossLocale("Midnight Falls", "frFR")
if L then
	L.deaths_dirge = "Jeu de mémoire"
	L.heavens_glaives = "Glaives"
	L.heavens_lance = "Lance"
	L.the_dark_archangel = "Gros Boom"
	L.prism_kicks = "Kicks"
	L.dark_constellation = "Étoiles"
	L.dark_rune = "Marques du Memory"
	L.dark_rune_bar = "Résoudre le Jeu"

	L.starsplinter = "Flamboiements" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "Flambe"

	L.left = "[G] %s" -- left/west group bars in p3
	L.right = "[D] %s" -- right/east group bars in p3

	L.custom_select_limit_warnings = "[Mythique] Restreindre les avertissements de P3"
	L.custom_select_limit_warnings_desc = "N'afficher que les avertissements de sorts de votre côté."
	L.custom_select_limit_warnings_value1 = "Groupes 1 & 2 à gauche, groupes 3 & 4 à droite."
	L.custom_select_limit_warnings_value2 = "Groupes impaires à gauche, groupes paires à droite."
	L.custom_select_limit_warnings_value3 = "Afficher les avertissements des deux côtés."
	L.custom_select_limit_warnings_value4 = "N'afficher que les avertissements du côté gauche."
	L.custom_select_limit_warnings_value5 = "N'afficher que les avertissements du côté droit."
end
