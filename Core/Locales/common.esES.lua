local L = BigWigsAPI:NewLocale("BigWigs: Common", "esES")
if not L then return end

-- Prototype.lua common words
L.you = "%s en TI"
L.you_icon = "%s en |T13700%d:0|tTI"
L.underyou = "%s debajo de TI"
L.other = "%s: %s"
L.onboss = "%s en el JEFE"
L.buff_boss = "Beneficio en el JEFE: %s"
L.buff_other = "Beneficio en %s: %s"
L.on = "%s en %s"
L.stack = "%dx %s en %s"
L.stackyou = "%dx %s en TI"
L.cast = "<Lanza %s>"
L.casting = "Lanzando %s"
L.soon = "%s pronto"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s cerca de TI"
L.on_group = "%s en el GRUPO" -- spell on group

L.phase = "Fase %d"
L.stage = "Fase %d"
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.active = "Activo" -- When a boss becomes active, after speech finishes
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s durante %s sec" -- Spell for 10 seconds
L.over = "%s terminado" -- Spell Over
L.removed = "%s eliminado" -- Spell Removed
L.removed_from = "%s eliminado de %s" -- Spell removed from Player
L.removed_by = "%s eliminado por %s" -- Spell removed by Player
--L.removed_after = "%s removed after %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s inminente" -- Spell Incoming
L.interrupted = "%s interrumpido" -- Spell Interrupted
L.interrupted_by = "%s interrumpido por %s" -- Spell interrupted by Player
L.no = "No %s" -- No Spell
L.intermission = "Intermedio"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancelado" -- Spell Cancelled

-- Add related
L.add_spawned = "Aparece Esbirro"
L.spawned = "%s Apareció"
L.spawning = "%s aparece"
L.next_add = "Siguiente Esbirro"
L.add_killed = "Esbirro muerto (%d/%d)"
L.add_remaining = "Esbirro muerto, %d restantes"
L.add = "Esbirro"
L.adds = "Esbirros"
L.big_add = "Esbirro grande" -- singular
L.big_adds = "Esbirros grande" -- plural
L.small_add = "Esbirro pequeños" -- singular
L.small_adds = "Esbirros pequeños" -- plural

-- Mob related
L.mob_killed = "%s muerto (%d/%d)"
L.mob_remaining = "%s muerto, %d restantes"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s iniciado - %s en %d min"
L.custom_start_s = "%s iniciado - %s en %d seg"
L.custom_end = "%s entra en %s"
L.custom_min = "%s en %d min"
L.custom_sec = "%s en %d seg"

L.focus_only = "|cffff0000Alertas sólo para objetivos en Foco.|r "
L.trash = "Basura"

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
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Common ability name replacements
--L.tank_combo = "Tank Combo" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Láser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "Haz" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Haces" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombas" -- Plural of L.bomb
L.explosion = "Deflagración" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fijar" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Retroceso" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Trampas" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteoro" -- This one will probably only ever be used for actual meteors
L.shield = "Escudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teletransporte" -- A boss/add/etc teleported somewhere
L.fear = "Miedo" -- For abilities that cause you to flee in fear
