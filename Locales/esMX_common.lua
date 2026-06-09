local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs: Common", "esMX")
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
L.magic_buff_boss = "Bufo mágico en JEFE: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Bufo mágico en %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s en %s"
L.stack = "%dx %s en %s" -- "5x SPELL_NAME on PLAYER_OR_NPC" showing how many stacks of a buff/debuff are on a player or NPC
L.stackyou = "%dx %s en TI" -- "5x SPELL_NAME on YOU" showing how many stacks of a buff/debuff are on you
L.stackboss = "%dx %s en el JEFE" -- "5x SPELL_NAME on BOSS" showing how many stacks of a buff/debuff are on the boss
L.stack_gained = "Obtenido %dx" -- "Gained 5x" for situations where we show how many stacks of a buff were gained since last time a message showed
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
L.stage = "Fase %d"
L.wave = "Oleada %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "Oleada %d de %d" -- Wave 1 of 3 (Usually waves of adds)
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
L.energy = "Energía"
L.energy_percent = "%d%% Energía" -- "80% Energy" The energy percentage of an NPC
L.door_open = "Puerta abierta" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Puerta abierta" -- When a gate is open, usually after a speech from an NPC
L.threat = "Amenaza"

L.remaining = "%d faltantes" -- 5 remaining
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
L.intermission_over = "Intermedio Finalizo"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s cancelado" -- Spell Cancelled
L.you_die = "Morirás" -- You will die
L.you_die_sec = "Morirás en %d seg" -- "You die in 15 sec" (seg = seconds (segundos))
L.next_ability = "Próxima habilidad" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.boss_landing = "%s está aterrizando" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.landing = "Aterrizando" -- Used when a flying NPC/dragon/boss is landing
L.flying_available = "Ahora puedes volar"
L.bosses_too_close = "Los jefes están muy cerca" -- When 2 or more bosses are too close to each other, buffing each other with a shield, extra damage, etc.
L.keep_moving = "Sigue moviéndote" -- An ability that forces you to keep moving or you will take damage
L.stand_still = "No te muevas" -- An ability that forces you to stand still or you will take damage
L.safe_to_stop = "Puedes pararte" -- When an ability that forces you to keep moving fades from you, allowing you to stop moving
L.safe_to_move = "Puedes moverte" -- When an ability to forces you to stand still fades from you, allowing you to move again
L.safe = "Seguro" -- You are safe from a bad ability
L.unsafe = "Peligro" -- You are unsafe (in danger) of a bad ability

-- Add related
L.add_spawned = "Esbirro apareció" -- singular
L.adds_spawned = "Esbirros aparecieron" -- plural
L.adds_spawned_count = "%d |4esbirro apareció:esbirros aparecieron;" -- 1 add spawned / 2 adds spawned
L.add_spawning = "Apareció un esbirro" -- singular
L.adds_spawning = "Esbirros apareciendo" -- plural
L.add_incoming = "Viene un esbirro" -- singular
L.adds_incoming = "Esbirros viniendo" -- plural
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
L.eat_adds = "Comer Esbirros" -- When a boss is going to eat/consume any adds remaining to empower/heal itself. Usually this is a timer. You have to kill all adds in X seconds or they will be eaten.

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
L.breka = "Señora de la guerra Breka Hacha Macabra" -- AI warrior tank (NPC 215517)
L.breka_short = "*Breka"
L.henry = "Henry Garrick" -- AI priest healer (NPC 215011)
L.henry_short = "*Henry"

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

-- GUI boss dropdown for cast counters (Usually a dropdown menu in the boss options that lets you choose when a spell counter should reset back to 1)
--L.counter_reset_name = "%s cast counter" -- SPELL_NAME cast counter
--L.counter_reset_desc = "Choose when to reset the counter."
--L.reset_casts = "Reset every %d casts" -- Reset every 3 casts
--L.reset_stages = "Reset on stage change"
--L.reset_casts_and_stages = "Reset every %d casts and on stage change"
--L.reset_never = "Never reset"

