local L = BigWigs:NewBossLocale("The Tarragrue", "frFR")
if not L then return end
if L then
	L.chains = "Chaînes" -- Chains of Eternity (Chains)
	L.remnants = "Vestiges de tourment oubliés" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Vestige Physique"
	L.magic_remnant = "Vestige Magique"
	L.fire_remnant = "Vestige de Feu"
	L.fire = "Feu"
	L.magic = "Magique"
	L.physical = "Physique"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "frFR")
if L then
	L.chains = "Chaînes" -- Short for Dragging Chains
	L.pool = "Pool" -- Spreading Misery
	L.pools = "Pools" -- Spreading Misery (multiple)
	L.death_gaze = "Rayon" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "frFR")
if L then
	L.fragments = "Fragments" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Fuyez" -- Wings of Rage
	L.song = "Chant" -- Short for Song of Dissolution
	L.go_in = "Rentrez" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Lames d'Agatha" -- Agatha's Eternal Blade
	L.big_bombs = "Grosses Bombes" -- Daschla's Mighty Impact
	L.big_bomb = "Grosse Bombe" -- Attached to the countdown
	L.shield = "Shield" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Petites Bombes" -- Brynja's Mournful Dirge
	L.recall = "Rappel" -- Short for Word of Recall

	L.blades_yell = "Tombez sous ma lame !"
	L.soaks_yell = "Vous êtes tous surpassés !"
	L.shield_yell = "Mon bouclier ne faiblit jamais !"

	L.berserk_stage1 = "Berserk 1"
	L.berserk_stage2 = "Berserk 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "frFR")
if L then
	L.cones = "Cônes" -- Grasp of Malice
	L.orbs = "Orbes" -- Orb of Torment
	L.orb = "Orbe" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "frFR")
if L then
	L.custom_off_nameplate_defiance = "Icône de Résistance"
	L.custom_off_nameplate_defiance_desc = "Affiche une icône au dessus du Suzerain antrelige si il est affecté par Résistance.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icône de Tourmenté"
	L.custom_off_nameplate_tormented_desc = "Affiche une icône au dessus du Suzerain antrelige si il est affecté par Tourment.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	L.cones = "Cônes" -- Torment
	L.dance = "Dance" -- Encore of Torment
	L.brands = "Marques" -- Brand of Torment
	L.brand = "Marque" -- Single Brand of Torment
	L.spike = "Nova" -- Short for Agonizing Spike
	L.chains = "Chaînes" -- Hellscream
	L.chain = "Chaînes" -- Soul Manacles
	L.souls = "Âmes" -- Rendered Soul

	L.chains_remaining = "%d Chaînes restantes"
	L.all_broken = "Chaînes Cassées"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "frFR")
if L then
	L.hammer = "Marteau" -- Short for Rippling Hammer
	L.axe = "Hâche" -- Short for Cruciform Axe
	L.scythe = "Faux" -- Short for Dualblade Scythe
	L.trap = "Pièges" -- Short for Flameclasp Trap
	L.chains = "Chaînes" -- Short for Shadowsteel Chains
	L.embers = "Braises" -- Short for Shadowsteel Embers
	L.adds_embers = "Braises (%d) - Puis Adds !"
	L.adds_killed = "Adds tués en %.2fs"
	L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les barres de compétence"
	L.custom_on_stop_timers_desc = "Il se peut que les timers soient décalés selon le déroulement du combnat. Quand cette option est activée, les compétences utilisées par le boss resteront affichées."

	L.bomb_missed = "%dx Bombes Râtées"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "frFR")
if L then
	L.rings = "Anneaux"
	L.rings_active = "Anneaux Actifs" -- for when they activate/are movable
	L.runes = "Runes"

	L.grimportent_countdown = "Décompte"
	L.grimportent_countdown_desc = "Countdown for the players who are Affected by Sombre Présage"
	L.grimportent_countdown_bartext = "Allez sur une Rune !"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "frFR")
if L then
	L.spikes = "Piques de Glace" -- Short for Glacial Spikes
	L.spike = "Pique de Glace"
	L.miasma = "Miasme" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Icône de Fixation"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône au dessus du Fidèle givre-lié si vous êtes sa cible.\n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "frFR")
if L then
	L.chains_active = "Chaînes Actives"
	L.chains_active_desc = "Affiche une barre quand les chaînes de domination sont activées"

	L.custom_on_nameplate_fixate = "Icône de Rage"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône au dessus de la Sentinelle sombre si vous êtes sa cible. \n\nNécessite un addon de Nameplates (KuiNameplates, Plater)."

	L.chains = "Chaînes" -- Short for Domination Chains
	L.chain = "Chaîne" -- Single Domination Chain
	L.darkness = "Voile" -- Short for Veil of Darkness
	L.arrow = "Flèche" -- Short for Wailing Arrow
	L.wave = "Vague" -- Short for Haunting Wave
	L.dread = "Effroi" -- Short for Crushing Dread
	L.orbs = "Orbes" -- Dark Communion
	L.curse = "Malédiction" -- Short for Curse of Lethargy
	L.pools = "Fléau" -- Banshee's Bane
	L.scream = "Cri" -- Banshee Scream

	L.knife_fling = "Poignards, Sortez !" -- "Death-touched blades fling out"
end
