local L = BigWigs:NewBossLocale("Atramedes", "frFR")
if L then
	L.ancientDwarvenShield = "Ancient Dwarven Shield" -- récupérer transcription
	L.ancientDwarvenShield_desc = "Warning for the remaining Ancient Dwarven Shields"
	L.ancientDwarvenShieldLeft = "%d Ancient Dwarven Shield left"

	L.ground_phase = "Phase au sol"
	L.ground_phase_desc = "Prévient quand Atramédès atterrit."
	L.air_phase = "Phase aérienne"
	L.air_phase_desc = "Prévient quand Atramédès décolle."

	L.air_phase_trigger = "Oui, fuyez ! Chaque foulée accélère votre cœur. Les battements résonnent, comme le tonnerre... Assourdissant. Vous ne vous échapperez pas !" -- à vérifier

	L.sonicbreath_cooldown = "~Souffle sonique"
end

L = BigWigs:NewBossLocale("Chimaeron", "frFR")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance." -- récupérer transcription

	L.next_system_failure = "Prochaine Défaillance"
	L.break_message = "%2$dx Brèche sur %1$s"

	L.warmup = "Échauffement"
	L.warmup_desc = "Minuteur de l'échauffement."
end

L = BigWigs:NewBossLocale("Magmaw", "frFR")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct"

	L.slump = "Affalement"
	L.slump_desc = "Prévient quand le boss s'affale vers l'avant et s'expose."

	L.slump_trigger = "%s s'affale vers l'avant et expose ses pinces !"
end

L = BigWigs:NewBossLocale("Maloriak", "frFR")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Prévient quand vous vous trouvez dans une %s."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Phase finale"

	L.release_aberration_message = "%s aberration(s) restante(s)"
	L.release_all = "%s aberration(s) libérée(s)"

	L.bitingchill_say = "Frisson mordant sur moi !"

	L.flashfreeze = "~Gel instantané"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.next_phase = "Prochaine phase"

	L.red_phase_trigger = "Mélanger et touiller, faire chauffer..." -- à vérifier
	L.red_phase = "Phase |cFFFF0000rouge|r"
	L.blue_phase_trigger = "Jusqu'où une enveloppe mortelle peut-elle supporter les écarts extrêmes de température ? Je dois trouver ! Pour la science !" -- à vérifier
	L.blue_phase = "Phase |cFF809FFEbleue|r"
	L.green_phase_trigger = "Celui-ci est un peu instable, mais que serai le progrès sans échec ?" -- à vérifier
	L.green_phase = "Phase |cFF33FF00verte|r"
	L.dark_phase = "Phase |cFF660099sombre|r"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!" -- récupérer transcription
end

L = BigWigs:NewBossLocale("Nefarian", "frFR")
if L then
	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.phase_two_trigger = "Soyez maudits, mortels ! Un tel mépris pour les possessions d'autrui doit être traîté avec une extrême fermeté !" -- à vérifier

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name -- récupérer transcription
end

L = BigWigs:NewBossLocale("Omnitron Defense System", "frFR")
if L then
	L.acquiring_target = "Acquisition d'une cible"
end
