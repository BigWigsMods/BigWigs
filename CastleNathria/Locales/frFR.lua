local L = BigWigs:NewBossLocale("Shriekwing", "frFR")
if not L then return end
if L then
	L.pickup_lantern = "%s a ramassé la lanterne !"
	L.dropped_lantern = "Lanterne posée par %s !"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "frFR")
if L then
	L.killed = "%s tué"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "frFR")
if L then
	L.shield_remaining = "%s restant : %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "frFR")
if L then
	L.miasma = "Miasme" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Répéter Vie sous Miasme en /crier"
	L.custom_on_repeating_yell_miasma_desc = "Répète des messages en /crier pour Miasme glouton afin d'indiquer aux autres quand vous êtes en dessous de 75% de vie."

	L.custom_on_repeating_say_laser = "Répéter Expulsion instable en /dire"
	L.custom_on_repeating_say_laser_desc = "Répète des messages en /dire pour Expulsion instable afin de vous aider quand vous vous déplacez à portée de discussion des joueurs qui n'ont pas vu votre premier message."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "frFR")
if L then
	L.tear = "Déchirure" -- Short for Dimensional Tear
	L.spirits = "Esprits" -- Short for Fleeting Spirits
	L.seeds = "Graines" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "frFR")
if L then
	L.times = "%dx %s"

	L.level = "%s (niveau |cffffff00%d|r)"
	L.full = "%s (|cffff0000PLEIN|r)"

	L.anima_adds = "Adds de l'Anima concentré"
	L.anima_adds_desc = "Affiche un délai indiquant quand les adds apparaissent des affaiblissements de Anima concentré."

	L.custom_off_experimental = "Activer les options expérimentales"
	L.custom_off_experimental_desc = "Ces options |cffff0000ne sont pas testées|r et pourraient |cffff0000spam|r."

	L.anima_tracking = "Suivi de l'anima |cffff0000(expérimental)|r"
	L.anima_tracking_desc = "Messages et barres pour suivre le niveau d'anima dans les conteneurs.|n|cffaaff00Astuce : vous pouvez désactiver les barres et boites d'infos si besoin."

	L.custom_on_stop_timers = "Toujours montrer les barres de techniques"
	L.custom_on_stop_timers_desc = "En cours de test"

	L.desires = "Désirs"
	L.bottles = "Bouteilles"
	L.sins = "Vices"
end

L = BigWigs:NewBossLocale("The Council of Blood", "frFR")
if L then
	L.custom_on_repeating_dark_recital = "Répéter Sombre Recital"
	L.custom_on_repeating_dark_recital_desc = "Répéter Sombre Recital en /dire avec les icônes {rt1}, {rt2} pendant la danse."

	L.custom_off_select_boss_order = "Marquage Ordre de kill des boss"
	L.custom_off_select_boss_order_desc = "Marque dans quel ordre le raid tuera les boss avec la croix {rt7}. Nécessite d'être assistant ou chef de raid."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "Assistant danse"
	L.dance_assist_desc = "Affiche des alertes directionelles pour la phase de danse."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'avant |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dansez vers la droite |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'arrière |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dansez vers la gauche |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Faites un entrechat" -- Faites un entrechat !
	L.dance_yell_right = "On se trémousse" -- On se trémousse à droite ! -or- On se trémousse vers la droite maintenant !
	L.dance_yell_down = "En avant le boogie" -- En avant le boogie !
	L.dance_yell_left = "Déhanché à gauche" -- Déhanché à gauche !
end

L = BigWigs:NewBossLocale("Sludgefist", "frFR")
if L then
	L.stomp_shift = "Piétinement & Transfert" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Info des dégâts"
	L.fun_info_desc = "Affiche un message indiquant combien de vie le boss a perdu durant Impact destructeur."

	L.health_lost = "Fangepoing a perdu %.1f%% !"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "frFR")
if L then
	L.first_blade = "Premier rebond"
	L.second_blade = "Deuxième rebond"

	L.skirmishers = "Tirailleuses" -- Short for Stone Legion Skirmishers (Tirailleuse de la Légion de pierre)
	L.eruption = "Éruption" -- Short for Reverberating Eruption

	L.custom_on_stop_timers = "Toujours montrer les barres de techniques"
	L.custom_on_stop_timers_desc = "En cours de test"

	L.goliath_short = "Goliath"
	L.goliath_desc = "Affiche des alertes et des délais indiquant quand le Goliath vive-pierre est sur le point d'apparaître."

	L.commando_short = "Commando"
	L.commando_desc = "Affiche des alertes quand un Commando de la Légion de pierre est tué."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "frFR")
if L then
	L.infobox_stacks = "%d |4cumul:cumuls; : %d |4joueur:joueurs;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Répéter Chasseur nocture en /cri"
	L.custom_on_repeating_nighthunter_desc = "Répète des messages en /cri pour Chasseur nocture en utilisant les icônes {rt1}, {rt2} ou {rt3} afin de trouver plus facilement votre ligne si vous devez soak."

	L.custom_on_repeating_impale = "Répéter Empaler en /dire"
	L.custom_on_repeating_impale_desc = "Répète des messages en /dire pour Empaler en utilisant '1', '22', '333' ou '4444' afin d'indiquer dans quel ordre vous serez touché."

	L.hymn_stacks = "Hymne nathrian"
	L.hymn_stacks_desc = "Alertes indiquant les cumuls de Hymne nathrian que vous avez sur vous."

	L.ravage_target = "Barre d'incantation cible de Reflet : Ravage"
	L.ravage_target_desc = "Barre d'incantation indiquant le temps avant que le reflet ne cible un emplacement pour Ravage."
	L.ravage_targeted = "Ravage ciblé" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sans Miroir : %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Miroir : %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "frFR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon massif"
	L.hawkeye = "Oeil-de-faucon nathrian"
	L.overseer = "Surveillante des Chenils"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Festoyeur de l'effroi"
	L.rat = "Rat de taille inhabituelle"
	L.miasma = "Miasme" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquaire sinistre"
	L.conservator = "Conservateur nathrian"
	L.archivist = "Archiviste nathriane"
	L.hierarch = "Hiérarque de la cour"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliath vive-pierre"
end

L = BigWigs:NewBossLocale("Castle Nathria Affixes", "frFR")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	L.creation_spark = "Etincelles"
	L.protoform_barrier = "Barrière"
	--L.reconfiguration_emitter = "Interrupt Add"
end
