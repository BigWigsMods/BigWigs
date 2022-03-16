local L = BigWigs:NewBossLocale("Vigilant Guardian", "frFR")
if not L then return end
if L then
	-- L.sentry = "Tank Add"
	-- L.materium = "Small Adds"
	-- L.shield = "Shield" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.tank_combo_desc = "Timer pour les cast de Mâche-faille/Pourfendre à 100 d'energie."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "frFR")
if L then
	L.traps = "Pièges" -- Stasis Trap
	L.sparknova = "Nova éclair" -- Hyperlight Sparknova
	L.relocation = "Bombe sur le tank" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Tunnels spatiotemporels" -- Interdimensional Wormholes
	L.wormhole = "Tunnel spatiotemporel" -- Interdimensional Wormhole
	L.rings = "Anneaux S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "frFR")
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.domination_core = "Add" -- Domination Core
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Anneaux" -- Disintegration Halo
	L.rings_x = "Anneaux x%d"
	L.rings_enrage = "Anneaux (Enragé)"
	L.ring_count = "Anneau (%d/%d)"

	--L.custom_on_ring_timers = "Individual Halo Timers"
	--L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."

	L.shield_removed = "%s retiré au bout de %.1fs" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Rafale"
	L.wild_stampede = "Ruée"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Poussée"
	--L.cosmic_shift_mythic = "Shift: %s"
	L.unstable_mote = "Granules"
	L.mote = "Granule"

	L.custom_on_nameplate_fixate = "Icône de barre d'unité fixée"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur la barre de nom d'unité des Automas pourvoyeurs qui vous fixent.\n\nNécessite d'avoir activé les barres de noms des unités ennemies et un addon de barres de noms compatible (KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "frFR")
if L then
	L.custom_off_repeating_blasphemy = "Répéter Blasphème"
	L.custom_off_repeating_blasphemy_desc = "Répéter Blasphème affiche un message en /dire avec les icônes {rt1}, {rt3} pour trouver une marque permettant d'enlever le débuff."

	L.kingsmourne_hungers = "Deuilleroi"
	L.blasphemy = "Marques"
	L.befouled_barrier = "Barrière"
	L.wicked_star = "Etoile"
	L.domination_word_pain = "MD : Douleur"
	L.army_of_the_dead = "Armée"
	L.grim_reflections = "Adds qui fear"
	L.march_of_the_damned = "Murs"
	L.dire_blasphemy = "Marques"
	L.beacon_of_hope = "Signal"

	L.remnant_active = "Vestige actif"
end

L = BigWigs:NewBossLocale("The Jailer", "frFR")
if L then
	--L.rune_of_damnation_countdown = "Countdown"
	--L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	--L.jump = "Jump In"

	--L.chain = "Chain"
	--L.rune = "Rune"

	--L.chain_target = "Chaining %s!"
	--L.chains_remaining = "%d/%d Chains Broken"

	--L.chains_of_oppression = "Pull Chains"
	--L.unholy_attunement = "Pylons"
	--L.chains_of_anguish = "Spread Chains"
	--L.rune_of_damnation = "Knock Runes"
	--L.rune_of_compulsion = "MC Runes"
	--L.rune_of_domination = "Heal Runes"
end