-- Common raid marking locale
L.marker = "%s marcador"
L.marker_player_desc = "Marca jugadores afectados por %s con %s, requiere asistente o líder." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Marca %s con %s, requiere ayudante o líder." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "Marca NPC afectados por '%s' con %s, requiere asistente o líder." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON
L.disabled = "Desactivado"
L.none = "Nada"
L.markers = "Marcas" -- Plural of marker

-- Ability where two players have to move close to each other
L.link = "Enlace"
L.link_with = "Enlazado con %s"
L.link_with_icon = "Enlazado con |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Enlazado con %s"
L.link_both = "%s + %s están enlazados"
L.link_both_icon = "|T13700%d:0|t%s + |T13700%d:0|t%s están enlazados"
L.link_removed = "Enlace eliminado"
L.link_say_option_name = "Repetir 'enlazado' mensaje en chat"
L.link_say_option_desc = "Repetir el mensaje en el chat diciendo con quién estás enlazado."

-- Abbreviated numbers
L.amount_one = "%dB" -- Miles de millones 1,000,000,000
L.amount_two = "%dM" -- Millones 1,000,000
L.amount_three = "%dK" -- Miles 1,000
L.seconds = "%.1fs" -- 1.1 segundos

-- Directions
L.top = "Superior"
L.top_right = "Superior Derecho"
L.top_left = "Superior Izquierdo"
L.up = "Arriba"
L.middle = "Medio"
L.down = "Abajo"
L.bottom = "Fondo"
L.bottom_right = "Inferior Derecho"
L.bottom_left = "Inferior Izquierdo"
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

-- Sizes
L.small = "Pequeño"
L.medium = "Mediano"
L.large = "Grande"

-- Schools
L.fire = "Fuego"
L.frost = "Escarcha"
L.shadow = "Sombra"
L.nature = "Naturaleza"
L.arcane = "Arcano"

-- Autotalk
L.autotalk = "Interacción con NPC automática"
L.autotalk_boss_desc = "Selecciona automáticamente el diálogo del NPC que provoca el inicio del encuentro con el jefe."
L.autotalk_generic_desc = "Selecciona automáticamente el diálogo del NPC que hace que avances a la siguiente fase del calabozo."
L.autotalk_notice = "Interactuando automáticamente con los NPC %s."

-- GUI notes
L.intermissionOnly = "Solo en Intermedio" -- A note to explain that a specific ability only happens during the intermission stage of a boss fight
L.stage1Only = "Solo Fase 1" -- A note to explain that a specific ability only happens during stage 1 of a boss fight
L.stage2Only = "Solo Fase 2"
L.stage3Only = "Solo Fase 3"

-- GUI notes for renames
L.generalNote = "Este es el texto que se usará de forma general"
L.timerNote = "Este texto se usará para los temporizadores"
L.castTimerNote = "Este texto solo se usará para temporizadores de lanzamiento"
L.messageCastOverNote = "Este texto se utilizará para mostrar un mensaje cuando termine el lanzamiento"
L.messageCastStartNote = "Este texto se usará para mostrar un mensaje cuando el lanzamiento comience"
L.messageBeforeCastStartNote = "Este texto se usará para mostrar un mensaje cuando el lanzamiento termine"
--L.messageDuringCastNote = "This text will be used for showing messages during the cast"
L.messageNote = "Este texto se usará para los mensajes"
L.messageOnYouNote = "El mensaje que se muestra cuando esta habilidad te afecta"
L.messageSpecificHealth = "El mensaje se muestra cuando el jefe esté en %d%% de vida"
L.timerOnYouNote = "El texto que se muestra en el temporizador cuando esta habilidad te afecta"
L.mythicOnlyNote = "Este texto se usará solo en Mítico"
L.otherDifficultiesNote = "Este texto se usará en todas las demás dificultades"

