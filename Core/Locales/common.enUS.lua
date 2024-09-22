local L = BigWigsAPI:NewLocale("BigWigs: Common", "enUS")

-- Prototype.lua common words
L.you = "%s on YOU"
L.you_icon = "%s on |T13700%d:0|tYOU"
L.underyou = "%s under YOU"
L.aboveyou = "%s above YOU"
L.other = "%s: %s"
L.onboss = "%s on BOSS"
L.buff_boss = "Buff on BOSS: %s"
L.buff_other = "Buff on %s: %s"
L.magic_buff_boss = "Magic buff on BOSS: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "Magic buff on %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s on %s"
L.stack = "%dx %s on %s"
L.stackyou = "%dx %s on YOU"
L.cast = "<Cast: %s>"
L.casting = "Casting %s"
L.soon = "%s soon"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s near YOU"
L.on_group = "%s on GROUP"
L.boss = "BOSS"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Phase %d"
L.stage = "Stage %d"
L.wave = "Wave %d" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "Wave %d of %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Normal mode"
L.heroic = "Heroic mode"
L.mythic = "Mythic mode"
L.hard = "Hard mode"
L.active = "Active" -- When a boss becomes active, after speech finishes
L.ready = "Ready" -- When a player is ready to do something
L.dead = "Dead" -- When a player is dead
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "Health" -- The health of an NPC
L.health_percent = "%d%% Health" -- "10% Health" The health percentage of an NPC
L.door_open = "Door open" -- When a door is open, usually after a speech from an NPC
L.gate_open = "Gate open" -- When a gate is open, usually after a speech from an NPC
L.threat = "Threat"
L.energy = "Energy"

L.remaining = "%d remaining" -- 5 remaining
L.duration = "%s for %s sec" -- Spell for 10 seconds
L.over = "%s over" -- Spell over
L.removed = "%s removed" -- Spell removed
L.removed_from = "%s removed from %s" -- Spell removed from Player
L.removed_by = "%s removed by %s" -- Spell removed by Player
L.removed_after = "%s removed after %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s incoming" -- Spell incoming
L.interrupted = "%s interrupted" -- Spell interrupted
L.interrupted_by = "%s interrupted by %s" -- Spell interrupted by Player
L.interruptible = "Interruptible" -- when a spell is interruptible
L.no = "No %s" -- No Spell
L.intermission = "Intermission"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s cancelled" -- Spell cancelled
L.you_die = "You die" -- You will die
L.you_die_sec = "You die in %d sec" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "Next ability" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.landing = "%s is landing" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.flying_available = "You can fly now"

-- Add related
L.add_spawned = "Add spawned" -- singular
L.adds_spawned = "Adds spawned" -- plural
L.adds_spawned_count = "%d |4add:adds; spawned" -- 1 add spawned / 2 adds spawned
L.add_spawning = "Add spawning" -- singular
L.adds_spawning = "Adds spawning" -- plural
L.spawned = "%s spawned"
L.spawning = "%s spawning"
L.next_add = "Next Add"
L.add_killed = "Add killed (%d/%d)"
L.add_remaining = "Add killed, %d remaining"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Big Add" -- singular
L.big_adds = "Big Adds" -- plural
L.small_add = "Small Add" -- singular
L.small_adds = "Small Adds" -- plural

-- Mob related
L.killed = "%s killed"
L.mob_killed = "%s killed (%d/%d)"
L.mob_remaining = "%s killed, %d remaining"

-- NPCs for follower dungeons
L.garrick = "Captain Garrick" -- AI paladin tank (NPC 209057)
L.garrick_short = "*Garrick"
L.meredy = "Meredy Huntswell" -- AI mage dps (NPC 209059)
L.meredy_short = "*Meredy"
L.shuja = "Shuja Grimaxe" -- AI shaman dps (NPC 214390)
L.shuja_short = "*Shuja"
L.crenna = "Crenna Earth-Daughter" -- AI druid healer (NPC 209072)
L.crenna_short = "*Crenna"
L.austin = "Austin Huxworth" -- AI hunter dps (NPC 209065)
L.austin_short = "*Austin"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s engaged - %s in %d min"
L.custom_start_s = "%s engaged - %s in %d sec"
L.custom_end = "%s goes %s"
L.custom_min = "%s in %d min"
L.custom_sec = "%s in %d sec"

