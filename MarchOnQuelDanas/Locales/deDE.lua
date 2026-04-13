local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "deDE")
if not L then return end
if L then
	L.infused_quills = "Federkiele"
	L.voidlight_convergence = "Farbwechsel"
	L.light_void_dive = "Licht/Leerensturz"
end

L = BigWigs:NewBossLocale("Midnight Falls", "deDE")
if L then
	L.deaths_dirge = "Memory Spiel"
	L.heavens_glaives = "Gleven"
	L.heavens_lance = "Lanze"
	L.the_dark_archangel = "Großer Knall"
	L.prism_kicks = "Unterbrechungen"
	L.dark_constellation = "Sterne"
	L.dark_rune = "Memory Markierung"
	L.dark_rune_bar = "Löse das Spiel"

	L.starsplinter = "Brände" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "Brand"

	L.left = "[L] %s" -- left/west group bars in p3
	L.right = "[R] %s" -- right/east group bars in p3

	--L.custom_on_limit_warnings = "Restrict Stage Three Warnings (Mythic)"
	--L.custom_on_limit_warnings_desc = "Only show warnings for abilities on your side of the room in Stage Three.  Group 1/2 is on left, Group 3/4 is on right."
end
