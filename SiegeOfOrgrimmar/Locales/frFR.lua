local L = BigWigs:NewBossLocale("The Fallen Protectors", "frFR")
if not L then return end
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "Marquage Mot de l'ombre : Plaie"
	L.custom_off_bane_marks_desc = "Afin d'aider à l'attribution des dissipations, marque les personnes initialement touchées par Mot de l'ombre : Plaie avec {rt1}{rt2}{rt3}{rt4}{rt5} (dans cet ordre, il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Norushen", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "Marquage Don des titans"
	L.custom_off_titan_mark_desc = "Marque les joueurs sous l'effet de Don des titans avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"

	L.custom_off_fragment_mark = "Marquage Fragment corrompu"
	L.custom_off_fragment_mark_desc = "Marque les Fragments corrompus avec {rt8}{rt7}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

L = BigWigs:NewBossLocale("Galakras", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Marquage Chaman des marées"
	L.custom_off_shaman_marker_desc = "Afin d'aider à l'attribution des interruptions, marque les Chamans des marées gueule-de-dragon avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2ASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement tous les chamans est le moyen le plus rapide de les marquer.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "frFR")
if L then
	L.custom_off_mine_marks = "Marquage Mine rampante"
	L.custom_off_mine_marks_desc = "Afin d'aider à l'attribution des soaking, marque les Mines rampantes avec {rt1}{rt2}{rt3}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les mines est le moyen le plus rapide de les marquer.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/KorkronDarkShaman", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_mist_marks = "Marquage Brume toxique"
	L.custom_off_mist_marks_desc = "Afin d'aider à l'attribution des soins, marque les joueurs subissant Brume toxique avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "frFR")
if L then
	L.custom_off_bonecracker_marks = "Marquage Brise-os"
	L.custom_off_bonecracker_marks_desc = "Afin d'aider à l'attribution des soins, marque les joueurs subissant Brise-os avec {rt1}{rt2}{rt3}{rt4}{rt5}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"

	L.stance_bar = "%s(ACTUELLE : %s)"
	L.battle = "Combat"
	L.berserker = "Berserker"
	L.defensive = "Défensive"

	L.adds_trigger1 = "Défendez les portes !"
	L.adds_trigger2 = "Ralliez les troupes !"
	L.adds_trigger3 = "Escouade suivante, au front !"
	L.adds_trigger4 = "Guerriers, au pas de course !"
	L.adds_trigger5 = "Kor’krons, avec moi !"
	L.adds_trigger_extra_wave = "Tous les Kor’krons sous mon commandement, tuez-les, maintenant !"
	L.extra_adds = "Renforts supplémentaires"
	L.final_wave = "Vague finale"
	L.add_wave = "%s (%s): %s"

	L.chain_heal_message = "Votre focalisation est en train d'incanter Salve de guérison !"

	L.arcane_shock_message = "Votre focalisation est en train d'incanter Horion des Arcanes !"
end

L = BigWigs:NewBossLocale("Malkorok", "frFR")
if L then
	L.custom_off_energy_marks = "Marquage Énergie déplacée"
	L.custom_off_energy_marks_desc = "Afin d'aider à l'attribution des dissipations, marque les joueurs subissant Énergie déplacée avec {rt1}{rt2}{rt3}{rt4}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/SpoilsOfPandaria", format="lua_additive_table", handle-unlocalized="ignore")@

	L.crates = "Caisses"
	L.crates_desc = "Messages indiquant combien d'énergie titanesque vous avez encore besoin et combien de grandes/moyennes/petites caisses sont nécessaires pour y arriver."
	L.full_power = "Énergie maximale !"
	L.power_left = "Plus que %d ! (%d/%d/%d)"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/SiegecrafterBlackfuse", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_mine_marker = "Marquage Mine"
	L.custom_off_mine_marker_desc = "Afin d'aider à l'attribution des étourdissements, marque les mines avec toutes les marques disponibles."
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "frFR")
if L then
	L.catalyst_match = "Catalyseur : |c%sVOUS CORRESPOND|r" -- might not be best for colorblind?
	L.you_ate = "Vous avez mangé un parasite (il en reste %d)"
	L.other_ate = "%s a mangé un %sparasite (il en reste %d)"
	L.parasites_up = "%d |4Parasite actif:Parasites actifs;"
	L.dance = "%s, Danse"
	L.prey_message = "Utilisez Prendre pour proie sur le parasite"
	L.injection_over_soon = "Injection bientôt terminée (%s) !"

	L.one = "Iyyokuk sélectionne : Un !"
	L.two = "Iyyokuk sélectionne : Deux !"
	L.three = "Iyyokuk sélectionne : Trois !"
	L.four = "Iyyokuk sélectionne : Quatre !"
	L.five = "Iyyokuk sélectionne : Cinq !"

	L.custom_off_edge_marks = "Marquage Tranchant enflammé"
	L.custom_off_edge_marks_desc = "Marque les joueurs qui seront les sommets des Tranchants enflammés avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"
	L.edge_message = "Vous êtes un sommet"

	L.custom_off_parasite_marks = "Marquage Parasite"
	L.custom_off_parasite_marks_desc = "Afin d'aider à l'attribution des contrôles de foule et des Prendre pour proie, marque les parasites avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"

	L.injection_tank = "Incantation d'Injection"
	L.injection_tank_desc = "Barre de délai indiquant quand Injection est incanté sur son tank actuel."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "frFR")
if L then
--@localization(locale="frFR", namespace="SiegeOfOrgrimmar/GarroshHellscream", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "Marquage Chevaucheur de loup long-voyant"
	L.custom_off_shaman_marker_desc = "Afin d'aider à l'attribution des interruptions, marque les Chevaucheurs de loup long-voyant avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."

	L.custom_off_minion_marker = "Marquage Sbires"
	L.custom_off_minion_marker_desc = "Afin d'aider à la séparation des sbires, marque ces derniers avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}. Nécessite d'être assistant ou chef de raid."
end

