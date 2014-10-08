local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "frFR")
if not L then return end
if L then
	L.storm_duration = "Durée de Tempête de foudre"
	L.storm_duration_desc = "Une barre d'alerte à part pour la durée d'incantation de Tempête de foudre."
	L.storm_short = "Tempête"

	L.in_water = "Vous êtes dans l'eau !"
end

L = BigWigs:NewBossLocale("Horridon", "frFR")
if L then
	L.charge_trigger = "pose les yeux sur"
	L.door_trigger = "surgissent de la porte"
	L.orb_trigger = "enfoncer" -- PLAYERNAME forces Horridon to charge the Farraki door!

	L.chain_lightning_message = "Votre focalisation est entrain d'incanter Chaîne d'éclairs !"
	L.chain_lightning_bar = "Focalisation : Chaîne d'éclairs"

	L.fireball_message = "Votre focalisation est en train d'incanter Boule de feu !"
	L.fireball_bar = "Focalisation : Boule de feu"

	L.venom_bolt_volley_message = "Votre focalisation est en train d'incanter Salve !"
	L.venom_bolt_volley_bar = "Focalisation : Salve"

	L.adds = "Apparition des renforts"
	L.adds_desc = "Prévient quand les Farraki, les Gurubashi, les Drakkari, les Amani et le Dieu-guerrier Jalak apparaissent."

	L.door_opened = "Porte ouverte !"
	L.door_bar = "Prochaine porte (%d)"
	L.balcony_adds = "Trolls des gradins"
	L.orb_message = "Orbe de contrôle lâché !"

	L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "frFR")
if L then
	L.priestess_adds = "Esprits loa de la prêtresse"
	L.priestess_adds_desc = "Prévient quand la Grande prêtresse Mar'li commence à invoquer des esprits loa."
	L.priestess_adds_message = "Esprit loa de la prêtresse"

	L.custom_on_markpossessed = "Marquage du boss possédé"
	L.custom_on_markpossessed_desc = "Marque le boss possédé à l'aide d'une icône de crâne. Nécessite d'être assistant ou chef de raid."

	L.priestess_heal = "%s a été soigné !"
	L.assault_stun = "Tank étourdi !"
	L.assault_message = "Assaut"
	L.full_power = "Puissance maximale"
	L.hp_to_go_power = "%d%% de PV à faire ! (Puissance : %d)"
	L.hp_to_go_fullpower = "%d%% de PV à faire ! (Puissance maximale)"
end

L = BigWigs:NewBossLocale("Tortos", "frFR")
if L then
	L.bats_desc = "Les chauve-souris ! Butez-les !"

	L.kick = "Coup de pied"
	L.kick_desc = "Effectue un suivi du nombre de tortues qui peuvent être bottées."
	L.kick_message = "Tortues à botter : %d"
	L.kicked_message = "%s a botté ! (il en reste %d)"

	L.custom_off_turtlemarker = "Marquage des tortues"
	L.custom_off_turtlemarker_desc = "Marque les tortues en utilisant toutes les icônes de raid, nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les tortues est le moyen le plus rapide de les marquer.|r"

	L.no_crystal_shell = "PAS de Carapace de cristal"
end

L = BigWigs:NewBossLocale("Megaera", "frFR")
if L then
	L.breaths = "Souffles"
	L.breaths_desc = "Alertes relatives aux différents types de souffles."

	L.arcane_adds = "Wyrms du Néant"
end

L = BigWigs:NewBossLocale("Ji-Kun", "frFR")
if L then
	L.first_lower_hatch_trigger = "Les œufs de l’un des nids inférieurs commencent à éclore !"
	L.lower_hatch_trigger = "Les œufs de l’un des nids inférieurs commencent à éclore !"
	L.upper_hatch_trigger = "Les œufs de l’un des nids supérieurs commencent à éclore !"

	L.nest = "Nids"
	L.nest_desc = "Alertes relatives aux nids.\n|cFFADFF2FASTUCE : Décochez ceci pour désactiver les alertes si vous n'êtes pas assigné à la gestion des nids.|r"

	L.flight_over = "Vol terminé dans %d sec !"
	L.upper_nest = "Nid |cff008000supérieur|r"
	L.lower_nest = "Nid |cffff0000inférieur|r"
	L.up = "|cff008000HAUT|r"
	L.down = "|cffff0000BAS|r"
	L.add = "Add"
	L.big_add_message = "Gros add au %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "frFR")
if L then
	L.red_spawn_trigger = "brume écarlate"
	L.blue_spawn_trigger = "brume azur"
	L.yellow_spawn_trigger = "brume d'ambre"

	L.adds = "Bêtes de brume révélées"
	L.adds_desc = "Alertes quand vous révélez une Brume écarlate, d'ambre ou azur et combien de Brumes écarlates il reste."

	L.custom_off_ray_controllers = "Contrôleurs de rayon"
	L.custom_off_ray_controllers_desc = "Utile les marqueurs de raid {rt1}{rt7}{rt6} afin de marquer les personnes qui vont contrôler les positions d'apparition de rayon ainsi que leurs mouvements, nécessite d'être assistant ou chef de raid."

	L.custom_off_parasite_marks = "Marquage des Sombres parasites"
	L.custom_off_parasite_marks_desc = "Afin d'aider à l'attribution des soins, marque les personnes sous l'effet de Sombre parisite avec les marqueurs de raid {rt3}{rt4}{rt5}, nécessite d'être assistant ou chef de raid."

	L.initial_life_drain = "Incantation initiale de Drain de vie"
	L.initial_life_drain_desc = "Message de l'incantation initiale de Drain de vie afin d'aider au suivi des affaiblissements de réduction des soins reçus."

	L.life_drain_say = "%dx Drain"

	L.rays_spawn = "Apparition des rayons"
	L.red_add = "Bête de brume |cffff0000rouge|r"
	L.blue_add = "Bête de brume |cff0000ffbleue|r"
	L.yellow_add = "Bête de brume |cffffff00jaune|r"
	L.death_beam = "Rayon mortel"
	L.red_beam = "Rayon |cffff0000rouge|r"
	L.blue_beam = "Rayon |cff0000ffbleu|r"
	L.yellow_beam = "Rayon |cffffff00jaune|r"
