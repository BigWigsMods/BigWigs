local L = BigWigs:NewBossLocale("The Tarragrue", "esES")
if not L then return end
if L then
	L.chains = "Cadenas" -- Chains of Eternity (Chains)
	L.remnants = "Remanentes" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Remanente Fisico"
	L.magic_remnant = "Remanente Magico"
	L.fire_remnant = "Remanente Fuego"
	L.fire = "Fuego"
	L.magic = "Magico"
	L.physical = "Fisico"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "esES")
if L then
	L.chains = "Cadenas" -- Short for Dragging Chains
	L.pool = "Charco" -- Spreading Misery
	L.pools = "Charcos" -- Spreading Misery (multiple)
	L.death_gaze = "Mirada Aniquiladora" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "esES")
if L then
	L.fragments = "Fragmentos" -- Short for Fragments of Destiny
	L.fragment = "Fragmento" -- Singular Fragment of Destiny
	L.run_away = "Corre" -- Wings of Rage
	L.song = "Cancion" -- Short for Song of Dissolution
	L.go_in = "Dentro" -- Reverberating Refrain
	L.valkyr = "Val'kyr" -- Short for Call of the Val'kyr
	L.blades = "Hojas" -- Agatha's Eternal Blade
	L.big_bombs = "Bombas grandes" -- Daschla's Mighty Impact
	L.big_bomb = "Gran Bomba" -- Attached to the countdown
	L.shield = "Escudo" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Bombas Pequeñas" -- Brynja's Mournful Dirge
	L.recall = "Palabra de regreso" -- Short for Word of Recall

	L.blades_yell = "¡Cae ante mi espada!"
	L.soaks_yell = "¡Estais superados!"
	L.shield_yell = "¡Mi escudo nunca flaquea!"

	L.berserk_stage1 = "Rabia Fase 1"
	L.berserk_stage2 = "Rabia Fase 2"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "esES")
if L then
	L.cones = "Conos" -- Grasp of Malice
	L.orbs = "Orbes" -- Orb of Torment
	L.orb = "Orbe" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "esES")
if L then
	L.custom_off_nameplate_defiance = "Icono de placa de nombre de desafio"
	L.custom_off_nameplate_defiance_desc = "Muestra un icono en la placa de nombre del Agonizador jurafauce que tiene Desafio.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Icono placa de nombre atormentado"
	L.custom_off_nameplate_tormented_desc = "Muestra un icono en la placa de nombre del Agonizador jurafauce que tiene Atormentado.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	L.cones = "Cono" -- Torment
	L.dance = "Baile" -- Encore of Torment
	L.brands = "Marcas" -- Brand of Torment
	L.brand = "Marca" -- Single Brand of Torment
	L.spike = "Nova" -- Short for Agonizing Spike
	L.chains = "Cadenas" -- Hellscream
	L.chain = "Cadena" -- Soul Manacles
	L.souls = "Almas" -- Rendered Soul

	L.chains_remaining = "%d Cadenas restantes"
	L.all_broken = "Todas las cadenas rotas"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "esES")
if L then
	L.hammer = "Martillo" -- Short for Rippling Hammer
	L.axe = "Hacha" -- Short for Cruciform Axe
	L.scythe = "Guadaña" -- Short for Dualblade Scythe
	L.trap = "Trampa" -- Short for Flameclasp Trap
	L.chains = "Cadenas" -- Short for Shadowsteel Chains
	L.embers = "Ascuas" -- Short for Shadowsteel Embers
	L.adds_embers = "Ascuas (%d) - Adds Next!"
	L.adds_killed = "Adds matados en %.2fs"
	L.spikes = "Muerte con pinchos" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "esES")
if L then
	L.custom_on_stop_timers = "Mostrar siempre barra de habilidades"
	L.custom_on_stop_timers_desc = "The Guardian puede retrasar sus habilidades. Cuendo esta opcion esta activada, las barras de esas habilidades se mantendran en tu pantalla."

	L.bomb_missed = "%dx Bombas Falladas"
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "esES")
if L then
	L.rings = "Anillos"
	L.rings_active = "Anillos Activos" -- for when they activate/are movable
	L.runes = "Runas"

	L.grimportent_countdown = "Cuenta atras"
	L.grimportent_countdown_desc = "Cuenta atras para los jugadores que estan afectados por Portar Oscuridad"
	L.grimportent_countdown_bartext = "¡Ve a la runa!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "esES")
if L then
	L.spikes = "Pinchos" -- Short for Glacial Spikes
	L.spike = "Pincho"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Icono placa de nombre Fijado"
	L.custom_on_nameplate_fixate_desc = "Muestra un icono en la placa de nombre del Devoto ligado a la Escarcha que se fija en ti.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "esES")
if L then
	L.chains_active = "Cadenas Activas"
	L.chains_active_desc = "Muestra una barra para cuando Cadenas de Dominacion se activan"

	L.custom_on_nameplate_fixate = "Icono placa de nombre Fijado"
	L.custom_on_nameplate_fixate_desc = "Muestra un icono en la placa de nombre del Centinela Oscuro que se fija en ti.\n\nRequiere el uso de Placa de nombre enemigas y un addon de placas de nombres soportado (KuiNameplates, Plater)."

	L.chains = "Cadenas" -- Short for Domination Chains
	L.chain = "Cadena" -- Single Domination Chain
	L.darkness = "Oscuridad" -- Short for Veil of Darkness
	L.arrow = "Flecha" -- Short for Wailing Arrow
	L.wave = "Ola" -- Short for Haunting Wave
	L.dread = "Terror" -- Short for Crushing Dread
	L.orbs = "Orbes" -- Dark Communion
	L.curse = "Maldicion" -- Short for Curse of Lethargy
	L.pools = "Charcos" -- Banshee's Bane
	L.scream = "Alarido" -- Banshee Scream

	L.knife_fling = "¡Cuchillas fuera!" -- "Death-touched blades fling out"
end

L = BigWigs:NewBossLocale("Sanctum of Domination Affixes", "esES")
if L then
	--L.custom_on_bar_icon = "Bar Icon"
	--L.custom_on_bar_icon_desc = "Show the Fated Raid icon on bars."

	--L.chaotic_essence = "Essence"
	--L.creation_spark = "Sparks"
	L.protoform_barrier = "Barrera"
	--L.reconfiguration_emitter = "Interrupt Add"
end
