local L = BigWigs:NewBossLocale("The Restless Cabal", "koKR")
if not L then return end
if L then
	--L.custom_off_eldritch_marker = "Eldritch Abomination Marker"
	--L.custom_off_eldritch_marker_desc = "Mark Eldritch Abomination with {rt3}{rt4}{rt5}."

	L.absorb = "피해 흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "koKR")
if L then
	--L.custom_off_mindbender_marker = "Primordial Mindbender Marker"
	--L.custom_off_mindbender_marker_desc = "Mark Primordial Mindbender with {rt1}{rt2}{rt3}."
end
