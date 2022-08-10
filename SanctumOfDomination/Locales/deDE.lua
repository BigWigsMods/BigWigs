local L = BigWigs:NewBossLocale("The Tarragrue", "deDE")
if not L then return end
if L then
	L.chains = "Ketten" -- Chains of Eternity (Chains)
	L.remnants = "Überreste" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Physischer Überrest"
	L.magic_remnant = "Magischer Überest"
	L.fire_remnant = "Feuer-Überrest"
	L.fire = "Feuer"
	L.magic = "Magisch"
	L.physical = "Physisch"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "deDE")
if L then
	L.chains = "Ketten" -- Short for Dragging Chains
	L.pool = "Lache" -- Spreading Misery
	L.pools = "Lachen" -- Spreading Misery (multiple)
	L.death_gaze = "Todesblick" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "deDE")
if L then
	L.fragments = "Fragmente" -- Short for Fragments of Destiny
	L.fragment = "Fragment" -- Singular Fragment of Destiny
	L.run_away = "Lauf weg" -- Wings of Rage
	L.song = "Lied" -- Short for Song of Dissolution
	L.go_in = "Lauf rein" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Klingen" -- Agatha's Eternal Blade
	L.big_bombs = "Große Bomben" -- Daschla's Mighty Impact
	L.big_bomb = "Große Bombe" -- Attached to the countdown
	L.shield = "Schild" -- Annhylde's Bright Aegis
	L.soaks = "Abfangen" -- Aradne's Falling Strike
	L.small_bombs = "Kleine Bomben" -- Brynja's Mournful Dirge
	L.recall = "Rückruf" -- Short for Word of Recall

	L.blades_yell = "Fallt durch meine Klinge!"
	L.soaks_yell = "Ihr seid alle unterlegen!"
	L.shield_yell = "Mein Schild versagt nie!"

	L.berserk_stage1 = "Berserker Phase 1"
	L.berserk_stage2 = "Berserker Phase 2"

	--L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "deDE")
if L then
	L.cones = "Kegel" -- Grasp of Malice
	L.orbs = "Kugeln" -- Orb of Torment
	L.orb = "Kugel" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "deDE")
if L then
	L.custom_off_nameplate_defiance = "Trotz Namensplakettensymbol"
	L.custom_off_nameplate_defiance_desc = "Zeigt ein Symbol an der Namensplakette der mit Trotz belegten Schlundgebundenen.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Gequält Namensplakettensymbol"
	L.custom_off_nameplate_tormented_desc = "Zeigt ein Symbol an der Namensplakette der gequälten Schlundgebundenen.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.cones = "Kegel" -- Torment
	L.dance = "Tanz" -- Encore of Torment
	L.brands = "Male" -- Brand of Torment
	L.brand = "Mal" -- Single Brand of Torment
	L.spike = "Stachel" -- Short for Agonizing Spike
	L.chains = "Ketten" -- Hellscream
	L.chain = "Kette" -- Soul Manacles
	L.souls = "Seelen" -- Rendered Soul

	L.chains_remaining = "%d Ketten übrig"
	L.all_broken = "Alle Ketten gebrochen"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "deDE")
if L then
	L.hammer = "Hammer" -- Short for Rippling Hammer
	L.axe = "Axt" -- Short for Cruciform Axe
	L.scythe = "Sichel" -- Short for Dualblade Scythe
	L.trap = "Falle" -- Short for Flameclasp Trap
	L.chains = "Ketten" -- Short for Shadowsteel Chains
	L.embers = "Glut" -- Short for Shadowsteel Embers
	L.adds_embers = "Glut (%d) - Adds als Nächstes!"
	L.adds_killed = "Adds in %.2fs getötet"
	L.spikes = "Stacheliger Tod" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "deDE")
if L then
	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Die Fähigkeiten des Wächters können sich verzögern. Wenn diese Option ausgewählt ist, werden die Leisten für diese Fähigkeiten bestehen bleiben."

	 L.bomb_missed = "%dx Bomben verfehlt"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "deDE")
if L then
	L.rings = "Ringe"
	L.rings_active = "Ringe aktiv" -- for when they activate/are movable
	L.runes = "Runen"

	L.grimportent_countdown = "Countdown"
	L.grimportent_countdown_desc = "Countdown für die von Finsteres Omen betroffenen Spieler"
	L.grimportent_countdown_bartext = "Geh zur Rune!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "deDE")
if L then
	L.spikes = "Stacheln" -- Short for Glacial Spikes
	L.spike = "Stachel"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Frostgebundenen Ergebenen an.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "deDE")
if L then
	L.chains_active = "Ketten aktiv"
	L.chains_active_desc = "Zeigt einen Timer für die Aktivierung der Herrschaftsketten"

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette der Dich fixierenden Dunklen Wache an.\n\nBenötigt die Nutzung von Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.chains = "Ketten" -- Short for Domination Chains
	L.chain = "Kette" -- Single Domination Chain
	L.darkness = "Dunkelheit" -- Short for Veil of Darkness
	L.arrow = "Pfeil" -- Short for Wailing Arrow
	L.wave = "Welle" -- Short for Haunting Wave
	L.dread = "Angst" -- Short for Crushing Dread
	L.orbs = "Kugeln" -- Dark Communion
	L.curse = "Fluch" -- Short for Curse of Lethargy
	L.pools = "Lachen" -- Banshee's Bane
	L.scream = "Kreischen" -- Banshee Scream

	L.knife_fling = "Messer fliegen!" -- "Death-touched blades fling out"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "deDE")
if L then
	L.custom_on_bar_icon = "Leistensymbol"
	L.custom_on_bar_icon_desc = "Zeigt das Schicksalhafte Schlachtzugssymbol in den Leisten."

	L.chaotic_essence = "Essenz"
	L.creation_spark = "Funken"
	L.protoform_barrier = "Barriere"
	L.reconfiguration_emitter = "Zauber-Add"
end
