local L = BigWigs:NewBossLocale("The Tarragrue", "frFR")
if not L then return end
if L then
	L.chains = "Chaînes" -- Chains of Eternity (Chains)
	L.remnants = "Vestiges" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Vestiage dommage physique"
	L.magic_remnant = "Vestige dommage magique"
	L.fire_remnant = "Vestiage dommage feu"
	L.fire = "Feu"
	L.magic = "Magique"
	L.physical = "Physique"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "frFR")
if L then
	L.chains = "Grappin" -- Short for Dragging Chains
	L.pool = "Flaque" -- Spreading Misery
	L.pools = "Flaques" -- Spreading Misery (multiple)
	L.death_gaze = "Regard de mort" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "frFR")
if L then
	L.fragments = "Fragments" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Fuit" -- Wings of Rage
	L.song = "Chant" -- Short for Song of Dissolution
	L.go_in = "Rassemblement" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Lames" -- Agatha's Eternal Blade
	L.big_bombs = "Impact" -- Daschla's Mighty Impact
	L.big_bomb = "Impact" -- Attached to the countdown
	L.shield = "Bouclier" -- Annhylde's Bright Aegis
	L.soaks = "Encaissé" -- Aradne's Falling Strike
	L.small_bombs = "Chant éploré" -- Brynja's Mournful Dirge
	L.recall = "Mot de rappel" -- Short for Word of Recall

	L.blades_yell = "Tombez devant mes lames!"
	L.soaks_yell = "Vous êtes complètement dépassé!"
	L.shield_yell = "Mon bouclier ne faiblira jamais!"

	L.berserk_stage1 = "Berserk Etape 1"
	L.berserk_stage2 = "Berserk Etape 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "frFR")
if L then
	L.cones = "Cones" -- Grasp of Malice
	L.orbs = "Orbes" -- Orb of Torment
	L.orb = "Orbe" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "frFR")
if L then
	L.custom_off_nameplate_defiance = "Icône sur les bars de nom lors du Tourment"
	 L.custom_off_nameplate_defiance_desc = "Affiche une icône sur les bars de nom des antreliges ayant le Tourment.\n\nIl est obligatoire d'utiliser l'affiche des bars de nom ennemie et d'addon de bar de nom compatible (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icône pour les bars de nom qui sont tourmentée"
	L.custom_off_nameplate_tormented_desc = "Affiche une icône sur les bar de nom des antreliges étant tourmentées.\n\nIl est obligatoire d'utiliser l'affiche des bars de nom ennemie et d'addon de bar de nom compatible (KuiNameplates, Plater)."

	L.cones = "Cones" -- Torment
	L.dance = "Dancer" -- Encore of Torment
	L.brands = "Marques" -- Brand of Torment
	L.brand = "Marque" -- Single Brand of Torment
	L.spike = "Agoniseur" -- Short for Agonizing Spike
	L.chains = "Chaines" -- Hellscream
	L.chain = "Chaine" -- Soul Manacles
	L.souls = "Ames" -- Rendered Soul

	L.chains_remaining = "%d Chaînes restantes"
	L.all_broken = "Toutes les chaines sont brisées"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "frFR")
if L then
	L.hammer = "Marteau" -- Short for Rippling Hammer
	L.axe = "Hache" -- Short for Cruciform Axe
	L.scythe = "Faux" -- Short for Dualblade Scythe
	L.trap = "Piège" -- Short for Flameclasp Trap
	L.chains = "Chaines" -- Short for Shadowsteel Chains
	L.embers = "Horreurs" -- Short for Shadowsteel Embers
	L.adds_embers = "Horreur (%d) - Prochaine vague!"
	L.adds_killed = "Vague terminée en %.2fs"
	L.spikes = "Balles cloutées" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les bars des techniques"
	L.custom_on_stop_timers_desc = "Le gardin peut temporisé ses techniques. Lorsque cette option est active, les bars pour ces techniques resteront sur votre écran."

	L.bomb_missed = "%dx noyaux ratés"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "frFR")
if L then
	L.rings = "Anneaux"
	L.rings_active = "Anneaux actif" -- for when they activate/are movable
	L.runes = "Runes"

	L.grimportent_countdown = "Compte à rebours"
	L.grimportent_countdown_desc = "Compte à rebours pour les joueurs qui sont affecté par Sombre Présage"
	L.grimportent_countdown_bartext = "Dans la rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "frFR")
if L then
	L.spikes = "Eclats" -- Short for Glacial Spikes
	L.spike = "Eclat"
	L.miasma = "Miasme" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Icon pour les bars de nom Ame Marquée"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur les bars de nom des Fidèle givre-liée qui sont fixé sur vous.\n\nIl est obligatoire d'utiliser l'affiche des bars de nom ennemie et d'addon de bar de nom compatible (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "frFR")
if L then
	L.chains_active = "Chaînes actives"
	L.chains_active_desc = "Affiché une bar quand la technique Chaînes de Domination est active"

	L.custom_on_nameplate_fixate = "Icon sur les bars de nom fixé"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur les bars de nom des Sentinelles sombre qui vous fixe.\n\nIl est obligatoire d'utiliser l'affiche des bars de nom ennemie et d'addon de bar de nom compatible (KuiNameplates, Plater)."

	L.chains = "Chaînes" -- Short for Domination Chains
	L.chain = "Chaîne" -- Single Domination Chain
	L.darkness = "Ténèbre" -- Short for Veil of Darkness
	L.arrow = "Flèche" -- Short for Wailing Arrow
	L.wave = "Vague" -- Short for Haunting Wave
	L.dread = "Effroi" -- Short for Crushing Dread
	L.orbs = "Orbes" -- Dark Communion
	L.curse = "Malédiction" -- Short for Curse of Lethargy
	L.pools = "Taches" -- Banshee's Bane
	L.scream = "Cri" -- Banshee Scream

	L.knife_fling = "Dagues volantes!" -- "Death-touched blades fling out"
end

