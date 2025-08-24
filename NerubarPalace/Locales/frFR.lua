local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "frFR")
if not L then return end
if L then
	L.carnivorous_contest_pull = "Attraction"
	L.chunky_viscera_message = "Nourrissez le boss ! (Bouton d'action spécial)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "frFR")
if L then
	L.gruesome_disgorge_debuff = "Déphasage"
	L.grasp_from_beyond = "Tentacule"
	L.grasp_from_beyond_say = "Tentacules"
	L.bloodcurdle = "Écartez-vous"
	L.bloodcurdle_on_you = "Écartez-vous" -- Singular of Spread
	L.goresplatter = "Courez"
end

L = BigWigs:NewBossLocale("Rasha'nan", "frFR")
if L then
	L.spinnerets_strands = "Brins"
	L.enveloping_webs = "Toiles"
	L.enveloping_web_say = "Toile" -- Singular of Webs
	L.erosive_spray = "Écartez-vous"
	L.caustic_hail = "Prochaine position"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "frFR")
if L then
	L.sticky_web = "Toile"
	L.sticky_web_say = "Toiles" -- Singular of Webs
	L.infest_message = "Lance Infester sur vous !"
	L.infest_say = "Parasites"
	L.experimental_dosage = "Éclosion d'œufs"
	L.experimental_dosage_say = "Casseur d'œufs"
	L.ingest_black_blood = "Prochain conteneur"
	L.unstable_infusion = "Tourbillons"

	L.custom_on_experimental_dosage_marks = "Assignements Dosage expérimental"
	L.custom_on_experimental_dosage_marks_desc = "Assigne des joueurs affectés par 'Dosage expérimental' à {rt6}{rt4}{rt3}{rt7} avec un priorité mélée > distant > soigneur. Affecte les messages dire et cible."

	L.volatile_concoction_explosion_desc = "Affiche une barre pour l'affaiblissement Décoction volatile."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "frFR")
if L then
	L.assasination = "Fantômes"
	L.twiligt_massacre = "Dashes"
	L.nexus_daggers = "Dagues"
end

L = BigWigs:NewBossLocale("The Silken Court", "frFR")
if L then
	L.skipped_cast = "Incantation passée %s (%d)"
	L.intermission_trigger = "Le pic de la puissance !" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "Pluie"
	L.burrowed_eruption = "Enfouissement"
	L.stinging_swarm = "Dispel debuffs"
	L.strands_of_reality = "Frontal Takazj" -- S for Skeinspinner Takazj
	L.strands_of_reality_message = "Frontal Takazj"
	L.impaling_eruption = "Frontal Anub'arash" -- A for Anub'arash
	L.impaling_eruption_message = "Frontal Anub'arash"
	L.entropic_desolation = "S'enfuir"
	L.cataclysmic_entropy = "Grosse explosion" -- Interrupt before it casts
	L.spike_eruption = "Pointes"
	L.unleashed_swarm = "Essaim"
	L.void_degeneration = "Orbe bleu"
	L.burning_rage = "Orbe rouge"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "frFR")
if L then
	L.stacks_onboss = "%dx %s sur le Boss"

	L.reactive_toxin = "Toxines"
	L.reactive_toxin_say = "Toxine"
	L.venom_nova = "Nova"
	L.web_blades = "Lames"
	L.silken_tomb = "Immobilisation" -- Raid being rooted in place
	L.wrest = "Attraction"
	L.royal_condemnation = "Entraves"
	L.frothing_gluttony = "Anneau"

	L.stage_two_end_message_storymode = "Courez vers le portail"
end
