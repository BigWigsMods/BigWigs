local L = BigWigsAPI:NewLocale("BigWigs: Common", "itIT")
if not L then return end

L.add = "Add"
L.add_killed = "Add ucciso (%d/%d)"
L.add_remaining = "Add ucciso, %d rimasti"
L.adds = "Adds"
L.add_spawned = "Add Apparso"
L.cast = "<Lancio di %s>"
L.casting = "Lancio di %s"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.custom_end = "%s diventa %s"
L.custom_min = "%s in %d min"
L.custom_sec = "%s in %d sec"
L.custom_start = "Combattimento con %s iniziato - %s in %d min"
L.custom_start_s = "Combattimento con %s iniziato - %s in %d sec"
L.focus_only = "|cffff0000Avviso solo per i bersagli focus.|r "
L.general = "Generali" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "Modalità Eroica"
L.mob_killed = "%s ucciso (%d/%d)"
L.mob_remaining = "%s ucciso, %d rimasti"
L.mythic = "Modalità Mitica"
L.near = "%s vicino A TE"
L.next_add = "Prossimo Add"
L.normal = "Modalità Normale"
L.on = "%s su %s"
L.onboss = "%s sul BOSS"
L.buff_boss = "Potenziamento sul BOSS: %s"
L.buff_other = "Potenziamento su %s: %s"
L.other = "%s: %s"
L.phase = "Fase %d"
L.soon = "%s tra poco"
L.spawned = "%s Reinizializzato"
L.spawning = "Apparizione di %s"
L.stack = "%dx %s su %s"
L.stackyou = "%dx %s su DI TE"
L.stage = "Fase %d"
L.trash = "Trash"
L.underyou = "%s sotto di TE"
L.you = "%s su di TE"
L.you_icon = "%s su di |T13700%d:0|tTE"
L.on_group = "%s sul GRUPPO" -- spell on group

L.duration = "%s per %s sec" -- Spell for 10 seconds
L.over = "%s Terminato" -- Spell Over
L.removed = "%s Rimosso" -- Spell Removed
L.removed_from = "%s rimosso da %s" -- Spell removed from Player
L.removed_by = "%s rimosso da %s" -- Spell removed by Player
L.incoming = "%s Tra Poco" -- Spell Incoming
L.interrupted = "%s Interrotto" -- Spell Interrupted
L.interrupted_by = "%s interrotto da %s" -- Spell interrupted by Player
L.no = "Nessun %s" -- No Spell
L.intermission = "Intermezzo"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancellata" -- Spell Cancelled

L.big_add = "Add Maggiore" -- singular
L.big_adds = "Adds Maggiori" -- plural
L.small_add = "Add Minore" -- singular
L.small_adds = "Adds Minori" -- plural

L.active = "Attivo" -- When a boss becomes active, after speech finishes

-- Common raid marking locale
L.marker = "Icona bersaglio %s"
L.marker_player_desc = "Marchia i giocatori affetti da %s con %s, necessario ruolo assistente o capo."
L.marker_npc_desc = "Marchia %s con %s, necessario ruolo assistente o capo."

-- Ability where two players have to move close to each other
L.link = "Vincolo"
L.link_with = "Vincolato a %s"
L.link_with_icon = "Vincolato a |T13700%d:0|t%s"
L.link_short = "Vincolo: %s"
L.link_both = "%s Vincolato a %s"
L.link_removed = "Vincolo rimosso"

-- Abbreviated numbers
L.amount_one = "%dMrd" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dk" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Common ability name replacements
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "Raggio" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Raggi" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.explosion = "Esplosione" -- When the explosion from a bomb-like ability will occur
L.fixate = "Ossessione" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Contraccolpo" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Trappole" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteora" -- This one will probably only ever be used for actual meteors
L.shield = "Scudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teletrasporto" -- A boss/add/etc teleported somewhere
L.fear = "Paura" -- For abilities that cause you to flee in fear
