local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "frFR")
if not L then return end
if L then
	L.engage_yell = "La Divine a choisi de donner une voix mortelle à Sa divine volonté. Nous ne sommes que l'instrument qui promulge Sa volonté." -- à vérifier

	L.force_message = "Impulsion de zone"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (anneaux)"
	L.attenuation_bar = "Anneaux... dansez !"
	L.attenuation_message = "%s Dancing %s"
	L.echo = "|c001cc986Echo|r"
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

	L.unseenstrike_inc = "Arrivée d'une Frappe !"
	L.unseenstrike_soon = "Frappe dans ~5-10 sec !"

	L.assault_message = "Assauts"
	L.side_swap = "Changement de côté"
end

L = BigWigs:NewBossLocale("Garalon", "frFR")
if L then
	L.removed = "%s enlevé !"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "frFR")
if L then
	L.next_pack = "Prochain groupe"
	L.next_pack_desc = "Prévient quand un prochain groupe atterrit après que vous ayez tué un autre."

	L.spear_removed = "Votre Lance de perforation a été enlevée !"
	L.residue_removed = "%s enlevé !"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "frFR")
if L then
	L.explosion_by_other = "Explosion d'ambre sur les autres"
	L.explosion_by_other_desc = "Alerte de temps de recharge des Explosions d'ambre incantées par la Monstruosité d'ambre ou votre cible de focalisation."

	L.explosion_casting_by_other = "Explosion d'ambre incanté par les autres"
	L.explosion_casting_by_other_desc = "Alertes d'incantation des Explosions d'ambre que la Monstruosité d'ambre ou que votre cible de focalisation lance. Mettre en évidence ceci est fortement recommandé !"

	L.explosion_by_you = "Explosion d'ambre sur vous"
	L.explosion_by_you_desc = "Alerte de temps de recharge de vos Explosions d'ambre."

	L.explosion_casting_by_you = "Explosion d'ambre incanté par vous"
	L.explosion_casting_by_you_desc = "Alertes d'incantation des Explosions d'ambre que vous lancez. Mettre en évidence ceci est fortement recommandé !"

	L.willpower = "Points de Volonté"
	L.willpower_message = "Points de Volonté à %d !"

	L.break_free_message = "Vie à %d%% !"
	L.fling_message = "Vous allez être jeté !"
	L.parasite = "Parasite"

	L.boss_is_casting = "Le BOSS est en train d'incanter !"
	L.you_are_casting = "VOUS êtes en train d'incanter !"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "frFR")
if L then
	L.engage_trigger = "Mort à tous ceux qui osent défier mon empire !" -- à vérifier
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre change de phase."

	L.eyes = "Yeux de l'impératrice"
	L.eyes_desc = "Compte les cumuls d'Yeux de l'impératrice et affiche une barre de durée."
	L.eyes_message = "%2$dx yeux sur %1$s"

	L.fumes_bar = "Votre buff Vapeurs"
end