L.focus_only = "|cffff0000Focus target alerts only.|r "
L.trash = "Trash"
L.affixes = "Affixes" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s marker"
L.marker_player_desc = "Mark players affected by '%s' with %s, requires promoted or leader." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Mark %s with %s, requires promoted or leader." -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "Mark NPCs affected by '%s' with %s, requires promoted or leader." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "Link"
L.link_with = "Linked with %s"
L.link_with_icon = "Linked with |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Linked with %s"
L.link_both = "%s + %s are linked"
L.link_both_icon = "|T13700%d:0|t%s + |T13700%d:0|t%s are linked"
L.link_removed = "Link removed"
L.link_say_option_name = "Repeating 'Linked' say messages"
L.link_say_option_desc = "Repeating say messages in chat stating who you are linked with."

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Directions
L.top = "Top"
L.up = "Up"
L.middle = "Middle"
L.down = "Down"
L.bottom = "Bottom"
L.left = "Left"
L.right = "Right"
L.north = "North"
L.north_east = "North-East"
L.east = "East" -- I thought you said weast!
L.south_east = "South-East"
L.south = "South"
L.south_west = "South-West"
L.west = "West"
L.north_west = "North-West"

-- Schools
L.fire = "Fire"
L.frost = "Frost"
L.shadow = "Shadow"
L.nature = "Nature"
L.arcane = "Arcane"

-- Autotalk
L.autotalk = "Automatic NPC interaction"
L.autotalk_boss_desc = "Automatically select the NPC dialog options that cause the boss encounter to begin."
L.autotalk_generic_desc = "Automatically select the NPC dialog options that cause you to progress to the next stage of the dungeon."

-- Common ability name replacements
L.absorb = "Absorb" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "Heal Absorb" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "Heal Absorbs" -- Plural of L.heal_absorb
L.tank_combo = "Tank Combo" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Lasers" -- Plural of L.lasers
L.beam = "Beam" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Beams" -- Plural of L.beam
L.bomb = "Bomb" -- Used for debuffs that make players explode
L.bombs = "Bombs" -- Plural of L.bomb
L.explosion = "Explosion" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fixate" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Knockback" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Pushback" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Traps" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteor" -- This one will probably only ever be used for actual meteors
L.shield = "Shield" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teleport" -- A boss/add/etc teleported somewhere
L.fear = "Fear" -- For abilities that cause you to flee in fear
L.breath = "Breath" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Roar" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Leap" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Charge" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Full Energy" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Weakened" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Immune" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "Stunned" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "Pool" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Pools" -- Plural of L.pool
L.totem = "Totem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Totems" -- Plural of L.totem
L.portal = "Portal" -- A portal somewhere, usually leading to a different location
L.portals = "Portals" -- Plural of L.portal
L.rift = "Rift" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Rifts" -- Plural of L.rift
L.orb = "Orb" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Orbs" -- Plural for L.orb
L.curse = "Curse" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Curses" -- Plural of L.curse
L.disease = "Disease" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Poison" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Spirit" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Spirits" -- Plural of L.spirit
L.tornado = "Tornado" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornadoes" -- Plural of L.tornado
L.frontal_cone = "Frontal Cone" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Fear" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Mark" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marks" -- Plural of L.marks
L.mind_control = "Mind Control" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "MC" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spell_reflection = "Spell Reflection" -- Any ability that reflects spells
L.parasite = "Parasite" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Rooted" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.dodge = "Dodge" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "Health Drain" -- Any ability that drains health from the player
L.smash = "Smash" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "Spike" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "Spikes" -- Plural of L.spike
L.waves = "Waves" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
