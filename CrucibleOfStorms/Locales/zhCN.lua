local L = BigWigs:NewBossLocale("The Restless Cabal", "zhCN")
if not L then return end
if L then
	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "泡泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhCN")
if L then
	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "乌纳特的某些技能可能推迟施放。当此选项启用，这些技能条将总是显示在屏幕上。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "泡泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.void = "虚无" -- Unstable Resonance: Void
	L.ocean = "海洋" -- Unstable Resonance: Ocean
	L.storm = "风暴" -- Unstable Resonance: Storm
	L.custom_on_repeating_resonance_say = "重复动荡共鸣喊话"
	L.custom_on_repeating_resonance_say_desc = "在动荡共鸣期间，重复喊话 {rt3}{rt5}{rt6} 标记（虚无、海洋以及风暴）。"
end
