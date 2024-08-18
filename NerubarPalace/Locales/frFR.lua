local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "frFR")
if not L then return end
if L then
	L.chunky_viscera_message = "Nourrissez le boss! (Bouton d'action spécial)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "frFR")
if L then
	L.grasp_from_beyond = "Tentacule"
	L.grasp_from_beyond_say = "Tentacules"
	L.bloodcurdle = "Écartez-vous"
	L.bloodcurdle_on_you = "Écartez-vous" -- Singular of Spread
	L.goresplatter = "Courez"
end

L = BigWigs:NewBossLocale("Rasha'nan", "frFR")
if L then
	L.rolling_acid = "Vagues"
	--L.spinnerets_strands = "Strands"
	L.enveloping_webs = "Toiles"
	L.enveloping_web_say = "Toile" -- Singular of Webs
	L.erosive_spray = "Écartez-vous"
	L.caustic_hail = "Prochaine position"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "frFR")
if L then
	--L.sticky_web = "Webs"
	L.sticky_web_say = "Toiles" -- Singular of Webs
	L.infest_message = "Lance Infester sur vous !"
	L.infest_say = "Parasites"
	--L.experimental_dosage = "Egg Breaks"
	--L.experimental_dosage_say = "Egg Break"
	--L.ingest_black_blood = "Next Container"
	L.unstable_infusion = "Tourbillons"

	L.custom_on_experimental_dosage_marks = "Assignements Dosage expérimental"
	L.custom_on_experimental_dosage_marks_desc = "Assigne des joueurs affectés par 'Dosage expérimental' à {rt6}{rt4}{rt3}{rt7} avec un priorité mélée > distant > soigneur. Affecte les messages dire et cible."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "frFR")
if L then
	L.assasination = "Fantômes"
	L.twiligt_massacre = "Dashes"
	L.nexus_daggers = "Dagues"
end

L = BigWigs:NewBossLocale("The Silken Court", "frFR")
if L then
	--L.skipped_cast = "Skipped %s (%d)"

	--L.venomous_rain = "Rain"
	--L.burrowed_eruption = "Burrow"
	--L.stinging_swarm = "Dispel Debuffs"
	--L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	--L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	--L.entropic_desolation = "Run Out"
	--L.cataclysmic_entropy = "Big Boom" -- Interrupt before it casts
	--L.spike_eruption = "Spikes"
	--L.unleashed_swarm = "Swarm"
end
