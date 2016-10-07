local L = BigWigs:NewBossLocale("Cenarius", "ptBR")
if not L then return end
if L then
	L.forces = "Forças do pesadelo"
	L.bramblesSay = "Espinheiras perto de %s"
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
	--read all this line --L.custom_off_deathglare_marker_desc = "Marca Tentáculo FUlgor da Morte com {rt6}{rt5}{rt4}{rt3}, requer assistente ou líder.\n|cFFFF0000Apenas 1 pessoa no raide deve ter isto ativado para prevenir conflitos na marcação.|r\n|cFFADFF2FDICA: Se o raide escolheu você para isso, ter placas de identificação ativadas ou passar rapidamente o mouse sobre *******"the spears"(you mean the body of the tentacle?, if yes then you can use "as cabeças")**** é a maneira mais rápida de marcá-las.|r"

 	L.bloods_remaining = "%d |4Sangue:Sangues; restando"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "ptBR")
if L then
	L.gelatinizedDecay = "Decomposição Gelatinizada"
	L.befouler = "Conspurcador Cordismáculo"
	L.shaman = "Xamã Atroz"
end

L = BigWigs:NewBossLocale("Ursoc", "ptBR")
if L then
	--L.custom_off_gaze_assist = "Focused Gaze Assist"
	--L.custom_off_gaze_assist_desc = "Show raid icons in bars and messages for Focused Gaze. Using {rt4} for odd, {rt6} for even soaks. Requires promoted or leader."
end

L = BigWigs:NewBossLocale("Xavius", "ptBR")
if L then
	L.custom_off_blade_marker = "Marcador de Lâminas do Pesadelo"
	L.custom_off_blade_marker_desc = "Marca os alvos de Lâminas do Pesadelo com {rt1}{rt2}, requer assistente ou líder."

	L.linked = "Vínculos de Terror em VOCÊ! - Linkado com %s!"
end
