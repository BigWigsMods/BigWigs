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
	L.custom_on_stop_timers = "永遠顯示技能條"
	L.custom_on_stop_timers_desc = "烏納特可以延遲他的某些技能。 啟用此選項後，這些技能的計時條會保持顯示。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "泡泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.void = "虛無" -- Unstable Resonance: Void
	L.ocean = "海洋" -- Unstable Resonance: Ocean
	L.storm = "風暴" -- Unstable Resonance: Storm
	L.custom_on_repeating_resonance_say = "重複不穩定的共鳴喊話"
	L.custom_on_repeating_resonance_say_desc = "在不穩定的共鳴期間，避免重複發送圖示 {rt3}{rt5}{rt6} (虛無、海洋以及風暴) 在聊天中。"
end
