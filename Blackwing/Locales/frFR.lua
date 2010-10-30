local L = BigWigs:NewBossLocale("Atramedes", "frFR")
if L then
	L.ground_phase = "Phase au sol"
	L.ground_phase_desc = "Prévient quand Atramédès atterrit."
	L.air_phase = "Phase aérienne"
	L.air_phase_desc = "Prévient quand Atramédès décolle."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!" -- récupérer transcription

	L.sonicbreath_cooldown = "~Sonic Breath" -- pas encore traduit dans beta
end

L = BigWigs:NewBossLocale("Chimaeron", "frFR")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance." -- récupérer transcription
	L.engage = "Engagement"
	L.next_system_failure = "Prochain System Failure" -- pas encore traduit dans beta
	L.break_message = "%2$dx Break on %1$s" -- pas encore traduit dans beta

	L.warmup = "Échauffement"
	L.warmup_desc = "Minuteur de l'échauffement."
end

L = BigWigs:NewBossLocale("Magmaw", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Maloriak", "frFR")
if L then
	L.final_phase = "Phase finale"

	L.release_aberration_message = "%s aberration(s) restante(s)"
	L.release_all = "%s aberration(s) libérée(s)"

	L.bitingchill_say = "Frisson mordant sur moi !"

	L.flashfreeze = "~Gel instantané"
	L.consuming_flames = "Flammes consumantes sur VOUS !"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.next_phase = "Prochaine phase"

	L.red_phase_trigger = "Mix and stir, apply heat..." -- récupérer transcription
	L.red_phase = "Phase |cFFFF0000rouge|r"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!" -- récupérer transcription
	L.blue_phase = "Phase |cFF809FFEbleue|r"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?" -- récupérer transcription
	L.green_phase = "Phase |cFF33FF00verte|r"
end

L = BigWigs:NewBossLocale("Nefarian", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.phase_x = "Phase %d !"

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!" -- récupérer transcription

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name -- récupérer transcription
end

L = BigWigs:NewBossLocale("Omnitron Defense System", "frFR")
if L then
	L.acquiring_target = "Acquisition d'une cible"
	L.chemical_cloud_message = "Nuage chimique sur VOUS !"
end