end

L = BigWigs:NewBossLocale("Primordius", "frFR")
if L then
	L.mutations = "Mutations |cff008000(%d)|r |cffff0000(%d)|r"
	L.acidic_spines = "Pointes acides (dégâts collatéraux)" -- find something better
end

L = BigWigs:NewBossLocale("Dark Animus", "frFR")
if L then
	L.engage_trigger = "L’orbe explose !"

	L.matterswap_desc = "Un personnage-joueur porteur d’Echange de matière se trouve loin de vous. Il échangera sa position avec la vôtre si Echange de matière est retiré."
	L.matterswap_message = "Vous êtes le plus éloigné pour Echange de matière !"

	L.siphon_power = "Siphon d’anima (%d%%)"
	L.siphon_power_soon = "Siphon d’anima (%d%%) %s imminent !"
	L.slam_message = "Heurt"
end

L = BigWigs:NewBossLocale("Iron Qon", "frFR")
if L then
	L.molten_energy = "Énergie magmatique"

	L.arcing_lightning_cleared = "Le raid est libéré de Foudre en arc"
end

L = BigWigs:NewBossLocale("Twin Consorts", "frFR")
if L then
	L.barrage_fired = "Barrage invoqué !"
	L.last_phase_yell_trigger = "D'accord, pour cette fois" -- à vérifier
end

L = BigWigs:NewBossLocale("Lei Shen", "frFR")
if L then
	L.custom_off_diffused_marker = "Marquages des Foudres diffuses"
	L.custom_off_diffused_marker_desc = "Marque les Foudres diffuses en utilisant toutes les icônes de raid, nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r\n|cFFADFF2FASTUCE : si le raid a décidé que c'est vous qui devez l'activer, survoler rapidement toutes les Foudres diffuses est le moyen le plus rapide de les marquer.|r"

	L.stuns = "Étourdissements"
	L.stuns_desc = "Affiche des barres pour les durées d'étourdissement, à utiliser avec la gestion des foudres en boule."

	L.aoe_grip = "\"Grip\" de zone"
	L.aoe_grip_desc = "Prévient quand un chevalier de la mort utilise Emprise de Fielsang, à utiliser avec la gestion des foudres en boule."

	L.shock_self = "Horion statique sur VOUS"
	L.shock_self_desc = "Affiche une barre de durée de l'affaiblissement Horion statique quand ce dernier est sur vous."

	L.overcharged_self = "Surchargé sur VOUS"
	L.overcharged_self_desc = "Affiche une barre de durée de l'affaiblissement Surchargé quand ce dernier est sur vous."

	L.last_inermission_ability = "Dernière technique d'entracte utilisée !"
	L.safe_from_stun = "Vous êtes probablement à l'abri des étourdissements de Surchargé"
	L.diffusion_add = "Foudres diffuses"
	L.shock = "Horion"
	L.static_shock_bar = "<Split d'Horion statique>"
	L.overcharge_bar = "<Pulse de Surcharge>"
end

L = BigWigs:NewBossLocale("Ra-den", "frFR")
if L then
	L.vita_abilities = "Techniques de Vita"
	L.anima_abilities = "Techniques d'Anima"
	L.worm = "Ver"
	L.worm_desc = "Invoque un ver"

	L.balls = "Boules"
	L.balls_desc = "Boules d'Anima (rouge) et de Vita (bleu), qui déterminent les techniques que Ra-den gagnera."

	L.corruptedballs = "Boules corrompues"
	L.corruptedballs_desc = "Boules corrompues de Vita et d'Anima dont l'effet est d'augmenter soit les dégâts infligés (Vita), soit les points de vie maximum (Anima)."

	L.unstablevitajumptarget = "Cible de saut de Vita instable"
	L.unstablevitajumptarget_desc = "Prévient quand vous êtes le plus éloigné d'un joueur sous Vita instable. Si vous mettez en évidence ceci, vous aurez également un compte à rebours indiquant quand Vita instable est sur le point de passer sur un autre joueur À PARTIR de vous."

	L.unstablevitajumptarget_message = "Vous êtes le plus éloigné de Vita instable"
	L.sensitivityfurthestbad = "Sensibilité au Vita + le plus éloigné = |cffff0000MAUVAIS|r !"
	L.kill_trigger = "Attendez !"

	L.assistPrint = "Un plugin appelé 'BigWigs_Ra-denAssist' est désormais disponible pour vous assister durant la rencontre face à Ra-den. N'hésitez pas à l'essayer."
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "frFR")
if L then
	L.stormcaller = "Mande-foudre zandalari"
	L.stormbringer = "Porte-tempête Draz’kil"
	L.monara = "Monara"
	L.rockyhorror = "Horreur rocheuse"
	L.thunderlord_guardian = "Seigneur du tonnerre / Gardien de foudre"
end

