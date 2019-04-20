local L = BigWigs:NewBossLocale("The Restless Cabal", "zhCN")
if not L then return end
if L then
	L.custom_off_eldritch_marker = "恐怖的憎恶体标记"
	L.custom_off_eldritch_marker_desc = "使用 {rt3}{rt4}{rt5} 标记恐怖的憎恶体。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhCN")
if L then
	--L.custom_off_mindbender_marker = "Primordial Mindbender Marker"
	--L.custom_off_mindbender_marker_desc = "Mark Primordial Mindbender with {rt1}{rt2}{rt3}."
end
