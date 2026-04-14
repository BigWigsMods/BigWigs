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
	--L.the_dark_archangel = "Big Boom"
	--L.prism_kicks = "Kicks"
	--L.dark_constellation = "Stars"
	--L.dark_rune = "Memory Mark"
	--L.dark_rune_bar = "Solve the Game"

	--L.starsplinter = "Blazes" -- Mythic intermission and P4 bar text
	--L.starsplinter_you = "Blaze"

	--L.left = "[L] %s" -- left/west group bars in p3
	--L.right = "[R] %s" -- right/east group bars in p3

	--L.custom_select_limit_warnings = "[Mythic] Restrict Stage 3 Warnings"
	--L.custom_select_limit_warnings_desc = "Only show warnings for abilities on your side."
	--L.custom_select_limit_warnings_value1 = "Groups 1 & 2 go left, groups 3 & 4 go right."
	--L.custom_select_limit_warnings_value2 = "Odd groups left, even groups right."
	--L.custom_select_limit_warnings_value3 = "Show warnings for both sides."
	--L.custom_select_limit_warnings_value4 = "Show warnings for left side only."
	--L.custom_select_limit_warnings_value5 = "Show warnings for right side only."
end
