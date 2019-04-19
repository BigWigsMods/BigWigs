local L = BigWigs:NewBossLocale("The Restless Cabal", "zhTW")
if not L then return end
if L then
	L.custom_off_eldritch_marker = "異法畸怪標記"
	L.custom_off_eldritch_marker_desc = "使用 {rt3}{rt4}{rt5} 標記異法畸怪，需要權限。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhTW")
if L then
	--L.custom_off_mindbender_marker = "Primordial Mindbender Marker"
	--L.custom_off_mindbender_marker_desc = "Mark Primordial Mindbender with {rt1}{rt2}{rt3}."
end
