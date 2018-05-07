local L = BigWigs:NewBossLocale("Argus the Unmaker", "ptBR")
if not L then return end
if L then
	L.combinedBurstAndBomb = "Combina Estouro Anímico e Bomba Anímica"
	L.combinedBurstAndBomb_desc = "|cff71d5ffBomba Anímica|r sempre é aplicada em conjunto com |cff71d5ffEstouro Anímico|r. Ative esta opção para combinar essas duas mensagens em uma só."

	L.custom_off_always_show_combined = "Sempre mostrar a mensagem combinada Estouro Anímico e Bomba Anímica"
	L.custom_off_always_show_combined_desc = "A mensagem combinada não será exibida se você sofrer |cff71d5ffBomba Anímica|r ou |cff71d5ffEstouro Anímico|r. Ative esta opção para sempre mostrar a mensagem combinada, mesmo quando você é afetado. |cff33ff99Útil para o líder da raide.|r"

	L.fear_help = "Combinação Medo de Sargeras"
	L.fear_help_desc = "Diz uma mensagem especial se você for afligido por |cff71d5ffMedo de Sargeras|r e |cff71d5ffPraga Anímica|r/|cff71d5ffEstouro Anímico|r/|cff71d5ffBomba Anímica|r/|cff71d5ffSentença de Sargeras|r."

	L[257931] = "Medo" -- short for Sargeras' Fear
	L[248396] = "Praga" -- short for Soulblight
	L[251570] = "Bomba" -- short for Soulbomb
	L[250669] = "Estouro" -- short for Soulburst
	L[257966] = "Sentença" -- short for Sentence of Sargeras

	L.stage2_early = "Que a fúria do mar leve em bora essa corrupção!"
	L.stage3_early = "Não há esperança. Somente dor!"

	L.gifts = "Gifts: %s (Céu), %s (Mar)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tEstouro:%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBomba (%d):|T137002:0|t%s - " -- short for Soulbomb

	L.sky_say = "{rt5} Crit/Maest" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} Acel/Versa" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "Explosões de Bombas"
	L.bomb_explosions_desc = "Mostrar um temporizador para a explosão de Estouro Anímico e Bomba Anímica."
end

L = BigWigs:NewBossLocale("Aggramar", "ptBR")
if L then
	L.wave_cleared = "Onda %d Limpa!" -- Wave 1 Cleared!

	L.track_ember = "Rastreador de Brasa de Taeshalach"
	L.track_ember_desc = "Exibir mensagens para cada morte de Brasa de Taeshalach."

	L.custom_off_ember_marker_desc = "Marca Brasa de Taeshalach com {rt1}{rt2}{rt3}{rt4}{rt5}, requer promovido ou líder.\n|cff33ff99Mítico: Isso só marcará acréscimos na onda atual e acima de 45 energia.|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "ptBR")
if L then
	L.torment_of_the_titans_desc = "A Shivarra forçará as almas titânicas a usar suas habilidades contra os jogadores."

	L.timeLeft = "%.1fs" -- s = seconds
	L.torment = "Tormento: %s"
	L.nextTorment = "Próximo Tormento: |cffffffff%s|r"
	L.tormentHeal = "Cura/DoT" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "Raios" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "Exército" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "Chamas" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "ptBR")
if L then
	L.warp_in_desc = "Mostra cronômetros e mensagens para cada onda, junto com quaisquer acréscimos especiais na onda."

	L.top_lane = "Superior"
	L.mid_lane = "Meio"
	L.bot_lane = "Inferior"

	L.purifier = "Purificador" -- Fel-Powered Purifier
	L.destructor = "Destruidor" -- Fel-Infused Destructor
	L.obfuscator = "Ofuscador" -- Fel-Charged Obfuscator
	L.bats = "Morcevil"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "ptBR")
if L then
	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "Hasabel randomiza qual habilidade off-cooldown ela usará em seguida. Quando esta opção está habilitada, as barras para essas habilidades permanecerão na sua tela."
	L.custom_on_filter_platforms = "Avisos e barras da Plataforma Lateral do filtro"
	L.custom_on_filter_platforms_desc = "Remove mensagens e barras desnecessárias se você não estiver em uma plataforma lateral. Ele sempre mostrará barras e avisos da plataforma principal: Nexus."
	L.worldExplosion_desc = "Mostra um temporizador para a explosão de Mundo em Colapso."
	L.platform_active = "%s Ativo!" -- Platform: Xoroth Active!
	L.add_killed = "%s morto!"
	L.achiev = "'Portal Kombat' achievement debuffs" -- Achievement 11928
end

L = BigWigs:NewBossLocale("Kin'garoth", "ptBR")
if L then
	L.empowered = "(E) %s" -- (E) Ruiner
	L.gains = "Kin'garoth ganha %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "ptBR")
if L then
	L.felshieldActivated = "Escudo Vil ativado por %s"
	L.felshieldUp = "Escudo Vil Ativo"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "ptBR")
if L then
	L.cannon_ability_desc = "Exibir Mensagens e Barras relacionadas aos 2 canhões do Quebramundo Garothi."

	L.missileImpact = "Aniquilação"
	L.missileImpact_desc = "Mostrar um temporizador para o lançamento de mísseis de Aniquilação."

	L.decimationImpact = "Dizimação"
	L.decimationImpact_desc = "Mostrar um temporizador para o lançamento de mísseis de Dizimação."
end

L = BigWigs:NewBossLocale("Antorus Trash", "ptBR")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	L.felguard = "Guarda Vil Antorano"

	-- [[ After Garothi Worldbreaker ]] --
	L.flameweaver = "Tecechamas"

	-- [[ Before Antoran High Command ]] --
	L.ravager = "Assolador Filho da Lâmina"
	L.deconix = "Imperador Deconix"
	L.clobex = "Clobex"

	-- [[ Before Portal Keeper Hasabel ]] --
	L.stalker = "Espreitador Voraz"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	L.tarneth = "Tarneth"
	L.priestess = "Sacerdotisa do Delírio"

	-- [[ Before Aggramar ]] --
	L.aedis = "Guardião Sombrio Aedis"
end
