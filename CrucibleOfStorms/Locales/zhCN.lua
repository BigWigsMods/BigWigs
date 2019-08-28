local L = BigWigs:NewBossLocale("The Restless Cabal", "zhCN")
if not L then return end
if L then
	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "气泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "zhCN")
if L then
	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "乌纳特某些技能可能延迟施放。 当此选项启用，这些技能条将保留在屏幕上。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.bubble = "气泡" -- Custody of the Deep Bubble
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.void = "虚空" -- Unstable Resonance: Void
	L.ocean = "海洋" -- Unstable Resonance: Ocean
	L.storm = "风暴" -- Unstable Resonance: Storm

	L.custom_on_repeating_resonance_yell = "重复能量圣物喊话"
	L.custom_on_repeating_resonance_yell_desc = "当动荡共鸣期间时持有能量圣物时重复喊话。"

	L.custom_off_repeating_resonance_say = "重复动荡共鸣喊话"
	L.custom_off_repeating_resonance_say_desc = "在聊天中重复喊话 {rt3}{rt5}{rt6}（虚空、海洋和风暴）图标，以在动荡共鸣期间避免爆炸。"
end
