local L = BigWigsAPI:NewLocale("BigWigs: Common", "frFR")
if not L then return end
local female = UnitSex("player") == 3

-- Prototype.lua common words
L.you = "%s sur VOUS"
L.you_icon = "%s sur |T13700%d:0|tVOUS"
L.underyou = "%s en dessous de VOUS"
L.aboveyou = "%s au dessus de VOUS"
L.other = "%s : %s"
L.onboss = "%s sur le BOSS"
L.buff_boss = "Buff sur le BOSS : %s"
L.buff_other = "Buff sur %s : %s"
--L.magic_buff_boss = "Magic buff on BOSS: %s" -- Magic buff on BOSS: SPELL_NAME
--L.magic_buff_other = "Magic buff on %s: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s sur %s"
L.stack = "%dx %s sur %s"
L.stackyou = "%dx %s sur VOUS"
L.cast = "<%s incanté>"
L.casting = "%s en incantation"
L.soon = "%s bientôt"
L.count = "%s (%d)"
L.count_amount = "%s (%d/%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s près de VOUS"
L.on_group = "%s sur le GROUPE" -- spell on group
L.boss = "BOSS"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s (%s)" -- SPELL_NAME (short spell name or extra information)

L.phase = "Phase %d"
L.stage = "Phase %d"
--L.wave = "Wave %d" -- e.g. "Wave 1" (Waves of adds)
--L.wave_count = "Wave %d of %d" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "Mode normal"
L.heroic = "Mode héroïque"
L.mythic = "Mode mythique"
L.hard = "Mode difficile"
L.active = "Actif" -- When a boss becomes active, after speech finishes
L.ready = "Prêt" -- When a player is ready to do something
L.dead = "Mort" -- When a player is dead
L.general = "Général" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
--L.health = "Health" -- The health of an NPC
--L.health_percent = "%d%% Health" -- "10% Health" The health percentage of an NPC
--L.door_open = "Door open" -- When a door is open, usually after a speech from an NPC
--L.gate_open = "Gate open" -- When a gate is open, usually after a speech from an NPC

L.duration = "%s pendant %s sec." -- Spell for 10 seconds
L.over = "%s terminé" -- Spell Over
L.removed = "%s enlevé" -- Spell Removed
L.removed_from = "%s enlevé de %s" -- Spell removed from Player
L.removed_by = "%s enlevé par %s" -- Spell removed by Player
L.removed_after = "%s enlevé en %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "Arrivée |2 %s" -- Spell Incoming
L.interrupted = "%s interrompu" -- Spell Interrupted
L.interrupted_by = "%s interrompu par %s" -- Spell interrupted by Player
--L.interruptible = "Interruptible" -- when a spell is interruptible
L.no = "Sans %s" -- No Spell
L.intermission = "Intervalle"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s annulé" -- Spell Cancelled
L.you_die = "Vous êtes mort" -- You will die
L.you_die_sec = "Vous mourrez dans %d sec." -- "You die in 15 sec" (sec = seconds)
--L.next_ability = "Next ability" -- We don't know what ability will be next, we only know when it will happen (showing a bar)

-- Add related
L.add_spawned = "Add apparu"
--L.adds_spawned = "Adds apparu"
L.spawned = "%s apparu"
L.spawning = "Apparition |2 %s"
L.next_add = "Prochain Add"
L.add_killed = "Add tué (%d/%d)"
L.add_remaining = "Add tué, il en reste %d"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Gros add" -- singular
L.big_adds = "Gros adds" -- plural
L.small_add = "Petit add" -- singular
L.small_adds = "Petits adds" -- plural

-- Mob related
L.killed = "%s tué"
L.mob_killed = "%s tué (%d/%d)"
L.mob_remaining = "%s tué, il en reste %d"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s engagé - %s dans %d min."
L.custom_start_s = "%s engagé - %s dans %d sec."
L.custom_end = "%s devient %s"
L.custom_min = "%s dans %d min."
L.custom_sec = "%s dans %d sec."

L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
L.trash = "Trash"
L.affixes = "Affixes" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "Marquage %s"
L.marker_player_desc = "Marque les joueurs affectés par %s avec %s. Nécessite d'être assistant ou chef de raid." -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "Marque %s avec %s. Nécessite d'être assistant ou chef de raid." -- Mark NPC_NAME with SKULL_ICON
--L.marker_npc_aura_desc = "Mark NPCs affected by '%s' with %s, requires promoted or leader." -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "Lien"
L.link_with = (female and "Liée" or "Lié") .." avec %s"
L.link_with_icon = (female and "Liée" or "Lié") .." avec |T13700%d:0|t%s"
L.link_short = (female and "Liée" or "Lié") .." : %s"
L.link_both = "%s est ".. (female and "liée" or "lié") .." avec %s"
L.link_removed = "Lien enlevé"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Directions
L.top = "En haut"
L.up = "En haut"
L.middle = "Au milieu"
L.down = "En bas"
L.bottom = "En bas"
L.left = "À gauche"
L.right = "À droite"
L.north = "Nord"
L.north_east = "Nord-est"
L.east = "Est"
L.south_east = "Sud-est"
L.south = "Sud"
L.south_west = "Sud-ouest"
L.west = "Ouest"
L.north_west = "Nord-ouest"

-- Schools
L.fire = "Feu"
L.frost = "Givre"
L.shadow = "Ombre"
L.nature = "Nature"
L.arcane = "Arcanes"

-- Common ability name replacements
L.absorb = "Absorbe" -- Used for shield-like abilities that absorb damage or healing
--L.heal_absorb = "Heal Absorb" -- Used for shield-like abilities that absorb healing only
--L.heal_absorbs = "Heal Absorbs" -- Plural of L.heal_absorb
L.tank_combo = "Combo Tank" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "Lasers" -- Plural of L.lasers
L.beam = "Rayon" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Rayons" -- Plural of L.beam
L.bomb = "Bombe" -- Used for debuffs that make players explode
L.bombs = "Bombes" -- Plural of L.bomb
L.explosion = "Explosion" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fixer" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Repousser" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "Repousser continu" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "Pièges" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Météore" -- This one will probably only ever be used for actual meteors
L.shield = "Bouclier" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Téléportation" -- A boss/add/etc teleported somewhere
L.fear = "Peur" -- For abilities that cause you to flee in fear
L.breath = "Souffle" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "Cri" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "Bond" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "Charge" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "Energie pleine" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "Affaibli" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "Insensible" -- When a boss becomes immune to all damage and you can no longer hurt it
L.pool = "Flaque" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "Flaques" -- Plural of L.pool
L.totem = "Totem" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "Totems" -- Plural of L.totem
L.portal = "Portail" -- A portal somewhere, usually leading to a different location
L.portals = "Portails" -- Plural of L.portal
L.rift = "Faille" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "Failles" -- Plural of L.rift
L.orb = "Orbe" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "Orbes" -- Plural for L.orb
L.curse = "Malédiction" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "Malédictions" -- Plural of L.curse
L.disease = "Maladie" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "Poison" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "Esprit" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "Esprits" -- Plural of L.spirit
L.tornado = "Tornade" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "Tornades" -- Plural of L.tornado
L.frontal_cone = "Cône Devant" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "Peur" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "Marque" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "Marques" -- Plural of L.marks
L.mind_control = "Contrôle mental" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "CM" -- Short version of Mind Control, mainly for bars
L.soak = "Soak" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "Soaks" -- Plural of L.soak
L.spell_reflection = "Renvoi de sort" -- Any ability that reflects spells
L.parasite = "Parasite" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "Immobilisé" -- Any ability that roots you in place, preventing you from moving
