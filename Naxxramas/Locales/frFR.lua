local L = BigWigs:NewBossLocale("Anub'Rekhan", "frFR")
if not L then return end
if L then
	L.bossName = "Anub'Rekhan"

	L.gainwarn10sec = "~10 sec. avant la Nuée de sauterelles"
	L.gainincbar = "~Prochaine Nuée"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "frFR")
if L then
	L.bossName = "Grande veuve Faerlina"

	L.silencewarn = "Réduite au silence !"
	L.silencewarn5sec = "Fin du silence dans 5 sec."
end

L = BigWigs:NewBossLocale("Gluth", "frFR")
if L then
	L.bossName = "Gluth"

	L.startwarn = "Gluth engagé ! ~105 sec. avant Décimer !"

	L.decimate_bar = "Prochain Décimer"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "frFR")
if L then
	L.bossName = "Gothik le Moissonneur"

	L.room = "Arrivée dans la salle"
	L.room_desc = "Prévient quand Gothik arrive dans la salle."

	L.add = "Arrivée des renforts"
	L.add_desc = "Prévient quand des renforts se joignent au combat."

	L.adddeath = "Mort des renforts"
	L.adddeath_desc = "Prévient quand un des renforts meurt."

	L.starttrigger1 = "Dans votre folie, vous avez provoqué votre propre mort."
	L.starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun"
	L.startwarn = "Gothik le moissonneur engagé ! 4 min. 30 sec. avant son arrivée dans la salle !"

	L.rider = "Cavalier tenace"
	L.spectral_rider = "Cavalier spectral"
	L.deathknight = "Chevalier de la mort tenace"
	L.spectral_deathknight = "Chevalier de la mort spectral"
	L.trainee = "Jeune recrue tenace"
	L.spectral_trainee = "Jeune recrue spectral"

	L.riderdiewarn = "Cavalier éliminé !"
	L.dkdiewarn = "Chevalier éliminé !"

	L.warn1 = "Dans la salle dans 3 min."
	L.warn2 = "Dans la salle dans 90 sec."
	L.warn3 = "Dans la salle dans 60 sec."
	L.warn4 = "Dans la salle dans 30 sec."
	L.warn5 = "Arrivée de Gothik dans 10 sec."

	L.wave = "%d/23 : %s"

	L.trawarn = "Jeune recrue dans 3 sec."
	L.dkwarn = "Chevalier de la mort dans 3 sec."
	L.riderwarn = "Cavalier dans 3 sec."

	L.trabar = "Jeune recrue - %d"
	L.dkbar = "Chevalier de la mort - %d"
	L.riderbar = "Cavalier - %d"

	L.inroomtrigger = "J'ai attendu assez longtemps. Maintenant, vous affrontez le moissonneur d'âmes."
	L.inroomwarn = "Il est dans la salle !"

	L.inroombartext = "Dans la salle"
end

L = BigWigs:NewBossLocale("Grobbulus", "frFR")
if L then
	L.bossName = "Grobbulus"

	L.bomb_message = "Injection"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "frFR")
if L then
	L.bossName = "Heigan l'Impur"

	L.starttrigger = "Vous êtes à moi, maintenant."
	L.starttrigger2 = "Tu es… le suivant."
	L.starttrigger3 = "Je vous vois…"

	L.engage = "Engagement"
	L.engage_desc = "Prévient quand Heigan est engagé."
	L.engage_message = "Heigan l'Impur engagé ! 90 sec. avant téléportation !"

	L.teleport = "Téléportation"
	L.teleport_desc = "Prévient quand Heigan se téléporte."
	L.teleport_trigger = "Votre fin est venue."
	L.teleport_1min_message = "Téléportation dans 1 min."
	L.teleport_30sec_message = "Téléportation dans 30 sec."
	L.teleport_10sec_message = "Téléportation dans 10 sec. !"
	L.on_platform_message = "Téléportation ! Sur la plate-forme pendant 45 sec. !"

	L.to_floor_30sec_message = "De retour dans 30 sec."
	L.to_floor_10sec_message = "De retour dans 10 sec. !"
	L.on_floor_message = "De retour sur le sol ! 90 sec. avant la prochaine téléportation !"

	L.teleport_bar = "Téléportation !"
	L.back_bar = "Retour sur le sol !"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "frFR")