-- GUI notes for debuffs
L.debuffFailureNote = "Se te aplicará este debufo si fallas"
L.debuffFailureMoveFromExplosionNote = "Se te aplicará este debufo si fallas en moverte de la explosión"
--L.debuffFailureInterruptNote = "This debuff will apply to you if you fail to interrupt the cast of |cFFFFFFFF%s|r" -- This debuff will apply to you if you fail to interrupt the cast of SPELL_NAME
L.preDebuffNote = "Este es el bufo previo al bufo principal que se te aplicará"
L.mainDebuffNote = "Este es el bufo principal que se te aplicará"
L.postDebuffNote = "Este debufo se te aplicará luego de que |cFFFFFFFF%s|r expire" -- This debuff will apply to you after OTHER_DEBUFF expires
L.debuffUnderYouNote = "Este debufo se te aplicará cuando te pares en alguna zona peligrosa" -- Usually when a player is standing in a pool of something bad, a debuff will apply to them
L.debuffDotAfterCastNote = "Este debufo es un efecto de daño por tiempo cuando el jefe lance |cFFFFFFFF%s|r" -- This debuff is a damage over time effect after the boss finishes casting SPELL_NAME
L.debuffPossibleAfterCastNote = "Este debufo podra aplicarse a ti luego de que el jefe lance |cFFFFFFFF%s|r" -- This debuff might apply to you after the boss finishes casting SPELL_NAME
L.debuffTankAfterCastNote = "Este debufo se le aplicara al tanque luego de que el jefe lance |cFFFFFFFF%s|r" -- This debuff will apply to the tank after the boss finishes casting SPELL_NAME
L.debuffWalkIntoObjectNote = "Este debufo se te apicara si caminas hacia |cFFFFFFFF%s|r" -- This debuff will apply to you if you purposely walk into the OBJECT_NAME (e.g. trap, mine, bomb)
--L.debuffHitByCastNote = "This debuff will apply to you if you are hit by the the |cFFFFFFFF%s|r cast" -- This debuff will apply to you if you are hit by the the SPELL_NAME cast
L.debuffAddsCast = "Este bufo te lo aplicará |cFFFFFFFF%s|r" -- This debuff is applied to you by NPC_NAME

-- Common ability name replacements
L.laser = "Láser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Láseres" -- Plural of L.lasers
L.beam = "Rayo" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Rayos" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombas" -- Plural of L.bomb
L.explosion = "Deflagración" -- When the explosion from a bomb-like ability will occur
L.explosions = "Deflagraciones" -- Plural of L.explosion
L.knockback = "Empujón" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.knockbacks = "Empujones" -- Plural of L.knockback
L.pushback = "Desplazamiento" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Trampas" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteorito" -- This one will probably only ever be used for actual meteors
L.teleport = "Teletransporte" -- A boss/add/etc teleported somewhere
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
L.spirit = "Espíritu" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Espíritus" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornados" -- Plural of L.tornado
L.mark = "Marca" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marcas" -- Plural of L.marks
L.mind_control = "Control mental" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.spell_reflection = "Reflejo de hechizos" -- Any ability that reflects spells
L.rooted = "Enraizado" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.arrow = "Flecha" -- Any type of ability that looks like an arrow, or has "arrow" in the name. Like an archer's arrow.
L.arrows = "Flechas" -- Plural of L.arrow
L.ball = "Pelota" -- A ball, like a football, basketball, etc
L.balls = "Pelotas" -- Plural of L.ball
L.blind = "Ceguera" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
L.bouncing_ball = "Pelota rebotando" -- A ball, but it bounces, usually you need to prevent it touching the ground so it bounces to a different location
L.bouncing_balls = "Pelotas rebotando" -- Plural of L.bouncing_ball
L.chakram = "Chakram" -- Short for any ability with the name "Chakram" in it e.g. "Wind Chakram" (1258152) or "Solar Chakram" (186046)
L.dodge = "Esquivar" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "Enfurecer" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "Miedo" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "Fijar" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "Fijados" -- Plural of L.fixate
L.frontal = "Frontal" -- Usually a bad Area-of-Effect ability cast by the boss in front of them
L.frontal_cone = "Cono frontal" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.grip = "Agarre" -- When a boss grapples a player towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
L.grips = "Agarres" -- Plural of L.grip
L.group_damage = "Daño de grupo" -- Any ability that causes damage to every player in the 5 player group
L.health_drain = "Drenaje de salud" -- Any ability that drains health from the player
L.madness = "Locura" -- Any ability that contains the word "Madness" in it e.g. "Rift Madness" (1264756) or "Burning Madness" (307013)
L.miasma = "Miasma" -- Any ability that contains the word "Miasma" in it e.g. "Consuming Miasma" (1257087) or "Black Miasma" (1275059)
L.missile = "Misil" -- Short for any ability with the name "Missile" in it e.g. "Fey Missile" (188046) or "Water Missile" (68250)
L.missiles = "Misiles" -- Plural of L.missile
L.parasite = "Parásito" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "Parásitos" -- Plural of L.parasite
L.pull_in = "Atraer" -- An ability that pulls you in towards the boss against your will
L.quills = "Péndolas" -- Short for any ability with the name "Quills" in it e.g. "Searing Quills" (159382) or "Infused Quills" (1242260)
L.raid_damage = "Daño de banda" -- Any ability that causes damage to every player in the raid
L.silence = "Silencio" -- Any ability that silences a player, preventing their spells being cast
L.smash = "Machaque" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spike = "Púa" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Púas" -- Plural of L.spike
L.spread = "Separarse" -- An ability that forces you to spread out away from other players, or you might damage them
L.stomp = "Pisotón" -- Short for any ability with the name "Stomp" in it e.g. "Cryostomp" (1261847) or "Powerful Stomp" (296691)
L.tentacle = "Tentáculo" -- Used for bosses that summon tentacles
L.tentacles = "Tentáculos" -- Plural of L.tentacle
L.waves = "Olas" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
L.whelp = "Cría" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "Crías" -- Plural of L.whelp

