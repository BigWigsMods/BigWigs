local L = BigWigsAPI:NewLocale("BigWigs: Common", "ptBR")
if not L then return end

-- Prototype.lua palavras comuns
L.you = "%s em VOCÊ"
L.you_icon = "%s em |T13700%d:0|tVOCÊ"
L.underyou = "%s debaixo de VOCÊ"
L.aboveyou = "%s acima de VOCÊ"
L.other = "%s: %s"
L.onboss = "%s no CHEFE"
L.buff_boss = "Buff no CHEFE: %s"
L.buff_other = "Buff no %s: %s"
L.magic_buff_boss = "Buff mágico no CHEFE: %s" -- Buff mágico no CHEFE: NOME_DO_FEITIÇO
L.magic_buff_other = "Buff mágico em %s: %s" -- Buff mágico no NOME_DO_NPC: NOME_DO_FEITIÇO
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
L.on_group = "%s no GRUPO" -- feitiço no grupo
L.boss = "CHEFE"
L.plus = "%s + %s" -- Feitiço 1 + Feitiço 2
L.extra = "%s (%s)" -- NOME_DO_FEITIÇO (nome curto do feitiço ou informação extra)

L.phase = "Fase %d"
L.stage = "Estágio %d"
L.wave = "Onda %d" -- Ex.: "Onda 1" (Ondas de adds)
L.wave_count = "Onda %d de %d" -- Onda 1 de 3 (Usualmente ondas de adds)
L.normal = "Modo normal"
L.heroic = "Modo heróico"
L.mythic = "Modo mítico"
L.hard = "Modo difícil"
L.active = "Ativo" -- Quando um chefe se torna ativo, após o discurso
L.ready = "Pronto" -- Quando um jogador está pronto para fazer algo
L.dead = "Morto" -- Quando um jogador está morto
L.general = "Geral" -- Configurações gerais, aplicáveis ao modo normal, heróico e mítico
L.health = "Vida" -- A vida de um NPC
L.health_percent = "%d%% de Vida" -- "10% de Vida" A porcentagem de vida de um NPC
L.door_open = "Porta Aberta" -- Quando uma porta é aberta, geralmente após um discurso de um NPC
L.gate_open = "Portão Aberto" -- Quando um portão é aberto, geralmente após um discurso de um NPC
L.threat = "Ameaça"
L.energy = "Energia"

L.remaining = "%d restantes" -- 5 restantes
L.duration = "%s durante %s seg" -- Feitiço por 10 segundos
L.over = "%s acabou" -- Feitiço acabou
L.removed = "%s removido" -- Feitiço removido
L.removed_from = "%s removido de %s" -- Feitiço removido do Jogador
L.removed_by = "%s removido por %s" -- Feitiço removido pelo Jogador
L.removed_after = "%s removido depois de %.1fs" -- "Feitiço removido após 1.1s" (s = segundos)
L.incoming = "%s a caminho" -- Feitiço a caminho
L.interrupted = "%s interrompido" -- Feitiço interrompido
L.interrupted_by = "%s interrompido por %s" -- Feitiço interrompido pelo Jogador
L.interruptible = "Interrompível" -- Quando um feitiço é interrompível
L.no = "Sem %s" -- Sem feitiço
L.intermission = "Intervalo"
L.percent = "%d%% - %s" -- 20% - Feitiço
L.cancelled = "%s Cancelado" -- Feitiço Cancelado
L.you_die = "Você morrerá" -- Você morrerá
L.you_die_sec = "Você morrerá em %d seg" -- "Você morrerá em 15 seg" (seg = segundos)
L.next_ability = "Próxima Habilidade" -- Não sabemos qual habilidade será a próxima, apenas quando ela acontecerá (mostrando uma barra)
L.landing = "%s está pousando" -- "NOME_DO_NPC está pousando" Usado quando um NPC/dragão/chefe está pousando
L.flying_available = "Pode voar agora"

-- Relacionado a adds
L.add_spawned = "Add surgiu" -- singular
L.adds_spawned = "Adds surgiram" -- plural
L.adds_spawned_count = "%d |4add:adds; surgiram" -- 1 add surgiu / 2 adds surgiram
L.add_spawning = "Add surgindo" -- singular
L.adds_spawning = "Adds surgindo" -- plural
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

