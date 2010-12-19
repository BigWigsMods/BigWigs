local L = BigWigs:NewBossLocale("Atramedes", "frFR")
if L then
	L.tracking_me = "Pistage sur moi !"

	L.ancientDwarvenShield = "Ancien bouclier nain"
	L.ancientDwarvenShield_desc = "Indique le nombre d'anciens boucliers nains restants."
	L.ancientDwarvenShieldLeft = "%d Ancien(s) bouclier(s) nain(s) restant(s)"

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

	L.you = "%s sur vous !"

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

	L.chromatic_prototype = "Prototype chromatique" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "frFR")
if L then
	L.nef = "Seigneur Victor Nefarius"
	L.nef_desc = "Prévient quand le Seigneur Victor Nefarius utilise une technique."
	L.switch = "Changement"
	L.switch_desc = "Prévient de l'arrivée des changements."

	L.next_switch = "Prochain changement"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you." -- récupérer transcription
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?" -- récupérer transcription

	L.nef_next = "~Prochain buff de technique"

	L.acquiring_target = "Acquisition d'une cible"

	L.cloud_message = "Nuage chimique sur vous !"
end
