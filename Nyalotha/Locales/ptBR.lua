local L = BigWigs:NewBossLocale("Maut", "ptBR")
if not L then return end
if L then
	L.stage2_over = "Estágio 2 Acabou - %.1f seg"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "ptBR")
if L then
	L.custom_on_stop_timers = "Sempre mostrar barras de habilidades"
	L.custom_on_stop_timers_desc = "Shad'har é aleatória nas habilidades fora de recarga que ela usará a seguir. Quando esta opção estiver habilitada, as barras para essas habilidades permanecerão na sua tela."
end

L = BigWigs:NewBossLocale("Drest'agath", "ptBR")
if L then
	L.adds_desc = "Mensagens e Alertas para o Olho, Tentáculos e Gorja de Drest'agath."
	L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "Olho morto!"
	L.tentacle_killed = "Tentáculo morto!"
	L.maw_killed = "Gorja morta!"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "ptBR")
if L then
	L.custom_on_fixate_plates = "Fixar ícone na barra de identificação do inimigo"
	L.custom_on_fixate_plates_desc = "Mostra um ícone na barra de identificação do alvo que está fixando em você.\nRequer o uso de barras de identificação inimigas. Essa função só é suportada pelo addon KuiNameplates."
end

L = BigWigs:NewBossLocale("Vexiona", "ptBR")
if L then
	L.killed = "%s morto"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "ptBR")
if L then
	L.essences = "Essências"
	L.essences_desc = "Ra-den periodicamente coleta essências de outros reinos. Essências que chegam até Ra-den deixam ele mais forte com a energia daquele tipo."
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "ptBR")
if L then
	L.player_membrane = "Membrana do Jogador" -- In stage 3
	L.boss_membrane = "Membrana do Chefe" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "ptBR")
if L then
	L.realm_switch = "Reino Trocado" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Dizer repetitivamente a paranoia"
	L.custom_on_repeating_paranoia_say_desc = "Spama uma mensagem no chat para ser evitado enquanto estiver com paranoia."
	L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "Alerta: Câmara do Coração comprometida. Forças hostis se aproximando." -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "Portão Aberto!"

	L.laser_left = "Lasers (Esquerda)"
	L.laser_right = "Lasers (Direita)"
end