if L then
	L.bossName = "Les quatre cavaliers"

	L.mark = "Marque"
	L.mark_desc = "Prévient de l'arrivée des marques."

	L.markbar = "Marque %d"
	L.markwarn1 = "Marque %d !"
	L.markwarn2 = "Marque %d dans 5 sec."

	L.startwarn = "Les 4 cavaliers engagés ! Marque dans ~17 sec. !"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "frFR")
if L then
	L.bossName = "Kel'Thuzad"
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Appartements de Kel'Thuzad"

	L.start_trigger = "Serviteurs, valets et soldats des ténèbres glaciales ! Répondez à l'appel de Kel'Thuzad !"
	L.start_warning = "Kel'Thuzad engagé ! ~3 min. 30 sec. avant qu'il ne soit actif !"

	L.phase2_trigger1 = "Faites vos prières !"
	L.phase2_trigger2 = "Hurlez et expirez !"
	L.phase2_trigger3 = "Votre fin est proche !"
	L.phase2_warning = "Phase 2, arrivée de Kel'Thuzad !"
	L.phase2_bar = "Kel'Thuzad actif !"

	L.phase3_trigger = "Maître, j'ai besoin d'aide !"
	L.phase3_soon_warning = "Phase 3 imminente !"
	L.phase3_warning = "Phase 3, gardiens dans ~15 sec. !"

	L.guardians = "Apparition des gardiens"
	L.guardians_desc = "Prévient de l'arrivée des gardiens en phase 3."
	L.guardians_trigger = "Très bien. Guerriers des terres gelées, relevez-vous ! Je vous ordonne de combattre, de tuer et de mourir pour votre maître ! N'épargnez personne !"
	L.guardians_warning = "Arrivée des gardiens dans ~10 sec. !"
	L.guardians_bar = "Arrivée des gardiens !"
end

L = BigWigs:NewBossLocale("Loatheb", "frFR")
if L then
	L.bossName = "Horreb"

	L.startwarn = "Horreb engagé ! 2 min. avant la 1ère Malédiction inévitable !"

	L.doom_5sec_warn = "Malédiction inévitable %d dans 5 sec. !"
	L.doomtime_bar = "Malé. toutes les 15 sec."
	L.doomtime_warn = "Changement du délai des malédictions dans %s sec. !"
	L.doomtime_now = "La Malédiction inévitable arrive désormais toutes les 15 sec. !"

	L.remove_curse = "Malédictions enlevées sur Loatheb"

	L.spore_warn = "Spore %d invoquée"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "frFR")
if L then
	L.bossName = "Noth le Porte-Peste"

	L.starttrigger1 = "Mourez, intrus !"
	L.starttrigger2 = "Gloire au maître !"
	L.starttrigger3 = "Vos vies ne valent plus rien !"
	L.startwarn = "Noth le Porte-peste engagé ! 90 sec. avant téléportation !"
	L.add_trigger = "Levez-vous, soldats ! Levez-vous et combattez une fois encore !"

	L.blink = "Transfert"
	L.blink_desc = "Prévient quand Noth utilise son Transfert."
	L.blink_trigger = "%s se transfère au loin !"
	L.blink_bar = "Transfert"

	L.teleport = "Téléportation"
	L.teleport_desc = "Prévient quand Noth se téléporte."
	L.teleport_bar = "Téléportation"
	L.teleportwarn = "Téléportation ! Il est sur le balcon !"
	L.teleportwarn2 = "Téléportation dans 10 sec. !"
	L.back_bar = "Retour dans la salle !"
	L.back_warn = "De retour dans la salle pendant %d sec. !"
	L.back_warn2 = "10 sec. avant son retour dans la salle !"

	L.curse_explosion = "Explosion des malé. !"
	L.curse_warn = "Malédictions ! Prochaines dans ~55 sec."
	L.curse_10sec_warn = "Malédictions dans ~10 sec."
	L.curse_bar = "Prochaines malédictions"

	L.wave = "Vagues"
	L.wave_desc = "Prévient de l'arrivée des vagues."
	L.wave1_bar = "1ère vague"
	L.wave2_bar = "2ème vague"
	L.wave2_message = "2ème vague dans 10 sec."
