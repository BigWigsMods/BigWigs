local L = BigWigs:NewBossLocale("Harjatan the Bludger", "ptBR")
if not L then return end
if L then
	L.custom_on_fixate_plates = "Fixar ícone na placa de identificação do inimigo"
	L.custom_on_fixate_plates_desc = "Mostra um ícone na placa de identificação no alvo que está se fixando em você.\nRequer o uso de Placas de Identificação do Inimigo. Atualmente este recurso é suportado apenas por KuiNameplates."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "ptBR")
if L then
	L.custom_on_fixate_plates = "Fixar ícone na placa de identificação do inimigo"
	L.custom_on_fixate_plates_desc = "Mostra um ícone na placa de identificação no alvo que está se fixando em você.\nRequer o uso de Placas de Identificação do Inimigo. Atualmente este recurso é suportado apenas por KuiNameplates."

	L.infobox_title_prisoners = "%d |4Prisionero:Prisioneros;"

	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "Inquisição Demoníaca tem alguns feitiços atrasados por interrupções/outros custos. Quando esta opção está habilitada, as barras para essas habilidades permanecerão na sua tela."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "ptBR")
if L then
	L.inks_fed_count = "Tinta em (%d/%d)"
	L.inks_fed = "Tinta alimenta: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "ptBR")
if L then
	L.infobox_players = "Jogadores"
	L.armor_remaining = "%s Restando (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "Ignora Armadura Óssea em Templários Revividos na Dificuldade Mítica"
	L.custom_on_mythic_armor_desc = "Deixe esta opção ativada se você estiver tankando Templários Reanimados e deseja ignorar os avisos e contando a Armadura Óssea nos Templários Ranimados"
	L.custom_on_armor_plates = "Ícone Armadura Óssea na placa de identificação do inimigo"
	L.custom_on_armor_plates_desc = "Mostra um ícone na placa de identificação dos Templários Reanimados que possuem Armadura Óssea.\nRequer o uso de Placas de Identificação do Inimigo. Atualmente este recurso é suportado apenas por KuiNameplates."
	L.tormentingCriesSay = "Chora" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "ptBR")
if L then
	L.infusionChanged = "Infusão MUDOU: %s"
	L.sameInfusion = "Mesma Infusão: %s"
	L.fel = "Vil"
	L.light = "Luz"
	L.felHammer = "Martelo da Obliteração" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "Martelo da Criação" -- Better name for "Hammer of Creation"
	L.absorb = "Absorve"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Lançar"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "Pilhas"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "ptBR")
if L then
	-- L.touch_impact = "Toque de Sargeras" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "Avatar Caído randomiza qual habilidade off-cooldown ele usará em seguida. Quando esta opção está habilitada, as barras para essas habilidades permanecerão na sua tela."

	L.energy_leak = "Consumir"
	L.energy_leak_desc = "Exibir um aviso quando a energia vazar para o chefe no estágio 1."
	L.energy_leak_msg = "Consumir! (%d)"

	L.warmup_trigger = "A carcaça antes de você" -- The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!

	L.absorb = "Absorve"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Lançar"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "ptBR")
if L then
	L.singularityImpact = "Singularidade Rompedora"
	L.obeliskExplosion = "Explosão do Obelisco"
	L.obeliskExplosion_desc = "Mostra um timer para a Explosão do Obelisco"

	L.darkness = "Trevas" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Reflexão: Erupção" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Reflexão: Ululante" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Reflexão: Desespero" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "Repulsão da Singularidade Rompedora "
	L.rupturingKnock_desc = "Mostra um timer para a repulsão"

	L.meteorImpact_desc = "Mostrar um timer para os Meteoros"

	L.shadowsoul = "Rastreador de Vide do Alma Sombria"
	L.shadowsoul_desc = "Mostrar a caixa de informações exibindo a vida atual dos 5 adds Alma Sombria."

	L.custom_on_track_illidan = "Rastrear Humanóides Automaticamente"
	L.custom_on_track_illidan_desc = "Se você é um Caçador ou um Druida Feral, esta opção ativará automaticamente o rastreamento de humanóides para que você possa rastrear Illidan."

	L.custom_on_zoom_in = "Zoom no Minimapa Automático"
	L.custom_on_zoom_in_desc = "Esse recurso definirá o zoom do minimapa para o nível 4 para facilitar o rastreamento do Illidan e restaurá-lo ao nível anterior assim que o estágio terminar."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "ptBR")
if L then
	L.rune = "Runa Órquica"
	L.chaosbringer = "Infernal Caótico"
	L.rez = "Rez, o Vigia da Tumba"
	L.erduval = "Erdu'val"
	L.varah = "Varah, Senhora dos Hipogrifos"
	L.seacaller = "Aquamante Escamaré"
	L.custodian = "Zelador Submarino"
	L.dresanoth = "Dresanoth"
	L.stalker = "Espreitador Medonho"
	L.darjah = "Senhor da Guerra Darjah"
	L.sentry = "Sentinela Guardiã"
	L.acolyte = "Acólita Fantasmagórica"
	L.ryul = "Ryul, o Esmaecido"
	L.countermeasure = "Contramedida Defensiva"
end
