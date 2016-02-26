local L = BigWigs:NewBossLocale("Gruul", "frFR")
if not L then return end
if L then
L.first_ability = "Frappe ou Heurt"

end

L = BigWigs:NewBossLocale("Oregorger", "frFR")
if L then
L.roll_message = "Roulade %d - %d minerais à faire !"

end

L = BigWigs:NewBossLocale("The Blast Furnace", "frFR")
if L then
L.bombs_dropped = "Bombes lâchées ! (%d)"
L.bombs_dropped_p2 = "Ingénieur tué, bombes lâchées !"
L.custom_off_firecaller_marker = "Marquage Mandefeu"
L.custom_off_firecaller_marker_desc = [=[Marque les Mandefeux avec {rt7}{rt6}. Nécessite d'être assistant ou chef de raid.
|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r
|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les monstres est le moyen le plus rapide de les marquer.|r]=]
L.custom_on_shieldsdown_marker = "Marquage Boucliers dissipés"
L.custom_on_shieldsdown_marker_desc = "Marque une Élémentariste primordiale vulnérable avec {rt8}. Nécessite d'être assistant ou chef de raid."
L.engineer = "Apparition des Ingénieurs de la fournaise"
L.engineer_desc = "Durant la phase deux, 2 Ingénieurs de la fournaise apparaîtront régulièrement, 1 de chaque côté de la salle."
L.firecaller = "Apparition des Mandefeux"
L.firecaller_desc = "Durant la phase deux, 2 Mandefeux apparaîtront régulièrement, 1 de chaque côté de la salle."
L.guard = "Apparition des Gardes de la sécurité"
L.guard_desc = "Pendant la phase une, 2 Gardes de la sécurité apparaîtront régulièrement, 1 de chaque côté de la salle. Pendant la phase deux, 1 Garde de la sécurité apparaîtra à l'entrée de la salle."
L.heat_increased_message = "La Chaleur augmente ! Explosion toutes les %ss"
L.operator = "Apparition des Opérateurs des soufflets"
L.operator_desc = "Pendant la phase une, 2 Opérateurs des soufflets apparaîtront régulièrement, 1 de chaque côté de la salle."

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "frFR")
if L then
L.custom_off_wolves_marker = "Marquage Loups de braise"
L.custom_off_wolves_marker_desc = "Marque les Loups de braise avec {rt3}{rt4}{rt5}{rt6}. Nécessite d'être assistant ou chef de raid."
L.molten_torrent_self = "Torrent de lave sur vous"
L.molten_torrent_self_bar = "Vous explosez !"
L.molten_torrent_self_desc = "Compte à rebours spécial quand le Torrent de lave est sur vous."

end

L = BigWigs:NewBossLocale("Kromog", "frFR")
if L then
L.custom_off_hands_marker = "Marquage Terres avides des tanks"
L.custom_off_hands_marker_desc = "Marque les Terres avides qui ont agrippé les tanks avec {rt7}{rt8}. Nécessite d'être assistant ou chef de raid."
L.destroy_pillars = "Destruction des piliers"
L.prox = "Proximité des tanks"
L.prox_desc = "Ouvre une fenêtre de proximité de 15m indiquant la position des autres tanks afin de vous aider à gérer la technique Poings de pierre."

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "frFR")
if L then
L.custom_off_conflag_marker = "Marquage Déflagration"
L.custom_off_conflag_marker_desc = [=[Marque les cibles de Déflagration avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid.
|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r]=]
L.custom_off_pinned_marker = "Marquage Clouer au sol"
L.custom_off_pinned_marker_desc = [=[Marque les cibles de Clouer au sol avec {rt8}{rt7}{rt6}{rt5}{rt4}. Nécessite d'être assistant ou chef de raid.
|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r
|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les mines est le moyen le plus rapide de les marquer.|r]=]
L.next_mount = "Mise en selle imminente !"

end

L = BigWigs:NewBossLocale("Operator Thogar", "frFR")
if L then
L.adds_train = "Train avec adds"
L.big_add_train = "Train avec gros add"
L.cannon_train = "Train avec canon"
L.custom_on_firemender_marker = "Marquage Garde-feu grom’kar"
L.custom_on_firemender_marker_desc = "Marque le Garde-feu grom’kar avec {rt7}. Nécessite d'être assistant ou chef de raid."
L.custom_on_manatarms_marker = "Marquage Homme d’armes grom’kar"
L.custom_on_manatarms_marker_desc = "Marque l'Homme d’armes grom’kar avec {rt8}. Nécessite d'être assistant ou chef de raid."
L.deforester = "Abatteur d'arbres"
L.lane = "Voie %s : %s"
L.random = "Trains aléatoires"
L.train = "Train"
L.trains = "Alertes Train"
L.trains_desc = "Affiche des délais et des messages pour chaque voies indiquant quand le prochain train arrive. Les voies sont numérotées en comptant du boss jusqu'à l'entrée : Boss 1 2 3 4 Entrée."
L.train_you = "Train sur votre voie ! (%d)"

end

L = BigWigs:NewBossLocale("The Iron Maidens", "frFR")
if L then
L.custom_off_heartseeker_marker = "Marquage Crève-cœur imprégné de sang"
L.custom_off_heartseeker_marker_desc = "Marque les cibles des crèves-cœurs avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."
L.power_message = "%d Furie de fer !"
L.ship = "Saut vers le navire"
L.ship_trigger = "s'apprête à employer le canon principal du cuirassier !"

end

L = BigWigs:NewBossLocale("Blackhand", "frFR")
if L then
L.custom_off_markedfordeath_marker = "Marquage Désigné pour mourir"
L.custom_off_markedfordeath_marker_desc = "Marque les cibles de Désigné pour mourir avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."
L.custom_off_massivesmash_marker = "Marquage Frappe fracassante massive"
L.custom_off_massivesmash_marker_desc = "Marque le tank touché par Frappe fracassante massive avec {rt6}. Nécessite d'être assistant ou chef de raid."

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "frFR")
if L then
L.beasttender = "Soigne-bête sire-tonnerre"
L.brute = "Brute de l’atelier des scories"
L.earthbinder = "Lieur de terre de Fer"
L.enforcer = "Massacreur rochenoire"
L.furnace = "Tuyau d’échappement du haut-fourneau"
L.furnace_msg1 = "Hmm, ça sent un peu le brûlé n'est-ce pas ?"
L.furnace_msg2 = "C'est l'heure de la guimauve !"
L.furnace_msg3 = "Ça sent mauvais..."
L.gnasher = "Grinceur sombréclat"
L.gronnling = "Travailleur gronnlin"
L.guardian = "Gardien de l’atelier"
L.hauler = "Hâleur ogron"
L.mistress = "Maître-forgeronne Main-de-Flammes"
L.taskmaster = "Sous-chef de Fer"

end

