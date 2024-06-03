local L = BigWigsAPI:NewLocale("BigWigs: Common", "ptBR")
if not L then return end

-- Prototype.lua common words
L.you = "%s em VOCÊ"
L.you_icon = "%s em |T13700%d:0|tVOCÊ"
L.underyou = "%s debaixo de VOCÊ"
L.aboveyou = "%s acima de VOCÊ"
L.other = "%s: %s"
L.onboss = "%s no CHEFE"
L.buff_boss = "Buff no CHEFE: %s"
L.buff_other = "Buff no %s: %s"
L.magic_buff_boss = "Buff mágico no CHEFE: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Buff mágico em %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s em %s"
L.stack = "%dx %s em %s"
L.stackyou = "%dx %s em VOCÊ"
L.cast = "<Conjurando %s>"
L.casting = "Conjurando: %s"
L.soon = "%s em breve"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s perto de VOCÊ"
L.on_group = "%s no GRUPO" -- spell on group
L.boss = "CHEFE"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Fase %d"
L.stage = "Estágio %d"
--L.wave = "Wave %d" -- e.g. "Wave 1" (Waves of adds)
--L.wave_count = "Wave %d of %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.hard = "Modo difícil"
L.active = "Ativo" -- When a boss becomes active, after speech finishes
L.ready = "Pronto" -- When a player is ready to do something
L.dead = "Morto" -- When a player is dead
L.general = "Geral" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Vida" -- The health of an NPC
L.health_percent = "%d%% de Vida" -- "10% Health" The health percentage of an NPC
L.door_open = "Porta Aberta" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Portão Aberto" -- When a gate is open, usually after a speech from an NPC

L.duration = "%s durante %s seg" -- Spell for 10 seconds
L.over = "%s acabou" -- Spell Over
L.removed = "%s removido" -- Spell Removed
L.removed_from = "%s removido de %s" -- Spell removed from Player
L.removed_by = "%s removido por %s" -- Spell removed by Player
L.removed_after = "%s removido depois de %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s a caminho" -- Spell Incoming
L.interrupted = "%s interrompido" -- Spell Interrupted
L.interrupted_by = "%s interrompido por %s" -- Spell interrupted by Player
L.interruptible = "Interrompível" -- when a spell is interruptible
L.no = "Sem %s" -- No Spell
L.intermission = "Intervalo"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancelado" -- Spell Cancelled
L.you_die = "Você morrerá" -- You will die
L.you_die_sec = "Você morrerá em %d seg" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "Próxima Habilidade" -- We don't know what ability will be next, we only know when it will happen (showing a bar)

-- Add related
L.add_spawned = "Add surgiu"
L.adds_spawned = "Adds surgiram"
L.spawned = "%s surgiu"
L.spawning = "%s Chegando"
L.next_add = "Próximo add"
L.add_killed = "Add morto (%d/%d)"
L.add_remaining = "Add morto, restam %d"
L.add = "Inimigo adicional"
L.adds = "Inimigos adicionais"
L.big_add = "Add Grande" -- singular
L.big_adds = "Adds Grandes" -- plural
L.small_add = "Add Pequeno" -- singular
L.small_adds = "Adds Pequenos" -- plural

-- Mob related
L.killed = "%s morto"
L.mob_killed = "%s morto (%d/%d)"
L.mob_remaining = "%s morto, %d restando"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s iniciado - %s em %d min"
L.custom_start_s = "%s iniciado - %s em %d seg"
L.custom_end = "%s começa em %s"
L.custom_min = "%s em %d min"
L.custom_sec = "%s em %d seg"

L.focus_only = "|cffff0000Apenas alertas de focar alvo.|r "
L.trash = "Trash"
L.affixes = "Afixos" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "Marcador %s"
L.marker_player_desc = "Marca jogadores afetados por %s com %s, requer líder ou assistente." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Marca %s com %s, requer líder ou assistente." -- Mark NPC_NAME with SKULL_ICON
--L.marker_npc_aura_desc = "Mark NPCs affected by '%s' with %s, requires promoted or leader." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "Ligação"
L.link_with = "Ligado com %s"
L.link_with_icon = "Ligado com |T13700%d:0|t%s"
L.link_short = "Ligado: %s"
L.link_both = "%s ligado com %s"
L.link_removed = "Ligação removida"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Directions
L.top = "Topo"
L.up = "Cima"
L.middle = "Meio"
L.down = "Baixo"
L.bottom = "Fundo"
L.left = "Esquerda"
L.right = "Direita"
L.north = "Norte"
L.north_east = "Nordeste"
L.east = "Leste"
L.south_east = "Sudeste"
L.south = "Sul"
L.south_west = "Sudoeste"
L.west = "Oeste"
L.north_west = "Noroeste"

-- Schools
L.fire = "Fogo"
L.frost = "Gelo"
L.shadow = "Sombra"
L.nature = "Natureza"
L.arcane = "Arcano"

-- Common ability name replacements
L.absorb = "Absorver" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Absorção de Cura" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Absorção de Cura" -- Plural of L.heal_absorb
L.tank_combo = "Combo de Tanque" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Lasers" -- Plural of L.lasers
L.beam = "Feixe" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Feixes" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombas" -- Plural of L.bomb
L.explosion = "Explosão" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fixação" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Empurrão" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Repulsão" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Armadilhas" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteoro" -- This one will probably only ever be used for actual meteors
L.shield = "Escudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teleporte" -- A boss/add/etc teleported somewhere
L.fear = "Medo" -- For abilities that cause you to flee in fear
L.breath = "Sopro" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Rugido" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Salto" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Investida" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Energia Cheia" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Enfraquecido" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Imune" -- When a boss becomes immune to all damage and you can no longer hurt it
L.pool = "Poça" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Poças" -- Plural of L.pool
L.totem = "Totem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Totems" -- Plural of L.totem
L.portal = "Portal" -- A portal somewhere, usually leading to a different location
L.portals = "Portais" -- Plural of L.portal
L.rift = "Fenda" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Fendas" -- Plural of L.rift
L.orb = "Orbe" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Orbes" -- Plural for L.orb
L.curse = "Maldição" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Maldições" -- Plural of L.curse
L.disease = "Doença" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Veneno" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Espírito" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Espíritos" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornados" -- Plural of L.tornado
L.frontal_cone = "Cônica à Frente" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Medo" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Marca" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marcas" -- Plural of L.marks
L.mind_control = "Controle Mental" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spell_reflection = "Reflexão de Feitiço" -- Any ability that reflects spells
L.parasite = "Parasita" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Enraizado" -- Any ability that roots you in place, preventing you from moving