-- Relacionado a mobs
L.killed = "%s morto"
L.mob_killed = "%s morto (%d/%d)"
L.mob_remaining = "%s morto, %d restando"

-- NPCs para masmorras de seguidores
L.garrick = "Capitã Garrick" -- Paladino tanque IA (NPC 209057)
L.garrick_short = "*Garrick"
L.meredy = "Mereida Caçaboa" -- Mago DPS IA (NPC 209059)
L.meredy_short = "*Mereida"
L.shuja = "Shuya Sinistracha" -- Xamã DPS IA (NPC 214390)
L.shuja_short = "*Shuya"
L.crenna = "Crenna Filha da Terra" -- Druida curadora IA (NPC 209072)
L.crenna_short = "*Crenna"
L.austin = "Austin Huxworth" -- Caçador DPS IA (NPC 209065)
L.austin_short = "*Austin"

-- Nota dos localizadores:
L.custom_start = "%s iniciado - %s em %d min"
L.custom_start_s = "%s iniciado - %s em %d seg"
L.custom_end = "%s começa em %s"
L.custom_min = "%s em %d min"
L.custom_sec = "%s em %d seg"

L.focus_only = "|cffff0000Apenas alertas de focar alvo.|r "
L.trash = "Trash"
L.affixes = "Afixos" -- Afixos sazonais para raides e masmorras míticas+

-- Localização comum de marcas de raide
L.marker = "Marcador %s"
L.marker_player_desc = "Marca jogadores afetados por %s com %s, requer líder ou assistente." -- Marca jogadores afetados por 'NOME_DO_FEITIÇO' com ÍCONE_DE_CAVEIRA
L.marker_npc_desc = "Marca %s com %s, requer líder ou assistente." -- Marca NOME_DO_NPC com ÍCONE_DE_CAVEIRA

-- Habilidade onde dois jogadores precisam se aproximar um do outro
L.link = "Ligação"
L.link_with = "Ligado com %s"
L.link_with_icon = "Ligado com |T13700%d:0|t%s"
L.link_with_rticon = "{rt%d}Ligado com %s"
L.link_both = "%s ligado com %s" -- Precisa ser atualizado
L.link_both_icon = "|T13700%d:0|t%s ligado com |T13700%d:0|t%s" -- Precisa ser atualizado
L.link_removed = "Ligação removida"

-- Abreviações de números
L.amount_one = "%dB" -- Bilhões 1.000.000.000
L.amount_two = "%dM" -- Milhões 1.000.000
L.amount_three = "%dK" -- Milhares 1.000
L.seconds = "%.1fs" -- 1.1 segundos

-- Direções
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

-- Escolas
L.fire = "Fogo"
L.frost = "Gelo"
L.shadow = "Sombra"
L.nature = "Natureza"
L.arcane = "Arcano"

-- Fala automática
L.autotalk = "Interação automática com NPCs"
L.autotalk_boss_desc = "Seleciona automaticamente as opções de diálogo com o NPC que iniciam o encontro com o chefe."
L.autotalk_generic_desc = "Seleciona automaticamente as opções de diálogo com o NPC que fazem você progredir para a próxima fase da masmorra."

