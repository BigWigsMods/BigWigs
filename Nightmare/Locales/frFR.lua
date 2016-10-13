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
	L.custom_off_deathglare_marker = "Marquage Oeil meurtrier tentaculaire"
	L.custom_off_deathglare_marker_desc = "Marque les Yeux meurtriers tentaculaires avec {rt6}{rt5}{rt4}{rt3}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement tous les yeux est le moyen le plus rapide de les marquer.|r"

	L.bloods_remaining = "Il reste %d |4sang:sangs;"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "frFR")
if L then
	--L.gelatinizedDecay = "Gelatinized Decay" -- to translate
	L.befouler = "Corrupteur cœur-corrompu"
	L.shaman = "Chaman redoutable"
	L.custom_on_mark_totem = "Marquage des totems"
	L.custom_on_mark_totem_desc = "Marque les totems avec {rt8}{rt7}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Ursoc", "frFR")
if L then
	L.custom_on_gaze_assist = "Assistance Regard focalisé"
	L.custom_on_gaze_assist_desc = "Affiche les icônes de raid dans les barres et les messages de Regard focalisé. {rt4} est utilisé pour les soaks impairs, et {rt6} pour les soaks pairs. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Xavius", "frFR")
if L then
	L.custom_off_blade_marker = "Marquage Lames de cauchemar"
	L.custom_off_blade_marker_desc = "Marque les cibles de Lames de cauchemar avec {rt1}{rt2}. Nécessite d'être assistant ou chef de raid."

	L.linked = "Liens de terreur sur VOUS ! - Lié(e) à %s !"
end
