local L = BigWigsAPI:NewLocale("BigWigs: Common", "esMX")
if not L then return end

-- Prototype.lua common words
L.you = "%s en TI"
L.you_icon = "%s en |T13700%d:0|tTI"
L.underyou = "%s debajo de TI"
L.aboveyou = "%s encima de TI"
L.other = "%s: %s"
L.onboss = "%s en JEFE"
L.buff_boss = "Efecto en JEFE: %s"
L.buff_other = "Efecto en %s: %s"
L.magic_buff_boss = "Beneficio de magia en JEFE: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Beneficio de magia en %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s en %s"
L.stack = "%dx %s en %s"
L.stackyou = "%dx %s en TI"
L.cast = "<Lanza: %s>"
L.casting = "Lanzando %s"
L.soon = "%s pronto"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s cerca de TI"
L.on_group = "%s en GRUPO" -- spell on group
L.boss = "JEFE"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Fase %d"
L.stage = "Etapa %d"
--L.wave = "Wave %d" -- e.g. "Wave 1" (Waves of adds)
--L.wave_count = "Wave %d of %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.hard = "Modo difícil"
L.active = "Activo" -- When a boss becomes active, after speech finishes
L.ready = "Listo" -- When a player is ready to do something
L.dead = "Muerto" -- When a player is dead
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Salud" -- The health of an NPC
L.health_percent = "%d%% Salud" -- "10% Health" The health percentage of an NPC
L.door_open = "Puerta abierta" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Puerta abierta" -- When a gate is open, usually after a speech from an NPC
L.threat = "Amenaza"
L.energy = "Energía"

--L.remaining = "%d remaining" -- 5 remaining
L.duration = "%s durante %s seg" -- Spell for 10 seconds
L.over = "%s terminado" -- Spell Over
L.removed = "%s eliminado" -- Spell Removed
L.removed_from = "%s eliminado de %s" -- Spell removed from Player
L.removed_by = "%s eliminado por %s" -- Spell removed by Player
L.removed_after = "%s eliminado después de %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s inminente" -- Spell Incoming
L.interrupted = "%s interrumpido" -- Spell Interrupted
L.interrupted_by = "%s interrumpido por %s" -- Spell interrupted by Player
L.interruptible = "Interrumpible" -- when a spell is interruptible
L.no = "No %s" -- No Spell
L.intermission = "Intermedio"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s cancelado" -- Spell Cancelled
L.you_die = "Morirás" -- You will die
L.you_die_sec = "Morirás en %d seg" -- "You die in 15 sec" (seg = seconds (segundos))
L.next_ability = "Próxima habilidad" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
--L.landing = "%s is landing" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
--L.flying_available = "You can fly now"

-- Add related
L.add_spawned = "Esbirro apareció" -- singular
L.adds_spawned = "Esbirros aparecieron" -- plural
--L.adds_spawned_count = "%d |4add:adds; spawned" -- 1 add spawned / 2 adds spawned
--L.add_spawning = "Add spawning" -- singular
--L.adds_spawning = "Adds spawning" -- plural
L.spawned = "%s apareció"
L.spawning = "%s aparece"
L.next_add = "Siguiente esbirro"
L.add_killed = "Esbirro muerto (%d/%d)"
L.add_remaining = "Esbirro muerto, %d restantes"
L.add = "Esbirro"
L.adds = "Esbirros"
L.big_add = "Esbirro grande" -- singular
L.big_adds = "Esbirros grandes" -- plural
L.small_add = "Esbirro pequeño" -- singular
L.small_adds = "Esbirros pequeños" -- plural

-- Mob related
L.killed = "%s muerto"
L.mob_killed = "%s muerto (%d/%d)"
L.mob_remaining = "%s muerto, %d restantes"

-- NPCs for follower dungeons
L.garrick = "Capitana Garrick" -- AI paladin tank (NPC 209057)
L.garrick_short = "*Garrick"
L.meredy = "Meredy Huntswell" -- AI mage dps (NPC 209059)
L.meredy_short = "*Meredy"
L.shuja = "Shuja Hacha Macabra" -- AI shaman dps (NPC 214390)
L.shuja_short = "*Shuja"
L.crenna = "Crenna Hija de la Tierra" -- AI druid healer (NPC 209072)
L.crenna_short = "*Crenna"
L.austin = "Austin Huxworth" -- AI hunter dps (NPC 209065)
L.austin_short = "*Austin"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s iniciado - %s en %d min"
L.custom_start_s = "%s iniciado - %s en %d seg"
L.custom_end = "%s comienza en %s"
L.custom_min = "%s en %d min"
L.custom_sec = "%s en %d seg"

