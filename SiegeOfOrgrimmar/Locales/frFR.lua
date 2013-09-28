local L = BigWigs:NewBossLocale("Immerseus", "frFR")
if not L then return end
if L then
	L.win_yell = "Ah, vous avez réussi !"
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "frFR")
if L then
	L.defile = "Incant. de Sol profané"

	L.custom_off_bane_marks = "Marquage Mot de l'ombre : Plaie"
	L.custom_off_bane_marks_desc = "Afin d'aider à l'attribution des dissipations, marque les personnes initialement touchées par Mot de l'ombre : Plaie avec %s%s%s%s%s (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."

	L.no_meditative_field = "PAS de Champ de méditation !"

	L.intermission = "Mesures désespérées"
	L.intermission_desc = "Prévient quand l'un des boss est sur le point d'utiliser ses Mesures désespérées."

	L.inferno_self = "Frappe du feu d'enfer"
	L.inferno_self_desc = "Compte à rebours spécial quand la Frappe du feu d'enfer est sur vous."
	L.inferno_self_bar = "Vous explosez !"
end

L = BigWigs:NewBossLocale("Norushen", "frFR")
if L then
	L.pre_pull = "Début du combat"
	L.pre_pull_desc = "Barre de délai de l'événement RP avant l'engagement du boss."
	L.pre_pull_trigger = "Très bien, je vais créer un champ de force qui contiendra votre corruption."

	L.big_adds = "Manifestations de la corruption"
	L.big_adds_desc = "Warning for killing big adds inside/outside"
	L.big_add = "Manifestation de la corruption (%d)"
	L.big_add_killed = "Manifestation de la corruption tuée ! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "frFR")
if L then
	L.custom_off_titan_mark = "Marquage Don des titans"
	L.custom_off_titan_mark_desc = "Marque les joueurs sous l'effet de Don des titans avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}. Nécessite d'être assistant ou chef de raid.\n|cFFFF0000Seule 1 personne du raid doit activer ceci afin d'éviter les conflits de marquage.|r"

	L.projection_message = "Allez sur la flèche |cFF00FF00VERTE|r !"
	L.projection_explosion = "Explosion de la projection"

	L.big_add_bar = "Manifestation de l'orgueil"
	L.big_add_spawning = "Apparition d'une Manifestation de l'orgueil !"
	L.small_adds = "Reflets d'orgueil"

	L.titan_pride = "Titan+Pride : %s"
end

L = BigWigs:NewBossLocale("Galakras", "frFR")
if L then
	L.demolisher = "Démolisseur"
	L.demolisher_desc = "Délais avant que les Démolisseurs kor’kron ne se joignent au combat."

	L.towers = "Tours"
	L.towers_desc = "Alertes quand les portes des tours sont détruites."
	L.south_tower_trigger = "La porte qui barrait l’accès à la tour sud a été détruite !"
	L.south_tower = "Tour sud"
	L.north_tower_trigger = "La porte qui barrait l’accès à la tour nord a été détruite !"
	L.north_tower = "Tour nord"
	L.tower_defender = "Défenseur de la tour"

	L.custom_off_shaman_marker = "Marquages Chaman des marées"
	L.custom_off_shaman_marker_desc = "Afin d'aider à l'attribution des interruptions, marque les Chamans des marées gueule-de-dragon avec %s%s%s%s%s%s%s (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "frFR")
if L then
	L.custom_off_mine_marks = "Marquage Mine rampante"
	L.custom_off_mine_marks_desc = "Afin d'aider à l'attribution des soaking, tente de marquer les Mines rampantes avec %s%s%s%s%s (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "frFR")
if L then
	L.blobs = "Gelées"

	L.custom_off_mist_marks = "Marquage Brume toxique"
	L.custom_off_mist_marks_desc = "Afin d'aider à l'attribution des soins, marque les joueurs ayant Brume toxique avec %s%s%s%s%s%s (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées)(les tanks ne sont pas marqués). Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("General Nazgrim", "frFR")
