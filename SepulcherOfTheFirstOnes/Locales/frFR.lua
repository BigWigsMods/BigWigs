local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "frFR")
if not L then return end
if L then
	L.traps = "Pièges" -- Stasis Trap
	L.sparknova = "Nova éclair" -- Hyperlight Sparknova
	L.relocation = "Tank bombe" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Déchirures dimensionnelle" -- Interdimensional Wormholes
	L.wormhole = "Déchirure dimensionnelle" -- Interdimensional Wormhole
	L.rings = "Anneaux S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "frFR")
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.domination_core = "Add" -- Domination Core
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Anneaux" -- Disintegration Halo
	L.rings_x = "Anneaux x%d"
	L.rings_enrage = "Anneaux (Enrage)"
	L.ring_count = "Anneau (%d/%d)"

	L.shield_removed = "%s retiré après %.1fs" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Vents"
	L.wild_stampede = "Ruée sauvage"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main de la destruction"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	--L.protoform_cascade = "Frontal"
	--L.cosmic_shift = "Pushback"
	--L.unstable_mote = "Motes"
	--L.mote = "Mote"

	--L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	--L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate on Acquisitions Automa that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "frFR")
if L then
	L.custom_off_repeating_blasphemy = "Répétition de blasphème"
	L.custom_off_repeating_blasphemy_desc = "Répétition de blasphème écrit des messages avec les icônes {rt1}, {rt3} afin de trouver celui qui correspond à votre debuff."

	L.kingsmourne_hungers = "Deuilleroi"
	L.blasphemy = "Marque"
	L.befouled_barrier = "Barrière"
	L.wicked_star = "Étoile"
	L.domination_word_pain = "Mot de domination:Douleur"
	L.army_of_the_dead = "Armée des morts"
	--L.grim_reflections = "Fear Adds"
	L.march_of_the_damned = "Murs"
	L.dire_blasphemy = "Marque"
	L.beacon_of_hope = "Signal"

	L.remnant_active = "Vestige Actif"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.tank_combo_desc = "Timer avant Mâche-faille/Pourgendre lancé a 100 d'énergie."
end
