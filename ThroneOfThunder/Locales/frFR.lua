local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "frFR")
if not L then return end
if L then
	L.storm_duration = "Durée de Tempête de foudre"
	L.storm_duration_desc = "Une barre d'alerte à part pour la durée d'incantation de Tempête de foudre."

	L.in_water = "Vous êtes dans l'eau !"
end

L = BigWigs:NewBossLocale("Horridon", "frFR")
if L then
	L.charge_trigger = "pose les yeux sur"
	L.door_trigger = "surgissent de la porte"

	L.chain_lightning_message = "Votre focalisation est entrain d'incanter Chaîne d'éclairs !"
	L.chain_lightning_bar = "Focalisation : Chaîne d'éclairs"

	L.fireball_message = "Votre focalisation est en train d'incanter Boule de feu !"
	L.fireball_bar = "Focalisation : Boule de feu"

	L.venom_bolt_volley_message = "Votre focalisation est en train d'incanter Salve !"
	L.venom_bolt_volley_bar = "Focalisation : Salve"

	L.adds = "Apparition des renforts"
	L.adds_desc = "Prévient quand les Farraki, les Gurubashi, les Drakkari, les Amani et le Dieu-guerrier Jalak apparaissent."

	L.door_opened = "Porte ouverte !"
	L.door_bar = "Proch. porte (%d)"
	L.balcony_adds = "Adds du balcon"
	L.orb_message = "Orbe de contrôle lâchée !"

	L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "frFR")
if L then
	L.priestess_adds = "Adds de la prêtresse"
	L.priestess_adds_desc = "Prévient de l'arrivée des différents genres de renforts de la Grande prêtresse Mar'li."
	L.priestess_adds_message = "Add de la prêtresse"

	L.full_power = "Puissance maximale"
	L.assault_message = "Assaut"
	L.hp_to_go_power = "PV à faire : %d%% - Puissance : %d"

	L.custom_on_markpossessed = "Marquage du boss possédé"
	L.custom_on_markpossessed_desc = "Marque le boss possédé à l'aide d'une icône de crâne."
end

L = BigWigs:NewBossLocale("Tortos", "frFR")
if L then
	L.kick = "Coup de pied"
	L.kick_desc = "Effectue un suivi du nombre de tortues qui peuvent être bottées."
	L.kick_message = "Tortues à botter : %d"

	L.crystal_shell_removed = "Carapace de cristal enlevé !"
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
	L.flight_over = "Vol terminé"
	L.young_egg_hatching = "Éclosion d'un jeune œuf"
	L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch !" -- à traduire
	L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch !" -- à traduire
	L.upper_nest = "Nid |c00008000supérieur|r"
	L.lower_nest = "Nid |c00FF0000inférieur|r"
	L.lower_upper_nest = "Nid |c00FF0000inférieur|r + |c00008000supérieur|r"
	L.nest = "Nids"
	L.nest_desc = "Alertes relatives aux nids. |c00FF0000Décochez ceci pour désactiver les alertes si vous n'êtes pas assigné à la gestion des nids !|r"
	L.big_add_message = "Gros add au %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "frFR")
if L then
	L.rays_spawn = "Apparition des rayons"
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog !" -- à traduire
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye !" -- à traduire
	L.red_add = "Add |c00FF0000rouge|r"
	L.blue_add = "Add |c000000FFbleu|r"
	L.clockwise = "Sens horaire"
	L.counter_clockwise = "Sens anti-horaire"
	L.death_beam = "Rayon mortel"

	L.custom_off_ray_controllers = "Contrôleurs de rayon"
	L.custom_off_ray_controllers_desc = "Utile les marqueurs de raid %s, %s, %s afin de marquer les personnes qui vont contrôler les positions d'apparition de rayon ainsi que leurs mouvements."
end

L = BigWigs:NewBossLocale("Primordius", "frFR")
if L then
	L.stream_of_blobs = "Flux de limons"
	L.mutations = "Mutations"
end

L = BigWigs:NewBossLocale("Dark Animus", "frFR")
if L then
	L.engage_trigger = "L'orbe explose !" -- à vérifier
	L.slam_message = "Heurt"
end

L = BigWigs:NewBossLocale("Iron Qon", "frFR")
if L then
	L.molten_energy = "Énergie magmatique"

	L.overload_casting = "Incantation de Surcharge de magma"
	L.overload_casting_desc = "Prévient quand Surcharge de magma est incanté."

	L.arcing_lightning_cleared = "Le raid est libéré de Foudre en arc"
end

L = BigWigs:NewBossLocale("Twin Consorts", "frFR")
if L then
	L.barrage_fired = "Barrage invoqué !"
	L.last_phase_yell_trigger = "Just this once..." -- à traduire
end

L = BigWigs:NewBossLocale("Lei Shen", "frFR")
if L then
	L.conduit_abilities = "Techniques du conduit"
	L.conduit_abilities_desc = "Barres approximatives des temps de recharge des techniques spécifiques au conduit."
	L.conduit_ability_meassage = "Proch. tech. du conduit"

	L.intermission = "Entracte"
	L.overchargerd_message = "Pulsation de zone étourdissante"
	L.static_shock_message = "Dégâts de zone à partager"
	L.diffusion_add_message = "Foudres diffuses"
	L.diffusion_chain_message = "Foudres diffuses imminentes - DISPERSEZ-VOUS !"
end

L = BigWigs:NewBossLocale("Ra-den", "frFR")
if L then

end
