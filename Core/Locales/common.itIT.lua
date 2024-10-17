local L = BigWigsAPI:NewLocale("BigWigs: Common", "itIT")
if not L then return end

-- Prototype.lua common words
L.you = "%s su di TE"
L.you_icon = "%s su di |T13700%d:0|tTE"
L.underyou = "%s sotto di TE"
L.aboveyou = "%s sopra di TE"
L.other = "%s: %s"
L.onboss = "%s sul BOSS"
L.buff_boss = "Potenziamento sul BOSS: %s"
L.buff_other = "Potenziamento su %s: %s"
L.magic_buff_boss = "Beneficio magico sul BOSS: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Beneficio magico su %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s su %s"
L.stack = "%dx %s su %s"
L.stackyou = "%dx %s su DI TE"
L.cast = "<Lancio di %s>"
L.casting = "Lancio di %s"
L.soon = "%s tra poco"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s vicino A TE"
L.on_group = "%s sul GRUPPO" -- spell on group
L.boss = "BOSS"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Fase %d"
L.stage = "Fase %d"
L.wave = "Ondata %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "Ondata %d di %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Modalità Normale"
L.heroic = "Modalità Eroica"
L.mythic = "Modalità Mitica"
L.hard = "Modalità Difficile"
L.active = "Attivo" -- When a boss becomes active, after speech finishes
L.ready = "Pronto" -- When a player is ready to do something
L.dead = "Morto" -- When a player is dead
L.general = "Generali" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Salute" -- The health of an NPC
L.health_percent = "%d%% Salute" -- "10% Health" The health percentage of an NPC
L.door_open = "Porta aperta" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Cancello aperto" -- When a gate is open, usually after a speech from an NPC
L.threat = "Minaccia"
L.energy = "Energia"

L.remaining = "%d rimanenti" -- 5 remaining
L.duration = "%s per %s sec" -- Spell for 10 seconds
L.over = "%s Terminato" -- Spell Over
L.removed = "%s Rimosso" -- Spell Removed
L.removed_from = "%s rimosso da %s" -- Spell removed from Player
L.removed_by = "%s rimosso da %s" -- Spell removed by Player
L.removed_after = "%s rimosso dopo %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s Tra Poco" -- Spell Incoming
L.interrupted = "%s Interrotto" -- Spell Interrupted
L.interrupted_by = "%s interrotto da %s" -- Spell interrupted by Player
L.interruptible = "Interrompibile" -- when a spell is interruptible
L.no = "Nessun %s" -- No Spell
L.intermission = "Intermezzo"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancellata" -- Spell Cancelled
L.you_die = "Tu muori" -- You will die
L.you_die_sec = "Morirai in %d sec" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "Prossima abilità" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.landing = "%s sta atterrando" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.flying_available = "Adesso puoi volare"

-- Add related
L.add_spawned = "Add Apparso" -- singular
L.adds_spawned = "Adds Apparso" -- plural
L.adds_spawned_count = "%d |4add:adds; Apparsi" -- 1 add spawned / 2 adds spawned
L.add_spawning = "Add a breve" -- singular
L.adds_spawning = "Adds a breve" -- plural
L.spawned = "%s Reinizializzato"
L.spawning = "Apparizione di %s"
L.next_add = "Prossimo Add"
L.add_killed = "Add ucciso (%d/%d)"
L.add_remaining = "Add ucciso, %d rimasti"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Add Maggiore" -- singular
L.big_adds = "Adds Maggiori" -- plural
L.small_add = "Add Minore" -- singular
L.small_adds = "Adds Minori" -- plural

-- Mob related
L.killed = "%s Ucciso"
L.mob_killed = "%s Ucciso (%d/%d)"
L.mob_remaining = "%s ucciso, %d rimasti"

-- NPCs for follower dungeons
L.garrick = "Capitana Garrick" -- AI paladin tank (NPC 209057)
L.garrick_short = "*Garrick"
L.meredy = "Meredy Caccialesta" -- AI mage dps (NPC 209059)
L.meredy_short = "*Meredy"
L.shuja = "Shuja Asciatetra" -- AI shaman dps (NPC 214390)
L.shuja_short = "*Shuja"
L.crenna = "Figlia della Terra Crenna" -- AI druid healer (NPC 209072)
L.crenna_short = "*Crenna"
L.austin = "Austin Huxworth" -- AI hunter dps (NPC 209065)
L.austin_short = "*Austin"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "Combattimento con %s iniziato - %s in %d min"
L.custom_start_s = "Combattimento con %s iniziato - %s in %d sec"
L.custom_end = "%s diventa %s"
L.custom_min = "%s in %d min"
L.custom_sec = "%s in %d sec"

