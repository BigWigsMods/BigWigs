local L = BigWigs:NewBossLocale("The Restless Cabal", "zhTW")
if not L then return end
if L then
	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "泡泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhTW")
if L then
	L.custom_on_stop_timers = "總是顯示計時器"
	L.custom_on_stop_timers_desc = "烏納特的某些技能可能延遲施放。 啟用此選項後，這些技能的計時條會保持顯示。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "泡泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.void = "虛無" -- Unstable Resonance: Void
	L.ocean = "海洋" -- Unstable Resonance: Ocean
	L.storm = "風暴" -- Unstable Resonance: Storm

	L.custom_on_repeating_resonance_yell = "重複力量聖物的喊話"
	L.custom_on_repeating_resonance_yell_desc = "在不穩定共鳴的期間，每秒重複喊話你所持有的聖物。"

	L.custom_off_repeating_resonance_say = "重複不穩定共鳴的喊話"
	L.custom_off_repeating_resonance_say_desc = "在不穩定共鳴的期間，每秒重複喊話 {rt3}{rt5}{rt6} 標記（虛無、海洋以及風暴）。"
end
