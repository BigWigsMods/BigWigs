local L = BigWigs:NewBossLocale("Cenarius", "ptBR")
if not L then return end
if L then
	L.forces = "Forças do pesadelo"
	L.bramblesSay = "Espinheiras perto de %s"
	L.custom_off_multiple_breath_bar = "Exibir várias barras de Sopro Apodrecido"
	L.custom_off_multiple_breath_bar_desc = "Por padrão BigWigs irá mostrar a barra de Sopro Apodrecido de um Draco Apodrecido. Ative esta opção se você deseja ver os contadores para todos os Dracos Apodrecidos."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "ptBR")
if L then
	L.isLinkedWith = "%s está vinculado com %s"
	L.yourLink = "Você está vinculado com %s"
	L.yourLinkShort = "vinculado com %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "ptBR")
if L then
	L.remaining = "Restando"
	L.missed = "Perdido" -- TODO: needs reviewing
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
	L.custom_on_gaze_assist_desc = "Mostra ícones de raide nas barras e mensagens para Olhar Concentrado. Usa {rt4} em conjurações ímpares e {rt6} em conjurações pares. Requer assistente ou líder."
end

L = BigWigs:NewBossLocale("Xavius", "ptBR")
if L then
	L.linked = "Vínculos de Terror em VOCÊ! - Vinculado com %s!"
	L.dreamHealers = "Dream Healers" -- TODO: needs translation
end
