local L = BigWigs:NewBossLocale("The Restless Cabal", "deDE")
if not L then return end
if L then
	L.absorb = "Absorbtion"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.bubble = "Blase" -- Custody of the Deep Bubble
	L.cast = "Zauber"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"
end

L = BigWigs:NewBossLocale("Uu'nat, Harbinger of the Void", "deDE")
if L then
	L.custom_on_stop_timers = "Fähigkeiten-Leisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Uunat kann einige seiner Fähigkeiten verzögern. Durch Aktivieren dieser Option werden die Leisten dieser Fähigkeiten weiterhin angezeigt."

	L.absorb = "Absorbtion"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.bubble = "Blase" -- Custody of the Deep Bubble
	L.cast = "Zauber"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.void = "Leere" -- Unstable Resonance: Void
	L.ocean = "Ozean" -- Unstable Resonance: Ocean
	L.storm = "Sturm" -- Unstable Resonance: Storm

	L.custom_on_repeating_resonance_yell = "Relikte der Macht-Schrei wiederholen"
	L.custom_on_repeating_resonance_yell_desc = "Wiederholt das Ausschreien Deines Reliktes während Instabiler Resonanz."

	L.custom_off_repeating_resonance_say = "Instabile Resonanz-Ansage wiederholen"
	L.custom_off_repeating_resonance_say_desc = "Wiederholt die Symbole {rt3}{rt5}{rt6} (Leere, Ozean und Sturm) im Chat, um diesen während Instabiler Resonanz auszuweichen."
end
