local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "frFR")
if not L then return end
if L then
	L.force_message = "AoE Pulse"

	L.attenuation = EJ_GetSectionInfo(6426) .. " (Discs)"
	L.attenuation_message = "Incoming Discs, Dance!"

	L.platform_emote = "platforms" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "inhales"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "Swapping Platform"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "frFR")
if L then
	L.unseenstrike_cone = "Cône de Frappe invisible"

	L.assault = "Assaut accablant"
	L.assault_desc = "Alerte pour tanks uniquement. L'attaque laisse les défenses de la cible exposées, augmentant les dégâts subis par la cible quand un Assaut accablant la touche de 100% pendant 45 sec."
end

L = BigWigs:NewBossLocale("Garalon", "frFR")
if L then
	L.crush_stun = "Étourdissement de Crabouille"
	L.crush_trigger1 = "Garalon détecte la présence" -- à vérifier
	L.crush_trigger2 = "Garalon sent le passage" -- à vérifier
	L.crush_trigger3 = "Garalon detects"
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
	L.explosion_casting = "Incantation d'explosion"
	L.explosion_casting_desc = "Prévient quand n'importe laquelle des Explosions d'ambre est en cours d'incantation. Les messages d'alerte de début d'incantation sont associés à cette option. Mettre en évidence ceci est vivement recommandé !"

	L.willpower = "Points de Volonté"
	L.willpower_desc = "Quand tous les points de Volonté ont été utilisés, le joueur meurt et l'Assemblage muté continue à agir, hors de tout contrôle."
	L.willpower_message = "Vos points de Volonté sont à %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "frFR")
if L then
	L.phases = "Phases"
	L.phases_desc = "Prévient quand la rencontre change de phase."

	L.eyes = "Yeux de l'impératrice"
	L.eyes_desc = "Compte les cumuls d'Yeux de l'impératrice et affiche une barre de durée."
	L.eyes_message = "%2$dx yeux sur %1$s"
end

