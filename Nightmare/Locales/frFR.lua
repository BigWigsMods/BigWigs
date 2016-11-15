local L = BigWigs:NewBossLocale("Cenarius", "frFR")
if not L then return end
if L then
	L.forces = "Forces"
	L.bramblesSay = "Ronces près de %s"
	L.custom_off_multiple_breath_bar = "Affichage de plusieurs barres de Souffle putride"
	L.custom_off_multiple_breath_bar_desc = "Par défault, BigWigs n'affichera que la barre de Souffle putride d'un seul drake. Activez cette option si vous souhaitez voir le délai de chaque drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "frFR")
if L then
	L.isLinkedWith = "%s est lié(e) avec %s"
	L.yourLink = "Vous êtes lié(e) à %s"
	L.yourLinkShort = "Lié(e) à %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "frFR")
if L then
	L.remaining = "Restant(s)"
	L.missed = "Raté(s)"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "frFR")
if L then
	L.gelatinizedDecay = "Gelée putréfiée"
	L.befouler = "Corrupteur cœur-corrompu"
	L.shaman = "Chaman redoutable"
end

L = BigWigs:NewBossLocale("Ursoc", "frFR")
if L then
	L.custom_on_gaze_assist = "Assistance Regard focalisé"
	L.custom_on_gaze_assist_desc = "Affiche les icônes de raid dans les barres et les messages de Regard focalisé. {rt4} est utilisé pour les soaks impairs, et {rt6} pour les soaks pairs. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Xavius", "frFR")
if L then
	L.linked = "Liens de terreur sur VOUS ! - Lié(e) à %s !"
	L.dreamHealers = "Soigneurs du Rêve"
end