-- Absorb / Shield related spell renames
L.absorb = "Absorción" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Absorción de curación" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Absorciones de curación" -- Plural of L.heal_absorb
L.break_shield = "Romper Escudo" -- When you need to do something to break an absorb shield on the boss.
L.break_shields = "Romper Escudos" -- Plural of L.break_shield
L.shield = "Escudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"

-- Debuff-related spell renames
L.debuff = "Debufo"
L.debuffs = "Debufos" -- Plural of L.debuff
L.fire_debuffs = "Debufo de fuego"

-- Dispel-related spell renames
L.curse = "Maldición" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Maldiciones" -- Plural of L.curse
L.disease = "Enfermedad" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.dispel = "Disipación" -- General term for any debuff that is dispellable
L.dispels = "Disipaciones" -- Plural of L.dispel
L.dispel_boss = "Disipar Jefe" -- When the boss gains a buff (magic or enrage) that you need to dispel
L.poison = "Veneno" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.bleed = "Sangrado" -- Any bleed-type debuff
L.bleeds = "Sangrados" -- Plural of L.bleed

-- Clearing-related spell renames (when you get a buff that allows you to clear/cleanse/remove other objects in the world, like pools on the ground, traps, or bombs)
L.clear_bombs = "Limpiar Bombas"
L.clear_pools = "Limpiar Piscinas"

-- Interrupt-related spell renames
L.interrupts = "Interrumpir" -- General term used when a player needs to interrupt a spell being cast
L.kick = "Corte" -- General term used when a player needs to interrupt a spell being cast, named after spell "Kick" (1766) from the Rogue class
L.kicks = "Cortes" -- Plural of L.kick

-- Tank-related spell renames
L.tank_bomb = "Bomba de Tanque" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "Combo de Tanque" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "Debufo de Tanque" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "Frontal de Tanque" -- Similar to L.frontal_cone but only applies to tanks
L.tank_hit = "Golpe de Tanque" -- An attack that will only target the tank, usually a spell that does a lot of heavy damage to the tank
L.tank_knockback = "Empujón de Tanque" -- Similar to L.knockback but only applies to tanks"
L.tank_soak = "Soak de Tanque" -- Similar to L.soak but only applies to tanks
L.tank_grip = "Agarre al Tanque" -- When a boss grapples the tank towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
