local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "frFR")
if not L then return end
if L then
	L.engage_yell = "La Divine a choisi de donner une voix mortelle à Sa divine volonté. Nous ne sommes que l'instrument qui promulge Sa volonté." -- à vérifier

	L.force_message = "Impulsion de zone"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (anneaux)"
	L.attenuation_bar = "Anneaux... dansez !"
	L.attenuation_message = "Danse |2 %s %s"
	L.echo = "|c001cc986l'Echo|r"
	L.zorlok = "|c00ed1ffaZor'lok|r"
	L.left = "|c00008000<- Gauche <-|r"
	L.right = "|c00FF0000-> Droite ->|r"

	L.platform_emote = "plateformes" -- Le vizir impérial Zor'lok s'envole vers l'une de ses plateformes !
	L.platform_emote_final = "inhale"-- Le vizir impérial Zor'lok inhale les Phéromones de zèle !
	L.platform_message = "Changement de plateforme"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "frFR")
if L then
	L.engage_yell = "Mettez-vous en garde, envahisseurs. Moi, Ta'yak, seigneur des Lames, je serai votre adversaire." -- à vérifier

	L.unseenstrike_soon = "Frappe (%d) dans ~5-10 sec !"
	L.assault_message = "Assauts"
	L.side_swap = "Changement de côté"

	L.custom_off_windstep = "Marquage Pas de vent"
	L.custom_off_windstep_desc = "Afin d'aider à l'attribution des soins, marque les joueurs affectés par Pas de vent avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Garalon", "frFR")
if L then
	L.phase2_trigger = "L'armure de plaques massive de Garalon commence à se fendiller !" -- à vérifier

	L.removed = "%s enlevé !"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "frFR")
if L then
	L.spear_removed = "Votre Lance de perforation a été enlevée !"

	L.mending_desc = "|cFFFF0000AVERTISSEMENT : seul le délai de votre cible de focalisation sera affiché étant donné que les Soigneurs de bataille zar’thik ont des temps de recharge de soins différents.|r "
	L.mending_warning = "Votre focalisation est en train d'incanter Guérison !"
	L.mending_bar = "Focalisation : Guérison"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "frFR")
if L then
	L.explosion_by_other = "Barre de temps de recharge d'Explosion d'ambre de la Monstruosité/de la focalisation"
	L.explosion_by_other_desc = "Alertes et barre de temps de recharge pour les Explosions d'ambre incantées par la Monstruosité d'ambre ou votre cible de focalisation."

	L.explosion_casting_by_other = "Barre d'incantion d'Explosion d'ambre de la Monstruosité/de la focalisation"
	L.explosion_casting_by_other_desc = "Alertes d'incantation pour les Explositions d'ambre initiés par la Monstruosité d'ambre ou votre cible de focalisation. Mettre en évidence ceci est fortement recommandé !"

	L.explosion_by_you = "Votre temps de recharge d'Explosion d'ambre"
	L.explosion_by_you_desc = "Alerte de temps de recharge pour vos Explosions d'ambre."
	L.explosion_by_you_bar = "Vous commencez à incanter..."

	L.explosion_casting_by_you = "Votre barre d'incantation d'Explosion d'ambre"
	L.explosion_casting_by_you_desc = "Alertes d'incantation pour les Explosions d'ambre que vous initiez. Mettre en évidence ceci est fortement recommandé !"

	L.willpower = "Points de Volonté"
	L.willpower_message = "Points de Volonté à %d !"

	L.break_free_message = "Vie à %d%% !"
	L.fling_message = "Vous allez être jeté !"
	L.parasite = "Parasite"

	L.monstrosity_is_casting = "Monstre : Explosion"
	L.you_are_casting = "VOUS êtes en train d'incanter !"

	L.unsok_short = "Boss"
	L.monstrosity_short = "Monstre"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "frFR")
if L then
	L.engage_trigger = "Mort à tous ceux qui osent défier mon empire !" -- à vérifier
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre change de phase."

	L.eyes = "Yeux de l'impératrice"
	L.eyes_desc = "Compte les cumuls d'Yeux de l'impératrice et affiche une barre de durée."
	L.eyes_message = "Yeux"

	L.visions_message = "Visions"
	L.visions_dispel = "Players have been feared!"
	L.fumes_bar = "Votre buff Vapeurs"
end

