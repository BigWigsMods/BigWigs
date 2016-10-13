local L = BigWigs:NewBossLocale("Cenarius", "ptBR")
if not L then return end
if L then
	L.forces = "Forças do pesadelo"
	L.bramblesSay = "Espinheiras perto de %s"
	--L.custom_off_multiple_breath_bar = "Show multiple Rotten Breath bars"
	--L.custom_off_multiple_breath_bar_desc = "Per default BigWigs will only show the Rotten Breath bar of one drake. Enable this option if you want to see the timer for each drake."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "ptBR")
if L then
	L.isLinkedWith = "%s esta linkado com %s"
	L.yourLink = "Você esta linkado com %s"
	L.yourLinkShort = "Linkado com %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "ptBR")
if L then
	L.custom_off_deathglare_marker = "Marcador de Tentáculo Fulgor da Morte"
	L.custom_off_deathglare_marker_desc = "Marca Tentáculo Fulgor da Morte com {rt6}{rt5}{rt4}{rt3}, requer assistente ou líder.\n|cFFFF0000Apenas 1 pessoa no raide deve ter isto ativado para prevenir conflitos na marcação.|r\n|cFFADFF2FDICA: Se o raide escolheu você para isso, ter placas de identificação ativadas ou passar rapidamente o mouse sobre os tentáculos é a maneira mais rápida de marcá-los.|r"

 	L.bloods_remaining = "%d |4Sangue:Sangues; faltando"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "ptBR")
if L then
	L.gelatinizedDecay = "Decomposição Gelatinizada"
	L.befouler = "Conspurcador Cordismáculo"
	L.shaman = "Xamã Atroz"
	--L.custom_on_mark_totem = "Mark the Totems"
	--L.custom_on_mark_totem_desc = "Mark the Totems with {rt8}{rt7}, requires promoted or leader."
end

L = BigWigs:NewBossLocale("Ursoc", "ptBR")
if L then
	L.custom_on_gaze_assist = "Assistente de Olhar Concentrado"
	L.custom_on_gaze_assist_desc = "Mostra ícones marcadores de raide nas barras e mensagens para Olhar Concentrado. Usa {rt4} em casts ímpares e {rt6} em casts pares. Requer assistente ou líder."
end

L = BigWigs:NewBossLocale("Xavius", "ptBR")
if L then
	L.custom_off_blade_marker = "Marcador de Lâminas do Pesadelo"
	L.custom_off_blade_marker_desc = "Marca os alvos de Lâminas do Pesadelo com {rt1}{rt2}, requer assistente ou líder."

	L.linked = "Vínculos de Terror em VOCÊ! - Linkado com %s!"
end
