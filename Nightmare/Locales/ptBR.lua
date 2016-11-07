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
	--L.remaining = "Remaining"
	--L.missed = "Missed"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "ptBR")
if L then
	L.gelatinizedDecay = "Decomposição Gelatinizada"
	L.befouler = "Conspurcador Cordismáculo"
	L.shaman = "Xamã Atroz"
end

L = BigWigs:NewBossLocale("Ursoc", "ptBR")
if L then
	L.custom_on_gaze_assist = "Assistente de Olhar Concentrado"
	L.custom_on_gaze_assist_desc = "Mostra ícones marcadores de raide nas barras e mensagens para Olhar Concentrado. Usa {rt4} em casts ímpares e {rt6} em casts pares. Requer assistente ou líder."
end

L = BigWigs:NewBossLocale("Xavius", "ptBR")
if L then
	L.linked = "Vínculos de Terror em VOCÊ! - Linkado com %s!"
	--L.dreamHealers = "Dream Healers"
end