L.focus_only = "|cffff0000Alertas solo para objetivo en foco.|r "
L.trash = "Bichos"
L.affixes = "Afijos" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s marcador"
L.marker_player_desc = "Marca jugadores afectados por %s con %s, requiere ayudante o líder." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Marca %s con %s, requiere ayudante o líder." -- Mark NPC_NAME with SKULL_ICON
--L.marker_npc_aura_desc = "Mark NPCs affected by '%s' with %s, requires promoted or leader." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "Enlace"
L.link_with = "Enlazado con %s"
L.link_with_icon = "Enlazado con |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Enlazado con %s"
L.link_both = "%s enlazado con %s" -- XXX needs updated
L.link_both_icon = "|T13700%d:0|t%s enlazado con |T13700%d:0|t%s" -- XXX needs updated
L.link_removed = "Enlace eliminado"
--L.link_say_option_name = "Repeating 'Linked' say messages"
--L.link_say_option_desc = "Repeating say messages in chat stating who you are linked with."

-- Abbreviated numbers
L.amount_one = "%dB" -- Miles de millones 1,000,000,000
L.amount_two = "%dM" -- Millones 1,000,000
L.amount_three = "%dK" -- Miles 1,000
L.seconds = "%.1fs" -- 1.1 segundos

-- Directions
L.top = "Superior"
L.up = "Arriba"
L.middle = "Medio"
L.down = "Abajo"
L.bottom = "Fondo"
L.left = "Izquierda"
L.right = "Derecha"
L.north = "Norte"
L.north_east = "Noreste"
L.east = "Este"
L.south_east = "Sureste"
L.south = "Sur"
L.south_west = "Suroeste"
L.west = "Oeste"
L.north_west = "Noroeste"

-- Schools
L.fire = "Fuego"
L.frost = "Escarcha"
L.shadow = "Sombras"
L.nature = "Naturaleza"
L.arcane = "Arcano"

-- Autotalk
--L.autotalk = "Automatic NPC interaction"
--L.autotalk_boss_desc = "Automatically select the NPC dialog options that cause the boss encounter to begin."
--L.autotalk_generic_desc = "Automatically select the NPC dialog options that cause you to progress to the next stage of the dungeon."

-- Common ability name replacements
L.absorb = "Absorber" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Absorción de sanación" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Absorciones de sanación" -- Plural of L.heal_absorb
L.tank_combo = "Combo de tanque" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Láser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Láseres" -- Plural of L.lasers
L.beam = "Rayo" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Rayos" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombas" -- Plural of L.bomb
L.explosion = "Deflagración" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fijar" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Retroceso" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Empujón" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Trampas" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteoro" -- This one will probably only ever be used for actual meteors
L.shield = "Escudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teletransporte" -- A boss/add/etc teleported somewhere
L.fear = "Miedo" -- For abilities that cause you to flee in fear
L.breath = "Aliento" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Rugido" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Salto" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Cargar" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Energía al máximo" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Debilitado" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Inmune" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "Aturdido" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "Charco" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Charcos" -- Plural of L.pool
L.totem = "Tótem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Tótems" -- Plural of L.totem
L.portal = "Portal" -- A portal somewhere, usually leading to a different location
L.portals = "Portales" -- Plural of L.portal
L.rift = "Falla" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Fallas" -- Plural of L.rift
L.orb = "Orbe" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Orbes" -- Plural for L.orb
L.curse = "Maldición" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Maldiciones" -- Plural of L.curse
L.disease = "Enfermedad" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Veneno" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Espíritu" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Espíritus" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornados" -- Plural of L.tornado
L.frontal_cone = "Cono frontal" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Miedo" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Marca" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marcas" -- Plural of L.marks
L.mind_control = "Control mental" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spell_reflection = "Reflejo de hechizos" -- Any ability that reflects spells
L.parasite = "Parásito" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Enraizado" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
--L.dodge = "Dodge" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "Absorción de salud" -- Any ability that drains health from the player
L.smash = "Machaque" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "Púa" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Púas" -- Plural of L.spike
--L.waves = "Waves" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
