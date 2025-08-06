local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs: Common", "deDE")
if not L then return end

-- Prototype.lua common words
L.you = "%s auf DIR"
L.you_icon = "%s auf |T13700%d:0|tDIR"
L.underyou = "%s unter DIR"
L.aboveyou = "%s über DIR"
L.other = "%s: %s"
L.onboss = "%s auf dem BOSS"
L.buff_boss = "Buff auf BOSS: %s"
L.buff_other = "Buff auf %s: %s"
L.magic_buff_boss = "Magie Buff auf BOSS: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Magie Buff auf: %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s auf %s"
L.stack = "%dx %s auf %s" -- "5x SPELL_NAME on PLAYER_OR_NPC" showing how many stacks of a buff/debuff are on a player or NPC
L.stackyou = "%dx %s auf DIR" -- "5x SPELL_NAME on YOU" showing how many stacks of a buff/debuff are on you
L.stackboss = "%dx %s auf BOSS" -- "5x SPELL_NAME on BOSS" showing how many stacks of a buff/debuff are on the boss
L.stack_gained = "%dx erhalten" -- "Gained 5x" for situations where we show how many stacks of a buff were gained since last time a message showed
L.cast = "<Wirkt %s>"
L.casting = "Wirkt %s"
L.soon = "%s bald"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s in DEINER Nähe"
L.on_group = "%s auf GRUPPE"
L.boss = "BOSS"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Phase %d"
L.stage = "Phase %d"
L.wave = "Welle %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "Welle %d von %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Normaler Modus"
L.heroic = "Heroischer Modus"
L.mythic = "Mythischer Modus"
L.hard = "Schwerer Modus"
L.active = "Aktiv" -- When a boss becomes active, after speech finishes
L.ready = "Bereit" -- When a player is ready to do something
L.dead = "Tot" -- When a player is dead
L.general = "Allgemein" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Gesundheit" -- The health of an NPC
L.health_percent = "%d%% Gesundheit" -- "10% Health" The health percentage of an NPC
L.energy = "Energie"
L.energy_percent = "%d%% Energie" -- "80% Energy" The energy percentage of an NPC
L.door_open = "Tür offen" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Tor offen" -- When a gate is open, usually after a speech from an NPC
L.threat = "Bedrohung"

L.remaining = "%d übrig" -- 5 remaining
L.duration = "%s für %s Sek" -- Spell for 10 seconds
L.over = "%s vorbei" -- Spell Over
L.removed = "%s entfernt" -- Spell Removed
L.removed_from = "%s wurde von %s entfernt" -- Spell removed from Player
L.removed_by = "%s wurde durch %s entfernt" -- Spell removed by Player
L.removed_after = "%s entfernt nach %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s steht bevor" -- Spell Incoming
L.interrupted = "%s unterbrochen" -- Spell Interrupted
L.interrupted_by = "%s wurde von %s unterbrochen" -- Spell interrupted by Player
L.interruptible = "Unterbrechbar" -- when a spell is interruptible
L.no = "Kein %s" -- No Spell
L.intermission = "Zwischenphase"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s abgebrochen" -- Spell Cancelled
L.you_die = "Du stirbst" -- You will die
L.you_die_sec = "Du stirbst in %d Sek" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "Nächste Fähigkeit" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.boss_landing = "%s landet" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.landing = "Landet" -- Used when a flying NPC/dragon/boss is landing
L.flying_available = "Du kannst jetzt fliegen"
L.bosses_too_close = "Bosse sind zu nah zusammen" -- When 2 or more bosses are too close to each other, buffing each other with a shield, extra damage, etc.
L.keep_moving = "In Bewegung bleiben" -- An ability that forces you to keep moving or you will take damage
L.stand_still = "Stehen bleiben" -- An ability that forces you to stand still or you will take damage
L.safe_to_stop = "Stehen möglich" -- When an ability that forces you to keep moving fades from you, allowing you to stop moving
L.safe_to_move = "Bewegen möglich" -- When an ability to forces you to stand still fades from you, allowing you to move again
L.safe = "Sicher" -- You are safe from a bad ability
L.unsafe = "Unsicher" -- You are unsafe (in danger) of a bad ability