end

L = BigWigs:NewBossLocale("Patchwerk", "frFR")
if L then
	L.bossName = "Le Recousu"
end

L = BigWigs:NewBossLocale("Maexxna", "frFR")
if L then
	L.bossName = "Maexxna"

	L.webspraywarn30sec = "Entoilage dans 10 sec."
	L.webspraywarn20sec = "Entoilage ! 10 sec. avant les araignées !"
	L.webspraywarn10sec = "Araignées ! 10 sec. avant le Jet de rets !"
	L.webspraywarn5sec = "Jet de rets dans 5 sec. !"
	L.enragewarn = "Frénésie !"
	L.enragesoonwarn = "Frénésie imminente !"

	L.cocoonbar = "Entoilage"
	L.spiderbar = "Araignées"
end

L = BigWigs:NewBossLocale("Sapphiron", "frFR")
if L then
	L.bossName = "Saphiron"

	L.deepbreath_trigger = "%s prend une grande inspiration…"

	-- L.air_phase = "Air phase"
	-- L.ground_phase = "Ground phase"

	L.deepbreath = "Bombe de glace"
	L.deepbreath_warning = "Arrivée d'une Bombe de glace !"
	L.deepbreath_bar = "Impact Bombe de glace "

	L.icebolt_say = "Je suis un bloc !"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "frFR")
if L then
	L.bossName = "Instructeur Razuvious"
	L.understudy = "Doublure de chevalier de la mort"

	L.taunt_warning = "Provocation prête dans 5 sec. !"
	L.shieldwall_warning = "Barrière d'os terminée dans 5 sec. !"
end

L = BigWigs:NewBossLocale("Thaddius", "frFR")
if L then
	L.bossName = "Thaddius"

	L.trigger_phase1_1 = "Stalagg écraser toi !"
	L.trigger_phase1_2 = "À manger pour maître !"
	L.trigger_phase2_1 = "Manger… tes… os…"
	L.trigger_phase2_2 = "Casser... toi !"
	L.trigger_phase2_3 = "Tuer…"

	L.polarity_trigger = "Maintenant toi sentir douleur..."

	L.polarity_warning = "3 sec. avant Changement de polarité !"
	L.polarity_changed = "La polarité a changé !"
	L.polarity_nochange = "Même polarité !"
	L.polarity_first_positive = "Vous êtes POSITIF !"
	L.polarity_first_negative = "Vous êtes NÉGATIF !"

	L.phase1_message = "Phase 1"
	L.phase2_message = "Phase 2 - Berserk dans 5 min. !"

	L.throw = "Lancer"
	L.throw_desc = "Prévient quand les tanks sont lancés d'une plate-forme à l'autre."
	L.throw_warning = "Lancer dans ~5 sec. !"

	-- L.polarity_extras = "Additional alerts for Polarity positioning. Only enable one strategy!"

	-- L.custom_off_charge_RL = "Strategy 1"
	-- L.custom_off_charge_RL_desc = "|cffff2020Negative (-)|r are LEFT, |cff2020ffPositive (+)|r are RIGHT. Start in front of the boss."
	-- L.custom_off_charge_LR = "Strategy 2"
	-- L.custom_off_charge_LR_desc = "|cff2020ffPositive (+)|r are LEFT, |cffff2020Negative (-)|r are RIGHT. Start in front of the boss."

	-- L.custom_off_charge_text = "Text arrows"
	-- L.custom_off_charge_text_desc = "Show an additional message with the direction to move when Polarity Shift happens."
	-- L.custom_off_charge_voice = "Voice alerts"
	-- L.custom_off_charge_voice_desc = "Play a speech sound when Polarity Shift happens."

	-- L.warn_left = "<--- GO LEFT <--- GO LEFT <---"
	-- L.warn_right = "---> GO RIGHT ---> GO RIGHT --->"
	-- L.warn_swap = "^^^^ SWITCH SIDES ^^^^ SWITCH SIDES ^^^^"
	-- L.warn_stay = "==== DON'T MOVE ==== DON'T MOVE ===="
end