L.focus_only = "|cffff0000Avviso solo per i bersagli focus.|r "
L.trash = "Trash"
L.affixes = "Modificatori" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "Icona bersaglio %s"
L.marker_player_desc = "Marchia i giocatori affetti da %s con %s, necessario ruolo assistente o capo." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Marchia %s con %s, necessario ruolo assistente o capo." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "Marchia NPCs che hanno '%s' con %s, richiede promozione or capogruppo." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "Vincolo"
L.link_with = "Vincolato a %s"
L.link_with_icon = "Vincolato a |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Vincolato a %s"
L.link_both = "%s + %s sono vincolati"
L.link_both_icon = "|T13700%d:0|t%s + |T13700%d:0|t%s sono vincolati"
L.link_removed = "Vincolo rimosso"
L.link_say_option_name = "Ripetendo 'Collegato' messaggi say "
L.link_say_option_desc = "Ripetendo messaggi say in chat dicendo con chi sei collegato."

-- Abbreviated numbers
L.amount_one = "%dMrd" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dk" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Directions
L.top = "Superiore"
L.up = "Sopra"
L.middle = "Centrale"
L.down = "Sotto"
L.bottom = "Inferiore"
L.left = "Sinistra"
L.right = "Destra"
L.north = "Nord"
L.north_east = "Nord-Est"
L.east = "Est"
L.south_east = "Sud-Est"
L.south = "Sud"
L.south_west = "Sud-Ovest"
L.west = "Ovest"
L.north_west = "Nord-Ovest"

-- Schools
L.fire = "Fuoco"
L.frost = "Gelo"
L.shadow = "Ombra"
L.nature = "Natura"
L.arcane = "Arcano"

-- Autotalk
L.autotalk = "Interazione NPC Automatica"
L.autotalk_boss_desc = "Automaticamente selezione l'opzione di dialogo NPC che fanno iniziare l'icontro col Boss."
L.autotalk_generic_desc = "Automaticamente selezione l'opzione di dialogo NPC che fanno iniziare la prossima fase della spedizione."

-- Common ability name replacements
L.absorb = "Assorbimento" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Assorbimento di cura" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Assorbimenti di cura" -- Plural of L.heal_absorb
L.tank_combo = "Combinazione Difensore" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Laser" -- Plural of L.lasers
L.beam = "Raggio" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Raggi" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombe" -- Plural of L.bomb
L.explosion = "Esplosione" -- When the explosion from a bomb-like ability will occur
L.fixate = "Ossessione" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Contraccolpo" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Spinta" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Trappole" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteora" -- This one will probably only ever be used for actual meteors
L.shield = "Scudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teletrasporto" -- A boss/add/etc teleported somewhere
L.fear = "Paura" -- For abilities that cause you to flee in fear
L.breath = "Soffio" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Ruggito" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Balzo" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Carica" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Energia al massimo" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Indebolito" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Immune" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "Stordimento" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "Pozza" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Pozze" -- Plural of L.pool
L.totem = "Totem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Totem" -- Plural of L.totem
L.portal = "Portale" -- A portal somewhere, usually leading to a different location
L.portals = "Portali" -- Plural of L.portal
L.rift = "Fenditura" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Fenditure" -- Plural of L.rift
L.orb = "Globo" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Globi" -- Plural for L.orb
L.curse = "Maledizione" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Maledizioni" -- Plural of L.curse
L.disease = "Malattia" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Veleno" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Spirito" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Spiriti" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornado" -- Plural of L.tornado
L.frontal_cone = "Cono Frontale" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Paura" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Marchio" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marchi" -- Plural of L.marks
L.mind_control = "Controllo Mentale" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spell_reflection = "Rifletti Incantesimo" -- Any ability that reflects spells
L.parasite = "Parassita" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Immobilizzato" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.dodge = "Schiva" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "Risucchio di Salute" -- Any ability that drains health from the player
L.smash = "Frantumazione" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "Spuntone" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Spuntoni" -- Plural of L.spike
L.waves = "Onde" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