-- Add related
L.add_spawned = "Add erschienen" -- singular
L.adds_spawned = "Adds erschienen" -- plural
L.adds_spawned_count = "%d |4Add:Adds; erschienen" -- 1 add spawned / 2 adds spawned
L.add_spawning = "Add erscheint" -- singular
L.adds_spawning = "Adds erscheinen" -- plural
L.spawned = "%s erschienen"
L.spawning = "%s entsteht"
L.next_add = "Nächstes Add"
L.add_killed = "Add getötet (%d/%d)"
L.add_remaining = "Add getötet, noch %d übrig"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Großes Add" -- singular
L.big_adds = "Große Adds" -- plural
L.small_add = "Kleines Add" -- singular
L.small_adds = "Kleine Adds" -- plural

-- Mob related
L.killed = "%s getötet"
L.mob_killed = "%s getötet (%d/%d)"
L.mob_remaining = "%s getötet, noch %d übrig"

-- NPCs for follower dungeons
L.garrick = "Kapitänin Garrick" -- AI paladin tank (NPC 209057)
L.garrick_short = "*Garrick"
L.meredy = "Meredy Weidmannsheil" -- AI mage dps (NPC 209059)
L.meredy_short = "*Meredy"
L.shuja = "Shuja Grimmaxt" -- AI shaman dps (NPC 214390)
L.shuja_short = "*Shuja"
L.crenna = "Crenna Erdentochter" -- AI druid healer (NPC 209072)
L.crenna_short = "*Crenna"
L.austin = "Austin Haxwart" -- AI hunter dps (NPC 209065)
L.austin_short = "*Austin"
L.breka = "Kriegsherrin Breka Grimmaxt" -- AI warrior tank (NPC 215517)
L.breka_short = "*Breka"
L.henry = "Henry Garrick" -- AI priest healer (NPC 215011)
L.henry_short = "*Henry"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s angegriffen – %s in %d Min"
L.custom_start_s = "%s angegriffen – %s in %d Sek"
L.custom_end = "%s wird zum %s"
L.custom_min = "%s in %d Min"
L.custom_sec = "%s in %d Sek"

L.focus_only = "|cffff0000Warnungen nur für Fokusziel.|r "
L.trash = "Trash"
L.affixes = "Affixe" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s markieren"
L.marker_player_desc = "Markiert Spieler, die von %s betroffen sind, mit %s. Benötigt Leiter oder Assistent." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Markiert %s mit %s. Benötigt Leiter oder Assistent." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "Von '%s' betroffene NPCs mit %s markieren. Benötigt Leiter oder Assistent." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON
L.disabled = "Deaktiviert"
L.none = "Nichts"
L.markers = "Markierungen" -- Plural of marker

-- Ability where two players have to move close to each other
L.link = "Verbindung"
L.link_with = "Verbunden mit %s"
L.link_with_icon = "Verbunden mit |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Verbunden mit %s"
L.link_both = "%s + %s sind verbunden"
L.link_both_icon = "|T13700%d:0|t%s + |T13700%d:0|t%s sind verbunden"
L.link_removed = "Verbindung entfernt"
L.link_say_option_name = "Wiederholte 'Verbunden' Chatnachrichten"
L.link_say_option_desc = "Wiederholt Nachrichten im Sprechen-Chat um mitzuteilen mit wem Du verbunden bist."

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Directions
L.top = "Oben"
L.top_right = "Oben Rechts"
L.top_left = "Oben Links"
L.up = "Hoch"
L.middle = "Mitte"
L.down = "Runter"
L.bottom = "Unten"
L.bottom_right = "Unten Rechts"
L.bottom_left = "Unten Links"
L.left = "Links"
L.right = "Rechts"
L.north = "Norden"
L.north_east = "Nordosten"
L.east = "Osten"
L.south_east = "Südosten"
L.south = "Süden"
L.south_west = "Südwesten"
L.west = "Westen"
L.north_west = "Nordwesten"

