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
	L.orb_message = "Orbe de contrôle lâchée !"

	L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "frFR")
if L then
	L.priestess_adds = "Adds de la prêtresse"
	L.priestess_adds_desc = "Prévient de l'arrivée des différents genres de renforts de la Grande prêtresse Mar'li."
	L.priestess_adds_message = "Add de la prêtresse"

	L.assault_stun = "Tank étourdi !"
	L.full_power = "Puissance maximale"
	L.assault_message = "Assaut"
	L.hp_to_go_power = "%d%% de PV à faire ! (Puissance : %d)"
	L.hp_to_go_fullpower = "%d%% de PV à faire ! (Puissance maximale)"

	L.custom_on_markpossessed = "Marquage du boss possédé"
	L.custom_on_markpossessed_desc = "Marque le boss possédé à l'aide d'une icône de crâne."
end

L = BigWigs:NewBossLocale("Tortos", "frFR")
if L then
	L.kick = "Coup de pied"
	L.kick_desc = "Effectue un suivi du nombre de tortues qui peuvent être bottées."
	L.kick_message = "Tortues à botter : %d"

	L.custom_off_turtlemarker = "Marqueur de tortue"
	L.custom_off_turtlemarker_desc = "Marque les tortues en utilisant toutes les icônes de raid.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the turtles is the fastest way to mark them.|r"

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
	L.lower_hatch_trigger = "Les œufs de l'un des nids inférieurs commencent à éclore !" -- à vérifier
	L.upper_hatch_trigger = "Les œufs de l'un des nids supérieurs commencent à éclore !" -- à vérifier

	L.nest = "Nids"
	L.nest_desc = "Alertes relatives aux nids. |cffff0000Décochez ceci pour désactiver les alertes si vous n'êtes pas assigné à la gestion des nids !|r"

	L.flight_over = "Vol terminé dans %d sec !"
	L.upper_nest = "Nid |cff008000supérieur|r"
	L.lower_nest = "Nid |cffff0000inférieur|r"
	L.up = "UP"
	L.down = "DOWN"
	L.add = "Add"
	L.big_add_message = "Gros add au %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "frFR")
if L then
	L.red_spawn_trigger = "La Lumière infrarouge révèle une brume écarlate !" -- à vérifier
	L.blue_spawn_trigger = "Les Rais bleus révèlent une brume azur !" -- à vérifier
	L.yellow_spawn_trigger = "The Bright Light reveals an Amber Fog!"

	L.adds = "Bêtes de brume révélées"
	L.adds_desc = "Alertes quand vous révélez une Brume écarlate, d'ambre ou azur et combien de Brumes écarlates il reste."

	L.custom_off_ray_controllers = "Contrôleurs de rayon"
	L.custom_off_ray_controllers_desc = "Utile les marqueurs de raid %s%s%s afin de marquer les personnes qui vont contrôler les positions d'apparition de rayon ainsi que leurs mouvements.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.custom_off_parasite_marks = "Dark parasite marker"
	L.custom_off_parasite_marks_desc = "To help healing assignments, mark the people who have dark parasite on them with %s%s%s.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.initial_life_drain = "Initial Life Drain cast"
	L.initial_life_drain_desc = "Message for the initial Life Drain cast to help keeping up healing received reducing debuff."

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

	L.custom_off_spear_target = "Throw Spear Target"
	L.custom_off_spear_target_desc = "Try to warn for the Throw Spear target. This method is high on CPU usage and sometimes displays the wrong target so it is disabled by default.\n|cFFADFF2FTIP: Setting up TANK roles should help to increase the accuracy of the warning.|r"
	L.possible_spear_target = "Possible Spear?"
end

L = BigWigs:NewBossLocale("Twin Consorts", "frFR")
if L then
	L.barrage_fired = "Barrage invoqué !"
	L.last_phase_yell_trigger = "D'accord, pour cette fois..." -- à vérifier
end

L = BigWigs:NewBossLocale("Lei Shen", "frFR")
if L then
	L.conduit_abilities = "Techniques du conduit"
	L.conduit_abilities_desc = "Barres approximatives des temps de recharge des techniques spécifiques au conduit."
	L.conduit_abilities_message = "Proch. tech. du conduit"

	L.intermission = "Entracte"
	L.diffusion_add = "Foudres diffuses"
	L.shock = "Horion"

	L.overcharged_message = "Pulsation de zone étourdissante"
	L.static_shock_message = "Dégâts de zone à partager"
	L.diffusion_add_message = "Foudres diffuses"
	L.diffusion_chain_message = "Foudres diffuses imminentes - DISPERSEZ-VOUS !"
end

L = BigWigs:NewBossLocale("Ra-den", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Trash", "frFR")
if L then
	L.stormcaller = "Mande-foudre zandalari"
	L.stormbringer = "Porte-tempête Draz’kil"
	L.monara = "Monara"
end

