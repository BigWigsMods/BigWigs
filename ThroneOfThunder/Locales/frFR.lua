local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "frFR")
if not L then return end
if L then
	L.storm_duration = "Durée de Tempête de foudre"
	L.storm_duration_desc = "Une barre d'alerte à part pour la durée d'incantation de Tempête de foudre."

	L.in_water = "Vous êtes dans l'eau !"
end

L = BigWigs:NewBossLocale("Horridon", "frFR")
if L then
	L.orb_message = "Orbe de contrôle lâchée !"

	L.chain_lightning_warning = "Votre focalisation est entrain d'incanter Chaîne d'éclairs !"
	L.chain_lightning_bar = "Focalisation : Chaîne d'éclairs"

	L.fireball_warning = "Votre focalisation est en train d'incanter Boule de feu !"
	L.fireball_bar = "Focalisation : Boule de feu"

	L.venom_bolt_volley_desc = "|cFFFF0000ATTENION : seul le délai de votre cible de 'focalisation' sera affiché car tous les incantateurs de Salve ont des temps de recharge distincts.|r "..select(2, EJ_GetSectionInfo(7112))
	L.venom_bolt_volley_warning = "Votre focalisation est en train d'incanter Salve !"
	L.venom_bolt_volley_bar = "Focalisation : Salve"

	L.puncture_message = "Perforation"
end

L = BigWigs:NewBossLocale("Council of Elders", "frFR")
if L then
	L.full_power = "Puissance maximale"

	L.assault_message = "Assaut"

	L.loa_kills = "Loa kills : %s"
	L.priestess_add = "Priestess add"
	L.priestess_adds = "Priestess adds"
	L.priestess_adds_desc = "Warning for all kinds of adds from High Priestess Mar'li"
	L.hp_to_go_power = "PV à faire : %d%% - Puissance : %d"
end

L = BigWigs:NewBossLocale("Tortos", "frFR")
if L then
	L.kick = "Coup de pied"
	L.kick_desc = "Effectue un suivi du nombre de tortues qui peuvent être bottées."
	L.kickable_turtles = "Tortues à botter : %d"
	L.crystal_shell_removed = "Carapace de cristal enlevé !"
	L.no_crystal_shell = "PAS de Carapace de cristal"
end

L = BigWigs:NewBossLocale("Megaera", "frFR")
if L then
	L.breaths = "Souffles"
	L.breaths_desc = "Alertes relatives aux différents types de souffles."
	L.rampage_over = "Saccager terminé !"
	L.arcane_adds = "Arcane adds"
end

L = BigWigs:NewBossLocale("Ji-Kun", "frFR")
if L then
	L.flight_over = "Vol terminé"
	L.young_egg_hatching = "Éclosion d'un jeune œuf"
	L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch !" -- à traduire
	L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch !" -- à traduire
	L.upper_nest = "Nid |c00008000supérieur|r"
	L.lower_nest = "Nid |c00FF0000inférieur|r"
	L.food_call_trigger = "Hatchling calls for food !" -- à traduire
	L.nest = "Nids"
	L.nest_desc = "Alertes relatives aux nids. |c00FF0000Décochez ceci pour désactiver les alertes si vous n'êtes pas assigné à la gestion des nids !|r"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "frFR")
if L then
	L.rays_spawn = "Apparition des rayons"
	L.ray_controller = "Contrôleur de rayon"
	L.ray_controller_desc = "Annonce les contrôleurs de la direction des rayons rouge et bleu."
	L.red_ray_controller = "Vous êtes le contrôleur du rayon |c000000FFbleu|r"
	L.blue_ray_controller = "Vous êtes le contrôleur du rayon |c00FF0000rouge|r"
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog !" -- à traduire
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye !" -- à traduire
	L.red_add = "Add |c00FF0000rouge|r"
	L.blue_add = "Add |c000000FFbleu|r"
	L.clockwise = "Sens horaire"
	L.counter_clockwise = "Sens anti-horaire"
	L.death_beam = "Rayon mortel"
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
end

L = BigWigs:NewBossLocale("Twin Consorts", "frFR")
if L then
	L.barrage_fired = "Barrage fired!"
end

L = BigWigs:NewBossLocale("Lei Shen", "frFR")
if L then
	L.conduit_abilities = "Techniques du conduit"
	L.conduit_abilities_desc = "Barres approximatives des temps de recharge des techniques spécifiques au conduit."
	L.conduit_ability_meassage = "Proch. tech. du conduit"
	L.intermission = "Entracte"
	L.overchargerd_message = "Stunning AoE pulse"
	L.static_shock_message = "Splitting AoE damege"
	L.diffusion_add_message = "Diffusion adds"
	L.diffusion_chain_message = "Diffusion adds soon - SPREAD !"
end

L = BigWigs:NewBossLocale("Ra-den", "frFR")
if L then

end
