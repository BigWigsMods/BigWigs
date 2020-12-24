local L = BigWigs:NewBossLocale("Shriekwing", "frFR")
if not L then return end
if L then
	L.pickup_lantern = "%s a ramassé la lanterne !"
	L.dropped_lantern = "Lanterne posée par %s !"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "frFR")
if L then
	L.killed = "%s tué"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "frFR")
if L then
	L.stage2_yell = "Oh, celle-là, je meurs d'envie de la voir en action. Mais c'est plutôt vous qui allez mourir."
	L.stage3_yell = "J'espère que cette petite merveille sera aussi meurtrière qu'elle en a l'air."
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "frFR")
if L then
	L.times = "%dx %s"

	L.level = "%s (niveau |cffffff00%d|r)"
	L.full = "%s (|cffff0000PLEIN|r)"

	L.container_active = "Active conteneur : %s"

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
	L.macabre_start_emote = "Prenez place pour la danse macabre !" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Répéter Sombre Recital"
	L.custom_on_repeating_dark_recital_desc = "Répéter Sombre Recital en /dire avec les icones {rt1}, {rt2} pendant la danse."

	L.custom_off_select_boss_order = "Mark Boss Kill Order"
	L.custom_off_select_boss_order_desc = "Marque dans quel ordre le raid tuera les boss avec la croix {rt7}. Nécessite d'être assistant ou chef de raid."

	L.dance_assist = "Assistant danse"
	L.dance_assist_desc = "Affiche des alertes directionelles pour la phase de danse."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'avant |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dansez vers la droite |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dansez vers l'arrière |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dansez vers la gauche |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "entrechat" -- Faites un entrechat !
	L.dance_yell_right = "droite" -- On se trémousse à droite ! -or- On se trémousse vers la droite maintenant !
	L.dance_yell_down = "avant" -- En avant le boogie !
	L.dance_yell_left = "gauche" -- Déhanché à gauche !
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "frFR")
if L then
	L.first_blade = "Premier rebond"
	L.second_blade = "Deuxième rebond"

	L.skirmishers = "Tirailleuses" -- Short for Stone Legion Skirmishers (Tirailleuse de la Légion de pierre)

	L.custom_on_stop_timers = "Toujours montrer les barres de techniques"
	L.custom_on_stop_timers_desc = "En cours de test"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "frFR")
if L then
	L.add_spawn = "La Cabale cramoisie entend l'appel de Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d |4cumul:cumuls; : %d |4joueur:joueurs;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	--L.custom_on_repeating_nighthunter = "Repeating Night Hunter Yell"
	--L.custom_on_repeating_nighthunter_desc = "Repeating yell messages for the Night Hunter ability using icons {rt1} or {rt2} or {rt3} to find your line easier if you have to soak."

	--L.custom_on_repeating_impale = "Repeating Impale Say"
	--L.custom_on_repeating_impale_desc = "Repeating say messages for the Impale ability using '1' or '22' or '333' or '4444' to make it clear in what order you will be hit."

	--L.hymn_stacks = "Nathrian Hymn"
	--L.hym_stacks_desc = "Alerts for the amount of Nathrian Hymn stacks currently on you."

	--L.ravage_target = "Ravage Target Cast Bar"
	--L.ravage_target_desc = "Display a cast bar showing the time until the Ravage Target location is chosen in stage 3."
end
