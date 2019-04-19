local L = BigWigs:NewBossLocale("The Restless Cabal", "deDE")
if not L then return end
if L then
	L.custom_off_eldritch_marker = "Unheimliche Monstrositäten markieren"
	L.custom_off_eldritch_marker_desc = "Markiert Unheimliche Monstrositäten mit {rt3}{rt4}{rt5}."

	L.absorb = "Absorbtion"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "deDE")
if L then
	L.custom_off_mindbender_marker = "Urzeitliche Geistbeuger markieren"
	L.custom_off_mindbender_marker_desc = "Markiert Urzeitliche Geistbeuger mit {rt1}{rt2}{rt3}."
end
