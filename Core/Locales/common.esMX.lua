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
L.on = "%s en %s"
L.stack = "%dx %s en %s"
L.stackyou = "%dx %s en TI"
L.cast = "<Canaliza: %s>"
L.casting = "Canalizando %s"
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

L.phase = "Fase %d"
L.stage = "Etapa %d"
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.hard = "Modo difícil"
L.active = "Activo" -- When a boss becomes active, after speech finishes
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.hp = "%d%% Salud" -- "30% HP" (HP = Health Points)
L.door_open = "Puerta abierta" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Puerta abierta" -- When a gate is open, usually after a speech from an NPC

L.duration = "%s durante %s seg" -- Spell for 10 seconds
L.over = "%s terminado" -- Spell Over
L.removed = "%s Removido" -- Spell Removed
L.removed_from = "%s Removido de %s" -- Spell removed from Player
L.removed_by = "%s Removido por %s" -- Spell removed by Player
L.removed_after = "%s removido después de %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s Acercándose" -- Spell Incoming
L.interrupted = "%s Interrumpido" -- Spell Interrupted
L.interrupted_by = "%s Interrumpido por %s" -- Spell interrupted by Player
L.no = "No %s" -- No Spell
L.intermission = "Intermedio"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancelado" -- Spell Cancelled
L.you_die = "Te mueres"
L.you_die_sec = "Morirás en %d seg" -- "You die in 15 sec" (seg = seconds (segundos))

-- Add related
L.add_spawned = "Apareció esbirro"
L.adds_spawned = "Apareció esbirros"
L.spawned = "%s Apareció"
L.spawning = "%s Aparece"
L.next_add = "Siguiente esbirro"
L.add_killed = "Esbirro muerto (%d/%d)"
L.add_remaining = "Esbirro muerto, %d restantes"
L.add = "Esbirro"
L.adds = "Esbirros"
L.big_add = "Esbirro grande" -- singular
L.big_adds = "Esbirros grande" -- plural
L.small_add = "Esbirro pequeño" -- singular
L.small_adds = "Esbirros pequeños" -- plural

-- Mob related
L.killed = "%s muerto"
L.mob_killed = "%s muerto (%d/%d)"
L.mob_remaining = "%s muerto, %d restantes"

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
L.marker = "%s Marcador"
L.marker_player_desc = "Marca jugadores afectados por %s con %s, requiere ayudante o líder."
L.marker_npc_desc = "Marca %s con %s, requiere ayudante o líder."

-- Ability where two players have to move close to each other
L.link = "Enlace"
L.link_with = "Enlazado con %s"
L.link_with_icon = "Enlazado con |T13700%d:0|t%s"
L.link_short = "Enlazado: %s"
L.link_both = "%s enlazado con %s"
L.link_removed = "Enlace eliminado"

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

-- Common ability name replacements
L.absorb = "Absorber" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Absorcion de sanación" -- Used for shield-like abilities that absorb healing only
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
L.spirit = "Espíritu" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Espíritus" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornados" -- Plural of L.tornado
L.frontal_cone = "Cono Frontal" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Miedo" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Marca" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marcas" -- Plural of L.marks
L.mind_control = "Control mental" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