if L then
	L.custom_off_bonecracker_marks = "Marquage Brise-os"
	L.custom_off_bonecracker_marks_desc = "Afin d'aider à l'attribution des soins, marque les joueurs ayant Brise-os avec (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."

	L.stance_bar = "%s(ACTUELLE : %s)"
	-- shorten stances so they fit on the bars
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

	L.chain_heal_message = "Votre focalisation est en train d'incanter Salve de guérison !"

	L.arcane_shock_message = "Votre focalisation est en train d'incanter Horion des Arcanes !"

	L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "frFR")
if L then
	L.custom_off_energy_marks = "Marquage Énergie déplacée"
	L.custom_off_energy_marks_desc = "Afin d'aider à l'attribution des dissipations, marque les joueurs ayant Énergie déplacée avec %s%s%s%s%s%s%s (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "frFR")
if L then
	L.win_trigger = "Système en cours de réinitialisation. Veuillez ne pas le débrancher, ou il pourrait vous sauter à la figure." -- to check

	L.enable_zone = "Entrepôt de l’Artéfact"
	L.matter_scramble_explosion = "Explosion Brouillage de la matière" -- shorten maybe?

	L.custom_off_mark_brewmaster = "Marquage Maître brasseur"
	L.custom_off_mark_brewmaster_desc = "Marque l'Esprit d'ancien maître brasseur avec %s."
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "frFR")
if L then
	L.tank_debuffs = "Affaiblissements tank"
	L.tank_debuffs_desc = "Alertes concernant les différents types d'affaiblisement de tank associés avec Rugissement effroyable."

	L.cage_opened = "Cage ouverte"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "frFR")
if L then
	L.shredder_engage_trigger = "Un déchiqueteur automatisé approche !"
	L.laser_on_you = "Laser sur vous PIOU PIOU !"
	L.laser_say = "Laser PIOU PIOU !"

	L.assembly_line_trigger = "Des armes non terminées commencent à avancer sur la chaîne d’assemblage."
	L.assembly_line_message = "Armes non terminées (%d)"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!" -- to translate
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "frFR")
if L then
	-- for getting all those calculate emotes:
	-- cat Transcriptor.lua | sed "s/\t//g" | grep -E "(CHAT_MSG_RAID_BOSS_EMOTE].*Iyyokuk)" | sed "s/.*EMOTE//" | sed "s/#/\"/" | sed "s/#.*/\"/" | sort | uniq
	L.one = "Iyyokuk selects: One !"
	L.two = "Iyyokuk selects: Two !"
	L.three = "Iyyokuk selects: Three !"
	L.four = "Iyyokuk selects: Four !"
	L.five = "Iyyokuk selects: Five !"
	--------------------------------
	L.edge_message = "Vous êtes un edge"
	L.custom_off_edge_marks = "Marquages Edge"
	L.custom_off_edge_marks_desc = "Marque les joueurs qui seront les edges based on the calculations %s%s%s%s%s%s. Nécessite d'être assistant ou chef de raid."
	L.injection_over_soon = "Injection bientôt terminée (%s) !"
	L.custom_off_mutate_marks = "Marquage Mutation : scorpion d'ambre"
	L.custom_off_mutate_marks_desc = "Afin d'aider à l'attribution des soins, marque les joueurs ayant Mutation : scorpion d'ambre avec %s%s%s. Nécessite d'être assistant ou chef de raid."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "frFR")
if L then
	L.intermission = "Intervalle"
	L.mind_control = "Contrôle mental"

	L.chain_heal_desc = "Rend 40% de ses points de vie maximum à une cible alliée et se propage aux cibles alliées à proximité."
	L.chain_heal_message = "Votre focalisation est en train d'incanter Salve de guérison !"
	L.chain_heal_bar = "Focalisation : Salve de guérison"

	L.farseer_trigger = "Long-voyants, soignez nos blessures !"
	L.custom_off_shaman_marker = "Marquage Chevaucheur de loup long-voyant"
	L.custom_off_shaman_marker_desc = "Afin d'aider à l'attribution des interruptions, marque les Chevaucheurs de loup long-voyant avec {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (dans cet ordre)(il se peut que toutes les marques ne soient pas utilisées). Nécessite d'être assistant ou chef de raid."

	L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "frFR")
if L then

end

