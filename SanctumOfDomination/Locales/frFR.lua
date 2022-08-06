local L = BigWigs:NewBossLocale("The Tarragrue", "frFR")
if not L then return end
if L then
	L.chains = "Chaînes" -- Chains of Eternity (Chains)
	L.remnants = "Vestige de tourments oubliés" -- Remnant of Forgotten Torments (Remnants)

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
	L.pool = "Piscine" -- Spreading Misery
	L.pools = "Piscines" -- Spreading Misery (multiple)
	--L.death_gaze = "Death Gaze" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "frFR")
if L then
	L.fragments = "Fragments" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Fuyez" -- Wings of Rage
	L.song = "Chanson" -- Short for Song of Dissolution
	L.go_in = "Rapprochez-vous" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Lames" -- Agatha's Eternal Blade
	L.big_bombs = "Grosse Bombes" -- Daschla's Mighty Impact
	L.big_bomb = "Grosse Bombe" -- Attached to the countdown
	L.shield = "Bouclier" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Petites Bombes" -- Brynja's Mournful Dirge
	L.recall = "Rappel" -- Short for Word of Recall

	L.blades_yell = "Tombez devant ma lame!"
	L.soaks_yell = "Vous êtes surclassés!"
	L.shield_yell = "Mon bouclier ne faiblit jamais!"

	L.berserk_stage1 = "Berserk Stage 1"
	L.berserk_stage2 = "Berserk Stage 2"

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
	-- L.custom_off_nameplate_defiance = "Defiance Nameplate Icon"
	-- L.custom_off_nameplate_defiance_desc = "Show an icon on the nameplate of Mawsworn that have Defiance.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	-- L.custom_off_nameplate_tormented = "Tormented Nameplate Icon"
	-- L.custom_off_nameplate_tormented_desc = "Show an icon on the nameplate of Mawsworn that have Tormented.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	L.cones = "Cônes" -- Torment
	L.dance = "Danse" -- Encore of Torment
  L.brands = "Marques" -- Brand of Torment
	L.brand = "Marque" -- Single Brand of Torment
	L.spike = "Spike" -- Short for Agonizing Spike
	L.chains = "Chaînes" -- Hellscream
	L.chain = "Chaîne" -- Soul Manacles
	L.souls = "Âmes" -- Rendered Soul

	L.chains_remaining = "%d Chaines restantes"
	L.all_broken = "Chaînes détruites"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "frFR")
if L then
	L.hammer = "Marteau" -- Short for Rippling Hammer
	L.axe = "Hache" -- Short for Cruciform Axe
	L.scythe = "Faux" -- Short for Dualblade Scythe
	L.trap = "Piège" -- Short for Flameclasp Trap
	L.chains = "Chaînes" -- Short for Shadowsteel Chains
	-- L.embers = "Embers" -- Short for Shadowsteel Embers
	-- L.adds_embers = "Embers (%d) - Adds Next!"
	L.adds_killed = "Adds tués en %.2fs"
	L.spikes = "Mort par les piques" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les techniques"
	L.custom_on_stop_timers_desc = "Le gardien peut retarder ses techniques. Quand cet option est activée, les bars pour ces techniques resteront à l'écran."

	-- L.bomb_missed = "%dx Bombs Missed"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "frFR")
if L then
	L.rings = "Anneaux"
	L.rings_active = "Anneaux actifs" -- for when they activate/are movable
	L.runes = "Runes"

	L.grimportent_countdown = "Compte à rebours"
	L.grimportent_countdown_desc = "Compte à rebours pour les joueurs affecté par Sombre Présage"
	L.grimportent_countdown_bartext = "Allez sur une rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "frFR")
if L then
	L.spikes = "Piques" -- Short for Glacial Spikes
	L.spike = "Pique"
	L.miasma = "Miasme" -- Short for Sinister Miasma

	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frostbound Devoted that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "frFR")
if L then
	L.chains_active = "Chaînes Active"
	L.chains_active_desc = "Affiche une barre quand les chaînes de domination s'active"

	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Dark Sentinels that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	L.chains = "Chaînes" -- Short for Domination Chains
	L.chain = "Chaîne" -- Single Domination Chain
	L.darkness = "Ténèbre" -- Short for Veil of Darkness
	L.arrow = "Flèche" -- Short for Wailing Arrow
	L.wave = "Vague" -- Short for Haunting Wave
	L.dread = "Terreur" -- Short for Crushing Dread
	L.orbs = "Orbes" -- Dark Communion
	L.curse = "Malédiction" -- Short for Curse of Lethargy
	L.pools = "Piscine" -- Banshee's Bane
	L.scream = "Hurlement" -- Banshee Scream

	L.knife_fling = "Couteaux prêt!" -- "Death-touched blades fling out"
end