-- Sizes
L.small = "Klein"
L.medium = "Mittel"
L.large = "Groß"

-- Schools
L.fire = "Feuer"
L.frost = "Frost"
L.shadow = "Schatten"
L.nature = "Natur"
L.arcane = "Arkan"

-- Autotalk
L.autotalk = "Automatische NPC Interaktion"
L.autotalk_boss_desc = "Automatisch die NPC Dialogoptionen wählen, welche den Bosskampf beginnen lassen."
L.autotalk_generic_desc = "Automatisch die NPC Dialogoptionen wählen, welche die nächste Phase des Dungeons einleiten."
L.autotalk_notice = "Automatisch mit NPC %s interagiert."

-- Common ability name replacements
L.absorb = "Absorbieren" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Heilung absorbiert" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Heilungen absorbiert" -- Plural of L.heal_absorb
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Laser" -- Plural of L.lasers
L.beam = "Strahl" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Strahlen" -- Plural of L.beam
L.bomb = "Bombe" -- Used for debuffs that make players explode
L.bombs = "Bomben" -- Plural of L.bomb
L.explosion = "Explosion" -- When the explosion from a bomb-like ability will occur
L.knockback = "Rückstoß" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Zurückschieben" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Fallen" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteor" -- This one will probably only ever be used for actual meteors
L.shield = "Schild" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teleport" -- A boss/add/etc teleported somewhere
L.breath = "Atem" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Brüllen" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Sprung" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Ansturm" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Volle Energie" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Geschwächt" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Immun" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "Betäubt" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "Pfütze" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Pfützen" -- Plural of L.pool
L.totem = "Totem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Totems" -- Plural of L.totem
L.portal = "Portal" -- A portal somewhere, usually leading to a different location
L.portals = "Portale" -- Plural of L.portal
L.rift = "Riss" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Risse" -- Plural of L.rift
L.orb = "Kugel" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Kugeln" -- Plural for L.orb
L.curse = "Fluch" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Flüche" -- Plural of L.curse
L.disease = "Krankheit" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Gift" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Geist" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Geister" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornados" -- Plural of L.tornado
L.frontal_cone = "Frontaler Kegel" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.mark = "Mal" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Male" -- Plural of L.marks
L.mind_control = "Gedankenkontrolle" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "GK" -- Short version of Mind Control, mainly for bars
L.spell_reflection = "Zauberreflexion" -- Any ability that reflects spells
L.rooted = "Bewegungsunfähig" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.ball = "Ball" -- A ball, like a football, basketball, etc
L.balls = "Bälle" -- Plural of L.ball
L.blind = "Blenden" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
L.dodge = "Ausweichen" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "Wutanfall" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "Furcht" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "Fixieren" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "Fixierungen" -- Plural of L.fixate
L.group_damage = "Gruppenschaden" -- Any ability that causes damage to every player in the 5 player group
L.health_drain = "Gesundheit entziehen" -- Any ability that drains health from the player
L.parasite = "Parasit" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "Parasiten" -- Plural of L.parasite
L.pull_in = "Heranziehen" -- An ability that pulls you in towards the boss against your will
L.raid_damage = "Raidschaden " -- Any ability that causes damage to every player in the raid
L.smash = "Schmettern" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spike = "Stachel" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Stacheln" -- Plural of L.spike
L.spread = "Verteilen" -- An ability that forces you to spread out away from other players, or you might damage them
L.tank_bomb = "Tank Bombe" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "Tank Kombi" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "Tank Debuff" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "Tank Frontal" -- Similar to L.frontal_cone but only applies to tanks
L.tank_soak = "Tank Soak" -- Similar to L.soak but only applies to tanks
L.tentacle = "Tentakel" -- Used for bosses that summon tentacles
L.tentacles = "Tentakel" -- Plural of L.tentacle
L.waves = "Wellen" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
L.whelp = "Welpe" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "Welpen" -- Plural of L.whelp
