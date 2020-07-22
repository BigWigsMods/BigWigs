local L = BigWigs:NewBossLocale("Maut", "frFR")
if not L then return end
if L then
	L.stage2_over = "Fin de la phase 2 - %.1f sec"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours montrer la barre des sorts"
	L.custom_on_stop_timers_desc = "Shad'har utilise un sort aléatoire parmis ceux qui sont up. Quand cette option est activée, les barres des sorts up restent à l'écran."
end

L = BigWigs:NewBossLocale("Drest'agath", "frFR")
if L then
	L.adds_desc = "Avertissements et Messages pour les Yeux, les tentacules et les gueules de Drest'agath."
	L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "Oeil mort !"
	L.tentacle_killed = "Tentacule morte!"
	L.maw_killed = "Gueule morte !"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "frFR")
if L then
	L.custom_on_fixate_plates = "Icon attaché sur les Nameplates énemies"
	L.custom_on_fixate_plates_desc = "Montre un icone sur la cible qui est sur vous.\nLes nameplates énemies sont recquises. Supporté seulement avec KuiNameplates."
end

L = BigWigs:NewBossLocale("Vexiona", "frFR")
if L then
	L.killed = "%s tué"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "frFR")
if L then
	L.essences = "Essences"
	L.essences_desc = "Ra-den fait régulièrement pop des essences. Les essences qui touchent Ra-den le buff en accord avec le type de l'essence."
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "frFR")
if L then
	L.player_membrane = "Membrane sur Joueur" -- In stage 3
	L.boss_membrane = "Membrane sur Boss" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "frFR")
if L then
	L.realm_switch = "Changement de royaume." -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Spamming paranoia dire"
	L.custom_on_repeating_paranoia_say_desc = "Spam un message en dire pour pour signaler que vous avez la paranoia"
	-- L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "Alerte. Des entités hostiles approchent de la chambre du Cœur." -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "Portail ouvert !"

	L.laser_left = "Lasers (Gauche)"
	L.laser_right = "Lasers (Droite)"
end