-- Substituições comuns para nomes de habilidades
L.absorb = "Absorver" -- Usado para habilidades de escudo que absorvem dano ou cura
L.heal_absorb = "Absorção de Cura" -- Usado para habilidades de escudo que absorvem apenas cura
L.heal_absorbs = "Absorção de Cura" -- Plural de L.heal_absorb
L.tank_combo = "Combo de Tanque" -- Usado para mecânicas de troca de tanque onde o chefe usa uma sequência de ataques devastadores
L.laser = "Laser" -- Usado para habilidades que agem como laser, geralmente do chefe para o jogador ou para uma área específica
L.lasers = "Lasers" -- Plural de L.laser
L.beam = "Feixe" -- Similar ao "Laser", mas usado para descrever melhor habilidades que não parecem um laser
L.beams = "Feixes" -- Plural de L.beam
L.bomb = "Bomba" -- Usado para debuffs que fazem os jogadores explodirem
L.bombs = "Bombas" -- Plural de L.bomb
L.explosion = "Explosão" -- Quando a explosão de uma habilidade como bomba ocorrerá
L.fixate = "Fixação" -- Usado quando um chefe ou add está perseguindo/obcecado por um jogador
L.knockback = "Empurrão" -- Usado quando uma habilidade empurra os jogadores para longe de um certo ponto
L.pushback = "Repulsão" -- Usado quando uma habilidade empurra lentamente e continuamente um jogador para longe
L.traps = "Armadilhas" -- Usado para habilidades que agem como armadilhas no chão
L.meteor = "Meteoro" -- Usado apenas para meteoros reais
L.shield = "Escudo" -- Habilidades que absorvem dano ou cura criando um "escudo"
L.teleport = "Teleporte" -- Um chefe/add/etc se teleporta para algum lugar
L.fear = "Medo" -- Para habilidades que fazem você fugir de medo
L.breath = "Sopro" -- Quando um chefe cospe fogo/gelo/etc. em um jogador ou no raide
L.roar = "Rugido" -- Quando um chefe solta um rugido alto
L.leap = "Salto" -- Quando um chefe salta de um local para outro ou para um jogador
L.charge = "Investida" -- Quando um chefe escolhe um alvo novo e investe rapidamente
L.full_energy = "Energia Cheia" -- Quando um chefe atinge energia máxima e costuma lançar uma habilidade poderosa
L.weakened = "Enfraquecido" -- Quando um chefe fica enfraquecido
L.immune = "Imune" -- Quando um chefe fica imune a todos os danos
L.stunned = "Atordoado" -- Quando um chefe fica atordoado e não pode lançar habilidades ou se mover
L.pool = "Poça" -- Uma poça ou líquido no chão, geralmente algo ruim que você deve evitar
L.pools = "Poças" -- Plural de L.pool
L.totem = "Totem" -- Um totem, geralmente invocado por um chefe ou xamã
L.totems = "Totems" -- Plural de L.totem
L.portal = "Portal" -- Um portal, geralmente levando a um lugar diferente
L.portals = "Portais" -- Plural de L.portal
L.rift = "Fenda" -- Pode ser usado de forma similar a "portal"
L.rifts = "Fendas" -- Plural de L.rift
L.orb = "Orbe" -- Uma bola/esfera que você precisa evitar
L.orbs = "Orbes" -- Plural de L.orb
L.curse = "Maldição" -- Qualquer tipo de debuff de maldição
L.curses = "Maldições" -- Plural de L.curse
L.disease = "Doença" -- Qualquer tipo de debuff de doença
L.poison = "Veneno" -- Qualquer tipo de debuff de veneno
L.spirit = "Espírito" -- Às vezes, um chefe invoca espíritos
L.spirits = "Espíritos" -- Plural de L.spirit
L.tornado = "Tornado" -- Um tornado
L.tornadoes = "Tornados" -- Plural de L.tornado
L.frontal_cone = "Cônica à Frente" -- Habilidade em formato de cone, não fique à frente do chefe!
L.mark = "Marca" -- Nome curto para habilidades com "Marca"
L.marks = "Marcas" -- Plural de L.mark
L.mind_control = "Controle Mental" -- Qualquer habilidade de Controle Mental
L.mind_control_short = "CM" -- Versão curta de Controle Mental
L.soak = "Soak" -- Habilidades que você precisa absorver
L.soaks = "Soaks" -- Plural de L.soak
L.spell_reflection = "Reflexão de Feitiço" -- Qualquer habilidade que reflete feitiços
L.parasite = "Parasita" -- Qualquer habilidade onde um parasita está envolvido
L.rooted = "Enraizado" -- Qualquer habilidade que te impede de se mover

-- Substituições comuns de A-Z
L.dodge = "Desviar" -- Quando você precisa desviar continuamente de habilidades
L.health_drain = "Dreno de Vida" -- Qualquer habilidade que drena vida do jogador
L.smash = "Esmagamento" -- Curto para habilidades com "esmagamento" no nome
L.spike = "Espeto" -- Curto para habilidades com "espeto" no nome
L.spikes = "Espetos" -- Plural de L.spike
L.waves = "Ondas" -- Múltiplas ondas de uma habilidade ruim vindo de um chefe, como ondas no oceano
