local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "deDE")
if not L then return end
if L then
	L.chunky_viscera_message = "Boss füttern! (Spezialaktionsbutton)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "deDE")
if L then
	L.grasp_from_beyond = "Tentakel"
	L.grasp_from_beyond_say = "Tentakel"
	L.bloodcurdle = "Verteilen"
	L.bloodcurdle_on_you = "Verteilen" -- Singular of Spread
	L.goresplatter = "Weglaufen"
end

L = BigWigs:NewBossLocale("Rasha'nan", "deDE")
if L then
	L.rolling_acid = "Wellen"
	L.spinnerets_strands = "Stränge"
	L.enveloping_webs = "Gespinste"
	L.enveloping_web_say = "Gespinst" -- Singular of Webs
	L.erosive_spray = "Spucke"
	L.caustic_hail = "Nächste Position"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "deDE")
if L then
	L.sticky_web = "Netze"
	L.sticky_web_say = "Netz" -- Singular of Webs
	L.infest_message = "Wirkt Infizieren auf DICH!"
	L.infest_say = "Parasiten"
	L.experimental_dosage = "Ei schlüpft"
	L.experimental_dosage_say = "Ei schlüpft"
	L.ingest_black_blood = "Nächster Kanister"
	L.unstable_infusion = "Wirbel"

	L.custom_on_experimental_dosage_marks = "Experimentelle Dosierung Zuweisungen"
	L.custom_on_experimental_dosage_marks_desc = "Weist den von 'Experimentelle Dosierung' betroffenen Spielern {rt6}{rt4}{rt3}{rt7} mit der Priorität Nahkampf > Fernkampf > Heiler zu. Betrifft Sagen- und Ziel-Nachrichten."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "deDE")
if L then
	L.assasination = "Phantome"
	L.twiligt_massacre = "Rennen"
	L.nexus_daggers = "Dolche"
end

L = BigWigs:NewBossLocale("The Silken Court", "deDE")
if L then
	L.skipped_cast = "%s (%d) übersprungen"

	L.venomous_rain = "Regen"
	L.burrowed_eruption = "Eingraben"
	L.stinging_swarm = "Debuffs entfernen"
	L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	L.entropic_desolation = "Rausrennen"
	L.cataclysmic_entropy = "Großer Knall" -- Interrupt before it casts
	L.spike_eruption = "Stacheln"
	L.unleashed_swarm = "Schwarm"
end



