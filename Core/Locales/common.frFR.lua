local L = BigWigsAPI:NewLocale("BigWigs: Common", "frFR")
if not L then return end
local female = UnitSex("player") == 3

-- Prototype.lua common words
L.you = "%s sur VOUS"
L.you_icon = "%s sur |T13700%d:0|tVOUS"
L.underyou = "%s en dessous de VOUS"
L.other = "%s : %s"
L.onboss = "%s sur le BOSS"
L.buff_boss = "Buff sur le BOSS : %s"
L.buff_other = "Buff sur %s : %s"
L.on = "%s sur %s"
L.stack = "%dx %s sur %s"
L.stackyou = "%dx %s sur VOUS"
L.cast = "<%s incanté>"
L.casting = "%s en incantation"
L.soon = "%s bientôt"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s près de VOUS"
L.on_group = "%s sur le GROUPE" -- spell on group

L.phase = "Phase %d"
L.stage = "Phase %d"
L.normal = "Mode normal"
L.heroic = "Mode héroïque"
L.mythic = "Mode mythique"
L.active = "Actif" -- When a boss becomes active, after speech finishes
L.general = "Général" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s pendant %s sec." -- Spell for 10 seconds
L.over = "%s terminé" -- Spell Over
L.removed = "%s enlevé" -- Spell Removed
L.removed_from = "%s enlevé de %s" -- Spell removed from Player
L.removed_by = "%s enlevé par %s" -- Spell removed by Player
L.incoming = "Arrivée |2 %s" -- Spell Incoming
L.interrupted = "%s interrompu" -- Spell Interrupted
L.interrupted_by = "%s interrompu par %s" -- Spell interrupted by Player
L.no = "Sans %s" -- No Spell
L.intermission = "Intervalle"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s annulé" -- Spell Cancelled

-- Add related
L.add_spawned = "Add apparu"
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
L.mob_killed = "%s tué (%d/%d)"
L.mob_remaining = "%s tué, il en reste %d"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s engagé - %s dans %d min."
L.custom_start_s = "%s engagé - %s dans %d sec."
L.custom_end = "%s devient %s"
L.custom_min = "%s dans %d min."
L.custom_sec = "%s dans %d sec."

L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
L.trash = "Trash"

-- Common raid marking locale
L.marker = "Marquage %s"
L.marker_player_desc = "Marque les joueurs affectés par %s avec %s. Nécessite d'être assistant ou chef de raid."
L.marker_npc_desc = "Marque %s avec %s. Nécessite d'être assistant ou chef de raid."

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

-- Common ability name replacements
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "Rayon" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Rayons" -- Plural of L.beam
L.bomb = "Bombe" -- Used for debuffs that make players explode
L.bombs = "Bombes" -- Plural of L.bomb
L.explosion = "Explosion" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fixer" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Repousser" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Pièges" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Météore" -- This one will probably only ever be used for actual meteors
L.shield = "Bouclier" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Téléportation" -- A boss/add/etc teleported somewhere
L.fear = "Peur" -- For abilities that cause you to flee in fear
