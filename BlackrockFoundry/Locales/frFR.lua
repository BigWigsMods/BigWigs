local L = BigWigs:NewBossLocale("Gruul", "frFR")
if not L then return end
if L then
	L.first_ability = "Frappe ou Heurt"
end

L = BigWigs:NewBossLocale("Oregorger", "frFR")
if L then
	L.berserk_trigger = "La faim rend Mangeroc fou furieux !" -- à vérifier

	L.shard_explosion = "Explosion de Eclat explosif"
	L.shard_explosion_desc = "Barre mise en évidence séparée pour l'explosion."

	L.hunger_drive_power = "%dx %s - %d minerai(s) à faire !"
end

L = BigWigs:NewBossLocale("The Blast Furnace", "frFR")
if L then
	L.custom_on_shieldsdown_marker = "Marquage Boucliers dissipés"
	L.custom_on_shieldsdown_marker_desc = "Marque une Élémentariste primordiale vulnérable avec {rt8}. Nécessite d'être assistant ou chef de raid."

	L.heat_increased_message = "La Chaleur augmente ! Explosion toutes les %ss"

	L.bombs_dropped = "Bombes lâchées ! (%d)"
end

L = BigWigs:NewBossLocale("Hans'gar and Franzok", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "frFR")
if L then
	L.molten_torrent_self = "Torrent de lave sur vous"
	L.molten_torrent_self_desc = "Compte à rebours spécial quand le Torrent de lave est sur vous."
	L.molten_torrent_self_bar = "Vous explosez !"
end

L = BigWigs:NewBossLocale("Kromog", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "frFR")
if L then
	L.next_mount = "Mise en selle imminente !"

	L.custom_off_pinned_marker = "Marquage Clouer au sol"
	L.custom_off_pinned_marker_desc = "Marque les cibles de Clouer au sol avec {rt8}{rt7}{rt6}{rt5}{rt4}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les mines est le moyen le plus rapide de les marquer.|r"

	L.custom_off_conflag_marker = "Marquage Déflagration"
	L.custom_off_conflag_marker_desc = "Marque les cibles de Déflagration avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

L = BigWigs:NewBossLocale("Operator Thogar", "frFR")
if L then
	L.custom_off_firemender_marker = "Marquage Garde-feu grom’kar"
	L.custom_off_firemender_marker_desc = "Marque les Gardes-feu grom’kar avec {rt1}{rt2}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les mines est le moyen le plus rapide de les marquer.|r"

	L.cauterizing_bolt_message = "Votre focalisation incante Eclair cautérisant !"

	L.trains = "Alertes Train"
	L.trains_desc = "Affiche des délais et des messages pour chaque voies indiquant quand le prochain train arrive. Les voies sont numérotées en comptant du boss jusqu'à l'entrée : Boss 1 2 3 4 Entrée."

	L.lane = "Voie %s : %s"
	L.train = "Train"
	--L.adds_train = "Adds train"
	--L.big_add_train = "Big add train"
	--L.cannon_train = "Cannon train"
	L.deforester = "Abatteur d'arbres" -- /dump (EJ_GetSectionInfo(10329))
	L.random = "Trains aléatoires"
end

L = BigWigs:NewBossLocale("The Iron Maidens", "frFR")
if L then
	L.ship_trigger = "s'apprête à employer le canon principal du cuirassier !" -- à vérifier

	L.ship = "Saut vers le navire"

	L.custom_off_heartseeker_marker = "Marquage Crève-cœur imprégné de sang"
	L.custom_off_heartseeker_marker_desc = "Marque les cibles des crèves-cœurs avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."

	L.power_message = "%d Furie de fer !"
end

L = BigWigs:NewBossLocale("Blackhand", "frFR")
if L then
	L.custom_off_markedfordeath_marker = "Marquage Désigné pour mourir"
	L.custom_off_markedfordeath_marker_desc = "Marque les cibles de Désigné pour mourir avec {rt1}{rt2}. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "frFR")
if L then
	L.gnasher = "Grinceur sombréclat"
	L.furnace = "Tuyau d’échappement du haut-fourneau"
	end

