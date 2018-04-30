local L = BigWigsAPI:NewLocale("BigWigs: Common", "ptBR")
if not L then return end

Prototype.lua common words
L.you = "%s em VOCÊ"
L.underyou = "%s debaixo de VOCÊ"
L.other = "%s: %s"
L.onboss = "%s no CHEFE"
L.on = "%s em %s"
L.stack = "%dx %s em %s"
L.stackyou = "%dx %s em VOCÊ"
L.cast = "<Conjurando %s>"
L.casting = "Conjurando: %s"
L.soon = "%s em breve"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "%s perto de VOCÊ"

L.phase = "Fase %d"
L.stage = "Estágio %d"
L.normal = "Modo normal"
L.heroic = "Modo heroico"
L.mythic = "Modo mítico"
L.active = "Ativo" -- When a boss becomes active, after speech finishes
L.general = "Geral" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s durante %s seg"
L.over = "%s Acabou"
L.removed = "%s Removido"
L.removed_from = "%s Removido %s"
L.removed_by = "%s Removido por %s" -- spell removed by player
L.incoming = "%s Chegando"
L.interrupted = "%s Interrompido"
L.interrupted_by = "%s interrompido por %s" -- spell interrupted by player
L.no = "Sem %s"
L.intermission = "Intervalo"
L.percent = "%d%% - %s" -- 20% - spell

-- Add related
L.add_spawned = "Add surgiu"
L.spawned = "%s surgiu"
L.spawning = "%s Chegando"
L.next_add = "Próximo add"
L.add_killed = "Add morto (%d/%d)"
L.add_remaining = "Add morto, restam %d"
L.add = "Inimigo adicional"
L.adds = "Inimigos adicionais"
L.big_add = "Add Grande"
L.small_adds = "Adds Pequenos"

-- Mob related
L.mob_killed = "%s morto (%d/%d)"
L.mob_remaining = "%s morto, %d restando"

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
L.link = "Ligado com %s"
L.link_short = "Ligado: %s"
L.link_both = "%s ligado com %s"
L.link_removed = "Ligação removida"

-- Abbreviated numbers
L.amount_one = "%dB"
L.amount_two = "%dM"
L.amount_three = "%dK"
