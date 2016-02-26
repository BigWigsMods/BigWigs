local L = BigWigs:NewBossLocale("Hellfire Assault", "frFR")
if not L then return end
if L then
L.left = "Gauche : %s"
L.middle = "Milieu : %s"
L.right = "Droite : %s"

end

L = BigWigs:NewBossLocale("Kilrogg Deadeye", "frFR")
if L then
L.add_warnings = "Alertes apparition des adds"

end

L = BigWigs:NewBossLocale("Gorefiend", "frFR")
if L then
L.fate_root_you = "Destin partagé - Vous êtes immobilisé !"
L.fate_you = "Destin partagé sur VOUS ! - Immobilisation sur %s"

end

L = BigWigs:NewBossLocale("Shadow-Lord Iskar", "frFR")
if L then
L.bindings_removed = "Liens enlevés (%d/3)"
L.custom_off_binding_marker = "Marquage Liens sombres"
L.custom_off_binding_marker_desc = [=[Marque les cibles de Liens sombres avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}. Nécessite d'être assistant ou chef de raid.
|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r]=]
L.custom_off_wind_marker = "Marquage Vents fantasmatiques"
L.custom_off_wind_marker_desc = [=[Marque les cibles de Vents fantasmatiques avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid.
|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r]=]

end

L = BigWigs:NewBossLocale("Socrethar the Eternal", "frFR")
if L then
L.dominator_desc = "Alertes concernant l'apparition du Dominateur sargereï."
L.portals = "Déplacement des portails"
L.portals_desc = "Délai indiquant quand les portails changent de position en phase 2."
L.portals_msg = "Les portails ont bougés !"

end

L = BigWigs:NewBossLocale("Fel Lord Zakuun", "frFR")
if L then
L.custom_off_seed_marker = "Marquage Graine de destruction"
L.custom_off_seed_marker_desc = "Marque les cibles de Graine de destruction avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid."
L.seed = "Graine"
L.tank_proximity = "Proximité des tanks"
L.tank_proximity_desc = "Ouvre une fenêtre de proximité de 5m indiquant la position des autres tanks afin de vous aider à gérer la technique Main lourde & Lourdement armé."

end

L = BigWigs:NewBossLocale("Tyrant Velhari", "frFR")
if L then
L.font_removed_soon = "Votre Fontaine se termine bientôt !"

end

L = BigWigs:NewBossLocale("Mannoroth", "frFR")
if L then
L["182212"] = "Portail des infernaux fermé !"
L["185147"] = "Portail des seigneurs funestes fermé !"
L["185175"] = "Portail des diablotins fermé !"
L.custom_off_doom_marker = "Marquage Marque funeste"
L.custom_off_doom_marker_desc = "En difficulté Mythique, marque les cibles de Marque funeste avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."
L.custom_off_gaze_marker = "Marquage Regard de Mannoroth"
L.custom_off_gaze_marker_desc = "Marque les cibles de Regard de Mannoroth avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."
L.custom_off_wrath_marker = "Marquage Courroux de Gul’dan"
L.custom_off_wrath_marker_desc = "Marque les cibles de Courroux de Gul’dan avec {rt8}{rt7}{rt6}{rt5}{rt4}. Nécessite d'être assistant ou chef de raid."
L.felseeker_message = "%s (%d) %dm"
L.gaze = "Regard (%d)"

end

L = BigWigs:NewBossLocale("Archimonde", "frFR")
if L then
L.chaos_bar = "%s -> %s"
L.chaos_from = "%s depuis %s"
L.chaos_helper_message = "Votre position Chaos : %d"
L.chaos_to = "%s vers %s"
L.custom_off_chaos_helper = "Assistant Chaos créé"
L.custom_off_chaos_helper_desc = "Pour la difficulté Mythique uniquement. Cette fonctionnalité vous indique quel numéro de chaos vous êtes, affiche un message normal et le fait dire à votre personnage. Selon la stratégie que vous utilisez, cette fonctionnalité peut se révéler être utile ou pas."
L.custom_off_infernal_marker = "Marquage Infernal"
L.custom_off_infernal_marker_desc = "Marque les infernaux créés par Pluie du chaos avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid."
L.custom_off_legion_marker = "Marquage Marque de la Légion"
L.custom_off_legion_marker_desc = "Marque les cibles de Marque de la Légion avec {rt1}{rt2}{rt3}{rt4}. Nécessite d'être assistant ou chef de raid."
L.custom_off_torment_marker = "Marquage Tourment enchaîné"
L.custom_off_torment_marker_desc = "Marque les cibles de Tourment enchaîné avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid."
L.infernal_count = "%s (%d/%d)"
L.markofthelegion_self = "Marque de la Légion sur vous"
L.markofthelegion_self_bar = "Vous explosez !"
L.markofthelegion_self_desc = "Compte à rebours spécial quand une Marque de la Légion est sur vous."
L.torment_removed = "Tourment enchaîné enlevé (%d/%d)"

end

L = BigWigs:NewBossLocale("Hellfire Citadel Trash", "frFR")
if L then
L.anetheron = "Anetheron"
L.azgalor = "Azgalor"
L.bloodthirster = "Carnassier salivant"
L.burster = "Perceur d’ombre"
L.daggorath = "Dag'gorath"
L.darkcaster = "Invocateur noir sanguinolent"
L.eloah = "Lieur Eloah"
L.enkindler = "Inflammatrice embrasée"
L.faithbreaker = "Erédar brisefoi"
L.graggra = "Graggra"
L.kazrogal = "Kaz'rogal"
L.kuroh = "Subalterne Kuroh"
L.orb = "Orbe de destruction"
L.peacekeeper = "Assemblage garde-paix"
L.talonpriest = "Prêtre de la serre corrompu"
L.weaponlord = "Seigneur des armes Mehlkhior"

end

