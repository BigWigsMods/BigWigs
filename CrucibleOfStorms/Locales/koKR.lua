local L = BigWigs:NewBossLocale("The Restless Cabal", "koKR")
if not L then return end
if L then
	L.absorb = "피해 흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.bubble = "Bubble" -- Custody of the Deep Bubble
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "koKR")
if L then
	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Uunat can delay some of his abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.absorb = "피해 흡수"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.bubble = "Bubble" -- Custody of the Deep Bubble
	L.cast = "시전"
	L.cast_text = "%.1f초 (|cff%s%.0f%%|r)"

	--L.void = "Void" -- Unstable Resonance: Void
	--L.ocean = "Ocean" -- Unstable Resonance: Ocean
	--L.storm = "Storm" -- Unstable Resonance: Storm

	--L.custom_on_repeating_resonance_yell = "Repeating Relics of Power Yell"
	--L.custom_on_repeating_resonance_yell_desc = "Spam a yell stating which relic you are holding during Unstable Resonance."

	--L.custom_off_repeating_resonance_say = "Repeating Unstable Resonance Say"
	--L.custom_off_repeating_resonance_say_desc = "Spam the icons {rt3}{rt5}{rt6} (Void, Ocean and Storm) in say chat to be avoided during Unstable Resonance."
end
