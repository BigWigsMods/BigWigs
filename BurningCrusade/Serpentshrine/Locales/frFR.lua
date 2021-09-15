local L = BigWigs:NewBossLocale("Hydross the Unstable", "frFR")
if not L then return end
if L then
	L.start_trigger = "Je ne peux pas vous laisser nous gêner !"

	L.mark = "Marque"
	L.mark_desc = "Affiche les alertes et les compteurs des marques."

	L.stance = "Changements d'état"
	L.stance_desc = "Prévient quand Hydross l'Instable change d'état."
	L.poison_stance = "Hydross est maintenant empoisonné !"
	L.water_stance = "Hydross est de nouveau sain !"

	L.debuff_warn = "Marque à %s%% !"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "frFR")
if L then
	L.enrage_trigger = "Gardes, en position ! Nous avons de la visite…"

	L.totem = "Totem crache-feu"
	L.totem_desc = "Prévient quand un Totem crache-feu est posé et indique son possesseur."
	L.totem_message1 = "Marevess : Totem crache-feu"
	L.totem_message2 = "Karathress : Totem crache-feu"
	L.heal_message = "Caribdis incante un soin !"

	L.priest = "Garde-fonds Caribdis"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "frFR")
if L then
	L.enrage_trigger = "Enfin, mon exil s'achève !"

	L.phase = "Phase démon"
	L.phase_desc = "Affiche une estimation de la phase démon."
	L.phase_trigger = "Hors d'ici, elfe insignifiant. Je prends le contrôle !"
	L.phase_demon = "Phase démon pendant 60 sec."
	L.phase_demonsoon = "Phase démon dans 5 sec. !"
	L.phase_normalsoon = "Phase normal dans 5 sec."
	L.phase_normal = "Phase normale !"
	L.demon_bar = "Phase démon"
	L.demon_nextbar = "Prochaine phase démon"

	L.mindcontrol = "Contrôle mental"
	L.mindcontrol_desc = "Prévient quand un joueur subit les effets du Contrôle mental."
	L.mindcontrol_warning = "Contrôle mental"

	L.image = "Image"
	L.image_desc = "Prévient quand l'image est créée à 15%."
	L.image_trigger = "Non… Non ! Mais qu'avez-vous fait ? C'est moi le maître ! Vous entendez ? Moi ! Je suis… Aaargh ! Impossible… de… retenir…"
	L.image_message = "15% - Image créée !"
	L.image_warning = "Image imminente !"

	L.whisper = "Murmure insidieux"
	L.whisper_desc = "Prévient quand des joueurs subissent le Murmure insidieux."
	L.whisper_message = "Démon"
	L.whisper_bar = "Disparition des démons"
	L.whisper_soon = "~Recharge Démons"
end

L = BigWigs:NewBossLocale("The Lurker Below", "frFR")
if L then
	L.engage_warning = "%s engagé - Plongée probable dans 90 sec."

	L.dive = "Plongées"
	L.dive_desc = "Délais avant que Le Rôdeur d'En-bas ne plonge."
	L.dive_warning = "Plongée probable dans %d sec. !"
	L.dive_bar = "~Plongée"
	L.dive_message = "Plongée - De retour dans 60 sec."

	L.spout = "Jet"
	L.spout_desc = "Délais concernant les Jets. Pas toujours précis."
	L.spout_message = "Incante un Jet !"
	L.spout_warning = "Jet probable dans ~3 sec. !"
	L.spout_bar = "Jet probable"

	L.emerge_warning = "De retour dans %d sec."
	L.emerge_message = "De retour - Plongée probable dans 90 sec."
	L.emerge_bar = "De retour dans"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "frFR")
if L then
	L.grave_bar = "<Tombeaux aquatique>"
	L.grave_nextbar = "~Recharge Tombeaux"

	L.murloc = "Murlocs"
	L.murloc_desc = "Prévient de l'arrivée des murlocs."
	L.murloc_bar = "~Recharge Murlocs"
	L.murloc_message = "Arrivée des murlocs !"
	L.murloc_soon_message = "Murlocs imminent !"
	L.murloc_engaged = "%s engagé, murlocs dans ~40 sec."

	L.globules = "Globules"
	L.globules_desc = "Prévient de l'arrivée des globules."
	L.globules_trigger1 = "Bientôt, ce sera terminé."
	L.globules_trigger2 = "Il est impossible de m'échapper !"
	L.globules_message = "Arrivée des globules !"
	L.globules_warning = "Globules imminent !"
	L.globules_bar = "Disparation des globules"
end

L = BigWigs:NewBossLocale("Lady Vashj", "frFR")
if L then
	L.engage_trigger1 = "J'espérais ne pas devoir m'abaisser à affronter des créatures de la surface, mais vous ne me laissez pas le choix..."
	L.engage_trigger2 = "Je te crache dessus, racaille de la surface !"
	L.engage_trigger3 = "Victoire au seigneur Illidan !"
	L.engage_trigger4 = "Je vais te déchirer de part en part !"
	L.engage_trigger5 = "Mort aux étrangers !"
	L.engage_message = "Début de la phase 1"

	L.phase = "Phases"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."
	L.phase2_trigger = "L'heure est venue ! N'épargnez personne !"
	L.phase2_soon_message = "Phase 2 imminente !"
	L.phase2_message = "Phase 2, arrivée des renforts !"
	L.phase3_trigger = "Il faudrait peut-être vous mettre à l'abri."
	L.phase3_message = "Phase 3 - Enrager dans 4 min. !"

	L.elemental = "Elémentaires souillés"
	L.elemental_desc = "Prévient quand les Elémentaires souillés apparaissent durant la phase 2."
	L.elemental_bar = "Prochain élémentaire souillé"
	L.elemental_soon_message = "Elémentaire souillé imminent !"

	L.strider = "Trotteurs de Glissecroc"
	L.strider_desc = "Prévient quand les Trotteurs de Glissecroc apparaissent durant la phase 2."
	L.strider_bar = "Prochain trotteur"
	L.strider_soon_message = "Trotteur imminent !"

	L.naga = "Nagas élites de Glissecroc"
	L.naga_desc = "Prévient quand les Nagas élites de Glissecroc apparaissent durant la phase 2."
	L.naga_bar = "Prochain naga"
	L.naga_soon_message = "Naga imminent !"

	L.barrier_desc = "Prévient quand les barrières se dissipent."
	L.barrier_down_message = "Barrière %d/4 dissipée !"
end

