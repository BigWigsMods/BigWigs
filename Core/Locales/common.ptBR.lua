local L = BigWigsAPI:NewLocale("BigWigs: Common", "ptBR")
if not L then return end

-- Prototype.lua common words
L.you = "%s em VOCÊ"
L.you_icon = "%s em |T13700%d:0|tVOCÊ"
L.underyou = "%s debaixo de VOCÊ"
L.other = "%s: %s"
L.onboss = "%s no CHEFE"
L.buff_boss = "Buff no CHEFE: %s"
L.buff_other = "Buff no %s: %s"
L.on = "%s em %s"
L.stack = "%dx %s em %s"
L.stackyou = "%dx %s em VOCÊ"
L.cast = "<Conjurando %s>"
L.casting = "Conjurando: %s"
L.soon = "%s em breve"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.rticon = "%s ({rt%d})"
L.near = "%s perto de VOCÊ"
L.on_group = "%s no GRUPO" -- spell on group

L.phase = "Fase %d"
L.stage = "Estágio %d"
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.active = "Ativo" -- When a boss becomes active, after speech finishes
L.general = "Geral" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s durante %s seg" -- Spell for 10 seconds
L.over = "%s Acabou" -- Spell Over
L.removed = "%s Removido" -- Spell Removed
L.removed_from = "%s Removido %s" -- Spell removed from Player
L.removed_by = "%s Removido por %s" -- Spell removed by Player
L.removed_after = "%s removido depois de %.1fs" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "%s Chegando" -- Spell Incoming
L.interrupted = "%s Interrompido" -- Spell Interrupted
L.interrupted_by = "%s interrompido por %s" -- Spell interrupted by Player
L.no = "Sem %s" -- No Spell
L.intermission = "Intervalo"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s Cancelado" -- Spell Cancelled

-- Add related
L.add_spawned = "Add surgiu"
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

-- Common raid marking locale
L.marker = "Marcador %s"
L.marker_player_desc = "Marca jogadores afetados por %s com %s, requer líder ou assistente."
L.marker_npc_desc = "Marca %s com %s, requer líder ou assistente."

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

-- Common ability name replacements
--L.tank_combo = "Tank Combo" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.beam = "Feixe" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "Feixes" -- Plural of L.beam
L.bomb = "Bomba" -- Used for debuffs that make players explode
L.bombs = "Bombas" -- Plural of L.bomb
L.explosion = "Explosão" -- When the explosion from a bomb-like ability will occur
L.fixate = "Fixação" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Empurrão" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Armadilhas" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "Meteoro" -- This one will probably only ever be used for actual meteors
L.shield = "Escudo" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "Teleporte" -- A boss/add/etc teleported somewhere
L.fear = "Medo" -- For abilities that cause you to flee in fear
